package com.servlet;

import com.bean.PageBean;
import com.bean.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/pages")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class PageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        try (Connection conn = DBUtil.getConnection()) {
            switch (action) {
                case "renderImage":
                    renderImageFromDb(conn, Long.parseLong(req.getParameter("imageId")), resp);
                    break;

                case "delete":
                    deletePage(conn, Long.parseLong(req.getParameter("id")));
                    resp.sendRedirect("pages");
                    break;

                case "deleteSection":
                    deleteSection(conn, Long.parseLong(req.getParameter("sectionId")));
                    resp.sendRedirect("pages?action=view&id=" + req.getParameter("pageId"));
                    break;

                case "deleteImage":
                    deleteImage(conn, Long.parseLong(req.getParameter("imageId")));
                    resp.sendRedirect("pages?action=view&id=" + req.getParameter("pageId"));
                    break;

                case "view":
                    Long viewId = Long.parseLong(req.getParameter("id"));
                    req.setAttribute("activePage", getPageDetails(conn, viewId));
                    req.setAttribute("pages", getAllPages(conn));
                    req.getRequestDispatcher("/index.jsp").forward(req, resp);
                    break;

                case "list":
                default:
                    req.setAttribute("pages", getAllPages(conn));
                    req.getRequestDispatcher("/index.jsp").forward(req, resp);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        try (Connection conn = DBUtil.getConnection()) {
            if ("createPage".equals(action)) {
                String title = req.getParameter("title");
                String slug = req.getParameter("slug");
                Long newId = createPage(conn, title, slug);
                resp.sendRedirect("pages?action=view&id=" + newId);

            } else if ("addSection".equals(action)) {
                Long pageId = Long.parseLong(req.getParameter("pageId"));
                String type = req.getParameter("sectionType");
                int order = Integer.parseInt(req.getParameter("sequenceOrder"));
                String title = req.getParameter("title");
                String content = req.getParameter("content");

                createSection(conn, pageId, type, order, title, content);
                resp.sendRedirect("pages?action=view&id=" + pageId);

            } else if ("uploadImage".equals(action)) {
                Long pageId = Long.parseLong(req.getParameter("pageId"));
                Long sectionId = Long.parseLong(req.getParameter("sectionId"));
                String alt = req.getParameter("altText");
                int order = Integer.parseInt(req.getParameter("sequenceOrder"));

                Part filePart = req.getPart("imageFile");
                if (filePart != null && filePart.getSize() > 0) {
                    String contentType = filePart.getContentType();
                    try (InputStream inputStream = filePart.getInputStream()) {
                        saveImageToDb(conn, sectionId, inputStream, contentType, alt, order);
                    }
                }

                resp.sendRedirect("pages?action=view&id=" + pageId);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    // Streams raw image BLOB directly from database to client browser
    private void renderImageFromDb(Connection conn, Long imageId, HttpServletResponse resp) throws SQLException, IOException {
        String sql = "SELECT image_data, image_type FROM section_images WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, imageId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    resp.setContentType(rs.getString("image_type"));
                    try (InputStream in = rs.getBinaryStream("image_data");
                         OutputStream out = resp.getOutputStream()) {
                        byte[] buffer = new byte[4096];
                        int bytesRead;
                        while ((bytesRead = in.read(buffer)) != -1) {
                            out.write(buffer, 0, bytesRead);
                        }
                    }
                } else {
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            }
        }
    }

    private void saveImageToDb(Connection conn, Long sectionId, InputStream is, String type, String altText, int order) throws SQLException {
        String sql = "INSERT INTO section_images (section_id, image_data, image_type, alt_text, sequence_order) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, sectionId);
            ps.setBinaryStream(2, is);
            ps.setString(3, type);
            ps.setString(4, altText);
            ps.setInt(5, order);
            ps.executeUpdate();
        }
    }

    // --- Helper Database Queries ---

    private List<PageBean> getAllPages(Connection conn) throws SQLException {
        List<PageBean> list = new ArrayList<>();
        String sql = "SELECT * FROM pages ORDER BY id DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                PageBean p = new PageBean();
                p.setId(rs.getLong("id"));
                p.setTitle(rs.getString("title"));
                p.setSlug(rs.getString("slug"));
                list.add(p);
            }
        }
        return list;
    }

    private PageBean getPageDetails(Connection conn, Long pageId) throws SQLException {
        PageBean page = null;
        String pageSql = "SELECT * FROM pages WHERE id = ?";
        String secSql = "SELECT * FROM sections WHERE page_id = ? ORDER BY sequence_order ASC";
        String imgSql = "SELECT id, section_id, image_type, alt_text, sequence_order FROM section_images WHERE section_id = ? ORDER BY sequence_order ASC";

        try (PreparedStatement ps = conn.prepareStatement(pageSql)) {
            ps.setLong(1, pageId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    page = new PageBean();
                    page.setId(rs.getLong("id"));
                    page.setTitle(rs.getString("title"));
                    page.setSlug(rs.getString("slug"));
                }
            }
        }

        if (page == null) return null;

        try (PreparedStatement psSec = conn.prepareStatement(secSql)) {
            psSec.setLong(1, pageId);
            try (ResultSet rsSec = psSec.executeQuery()) {
                while (rsSec.next()) {
                    PageBean.Section sec = new PageBean.Section();
                    sec.setId(rsSec.getLong("id"));
                    sec.setPageId(pageId);
                    sec.setSectionType(rsSec.getString("section_type"));
                    sec.setSequenceOrder(rsSec.getInt("sequence_order"));
                    sec.setTitle(rsSec.getString("title"));
                    sec.setContent(rsSec.getString("content"));

                    try (PreparedStatement psImg = conn.prepareStatement(imgSql)) {
                        psImg.setLong(1, sec.getId());
                        try (ResultSet rsImg = psImg.executeQuery()) {
                            while (rsImg.next()) {
                                PageBean.SectionImage img = new PageBean.SectionImage();
                                img.setId(rsImg.getLong("id"));
                                img.setSectionId(sec.getId());
                                img.setImageType(rsImg.getString("image_type"));
                                img.setAltText(rsImg.getString("alt_text"));
                                img.setSequenceOrder(rsImg.getInt("sequence_order"));
                                sec.getImages().add(img);
                            }
                        }
                    }
                    page.getSections().add(sec);
                }
            }
        }
        return page;
    }

    private Long createPage(Connection conn, String title, String slug) throws SQLException {
        String sql = "INSERT INTO pages (title, slug) VALUES (?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, title);
            ps.setString(2, slug);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getLong(1);
            }
        }
        return null;
    }

    private void createSection(Connection conn, Long pageId, String type, int order, String title, String content) throws SQLException {
        String sql = "INSERT INTO sections (page_id, section_type, sequence_order, title, content) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, pageId);
            ps.setString(2, type);
            ps.setInt(3, order);
            ps.setString(4, title);
            ps.setString(5, content);
            ps.executeUpdate();
        }
    }

    private void deletePage(Connection conn, Long id) throws SQLException {
        String sql = "DELETE FROM pages WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            ps.executeUpdate();
        }
    }

    private void deleteSection(Connection conn, Long sectionId) throws SQLException {
        String sql = "DELETE FROM sections WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, sectionId);
            ps.executeUpdate();
        }
    }

    private void deleteImage(Connection conn, Long imageId) throws SQLException {
        String sql = "DELETE FROM section_images WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, imageId);
            ps.executeUpdate();
        }
    }
}