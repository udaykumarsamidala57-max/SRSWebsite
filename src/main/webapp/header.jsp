<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!-- Header Navbar (SAP Shell Bar Style) -->
<header class="sticky top-0 z-40 w-full bg-sap-header text-white px-6 py-3 shadow-md flex items-center justify-between">
    <div class="flex items-center gap-3">
        <div>
            <h1 class="text-base font-semibold tracking-tight leading-none text-white">Dynamic Page Builder</h1>
        </div>
    </div>
    
    <div class="flex items-center gap-4 text-xs">
        <a href="<c:url value='/LatestNewsServlet'/>" 
           class="flex items-center gap-1.5 px-3 py-1.5 rounded bg-slate-700/60 hover:bg-slate-600 border border-slate-600/80 text-white font-semibold transition-colors">
            <svg class="w-3.5 h-3.5 text-blue-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 20H5a2 2 0 01-2-2V6a2 2 0 012-2h10a2 2 0 012 2v1m2 13a2 2 0 01-2-2V7m2 13a2 2 0 002-2V9a2 2 0 00-2-2h-2m-4-3H9M7 16h6M7 8h6v4H7V8z"/>
            </svg>
            <span>Latest News</span>
        </a>

        <div class="hidden md:flex items-center gap-2 bg-slate-700/60 border border-slate-600/80 px-3 py-1.5 rounded text-slate-200">
            <span class="inline-block w-2 h-2 rounded-full bg-emerald-400"></span>
            <span>User: <strong class="text-white font-semibold">${fn:escapeXml(user)}</strong></span>
            <span class="text-slate-400">|</span>
            <span class="uppercase tracking-wider font-semibold text-blue-300">${fn:escapeXml(role)}</span>
            <c:if test="${not empty branch}">
                <span class="text-slate-400">|</span>
                <span>Branch: <strong class="text-white">${fn:escapeXml(branch)}</strong></span>
            </c:if>
        </div>
        <a href="Logout.jsp" class="btn-sap-danger text-xs font-semibold px-3 py-1.5 rounded flex items-center gap-1.5">
            <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/></svg>
            Logout
        </a>
    </div>
</header>