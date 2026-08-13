package com.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/navigation")
public class NavigationServlet extends HttpServlet {

    // Update database credentials according to your setup
    private static final String DB_URL = "jdbc:mysql://localhost:3306/your_database_name";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "password";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Map<String, String>> pageList = new ArrayList<>();

        String query = "SELECT id, title, slug FROM pages ORDER BY title ASC";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                 PreparedStatement stmt = conn.prepareStatement(query);
                 ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    Map<String, String> page = new HashMap<>();
                    page.put("id", String.valueOf(rs.getLong("id")));
                    page.put("title", rs.getString("title"));
                    page.put("slug", rs.getString("slug"));
                    pageList.add(page);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Pass the list to the request scope
        request.setAttribute("dynamicPages", pageList);

        // Forward to your JSP page
        request.getRequestDispatcher("/your-page.jsp").forward(request, response);
    }
}