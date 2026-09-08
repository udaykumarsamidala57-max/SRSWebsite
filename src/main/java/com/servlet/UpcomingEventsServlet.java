package com.servlet;

import com.bean.DBUtil;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import java.io.InputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/upcoming-events")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class UpcomingEventsServlet extends HttpServlet {

    // -------------------------------------------------------------------------
    // GET: Retrieve and Display Events
    // -------------------------------------------------------------------------
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession sess = request.getSession(false);
        if (sess == null || sess.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String branch = (String) sess.getAttribute("branch");
        List<Map<String, Object>> eventList = new ArrayList<>();
        String sql = "SELECT id, event_date, event_name, time_from, time_to, place, event_description, image_blob " +
                     "FROM upcoming_events ORDER BY event_date ASC";

        try (Connection conn = DBUtil.getConnection(branch);
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> event = new HashMap<>();
                event.put("id", rs.getInt("id"));
                event.put("eventDate", rs.getDate("event_date"));
                event.put("eventName", rs.getString("event_name"));
                event.put("timeFrom", rs.getTime("time_from"));
                event.put("timeTo", rs.getTime("time_to"));
                event.put("place", rs.getString("place"));
                event.put("eventDescription", rs.getString("event_description"));

                InputStream inputStream = rs.getBinaryStream("image_blob");
                if (inputStream != null) {
                    byte[] bytes = inputStream.readAllBytes();
                    if (bytes.length > 0) {
                        String base64Image = Base64.getEncoder().encodeToString(bytes);
                        event.put("imageBase64", base64Image);
                    } else {
                        event.put("imageBase64", null);
                    }
                } else {
                    event.put("imageBase64", null);
                }

                eventList.add(event);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
        }

        request.setAttribute("events", eventList);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/upcoming_events.jsp");
        dispatcher.forward(request, response);
    }

    // -------------------------------------------------------------------------
    // POST: Insert New Event
    // -------------------------------------------------------------------------
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession sess = request.getSession(false);
        if (sess == null || sess.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String branch = (String) sess.getAttribute("branch");

        // 1. Retrieve Form Fields
        String eventDateStr = request.getParameter("event_date");
        String eventName = request.getParameter("event_name");
        String timeFromStr = request.getParameter("time_from");
        String timeToStr = request.getParameter("time_to");
        String place = request.getParameter("place");
        String eventDescription = request.getParameter("event_description");
        Part imagePart = request.getPart("image_blob");

        // 2. Insert Query
        String sql = "INSERT INTO upcoming_events (event_date, event_name, time_from, time_to, place, event_description, image_blob) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection(branch);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Required Fields
            ps.setDate(1, Date.valueOf(eventDateStr)); // Format: YYYY-MM-DD
            ps.setString(2, eventName);

            // Optional Time Fields (Convert "HH:mm" to java.sql.Time or set NULL)
            if (timeFromStr != null && !timeFromStr.trim().isEmpty()) {
                ps.setTime(3, Time.valueOf(timeFromStr.length() == 5 ? timeFromStr + ":00" : timeFromStr));
            } else {
                ps.setNull(3, Types.TIME);
            }

            if (timeToStr != null && !timeToStr.trim().isEmpty()) {
                ps.setTime(4, Time.valueOf(timeToStr.length() == 5 ? timeToStr + ":00" : timeToStr));
            } else {
                ps.setNull(4, Types.TIME);
            }

            // Optional Text Fields
            ps.setString(5, (place != null && !place.trim().isEmpty()) ? place : null);
            ps.setString(6, (eventDescription != null && !eventDescription.trim().isEmpty()) ? eventDescription : null);

            // Image Binary Stream (Mediumblob)
            if (imagePart != null && imagePart.getSize() > 0) {
                ps.setBinaryStream(7, imagePart.getInputStream(), (int) imagePart.getSize());
            } else {
                ps.setNull(7, Types.BLOB);
            }

            int rowsInserted = ps.executeUpdate();
            if (rowsInserted > 0) {
                request.setAttribute("successMessage", "Event added successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to add event.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Invalid date/time format submitted.");
        }

        // Re-load the list and return to the page
        doGet(request, response);
    }

    private boolean isAuthorized(String role) {
        if (role == null) {
            return false;
        }
        return role.equalsIgnoreCase("ADMIN") || 
               role.equalsIgnoreCase("MANAGER") || 
               role.equalsIgnoreCase("USER");
    }
}