package com.servlet;

import com.bean.PageBean;
import com.bean.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/pages")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class PageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession sess = req.getSession(false);
        if (sess == null || sess.getAttribute("username") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String branch = (String) sess.getAttribute("branch");
        String role = (String) sess.getAttribute("role");
        if (!isAuthorized(role)) {
            resp.setContentType("text/html");
            resp.getWriter().println("<h3 style='color:red;'>Access Denied</h3>");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) action = "list";

        try (Connection conn = DBUtil.getConnection(branch)) {
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
        HttpSession sess = req.getSession(false);
        if (sess == null || sess.getAttribute("username") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String role = (String) sess.getAttribute("role");
        String branch = (String) sess.getAttribute("branch");
        if (!isAuthorized(role)) {
            resp.setContentType("text/html");
            resp.getWriter().println("<h3 style='color:red;'>Access Denied</h3>");
            return;
        }

        String action = req.getParameter("action");

        try (Connection conn = DBUtil.getConnection(branch)) {
            if ("createPage".equals(action)) {
                String title = req.getParameter("title");
                String slug = req.getParameter("slug");
                Long newId = createPage(conn, title, slug);
                resp.sendRedirect("pages?action=view&id=" + newId);

            } else if ("editPage".equals(action)) {
                Long pageId = Long.parseLong(req.getParameter("pageId"));
                String title = req.getParameter("title");
                String slug = req.getParameter("slug");
                updatePage(conn, pageId, title, slug);
                resp.sendRedirect("pages?action=view&id=" + pageId);

            } else if ("addSection".equals(action)) {
                Long pageId = Long.parseLong(req.getParameter("pageId"));
                String type = req.getParameter("sectionType");
                int order = Integer.parseInt(req.getParameter("sequenceOrder"));
                String title = req.getParameter("title");
                String content = req.getParameter("content");

                createSection(conn, pageId, type, order, title, content);
                resp.sendRedirect("pages?action=view&id=" + pageId);

            } else if ("updateSection".equals(action)) {
                Long pageId = Long.parseLong(req.getParameter("pageId"));
                Long sectionId = Long.parseLong(req.getParameter("sectionId"));
                String type = req.getParameter("sectionType");
                int order = Integer.parseInt(req.getParameter("sequenceOrder"));
                String title = req.getParameter("title");
                String content = req.getParameter("content");

                updateSection(conn, sectionId, type, order, title, content);
                resp.sendRedirect("pages?action=view&id=" + pageId);

            } else if ("uploadImage".equals(action)) {
                Long pageId = Long.parseLong(req.getParameter("pageId"));
                Long sectionId = Long.parseLong(req.getParameter("sectionId"));
                String alt = req.getParameter("altText");
                int order = Integer.parseInt(req.getParameter("sequenceOrder"));
                String heading1 = req.getParameter("heading1");
                String heading2 = req.getParameter("heading2");

                Part filePart = req.getPart("imageFile");
                if (filePart != null && filePart.getSize() > 0) {
                    String contentType = filePart.getContentType();
                    try (InputStream inputStream = filePart.getInputStream()) {
                        saveImageToDb(conn, sectionId, inputStream, contentType, alt, order, heading1, heading2);
                    }
                }
                resp.sendRedirect("pages?action=view&id=" + pageId);

            } else if ("updateImage".equals(action)) {
                Long pageId = Long.parseLong(req.getParameter("pageId"));
                Long imageId = Long.parseLong(req.getParameter("imageId"));
                String alt = req.getParameter("altText");
                int order = Integer.parseInt(req.getParameter("sequenceOrder"));
                String heading1 = req.getParameter("heading1");
                String heading2 = req.getParameter("heading2");

                Part filePart = req.getPart("imageFile");
                if (filePart != null && filePart.getSize() > 0) {
                    String contentType = filePart.getContentType();
                    try (InputStream inputStream = filePart.getInputStream()) {
                        updateImageWithFile(conn, imageId, inputStream, contentType, alt, order, heading1, heading2);
                    }
                } else {
                    updateImageMetadata(conn, imageId, alt, order, heading1, heading2);
                }
                resp.sendRedirect("pages?action=view&id=" + pageId);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private boolean isAuthorized(String role) {
        return "Global".equalsIgnoreCase(role)
                || "Incharge".equalsIgnoreCase(role)
                || "Admin".equalsIgnoreCase(role);
    }

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

    private void saveImageToDb(Connection conn, Long sectionId, InputStream is, String type, String altText, int order, String heading1, String heading2) throws SQLException {
        String sql = "INSERT INTO section_images (section_id, image_data, image_type, alt_text, sequence_order, Heading1, Heading2) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, sectionId);
            ps.setBinaryStream(2, is);
            ps.setString(3, type);
            ps.setString(4, altText);
            ps.setInt(5, order);
            ps.setString(6, heading1);
            ps.setString(7, heading2);
            ps.executeUpdate();
        }
    }

    private void updateImageWithFile(Connection conn, Long imageId, InputStream is, String type, String altText, int order, String heading1, String heading2) throws SQLException {
        String sql = "UPDATE section_images SET image_data = ?, image_type = ?, alt_text = ?, sequence_order = ?, Heading1 = ?, Heading2 = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBinaryStream(1, is);
            ps.setString(2, type);
            ps.setString(3, altText);
            ps.setInt(4, order);
            ps.setString(5, heading1);
            ps.setString(6, heading2);
            ps.setLong(7, imageId);
            ps.executeUpdate();
        }
    }

    private void updateImageMetadata(Connection conn, Long imageId, String altText, int order, String heading1, String heading2) throws SQLException {
        String sql = "UPDATE section_images SET alt_text = ?, sequence_order = ?, Heading1 = ?, Heading2 = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, altText);
            ps.setInt(2, order);
            ps.setString(3, heading1);
            ps.setString(4, heading2);
            ps.setLong(5, imageId);
            ps.executeUpdate();
        }
    }

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
        String sql = "SELECT p.id as page_id, p.title as page_title, p.slug, " +
                     "s.id as section_id, s.section_type, s.sequence_order as sec_order, s.title as sec_title, s.content, " +
                     "i.id as image_id, i.image_type, i.alt_text, i.sequence_order as img_order, " +
                     "i.created_at, i.Heading1, i.Heading2 " +
                     "FROM pages p " +
                     "LEFT JOIN sections s ON p.id = s.page_id " +
                     "LEFT JOIN section_images i ON s.id = i.section_id " +
                     "WHERE p.id = ? " +
                     "ORDER BY s.sequence_order ASC, i.sequence_order ASC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, pageId);
            try (ResultSet rs = ps.executeQuery()) {
                Map<Long, PageBean.Section> sectionMap = new LinkedHashMap<>();

                while (rs.next()) {
                    if (page == null) {
                        page = new PageBean();
                        page.setId(rs.getLong("page_id"));
                        page.setTitle(rs.getString("page_title"));
                        page.setSlug(rs.getString("slug"));
                    }

                    long secId = rs.getLong("section_id");
                    if (!rs.wasNull()) {
                        PageBean.Section section = sectionMap.get(secId);
                        if (section == null) {
                            section = new PageBean.Section();
                            section.setId(secId);
                            section.setPageId(pageId);
                            section.setSectionType(rs.getString("section_type"));
                            section.setSequenceOrder(rs.getInt("sec_order"));
                            section.setTitle(rs.getString("sec_title"));
                            section.setContent(rs.getString("content"));
                            sectionMap.put(secId, section);
                            page.getSections().add(section);
                        }

                        long imgId = rs.getLong("image_id");
                        if (!rs.wasNull()) {
                            PageBean.SectionImage img = new PageBean.SectionImage();
                            img.setId(imgId);
                            img.setSectionId(secId);
                            img.setImageType(rs.getString("image_type"));
                            img.setAltText(rs.getString("alt_text"));
                            img.setSequenceOrder(rs.getInt("img_order"));
                            img.setCreatedAt(rs.getTimestamp("created_at"));
                            img.setHeading1(rs.getString("Heading1"));
                            img.setHeading2(rs.getString("Heading2"));
                            section.getImages().add(img);
                        }
                    }
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

    private void updatePage(Connection conn, Long pageId, String title, String slug) throws SQLException {
        String sql = "UPDATE pages SET title = ?, slug = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, slug);
            ps.setLong(3, pageId);
            ps.executeUpdate();
        }
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

    private void updateSection(Connection conn, Long sectionId, String type, int order, String title, String content) throws SQLException {
        String sql = "UPDATE sections SET section_type = ?, sequence_order = ?, title = ?, content = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, type);
            ps.setInt(2, order);
            ps.setString(3, title);
            ps.setString(4, content);
            ps.setLong(5, sectionId);
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