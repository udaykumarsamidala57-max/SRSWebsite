package com.servlet;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.bean.DBUtil; // assuming DBUtil.getConnection() is available

@WebServlet("/HomeDataServlet")
public class HomeDataServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;
        PreparedStatement psNews = null, psEvents = null;
        ResultSet rsNews = null, rsEvents = null;

        List<Map<String, Object>> newsList = new ArrayList<>();
        List<Map<String, Object>> eventList = new ArrayList<>();

        try {
            con = DBUtil.getConnection();

            // ---- Fetch latest_news ----
            String sqlNews = "SELECT id, title, description, image, link, created_at FROM latest_news ORDER BY created_at DESC LIMIT 5";
            psNews = con.prepareStatement(sqlNews);
            rsNews = psNews.executeQuery();

            while (rsNews.next()) {
                Map<String, Object> news = new HashMap<>();
                news.put("id", rsNews.getInt("id"));
                news.put("title", rsNews.getString("title"));
                news.put("description", rsNews.getString("description"));
                news.put("image", rsNews.getString("image"));
                news.put("link", rsNews.getString("link"));
                news.put("created_at", rsNews.getTimestamp("created_at"));
                newsList.add(news);
            }

            // ---- Fetch events ----
            String sqlEvents = "SELECT id, event_date, title, description, icon, created_at FROM events ORDER BY event_date DESC LIMIT 5";
            psEvents = con.prepareStatement(sqlEvents);
            rsEvents = psEvents.executeQuery();

            while (rsEvents.next()) {
                Map<String, Object> event = new HashMap<>();
                event.put("id", rsEvents.getInt("id"));
                event.put("event_date", rsEvents.getDate("event_date"));
                event.put("title", rsEvents.getString("title"));
                event.put("description", rsEvents.getString("description"));
                event.put("icon", rsEvents.getString("icon"));
                event.put("created_at", rsEvents.getTimestamp("created_at"));
                eventList.add(event);
            }

            // Set both lists as request attributes
            request.setAttribute("newsList", newsList);
            request.setAttribute("eventList", eventList);

            // Forward to Home.jsp
            RequestDispatcher rd = request.getRequestDispatcher("Home.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        } finally {
            try { if (rsNews != null) rsNews.close(); } catch (Exception e) {}
            try { if (rsEvents != null) rsEvents.close(); } catch (Exception e) {}
            try { if (psNews != null) psNews.close(); } catch (Exception e) {}
            try { if (psEvents != null) psEvents.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}
