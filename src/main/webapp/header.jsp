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
    String initials = (user != null && !user.trim().isEmpty()) ? user.trim().substring(0, 1).toUpperCase() : "?";
    boolean canMove = "Global".equalsIgnoreCase(role) || "Admin".equalsIgnoreCase(role);
%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!-- Admin top bar (styles are self-contained so every admin page looks the same) -->
<style type="text/css">
    .srs-topbar {
        all: initial;
        box-sizing: border-box;
        position: sticky;
        top: 0;
        z-index: 1000;
        display: flex;
        align-items: center;
        gap: 20px;
        width: 100%;
        height: 56px;
        padding: 0 20px;
        background: #2b1206;
        border-bottom: 3px solid #e0701b;
        font-family: 'Inter', system-ui, -apple-system, 'Segoe UI', sans-serif;
        color: #fff;
        -webkit-font-smoothing: antialiased;
    }
    .srs-topbar *, .srs-topbar *::before, .srs-topbar *::after { box-sizing: border-box; margin: 0; padding: 0; font-family: inherit; }
    .srs-topbar a { text-decoration: none; color: inherit; }
    .srs-topbar .tb-brand { display: flex; align-items: center; gap: 10px; flex: 0 0 auto; }
    .srs-topbar .tb-mark {
        width: 32px; height: 32px; border-radius: 9px;
        display: flex; align-items: center; justify-content: center;
        background: #e0701b; color: #fff; font-size: 13px; font-weight: 800; letter-spacing: .02em;
    }
    .srs-topbar .tb-name { display: flex; flex-direction: column; line-height: 1.15; }
    .srs-topbar .tb-name b { font-size: 14px; font-weight: 700; color: #fff; }
    .srs-topbar .tb-name small { font-size: 11px; color: #d9b89c; letter-spacing: .04em; }
    .srs-topbar .tb-nav { display: flex; align-items: stretch; gap: 2px; height: 100%; margin-left: 12px; }
    .srs-topbar .tb-nav a {
        position: relative; display: flex; align-items: center; gap: 7px;
        padding: 0 12px; color: #e9d7c7; font-size: 13px; font-weight: 600;
        transition: color .15s ease, background-color .15s ease;
    }
    .srs-topbar .tb-nav a:hover { color: #fff; background: rgba(255,255,255,.06); }
    .srs-topbar .tb-nav a.active { color: #fff; }
    .srs-topbar .tb-nav a.active::after {
        content: ''; position: absolute; left: 10px; right: 10px; bottom: -3px; height: 3px;
        background: #fff; border-radius: 3px 3px 0 0;
    }
    .srs-topbar .tb-nav svg { width: 16px; height: 16px; opacity: .85; }
    .srs-topbar .tb-right { margin-left: auto; display: flex; align-items: center; gap: 10px; }
    .srs-topbar .tb-user { display: flex; align-items: center; gap: 9px; padding: 4px 10px 4px 4px; border-radius: 999px; background: rgba(255,255,255,.07); }
    .srs-topbar .tb-avatar {
        width: 30px; height: 30px; border-radius: 50%;
        display: flex; align-items: center; justify-content: center;
        background: #f6d6bd; color: #612405; font-size: 13px; font-weight: 800;
    }
    .srs-topbar .tb-user-text { display: flex; flex-direction: column; line-height: 1.15; }
    .srs-topbar .tb-user-text b { font-size: 12.5px; color: #fff; font-weight: 650; }
    .srs-topbar .tb-user-text small { font-size: 11px; color: #d9b89c; }
    .srs-topbar .tb-logout {
        display: inline-flex; align-items: center; gap: 6px; height: 32px; padding: 0 12px;
        border: 1px solid rgba(255,255,255,.22); border-radius: 8px; white-space: nowrap;
        color: #f3e4d6; font-size: 12.5px; font-weight: 600;
        transition: background-color .15s ease, border-color .15s ease;
    }
    .srs-topbar .tb-logout:hover { background: rgba(255,255,255,.1); border-color: rgba(255,255,255,.4); color: #fff; }
    .srs-topbar .tb-logout svg { width: 15px; height: 15px; }
    @media (max-width: 1000px) {
        .srs-topbar .tb-name, .srs-topbar .tb-user-text { display: none; }
        .srs-topbar .tb-nav a span { display: none; }
        .srs-topbar .tb-nav a { padding: 0 10px; }
    }
</style>

<header class="srs-topbar">
    <a class="tb-brand" href="<c:url value='/pages'/>">
        <span class="tb-mark">SRS</span>
        <span class="tb-name"><b>Website Admin</b><small>Sandur Residential School</small></span>
    </a>

    <nav class="tb-nav">
        <a href="<c:url value='/pages'/>" data-match="/pages,/index.jsp">
            <svg fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><path d="M14 3H6a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9Z"/><path d="M14 3v6h6"/></svg>
            <span>Pages</span>
        </a>
        <a href="<c:url value='/LatestNewsServlet'/>" data-match="/LatestNewsServlet,/latestNews.jsp">
            <svg fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><path d="M4 4h13v16H6a2 2 0 0 1-2-2Z"/><path d="M17 8h3v10a2 2 0 0 1-2 2M8 8h5M8 12h5M8 16h3"/></svg>
            <span>Latest News</span>
        </a>
        <a href="<c:url value='/upcoming-events'/>" data-match="/upcoming-events,/upcoming_events.jsp">
            <svg fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><rect x="3" y="5" width="18" height="16" rx="2"/><path d="M8 3v4M16 3v4M3 10h18"/></svg>
            <span>Upcoming Events</span>
        </a>
        <% if (canMove) { %>
        <a href="<c:url value='/admin/move-photos'/>" data-match="/admin/move-photos">
            <svg fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><path d="M12 16V4M7 9l5-5 5 5"/><path d="M4 16v3a1 1 0 0 0 1 1h14a1 1 0 0 0 1-1v-3"/></svg>
            <span>Photo storage</span>
        </a>
        <% } %>
    </nav>

    <div class="tb-right">
        <div class="tb-user" title="Signed in">
            <span class="tb-avatar"><%= initials %></span>
            <span class="tb-user-text">
                <b>${fn:escapeXml(sessionScope.username)}</b>
                <small>${fn:escapeXml(sessionScope.role)}<c:if test="${not empty sessionScope.branch}"> &middot; ${fn:escapeXml(sessionScope.branch)}</c:if></small>
            </span>
        </div>
        <a href="Logout.jsp" class="tb-logout">
            <svg fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24"><path d="M15 17l5-5-5-5M20 12H9M12 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h7"/></svg>
            Log out
        </a>
    </div>
</header>
<script>
    (function () {
        var path = window.location.pathname;
        document.querySelectorAll('.srs-topbar .tb-nav a').forEach(function (a) {
            var hit = (a.getAttribute('data-match') || '').split(',').some(function (m) { return m && path.indexOf(m) !== -1; });
            if (hit) a.classList.add('active');
        });
    })();
</script>
