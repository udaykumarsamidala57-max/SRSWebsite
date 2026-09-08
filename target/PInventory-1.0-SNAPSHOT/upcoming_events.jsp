<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Upcoming Events</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f4f4f9; }
        .container { max-width: 900px; margin: auto; }
        
        /* Form Section Styles */
        .form-card {
            background: #ffffff;
            border-radius: 8px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; color: #333; }
        .form-group input[type="text"],
        .form-group input[type="date"],
        .form-group input[type="time"],
        .form-group textarea,
        .form-group input[type="file"] {
            width: 100%;
            padding: 8px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .form-row { display: flex; gap: 15px; }
        .form-row .form-group { flex: 1; }
        .btn-submit {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 16px;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn-submit:hover { background-color: #0056b3; }
        
        /* Feedback Messages */
        .alert-error { color: #721c24; background-color: #f8d7da; border: 1px solid #f5c6cb; padding: 10px; border-radius: 4px; margin-bottom: 15px; }
        .alert-success { color: #155724; background-color: #d4edda; border: 1px solid #c3e6cb; padding: 10px; border-radius: 4px; margin-bottom: 15px; }

        /* Event List Styles */
        .event-card { 
            background: #ffffff; 
            border-radius: 8px; 
            padding: 20px; 
            margin-bottom: 20px; 
            box-shadow: 0 2px 5px rgba(0,0,0,0.1); 
            display: flex;
            gap: 20px;
        }
        .event-image { max-width: 200px; max-height: 150px; border-radius: 6px; object-fit: cover; }
        .event-details { flex: 1; }
        .event-title { margin-top: 0; color: #333; }
        .event-meta { color: #666; font-size: 0.9em; margin-bottom: 10px; }
        .no-image { width: 200px; height: 120px; background: #e0e0e0; display: flex; align-items: center; justify-content: center; color: #777; border-radius: 6px; }
    </style>
</head>
<body>

<div class="container">

    <!-- Feedback Alerts -->
    <c:if test="${not empty errorMessage}">
        <div class="alert-error">${errorMessage}</div>
    </c:if>
    <c:if test="${not empty successMessage}">
        <div class="alert-success">${successMessage}</div>
    </c:if>

    <!-- Insert Event Form -->
    <div class="form-card">
        <h2>Add New Event</h2>
        <form action="upcoming-events" method="post" enctype="multipart/form-data">
            
            <div class="form-group">
                <label for="event_name">Event Name *</label>
                <input type="text" id="event_name" name="event_name" required placeholder="e.g. Annual Tech Conference">
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="event_date">Event Date *</label>
                    <input type="date" id="event_date" name="event_date" required>
                </div>
                <div class="form-group">
                    <label for="place">Place / Location</label>
                    <input type="text" id="place" name="place" placeholder="e.g. Main Auditorium">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="time_from">Start Time</label>
                    <input type="time" id="time_from" name="time_from">
                </div>
                <div class="form-group">
                    <label for="time_to">End Time</label>
                    <input type="time" id="time_to" name="time_to">
                </div>
            </div>

            <div class="form-group">
                <label for="event_description">Description</label>
                <textarea id="event_description" name="event_description" rows="3" placeholder="Enter event details..."></textarea>
            </div>

            <div class="form-group">
                <label for="image_blob">Event Image (Optional)</label>
                <input type="file" id="image_blob" name="image_blob" accept="image/*">
            </div>

            <button type="submit" class="btn-submit">Add Event</button>
        </form>
    </div>

    <!-- Event List -->
    <h2>Upcoming Events</h2>
    <c:choose>
        <c:when test="${not empty events}">
            <c:forEach var="event" items="${events}">
                <div class="event-card">
                    <!-- Image Section -->
                    <div>
                        <c:choose>
                            <c:when test="${not empty event.imageBase64}">
                                <img src="data:image/jpeg;base64,${event.imageBase64}" alt="${event.eventName}" class="event-image" />
                            </c:when>
                            <c:otherwise>
                                <div class="no-image">No Image</div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Details Section -->
                    <div class="event-details">
                        <h3 class="event-title">${event.eventName}</h3>
                        <div class="event-meta">
                            <strong>Date:</strong> ${event.eventDate} | 
                            <strong>Time:</strong> ${event.timeFrom != null ? event.timeFrom : 'N/A'} - ${event.timeTo != null ? event.timeTo : 'N/A'}<br>
                            <strong>Location:</strong> ${event.place != null ? event.place : 'TBD'}
                        </div>
                        <p>${event.eventDescription}</p>
                    </div>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <p>No upcoming events found.</p>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>