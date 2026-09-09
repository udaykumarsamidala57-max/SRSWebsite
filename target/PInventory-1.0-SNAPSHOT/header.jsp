<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Session check MUST be at the very top before any white space or dynamic output
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String user   = (String) sess.getAttribute("username");
    String role   = (String) sess.getAttribute("role");
    String dept   = (String) sess.getAttribute("department");
    String branch = (String) sess.getAttribute("branch");
%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!-- Isolated Header Styles -->
<style type="text/css">
    /* Encapsulated Shell Bar Scoping */
    .sap-shell-bar {
        all: initial;
        box-sizing: border-box;
        display: flex;
        align-items: center;
        justify-content: space-between;
        position: sticky;
        top: 0;
        z-index: 1000;
        width: 100%;
        height: 48px;
        background-color: var(--sap-shell-bg, #1c2d42);
        padding: 0 1.5rem;
        font-family: var(--sap-font-family, 'Inter', '72', -apple-system, sans-serif);
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
    }

    .sap-shell-bar *, 
    .sap-shell-bar *::before, 
    .sap-shell-bar *::after {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
        font-family: inherit;
    }

    /* Brand Section */
    .sap-shell-bar .shell-brand {
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }

    .sap-shell-bar .shell-title {
        font-size: 0.95rem;
        font-weight: 600;
        color: #ffffff;
        letter-spacing: -0.01em;
        line-height: 1;
    }

    /* Controls & Actions */
    .sap-shell-bar .shell-actions {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        font-size: 0.8125rem;
    }

    .sap-shell-bar .shell-link {
        display: inline-flex;
        align-items: center;
        gap: 0.4rem;
        padding: 0.35rem 0.75rem;
        border-radius: var(--sap-radius-sm, 4px);
        background-color: rgba(255, 255, 255, 0.08);
        border: 1px solid rgba(255, 255, 255, 0.15);
        color: #ffffff;
        font-weight: 500;
        text-decoration: none;
        transition: background-color 0.15s ease, border-color 0.15s ease;
    }

    .sap-shell-bar .shell-link:hover {
        background-color: rgba(255, 255, 255, 0.16);
        border-color: rgba(255, 255, 255, 0.25);
    }

    /* User Profile Info Badge */
    .sap-shell-bar .shell-user-badge {
        display: none;
        align-items: center;
        gap: 0.5rem;
        padding: 0.35rem 0.75rem;
        border-radius: var(--sap-radius-sm, 4px);
        background-color: rgba(255, 255, 255, 0.06);
        border: 1px solid rgba(255, 255, 255, 0.12);
        color: #e2e8f0;
    }

    @media (min-width: 768px) {
        .sap-shell-bar .shell-user-badge {
            display: inline-flex;
        }
    }

    .sap-shell-bar .status-dot {
        width: 6px;
        height: 6px;
        border-radius: 50%;
        background-color: #10b981;
    }

    .sap-shell-bar .badge-role {
        color: #93c5fd;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.03em;
    }

    .sap-shell-bar .badge-divider {
        color: #64748b;
    }

    /* Logout Action Button */
    .sap-shell-bar .btn-shell-danger {
        display: inline-flex;
        align-items: center;
        gap: 0.4rem;
        padding: 0.35rem 0.75rem;
        border-radius: var(--sap-radius-sm, 4px);
        background-color: #fef2f2;
        color: #dc2626;
        border: 1px solid #fca5a5;
        font-weight: 600;
        font-size: 0.8125rem;
        text-decoration: none;
        transition: background-color 0.15s ease;
    }

    .sap-shell-bar .btn-shell-danger:hover {
        background-color: #fee2e2;
    }

    /* Icon Sizing */
    .sap-shell-bar .shell-icon {
        width: 14px;
        height: 14px;
        flex-shrink: 0;
    }
</style>

<!-- Header Navbar (SAP Shell Bar Style) -->
<header class="sap-shell-bar">
    <div class="shell-brand">
        <h1 class="shell-title">Dynamic Page Builder</h1>
    </div>
    
    <div class="shell-actions">
    
    <a href="<c:url value='/pages'/>" class="shell-link">
            <svg class="shell-icon" style="color: #93c5fd;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 20H5a2 2 0 01-2-2V6a2 2 0 012-2h10a2 2 0 012 2v1m2 13a2 2 0 01-2-2V7m2 13a2 2 0 002-2V9a2 2 0 00-2-2h-2m-4-3H9M7 16h6M7 8h6v4H7V8z"/>
            </svg>
            <span>Create Pages</span>
        </a>
    
        <!-- Link to LatestNewsServlet -->
        <a href="<c:url value='/LatestNewsServlet'/>" class="shell-link">
            <svg class="shell-icon" style="color: #93c5fd;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 20H5a2 2 0 01-2-2V6a2 2 0 012-2h10a2 2 0 012 2v1m2 13a2 2 0 01-2-2V7m2 13a2 2 0 002-2V9a2 2 0 00-2-2h-2m-4-3H9M7 16h6M7 8h6v4H7V8z"/>
            </svg>
            <span>Latest News</span>
        </a>
        
        <a href="<c:url value='/upcoming-events'/>" class="shell-link">
            <svg class="shell-icon" style="color: #93c5fd;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
            </svg>
            <span>Upcoming Events</span>
        </a>

        <!-- User Information Badge -->
        <div class="shell-user-badge">
            <span class="status-dot"></span>
            <span>User: <strong style="color: #ffffff;">${fn:escapeXml(user)}</strong></span>
            <span class="badge-divider">|</span>
            <span class="badge-role">${fn:escapeXml(role)}</span>
            <% if (branch != null && !branch.trim().isEmpty()) { %>
                <span class="badge-divider">|</span>
                <span>Branch: <strong style="color: #ffffff;">${fn:escapeXml(branch)}</strong></span>
            <% } %>
        </div>

        <!-- Logout Action -->
        <a href="Logout.jsp" class="btn-shell-danger">
            <svg class="shell-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
            </svg>
            <span>Logout</span>
        </a>
    </div>
</header>