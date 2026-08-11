<%@ page import="java.sql.*, com.bean.DBUtil" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Manage News & Events</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<style>
body { background-color: #f8f9fa; padding: 20px; font-family: Arial, sans-serif; }
.container { max-width: 1100px; }
h2 { margin-top: 40px; color: #4b2000; border-bottom: 2px solid #e66d26; padding-bottom: 10px; }
.table img { width: 60px; height: 40px; object-fit: cover; border-radius: 4px; }
.btn-sm { padding: 3px 8px; }
</style>
</head>
<body>

<div class="container">
    <h1 class="text-center mb-4 text-primary">Manage Latest News & Events</h1>

    <!-- ========== LATEST NEWS MANAGEMENT ========== -->
    <h2>Latest News</h2>

    <!-- Add News Form -->
    <form method="post" action="">
        <input type="hidden" name="action" value="addNews">
        <div class="row mb-2">
            <div class="col-md-3"><input class="form-control" name="title" placeholder="Title" required></div>
            <div class="col-md-3"><input class="form-control" name="image" placeholder="Image Path (e.g. Home/img.jpg)"></div>
            <div class="col-md-3"><input class="form-control" name="link" placeholder="Link URL"></div>
            <div class="col-md-3"><input class="form-control" name="description" placeholder="Description"></div>
        </div>
        <button class="btn btn-success btn-sm">Add News</button>
    </form>

    <%
        // Handle add/update/delete for News
        String action = request.getParameter("action");
        if (action != null) {
            Connection con = null; PreparedStatement ps = null;
            try {
                con = DBUtil.getConnection();
                if (action.equals("addNews")) {
                    ps = con.prepareStatement("INSERT INTO latest_news (title, description, image, link) VALUES (?, ?, ?, ?)");
                    ps.setString(1, request.getParameter("title"));
                    ps.setString(2, request.getParameter("description"));
                    ps.setString(3, request.getParameter("image"));
                    ps.setString(4, request.getParameter("link"));
                    ps.executeUpdate();
                } else if (action.equals("updateNews")) {
                    ps = con.prepareStatement("UPDATE latest_news SET title=?, description=?, image=?, link=? WHERE id=?");
                    ps.setString(1, request.getParameter("title"));
                    ps.setString(2, request.getParameter("description"));
                    ps.setString(3, request.getParameter("image"));
                    ps.setString(4, request.getParameter("link"));
                    ps.setInt(5, Integer.parseInt(request.getParameter("id")));
                    ps.executeUpdate();
                } else if (action.equals("deleteNews")) {
                    ps = con.prepareStatement("DELETE FROM latest_news WHERE id=?");
                    ps.setInt(1, Integer.parseInt(request.getParameter("id")));
                    ps.executeUpdate();
                }
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
            } finally { if (ps != null) ps.close(); if (con != null) con.close(); }
        }
    %>

    <!-- News Table -->
    <table class="table table-bordered table-striped mt-3">
        <thead class="table-warning">
            <tr><th>ID</th><th>Title</th><th>Image</th><th>Link</th><th>Description</th><th>Actions</th></tr>
        </thead>
        <tbody>
        <%
            try {
                Connection con = DBUtil.getConnection();
                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery("SELECT * FROM latest_news ORDER BY id DESC");
                while (rs.next()) {
        %>
            <tr>
                <form method="post" action="">
                    <td><%= rs.getInt("id") %></td>
                    <td><input class="form-control form-control-sm" name="title" value="<%= rs.getString("title") %>"></td>
                    <td><input class="form-control form-control-sm" name="image" value="<%= rs.getString("image") %>"></td>
                    <td><input class="form-control form-control-sm" name="link" value="<%= rs.getString("link") %>"></td>
                    <td><input class="form-control form-control-sm" name="description" value="<%= rs.getString("description") %>"></td>
                    <td>
                        <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                        <button name="action" value="updateNews" class="btn btn-primary btn-sm">Update</button>
                        <button name="action" value="deleteNews" class="btn btn-danger btn-sm" onclick="return confirm('Delete this news?')">Delete</button>
                    </td>
                </form>
            </tr>
        <%
                }
                rs.close(); st.close(); con.close();
            } catch (Exception e) {
                out.print("<tr><td colspan='6'>Error loading news: " + e.getMessage() + "</td></tr>");
            }
        %>
        </tbody>
    </table>


    <!-- ========== EVENTS MANAGEMENT ========== -->
    <h2>Upcoming Events</h2>

    <!-- Add Event Form -->
    <form method="post" action="">
        <input type="hidden" name="action" value="addEvent">
        <div class="row mb-2">
            <div class="col-md-3"><input class="form-control" type="date" name="event_date" required></div>
            <div class="col-md-3"><input class="form-control" name="title" placeholder="Event Title" required></div>
            <div class="col-md-3"><input class="form-control" name="icon" placeholder="Icon (optional)" value="bell"></div>
            <div class="col-md-3"><input class="form-control" name="description" placeholder="Description"></div>
        </div>
        <button class="btn btn-success btn-sm">Add Event</button>
    </form>

    <%
        // Handle add/update/delete for Events
        if (action != null) {
            Connection con = null; PreparedStatement ps = null;
            try {
                con = DBUtil.getConnection();
                if (action.equals("addEvent")) {
                    ps = con.prepareStatement("INSERT INTO events (event_date, title, description, icon) VALUES (?, ?, ?, ?)");
                    ps.setString(1, request.getParameter("event_date"));
                    ps.setString(2, request.getParameter("title"));
                    ps.setString(3, request.getParameter("description"));
                    ps.setString(4, request.getParameter("icon"));
                    ps.executeUpdate();
                } else if (action.equals("updateEvent")) {
                    ps = con.prepareStatement("UPDATE events SET event_date=?, title=?, description=?, icon=? WHERE id=?");
                    ps.setString(1, request.getParameter("event_date"));
                    ps.setString(2, request.getParameter("title"));
                    ps.setString(3, request.getParameter("description"));
                    ps.setString(4, request.getParameter("icon"));
                    ps.setInt(5, Integer.parseInt(request.getParameter("id")));
                    ps.executeUpdate();
                } else if (action.equals("deleteEvent")) {
                    ps = con.prepareStatement("DELETE FROM events WHERE id=?");
                    ps.setInt(1, Integer.parseInt(request.getParameter("id")));
                    ps.executeUpdate();
                }
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
            } finally { if (ps != null) ps.close(); if (con != null) con.close(); }
        }
    %>

    <!-- Events Table -->
    <table class="table table-bordered table-striped mt-3">
        <thead class="table-warning">
            <tr><th>ID</th><th>Date</th><th>Title</th><th>Icon</th><th>Description</th><th>Actions</th></tr>
        </thead>
        <tbody>
        <%
            try {
                Connection con = DBUtil.getConnection();
                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery("SELECT * FROM events ORDER BY event_date DESC");
                while (rs.next()) {
        %>
            <tr>
                <form method="post" action="">
                    <td><%= rs.getInt("id") %></td>
                    <td><input class="form-control form-control-sm" type="date" name="event_date" value="<%= rs.getDate("event_date") %>"></td>
                    <td><input class="form-control form-control-sm" name="title" value="<%= rs.getString("title") %>"></td>
                    <td><input class="form-control form-control-sm" name="icon" value="<%= rs.getString("icon") %>"></td>
                    <td><input class="form-control form-control-sm" name="description" value="<%= rs.getString("description") %>"></td>
                    <td>
                        <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                        <button name="action" value="updateEvent" class="btn btn-primary btn-sm">Update</button>
                        <button name="action" value="deleteEvent" class="btn btn-danger btn-sm" onclick="return confirm('Delete this event?')">Delete</button>
                    </td>
                </form>
            </tr>
        <%
                }
                rs.close(); st.close(); con.close();
            } catch (Exception e) {
                out.print("<tr><td colspan='6'>Error loading events: " + e.getMessage() + "</td></tr>");
            }
        %>
        </tbody>
    </table>
</div>

</body>
</html>
