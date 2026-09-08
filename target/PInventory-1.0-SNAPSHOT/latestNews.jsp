
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Base64" %>
<%@ page import="com.bean.DBUtil" %>

<%
    HttpSession sess = request.getSession(false);

    if (sess == null || sess.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String branch = (String) sess.getAttribute("branch");
    String editId = request.getParameter("edit");

    String eventName = "";
    String description = "";
    String base64Image = "";
    int id = 0;

    if (editId != null && !editId.trim().isEmpty()) {
        String sql = "SELECT * FROM latest_news WHERE id=?";
        try (Connection con = DBUtil.getConnection(branch);
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, Integer.parseInt(editId));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    id = rs.getInt("id");
                    eventName = rs.getString("event_name");
                    description = rs.getString("description");

                    byte[] imgBytes = rs.getBytes("image");
                    if (imgBytes != null && imgBytes.length > 0) {
                        base64Image = Base64.getEncoder().encodeToString(imgBytes);
                    }
                }
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Latest News - SAP Fiori Style</title>
    <style>
        /* SAP Fiori Theme Variables (Based on SAP Horizon/Quartz) */
        :root {
            --sapBrandColor: #0070f2;
            --sapBackgroundColor: #f3f4f5;
            --sapBaseColor: #ffffff;
            --sapTextColor: #1d2d3e;
            --sapTitleColor: #1d2d3e;
            --sapLinkColor: #0070f2;
            --sapBorderColor: #d9d9d9;
            
            /* Buttons */
            --sapBtnEmphasizedBackground: #0070f2;
            --sapBtnEmphasizedTextColor: #ffffff;
            --sapBtnEmphasizedHover: #005cc2;
            
            --sapBtnStandardBackground: #ffffff;
            --sapBtnStandardBorder: #0070f2;
            --sapBtnStandardTextColor: #0070f2;
            --sapBtnStandardHover: #e5f0fa;
            
            --sapBtnRejectBackground: #ffffff;
            --sapBtnRejectBorder: #ee0000;
            --sapBtnRejectTextColor: #ee0000;
            --sapBtnRejectHover: #fde6e6;
            
            /* Inputs */
            --sapFieldBackground: #ffffff;
            --sapFieldBorder: #89919a;
            --sapFieldFocus: #0070f2;
            
            /* Shellbar */
            --sapShellColor: #354a5f;
            --sapShellTextColor: #ffffff;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: "72", "72full", Arial, Helvetica, sans-serif;
        }

        body {
            background-color: var(--sapBackgroundColor);
            color: var(--sapTextColor);
            font-size: 0.875rem; /* 14px */
        }

        /* --- SAP Shell Bar --- */
        .sap-shellbar {
            background-color: var(--sapShellColor);
            color: var(--sapShellTextColor);
            height: 2.75rem;
            display: flex;
            align-items: center;
            padding: 0 2rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.15);
        }
        
        .sap-shellbar-title {
            font-size: 1rem;
            font-weight: bold;
            letter-spacing: 0.025rem;
        }

        /* --- Page Layout --- */
        .sap-page {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem 1rem;
        }

        .sap-page-header {
            margin-bottom: 1.5rem;
        }

        .sap-page-title {
            font-size: 1.25rem;
            color: var(--sapTitleColor);
            font-weight: bold;
        }

        /* --- SAP Cards --- */
        .sap-card {
            background: var(--sapBaseColor);
            border-radius: 0.5rem;
            box-shadow: 0 0 0.125rem 0 rgba(0,0,0,0.1), 0 0.25rem 0.5rem 0 rgba(0,0,0,0.08);
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .sap-card-title {
            font-size: 1.125rem;
            color: var(--sapTitleColor);
            margin-bottom: 1.25rem;
            font-weight: bold;
            border-bottom: 1px solid var(--sapBorderColor);
            padding-bottom: 0.75rem;
        }

        /* --- Form Elements --- */
        .sap-form-item {
            margin-bottom: 1.25rem;
        }

        .sap-label {
            display: block;
            color: #556b82;
            font-size: 0.875rem;
            margin-bottom: 0.25rem;
        }

        .sap-input,
        .sap-textarea,
        .sap-file {
            width: 100%;
            padding: 0.5rem 0.75rem;
            font-size: 0.875rem;
            color: var(--sapTextColor);
            background: var(--sapFieldBackground);
            border: 1px solid var(--sapFieldBorder);
            border-radius: 0.25rem;
            transition: all 0.2s ease;
        }

        .sap-input:focus,
        .sap-textarea:focus {
            outline: none;
            border-color: var(--sapFieldFocus);
            box-shadow: inset 0 0 0 1px var(--sapFieldFocus);
        }

        .sap-textarea {
            height: 120px;
            resize: vertical;
        }

        .sap-file {
            padding: 0.4rem;
            background: #fbfbfb;
        }

        /* --- Buttons --- */
        .sap-btn-group {
            display: flex;
            gap: 0.5rem;
            margin-top: 1.5rem;
        }

        .sap-btn {
            display: inline-block;
            font-size: 0.875rem;
            font-weight: bold;
            text-align: center;
            padding: 0.5rem 1rem;
            border-radius: 0.375rem;
            cursor: pointer;
            text-decoration: none;
            border: 1px solid transparent;
            transition: all 0.2s ease;
            min-width: 6rem;
        }

        .sap-btn-emphasized {
            background-color: var(--sapBtnEmphasizedBackground);
            color: var(--sapBtnEmphasizedTextColor);
        }

        .sap-btn-emphasized:hover {
            background-color: var(--sapBtnEmphasizedHover);
        }

        .sap-btn-standard {
            background-color: var(--sapBtnStandardBackground);
            color: var(--sapBtnStandardTextColor);
            border-color: var(--sapBtnStandardBorder);
        }

        .sap-btn-standard:hover {
            background-color: var(--sapBtnStandardHover);
        }

        .sap-btn-reject {
            background-color: var(--sapBtnRejectBackground);
            color: var(--sapBtnRejectTextColor);
            border-color: var(--sapBtnRejectBorder);
        }

        .sap-btn-reject:hover {
            background-color: var(--sapBtnRejectHover);
        }

        /* --- Tables --- */
        .sap-table-wrapper {
            overflow-x: auto;
        }

        .sap-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        .sap-table th {
            background-color: #f4f4f5;
            color: #556b82;
            padding: 0.75rem 1rem;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05rem;
            border-bottom: 1px solid var(--sapBorderColor);
            border-top: 1px solid var(--sapBorderColor);
        }

        .sap-table td {
            padding: 0.75rem 1rem;
            border-bottom: 1px solid var(--sapBorderColor);
            vertical-align: middle;
        }

        .sap-table tr:hover td {
            background-color: #f5faff;
        }

        .sap-img-preview {
            width: 80px;
            height: 56px;
            object-fit: cover;
            border-radius: 4px;
            border: 1px solid var(--sapBorderColor);
        }

        /* --- Message Strips --- */
        .sap-message-strip {
            padding: 0.75rem 1rem;
            border-radius: 0.25rem;
            margin-bottom: 1.5rem;
            font-weight: bold;
            display: flex;
            align-items: center;
            border-left: 4px solid;
        }

        .sap-message-success {
            background-color: #f1fdf6;
            color: #107e3e;
            border-left-color: #107e3e;
        }

        .sap-message-error {
            background-color: #ffeef0;
            color: #bb0000;
            border-left-color: #bb0000;
        }
        
        .current-image-wrapper {
            margin-top: 0.5rem;
            padding: 0.5rem;
            background: #fbfbfb;
            border: 1px dashed var(--sapBorderColor);
            border-radius: 4px;
            display: inline-block;
        }
    </style>
</head>

<body>

    <!-- SAP Fiori Shell Bar -->
    <header class="sap-shellbar">
        <div class="sap-shellbar-title">Enterprise Portal / Latest News Management</div>
    </header>

    <div class="sap-page">

        <div class="sap-page-header">
            <h1 class="sap-page-title">News Administration</h1>
        </div>

        <%
            String success = request.getParameter("success");
            String error = request.getParameter("error");

            if ("added".equals(success)) {
        %>
            <div class="sap-message-strip sap-message-success">
                <span>✓ News entry added successfully.</span>
            </div>
        <%
            } else if ("updated".equals(success)) {
        %>
            <div class="sap-message-strip sap-message-success">
                <span>✓ News entry updated successfully.</span>
            </div>
        <%
            } else if ("deleted".equals(success)) {
        %>
            <div class="sap-message-strip sap-message-success">
                <span>✓ News entry deleted successfully.</span>
            </div>
        <%
            } else if ("1".equals(error)) {
        %>
            <div class="sap-message-strip sap-message-error">
                <span>⚠ An error occurred while processing your request. Please try again.</span>
            </div>
        <%
            }
        %>

        <!-- Form Card -->
        <div class="sap-card">
            <h2 class="sap-card-title">
                <%= (editId == null || editId.trim().isEmpty()) ? "Create News Entry" : "Edit News Entry" %>
            </h2>
            
            <form action="LatestNewsServlet" method="post" enctype="multipart/form-data">

                <% if (editId == null || editId.trim().isEmpty()) { %>
                    <input type="hidden" name="action" value="add">
                <% } else { %>
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="<%= id %>">
                <% } %>

                <div class="sap-form-item">
                    <label class="sap-label">Event Name <span style="color:#ee0000;">*</span></label>
                    <input type="text" class="sap-input" name="event_name" value="<%= eventName != null ? eventName : "" %>" required>
                </div>

                <div class="sap-form-item">
                    <label class="sap-label">Description <span style="color:#ee0000;">*</span></label>
                    <textarea class="sap-textarea" name="description" required><%= description != null ? description : "" %></textarea>
                </div>

                <div class="sap-form-item">
                    <label class="sap-label">Thumbnail Image <%= (editId == null || editId.trim().isEmpty()) ? "<span style='color:#ee0000;'>*</span>" : "" %></label>
                    <input type="file" class="sap-file" name="image" accept="image/*" <%= (editId == null || editId.trim().isEmpty()) ? "required" : "" %>>
                    
                    <% if (!base64Image.isEmpty()) { %>
                        <div class="current-image-wrapper">
                            <label class="sap-label" style="margin-bottom:0.5rem;">Current Image</label>
                            <img src="data:image/jpeg;base64,<%= base64Image %>" class="sap-img-preview" alt="Current News Image">
                        </div>
                    <% } %>
                </div>

                <div class="sap-btn-group">
                    <button type="submit" class="sap-btn sap-btn-emphasized">
                        <%= (editId == null || editId.trim().isEmpty()) ? "Save Entry" : "Update Entry" %>
                    </button>
                    <% if (editId != null && !editId.trim().isEmpty()) { %>
                        <a href="latestNews.jsp" class="sap-btn sap-btn-standard">Cancel</a>
                    <% } %>
                </div>

            </form>
        </div>

        <!-- Data Table Card -->
        <div class="sap-card">
            <h2 class="sap-card-title">Existing News Records</h2>

            <div class="sap-table-wrapper">
                <table class="sap-table">
                    <thead>
                        <tr>
                            <th style="width: 50px;">ID</th>
                            <th style="width: 100px;">Image</th>
                            <th style="width: 25%;">Event Name</th>
                            <th>Description</th>
                            <th style="width: 15%;">Date Created</th>
                            <th style="width: 150px; text-align: center;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            String sqlList = "SELECT * FROM latest_news ORDER BY created_at DESC";

                            try (Connection con = DBUtil.getConnection(branch);
                                 PreparedStatement ps = con.prepareStatement(sqlList);
                                 ResultSet rs = ps.executeQuery()) {

                                boolean found = false;

                                while (rs.next()) {
                                    found = true;
                                    byte[] imgBytes = rs.getBytes("image");
                                    String rowBase64Image = "";

                                    if (imgBytes != null && imgBytes.length > 0) {
                                        rowBase64Image = Base64.getEncoder().encodeToString(imgBytes);
                                    }
                        %>
                        <tr>
                            <td><strong><%= rs.getInt("id") %></strong></td>
                            <td>
                                <% if (!rowBase64Image.isEmpty()) { %>
                                    <img src="data:image/jpeg;base64,<%= rowBase64Image %>" class="sap-img-preview" alt="News Image">
                                <% } else { %>
                                    <span style="color:#89919a; font-style:italic; font-size:0.75rem;">No Image</span>
                                <% } %>
                            </td>
                            <td style="font-weight: bold; color: var(--sapLinkColor);"><%= rs.getString("event_name") %></td>
                            <td><%= rs.getString("description") %></td>
                            <td style="color: #556b82; font-size: 0.75rem;"><%= rs.getTimestamp("created_at") %></td>
                            <td style="text-align: center;">
                                <a href="latestNews.jsp?edit=<%= rs.getInt("id") %>" class="sap-btn sap-btn-standard" style="padding: 0.25rem 0.5rem; min-width: auto; margin-right:0.25rem;">Edit</a>
                                <a href="LatestNewsServlet?action=delete&id=<%= rs.getInt("id") %>" class="sap-btn sap-btn-reject" style="padding: 0.25rem 0.5rem; min-width: auto;" onclick="return confirm('Are you sure you want to permanently delete this news entry?');">Delete</a>
                            </td>
                        </tr>
                        <%
                                }
                                if (!found) {
                        %>
                        <tr>
                            <td colspan="6" style="text-align:center; padding: 2rem; color: #556b82;">
                                <em>No news entries available.</em>
                            </td>
                        </tr>
                        <%
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                        %>
                        <tr>
                            <td colspan="6" style="text-align:center; padding: 2rem; color: #bb0000;">
                                <em>System Error: Unable to load news records. Please contact administration.</em>
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

</body>
</html>