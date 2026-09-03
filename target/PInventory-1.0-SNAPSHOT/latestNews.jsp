```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
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
    String image = "";
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
                    image = rs.getString("image");
                }
            }
        }
    }
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Latest News</title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
            margin: 30px;
        }

        .container {
            max-width: 1100px;
            margin: auto;
            background: #fff;
            padding: 25px;
            border-radius: 10px;
        }

        h2 {
            margin-bottom: 20px;
        }

        label {
            display: block;
            font-weight: bold;
            margin-bottom: 6px;
        }

        input[type="text"],
        textarea {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        textarea {
            height: 120px;
            resize: vertical;
        }

        input[type="file"] {
            margin-bottom: 15px;
        }

        button {
            background: #333;
            color: white;
            border: none;
            padding: 10px 18px;
            cursor: pointer;
            border-radius: 5px;
        }

        .cancel {
            background: #777;
            color: white;
            padding: 10px 18px;
            text-decoration: none;
            border-radius: 5px;
            margin-left: 5px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 30px;
        }

        th,
        td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
            vertical-align: middle;
        }

        th {
            background: #eee;
        }

        .news-image {
            width: 100px;
            height: 70px;
            object-fit: cover;
            border-radius: 5px;
        }

        .edit {
            background: #2878d0;
            color: white;
            padding: 7px 12px;
            text-decoration: none;
            border-radius: 4px;
        }

        .delete {
            background: #d33;
            color: white;
            padding: 7px 12px;
            text-decoration: none;
            border-radius: 4px;
            margin-left: 5px;
        }

        .message {
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 5px;
        }

        .success {
            background: #dff0d8;
            color: #3c763d;
        }

        .error {
            background: #f2dede;
            color: #a94442;
        }

    </style>

</head>

<body>

<div class="container">

    <h2>Latest News</h2>

    <%
        String success = request.getParameter("success");
        String error = request.getParameter("error");

        if ("added".equals(success)) {
    %>

        <div class="message success">
            News added successfully.
        </div>

    <%
        } else if ("updated".equals(success)) {
    %>

        <div class="message success">
            News updated successfully.
        </div>

    <%
        } else if ("deleted".equals(success)) {
    %>

        <div class="message success">
            News deleted successfully.
        </div>

    <%
        } else if ("1".equals(error)) {
    %>

        <div class="message error">
            Something went wrong.
        </div>

    <%
        }
    %>


    <form action="LatestNewsServlet"
          method="post"
          enctype="multipart/form-data">

        <%
            if (editId == null || editId.trim().isEmpty()) {
        %>

            <input type="hidden"
                   name="action"
                   value="add">

        <%
            } else {
        %>

            <input type="hidden"
                   name="action"
                   value="update">

            <input type="hidden"
                   name="id"
                   value="<%= id %>">

            <input type="hidden"
                   name="old_image"
                   value="<%= image != null ? image : "" %>">

        <%
            }
        %>


        <label>Event Name</label>

        <input type="text"
               name="event_name"
               value="<%= eventName != null ? eventName : "" %>"
               required>


        <label>Description</label>

        <textarea name="description"
                  required><%= description != null ? description : "" %></textarea>


        <label>Image</label>

        <input type="file"
               name="image"
               accept="image/*"
               <%= (editId == null || editId.trim().isEmpty()) ? "required" : "" %>>


        <%
            if (image != null && !image.isEmpty()) {
        %>

            <br>

            <span>Current Image:</span><br><br>

            <img src="uploads/news/<%= image %>"
                 class="news-image">

            <br><br>

        <%
            }
        %>


        <button type="submit">
            <%= (editId == null || editId.trim().isEmpty())
                    ? "Add News"
                    : "Update News" %>
        </button>


        <%
            if (editId != null && !editId.trim().isEmpty()) {
        %>

            <a href="latestNews.jsp" class="cancel">
                Cancel
            </a>

        <%
            }
        %>

    </form>


    <h2 style="margin-top:40px;">News List</h2>


    <table>

        <tr>
            <th>ID</th>
            <th>Image</th>
            <th>Event Name</th>
            <th>Description</th>
            <th>Date</th>
            <th>Action</th>
        </tr>


        <%

            String sql =
                    "SELECT * FROM latest_news " +
                    "ORDER BY created_at DESC";

            try (Connection con = DBUtil.getConnection(branch);
                 PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                boolean found = false;

                while (rs.next()) {

                    found = true;

                    String newsImage = rs.getString("image");

        %>

        <tr>

            <td>
                <%= rs.getInt("id") %>
            </td>

            <td>

                <%
                    if (newsImage != null &&
                        !newsImage.trim().isEmpty()) {
                %>

                    <img src="uploads/news/<%= newsImage %>"
                         class="news-image">

                <%
                    } else {
                %>

                    No Image

                <%
                    }
                %>

            </td>

            <td>
                <%= rs.getString("event_name") %>
            </td>

            <td>
                <%= rs.getString("description") %>
            </td>

            <td>
                <%= rs.getTimestamp("created_at") %>
            </td>

            <td>

                <a href="latestNews.jsp?edit=<%= rs.getInt("id") %>"
                   class="edit">
                    Edit
                </a>

                <a href="LatestNewsServlet?action=delete&id=<%= rs.getInt("id") %>"
                   class="delete"
                   onclick="return confirm('Are you sure you want to delete this news?');">
                    Delete
                </a>

            </td>

        </tr>

        <%
                }

                if (!found) {
        %>

        <tr>
            <td colspan="6" style="text-align:center;">
                No news available.
            </td>
        </tr>

        <%
                }

            } catch (Exception e) {

                e.printStackTrace();
        %>

        <tr>
            <td colspan="6" style="text-align:center;color:red;">
                Unable to load news.
            </td>
        </tr>

        <%
            }
        %>

    </table>

</div>

</body>
</html>
```
