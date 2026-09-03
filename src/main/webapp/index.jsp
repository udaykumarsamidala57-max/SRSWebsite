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
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Page Builder | SAP Fiori Control Center</title>
    
    <!-- Modern Typography & Icons -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=72:wght@300;400;600;700&family=Inter:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        sans: ['Inter', '72', 'sans-serif'],
                        mono: ['JetBrains Mono', 'monospace'],
                    },
                    colors: {
                        sap: {
                            blue: '#0070f2',
                            darkBlue: '#005bbf',
                            accent: '#ebf8ff',
                            header: '#354a5f',
                            bg: '#f5f6f7',
                            card: '#ffffff',
                            border: '#d9d9d9',
                            text: '#1d2d3e',
                            muted: '#556b82'
                        }
                    }
                }
            }
        }
    </script>
    
    <link rel="stylesheet" href="<c:url value='/css/page.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/index.css'/>">
    
    <style>
        /* SAP Fiori Light Micro-Styles */
        body {
            background-color: #f5f6f7;
            color: #1d2d3e;
            font-family: 'Inter', '72', sans-serif;
        }

        .sap-card {
            background: #ffffff;
            border: 1px solid #d9d9d9;
            box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05);
        }

        .sap-input {
            background-color: #ffffff;
            border: 1px solid #89919a;
            color: #1d2d3e;
            transition: all 0.15s ease;
        }
        .sap-input:focus {
            outline: none;
            border-color: #0070f2;
            box-shadow: 0 0 0 2px rgba(0, 112, 242, 0.2);
        }

        .btn-sap-primary {
            background-color: #0070f2;
            color: #ffffff;
            border: 1px solid #0070f2;
            transition: all 0.15s ease;
        }
        .btn-sap-primary:hover {
            background-color: #005bbf;
            border-color: #005bbf;
        }

        .btn-sap-danger {
            background: #fff0f0;
            color: #bb0000;
            border: 1px solid #f2b3b3;
            transition: all 0.15s ease;
        }
        .btn-sap-danger:hover {
            background: #ffe0e0;
            color: #a00000;
        }

        .tree-toggle-btn {
            background: #eef2f5;
            border: 1px solid #cccccc;
            color: #354a5f;
            padding: 2px 6px;
            margin-right: 6px;
            border-radius: 4px;
            transition: all 0.15s ease;
        }
        .tree-toggle-btn:hover {
            background: #d9e1e8;
            color: #000000;
        }
        
        .sub-page-row.is-hidden {
            display: none !important;
        }

        /* Custom Scrollbar */
        ::-webkit-scrollbar {
            width: 6px;
            height: 6px;
        }
        ::-webkit-scrollbar-track {
            background: #f5f6f7;
        }
        ::-webkit-scrollbar-thumb {
            background: #cccccc;
            border-radius: 4px;
        }
        ::-webkit-scrollbar-thumb:hover {
            background: #a0a0a0;
        }
    </style>
    
    <script type="module" src="<c:url value='/js/index.js'/>" defer></script>
</head>
<body class="min-h-screen flex flex-col antialiased selection:bg-sap-blue selection:text-white">

    <!-- Header Navbar (SAP Shell Bar Style) -->
    <header class="sticky top-0 z-40 w-full bg-sap-header text-white px-6 py-3 shadow-md flex items-center justify-between">
        <div class="flex items-center gap-3">
            
            <div>
                <h1 class="text-base font-semibold tracking-tight leading-none text-white">Dynamic Page Builder</h1>
                
            </div>
        </div>
        
        <div class="flex items-center gap-4 text-xs">
            <div class="hidden md:flex items-center gap-2 bg-slate-700/60 border border-slate-600/80 px-3 py-1.5 rounded text-slate-200">
                <span class="inline-block w-2 h-2 rounded-full bg-emerald-400"></span>
                <span>User: <strong class="text-white font-semibold">${fn:escapeXml(user)}</strong></span>
                <span class="text-slate-400">|</span>
                <span class="uppercase tracking-wider font-semibold text-blue-300">${fn:escapeXml(role)}</span>
                <% if (branch != null && !branch.trim().isEmpty()) { %>
                    <span class="text-slate-400">|</span>
                    <span>Branch: <strong class="text-white">${fn:escapeXml(branch)}</strong></span>
                <% } %>
            </div>
            <a href="Logout.jsp" class="btn-sap-danger text-xs font-semibold px-3 py-1.5 rounded flex items-center gap-1.5">
                <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/></svg>
                Logout
            </a>
        </div>
    </header>

    <!-- App Main Dashboard Container -->
    <div class="flex-1 max-w-[1700px] w-full mx-auto p-4 md:p-6 grid grid-cols-1 lg:grid-cols-12 gap-6">
        
        <!-- Sidebar Column (Page Management) -->
        <aside class="lg:col-span-3 space-y-6">
            
            <!-- Create New Page Panel -->
            <div class="sap-card rounded-lg p-5">
                <div class="flex items-center gap-2 pb-3 mb-4 border-b border-sap-border">
                    <svg class="w-4 h-4 text-sap-blue" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
                    <h3 class="text-sm font-semibold text-sap-text tracking-wide uppercase">Create New Page</h3>
                </div>
                <form action="pages" method="post" class="space-y-4">
                    <input type="hidden" name="action" value="createPage">
                    <div>
                        <label for="title" class="block text-xs font-semibold text-sap-muted mb-1.5">Page Title</label>
                        <input type="text" id="title" name="title" required placeholder="e.g. Landing Page" class="sap-input w-full px-3 py-2 rounded text-sm">
                    </div>
                    <div>
                        <label for="slug" class="block text-xs font-semibold text-sap-muted mb-1.5">URL Slug</label>
                        <div class="relative">
                            <span class="absolute left-3 top-2 text-xs text-sap-muted font-mono">/</span>
                            <input type="text" id="slug" name="slug" required placeholder="home or sub-path" class="sap-input w-full pl-6 pr-3 py-2 rounded text-sm font-mono">
                        </div>
                    </div>
                    <div>
                        <label for="parentId" class="block text-xs font-semibold text-sap-muted mb-1.5">Parent Navigation</label>
                        <select id="parentId" name="parentId" class="sap-input w-full px-3 py-2 rounded text-sm">
                            <option value="">-- None (Top Level Menu) --</option>
                            <c:forEach var="p" items="${pages}">
                                <c:if test="${empty p.parentId}">
                                    <option value="${p.id}">${fn:escapeXml(p.title)} (/${fn:escapeXml(p.slug)})</option>
                                </c:if>
                            </c:forEach>
                        </select>
                    </div>
                    <button type="submit" class="btn-sap-primary w-full py-2.5 rounded text-xs font-semibold tracking-wide uppercase flex items-center justify-center gap-2 mt-2">
                        <span>+ Create Page</span>
                    </button>
                </form>
            </div>

            <!-- Pages Directory Panel -->
            <div class="sap-card rounded-lg overflow-hidden flex flex-col">
                <div class="p-4 bg-slate-50 border-b border-sap-border flex items-center justify-between">
                    <div class="flex items-center gap-2">
                        <svg class="w-4 h-4 text-sap-blue" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z"/></svg>
                        <h3 class="text-sm font-semibold text-sap-text tracking-wide uppercase">Pages Directory</h3>
                    </div>
                </div>
                <div class="p-2 overflow-x-auto">
                    <table class="w-full text-left text-xs">
                        <thead>
                            <tr class="border-b border-sap-border text-sap-muted uppercase font-semibold bg-slate-50">
                                <th class="p-2.5">Hierarchy</th>
                                <th class="p-2.5 text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-sap-border">
                            <c:forEach var="p" items="${pages}">
                                <c:if test="${empty p.parentId}">
                                    <c:set var="subCount" value="0" />
                                    <c:forEach var="chk" items="${pages}">
                                        <c:if test="${chk.parentId == p.id}">
                                            <c:set var="subCount" value="${subCount + 1}" />
                                        </c:if>
                                    </c:forEach>

                                    <tr class="root-page-row hover:bg-slate-50 transition-colors group">
                                        <td class="p-2.5">
                                            <div class="flex items-center gap-1.5">
                                                <c:choose>
                                                    <c:when test="${subCount > 0}">
                                                        <button type="button" class="tree-toggle-btn text-[10px]" data-toggle-target="group-${p.id}">
                                                            ▶
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="inline-block w-4"></span>
                                                    </c:otherwise>
                                                </c:choose>
                                                <span class="px-1.5 py-0.5 rounded text-[10px] font-semibold bg-blue-50 text-sap-blue border border-blue-200">Root</span>
                                                <span class="font-medium text-sap-text truncate max-w-[100px]">${fn:escapeXml(p.title)}</span>
                                                <code class="text-[10px] text-sap-muted font-mono">/${fn:escapeXml(p.slug)}</code>
                                            </div>
                                        </td>
                                        <td class="p-2.5 text-right">
                                            <div class="flex items-center justify-end gap-1">
                                                <button type="button" 
                                                        class="p-1 rounded bg-slate-100 hover:bg-slate-200 text-sap-text border border-slate-300 transition-colors btn-edit-page" 
                                                        data-id="${p.id}"
                                                        data-title="${fn:escapeXml(p.title)}"
                                                        data-slug="${fn:escapeXml(p.slug)}"
                                                        data-parent-id="${p.parentId}"
                                                        title="Edit Page">
                                                    <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/></svg>
                                                </button>
                                                <a href="pages?action=view&id=${p.id}" class="p-1 rounded bg-blue-50 hover:bg-blue-100 text-sap-blue border border-blue-200 transition-colors" title="Manage">
                                                    <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/></svg>
                                                </a>
                                                <a href="pages?action=delete&id=${p.id}" onclick="return confirm('Delete page?')" class="p-1 rounded bg-red-50 hover:bg-red-100 text-red-600 border border-red-200 transition-colors" title="Delete">
                                                    <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>

                                    <c:forEach var="sub" items="${pages}">
                                        <c:if test="${sub.parentId == p.id}">
                                            <tr class="sub-page-row is-hidden child-group-${p.id} bg-slate-50/60 hover:bg-slate-100 transition-colors">
                                                <td class="p-2.5 pl-6">
                                                    <div class="flex items-center gap-1.5">
                                                        <span class="text-sap-muted font-mono">↳</span>
                                                        <span class="px-1.5 py-0.5 rounded text-[10px] font-semibold bg-purple-50 text-purple-700 border border-purple-200">Sub</span>
                                                        <span class="font-medium text-sap-text truncate max-w-[90px]">${fn:escapeXml(sub.title)}</span>
                                                        <code class="text-[9px] text-sap-muted font-mono">
                                                            <span class="opacity-50">/${fn:escapeXml(p.slug)}</span>/${fn:escapeXml(sub.slug)}
                                                        </code>
                                                    </div>
                                                </td>
                                                <td class="p-2.5 text-right">
                                                    <div class="flex items-center justify-end gap-1">
                                                        <button type="button" 
                                                                class="p-1 rounded bg-slate-100 hover:bg-slate-200 text-sap-text border border-slate-300 transition-colors btn-edit-page" 
                                                                data-id="${sub.id}"
                                                                data-title="${fn:escapeXml(sub.title)}"
                                                                data-slug="${fn:escapeXml(sub.slug)}"
                                                                data-parent-id="${sub.parentId}"
                                                                title="Edit Sub Page">
                                                            <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/></svg>
                                                        </button>
                                                        <a href="pages?action=view&id=${sub.id}" class="p-1 rounded bg-blue-50 hover:bg-blue-100 text-sap-blue border border-blue-200 transition-colors" title="Manage">
                                                            <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/></svg>
                                                        </a>
                                                        <a href="pages?action=delete&id=${sub.id}" onclick="return confirm('Delete sub-page?')" class="p-1 rounded bg-red-50 hover:bg-red-100 text-red-600 border border-red-200 transition-colors" title="Delete">
                                                            <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </c:if>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </aside>

        <!-- Main Content Area -->
        <main class="lg:col-span-7 space-y-6">
            <c:choose>
                <c:when test="${not empty activePage}">
                    
                    <!-- Overview Card -->
                    <div class="sap-card rounded-lg p-6 relative overflow-hidden" id="page-overview">
                        <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-5 border-b border-sap-border">
                            <div>
                                <div class="flex items-center gap-2">
                                    <h2 class="text-xl font-bold text-sap-text tracking-tight">${fn:escapeXml(activePage.title)}</h2>
                                    <c:if test="${not empty activePage.parentId}">
                                        <span class="px-2 py-0.5 rounded text-[10px] font-semibold bg-purple-50 text-purple-700 border border-purple-200">
                                            Sub-page (Parent #${activePage.parentId})
                                        </span>
                                    </c:if>
                                </div>
                                <div class="mt-1 flex items-center gap-2">
                                    <span class="text-xs text-sap-muted">Path:</span>
                                    <code class="px-2 py-0.5 rounded bg-slate-100 border border-slate-300 text-xs text-sap-blue font-mono">/${fn:escapeXml(activePage.slug)}</code>
                                </div>
                            </div>
                            
                            <button type="button" 
                                    class="px-3.5 py-2 rounded bg-slate-100 hover:bg-slate-200 border border-slate-300 text-xs font-semibold text-sap-text transition-colors flex items-center gap-2 self-start sm:self-auto btn-edit-page"
                                    data-id="${activePage.id}"
                                    data-title="${fn:escapeXml(activePage.title)}"
                                    data-slug="${fn:escapeXml(activePage.slug)}"
                                    data-parent-id="${activePage.parentId}">
                                <svg class="w-3.5 h-3.5 text-sap-muted" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/></svg>
                                Edit Page Details
                            </button>
                        </div>

                        <!-- Add New Section Form Block -->
                        <div class="mt-5 pt-2">
                            <h4 class="text-xs font-semibold text-sap-muted uppercase tracking-wider mb-3">Add New Section Block</h4>
                            <form action="pages" method="post" class="space-y-4">
                                <input type="hidden" name="action" value="addSection">
                                <input type="hidden" name="pageId" value="${activePage.id}">
                                
                                <div class="grid grid-cols-1 md:grid-cols-12 gap-3">
                                    <div class="md:col-span-4">
                                        <label class="block text-xs font-semibold text-sap-muted mb-1">Section Type</label>
                                        <select name="sectionType" class="sap-input w-full px-3 py-2 rounded text-xs">
                                            <option value="hero">Hero</option>
                                            <option value="DISTINCT">DISTINCT</option>
                                            <option value="DESC">DESC</option>
                                            <option value="DESC2">DESC2</option>
                                            <option value="DESC3">DESC3</option>
                                            <option value="SIDE_DESIGN">SIDE_DESIGN</option>
                                            <option value="person_details">PERSON-DETAILS</option>
                                        </select>
                                    </div>

                                    <div class="md:col-span-2">
                                        <label class="block text-xs font-semibold text-sap-muted mb-1">Sequence</label>
                                        <input type="number" name="sequenceOrder" value="1" min="1" required class="sap-input w-full px-3 py-2 rounded text-xs">
                                    </div>

                                    <div class="md:col-span-6">
                                        <label class="block text-xs font-semibold text-sap-muted mb-1">Section Title</label>
                                        <input type="text" name="title" placeholder="Enter block header..." class="sap-input w-full px-3 py-2 rounded text-xs">
                                    </div>
                                </div>

                                <div>
                                    <label class="block text-xs font-semibold text-sap-muted mb-1">Content Description</label>
                                    <textarea name="content" rows="2" placeholder="Write section body content..." class="sap-input w-full px-3 py-2 rounded text-xs resize-none"></textarea>
                                </div>

                                <button type="submit" class="btn-sap-primary px-4 py-2 rounded text-xs font-semibold tracking-wide uppercase inline-flex items-center gap-1.5">
                                    <span>+ Add Section Block</span>
                                </button>
                            </form>
                        </div>
                    </div>

                    <!-- Render Page Sections -->
                    <c:forEach var="sec" items="${activePage.sections}">
                        <div class="sap-card rounded-lg p-6 space-y-5" id="section-${sec.id}">
                            
                            <!-- Section Header -->
                            <div class="flex items-center justify-between gap-4 pb-4 border-b border-sap-border">
                                <div class="flex items-center gap-2 flex-wrap">
                                    <span class="px-2 py-0.5 rounded text-[10px] font-bold bg-slate-100 text-sap-text border border-slate-300">#${sec.sequenceOrder}</span>
                                    <span class="px-2 py-0.5 rounded text-[10px] font-semibold bg-blue-50 text-sap-blue border border-blue-200 uppercase">${fn:escapeXml(sec.sectionType)}</span>
                                    <h3 class="text-base font-semibold text-sap-text">${fn:escapeXml(sec.title)}</h3>
                                </div>

                                <div class="flex items-center gap-2">
                                    <button type="button" 
                                            class="px-3 py-1.5 rounded bg-slate-100 hover:bg-slate-200 text-xs font-semibold text-sap-text border border-slate-300 transition-colors btn-edit-section"
                                            data-id="${sec.id}"
                                            data-type="${sec.sectionType}"
                                            data-seq="${sec.sequenceOrder}"
                                            data-title="${fn:escapeXml(sec.title)}">
                                        Edit
                                    </button>
                                    
                                    <div class="hidden" id="section-content-data-${sec.id}">${fn:escapeXml(sec.content)}</div>

                                    <a href="pages?action=deleteSection&sectionId=${sec.id}&pageId=${activePage.id}" 
                                       class="btn-sap-danger px-3 py-1.5 rounded text-xs font-semibold transition-colors"
                                       onclick="return confirm('Delete Section?')">Remove</a>
                                </div>
                            </div>

                            <!-- Section Body -->
                            <div class="space-y-4">
                                <p class="text-sm text-sap-muted leading-relaxed bg-slate-50 p-3.5 rounded border border-slate-200">${fn:escapeXml(sec.content)}</p>

                                <div class="pt-2">
                                    <h4 class="text-xs font-semibold text-sap-muted uppercase tracking-wider mb-3 flex items-center justify-between">
                                        <span>Sequenced Media Assets</span>
                                        <span class="text-[10px] text-sap-muted lowercase">(${fn:length(sec.images)} items)</span>
                                    </h4>
                                    
                                    <!-- Asset Cards Gallery Grid -->
                                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                        <c:forEach var="img" items="${sec.images}">
                                            <div class="bg-white border border-sap-border rounded-lg p-3 flex flex-col justify-between space-y-3 relative group shadow-sm">
                                                <span class="absolute top-4 left-4 z-10 px-2 py-0.5 rounded text-[10px] font-bold bg-slate-800 text-white shadow">
                                                    Seq ${img.sequenceOrder}
                                                </span>
                                                
                                                <div class="w-full h-40 bg-slate-100 rounded border border-slate-200 overflow-hidden flex items-center justify-center relative">
                                                    <c:choose>
                                                        <c:when test="${fn:startsWith(img.imageType, 'video/')}">
                                                            <video controls preload="metadata" class="w-full h-full object-cover">
                                                                <source src="pages?action=renderImage&imageId=${img.id}"
                                                                        type="${fn:escapeXml(img.imageType)}">
                                                                Your browser does not support video.
                                                            </video>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="pages?action=renderImage&imageId=${img.id}"
                                                                 alt="${fn:escapeXml(img.altText)}"
                                                                 class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300">
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <c:if test="${not empty img.heading1 or not empty img.heading2}">
                                                    <div class="text-xs space-y-0.5 px-1">
                                                        <c:if test="${not empty img.heading1}">
                                                            <div class="font-semibold text-sap-text truncate">${fn:escapeXml(img.heading1)}</div>
                                                        </c:if>
                                                        <c:if test="${not empty img.heading2}">
                                                            <div class="text-sap-muted italic text-[11px] truncate">${fn:escapeXml(img.heading2)}</div>
                                                        </c:if>
                                                    </div>
                                                </c:if>
                                                
                                                <div class="text-[11px] text-sap-muted line-clamp-2 px-1" title="${fn:escapeXml(img.altText)}">
                                                    <c:choose>
                                                        <c:when test="${not empty img.altText}">${fn:escapeXml(img.altText)}</c:when>
                                                        <c:otherwise><span class="italic text-slate-400">No description provided</span></c:otherwise>
                                                    </c:choose>
                                                </div>
                                                
                                                <div class="grid grid-cols-2 gap-2 pt-2 border-t border-sap-border">
                                                    <button type="button" 
                                                            class="w-full py-1.5 rounded bg-slate-100 hover:bg-slate-200 border border-slate-300 text-xs font-semibold text-sap-text transition-colors btn-edit-image"
                                                            data-id="${img.id}"
                                                            data-seq="${img.sequenceOrder}"
                                                            data-alt="${fn:escapeXml(img.altText)}"
                                                            data-h1="${fn:escapeXml(img.heading1)}"
                                                            data-h2="${fn:escapeXml(img.heading2)}">
                                                        Edit
                                                    </button>
                                                    <a href="pages?action=deleteImage&imageId=${img.id}&pageId=${activePage.id}" 
                                                       class="w-full py-1.5 rounded text-center btn-sap-danger text-xs font-semibold transition-colors"
                                                       onclick="return confirm('Delete asset?')">Delete</a>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>

                                    <!-- Asset Upload Form -->
                                    <div class="mt-4 p-4 bg-slate-50 border border-sap-border rounded-lg space-y-3">
                                        <h5 class="text-xs font-semibold text-sap-text">Upload Media Asset</h5>
                                        <form action="pages?action=uploadImage" method="post" enctype="multipart/form-data" class="space-y-3">
                                            <input type="hidden" name="pageId" value="${activePage.id}">
                                            <input type="hidden" name="sectionId" value="${sec.id}">
                                            
                                            <div class="grid grid-cols-1 md:grid-cols-12 gap-3">
                                                <div class="md:col-span-6">
                                                    <label class="block text-[11px] font-semibold text-sap-muted mb-1">Select File</label>
                                                    <input type="file" name="imageFile" accept="image/*,video/*" required class="sap-input w-full px-2.5 py-1 rounded text-xs file:mr-3 file:py-1 file:px-2 file:rounded file:border file:border-slate-300 file:text-xs file:bg-slate-100 file:text-sap-text hover:file:bg-slate-200">
                                                </div>
                                                <div class="md:col-span-3">
                                                    <label class="block text-[11px] font-semibold text-sap-muted mb-1">Heading 1</label>
                                                    <input type="text" name="heading1" placeholder="Main Heading" class="sap-input w-full px-3 py-1.5 rounded text-xs">
                                                </div>
                                                <div class="md:col-span-3">
                                                    <label class="block text-[11px] font-semibold text-sap-muted mb-1">Heading 2</label>
                                                    <input type="text" name="heading2" placeholder="Sub Heading" class="sap-input w-full px-3 py-1.5 rounded text-xs">
                                                </div>
                                            </div>

                                            <div class="grid grid-cols-1 md:grid-cols-12 gap-3 items-end">
                                                <div class="md:col-span-8">
                                                    <label for="uploadAltText" class="block text-[11px] font-semibold text-sap-muted mb-1">Alt Text / Description</label>
                                                    <textarea id="uploadAltText" name="altText" rows="2" placeholder="Image description..." class="sap-input w-full px-3 py-1.5 rounded text-xs resize-none"></textarea>
                                                </div>
                                                <div class="md:col-span-2">
                                                    <label class="block text-[11px] font-semibold text-sap-muted mb-1">Seq #</label>
                                                    <input type="number" name="sequenceOrder" value="1" min="1" required class="sap-input w-full px-3 py-1.5 rounded text-xs">
                                                </div>
                                                <div class="md:col-span-2">
                                                    <button type="submit" class="w-full py-2 bg-slate-100 hover:bg-slate-200 border border-slate-300 rounded text-xs font-semibold text-sap-text transition-colors">
                                                        Upload
                                                    </button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    
                </c:when>
                <c:otherwise>
                    <!-- Empty State Panel -->
                    <div class="sap-card rounded-lg p-12 text-center space-y-4">
                        <div class="w-16 h-16 rounded-full bg-slate-100 border border-slate-300 flex items-center justify-center mx-auto text-sap-muted">
                            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/></svg>
                        </div>
                        <div class="space-y-1">
                            <h3 class="text-lg font-semibold text-sap-text">No Page Selected</h3>
                            <p class="text-xs text-sap-muted max-w-sm mx-auto">Select a page from the directory on the left to edit its layout and sections, or create a new page to get started.</p>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>

        <!-- Right Quick Navigation Sidebar -->
        <c:if test="${not empty activePage and not empty activePage.sections}">
            <aside class="lg:col-span-2 space-y-6">
                <div class="sap-card rounded-lg p-4 sticky top-20">
                    <div class="pb-3 mb-3 border-b border-sap-border flex items-center justify-between">
                        <h3 class="text-xs font-semibold text-sap-muted uppercase tracking-wider">Page Structure</h3>
                        <span class="w-2 h-2 rounded-full bg-sap-blue"></span>
                    </div>
                    <ul class="space-y-1 text-xs">
                        <li>
                            <a href="#page-overview" class="flex items-center justify-between p-2 rounded hover:bg-slate-100 text-sap-text transition-colors">
                                <span class="truncate">Overview</span>
                                <span class="text-[9px] px-1.5 py-0.5 rounded bg-slate-100 border border-slate-300 text-sap-muted">Top</span>
                            </a>
                        </li>
                        <c:forEach var="sec" items="${activePage.sections}">
                            <li>
                                <a href="#section-${sec.id}" class="flex items-center justify-between p-2 rounded hover:bg-slate-100 text-sap-muted hover:text-sap-text transition-colors">
                                    <span class="truncate max-w-[110px]">${fn:escapeXml(sec.title)}</span>
                                    <span class="text-[9px] px-1.5 py-0.5 rounded bg-blue-50 text-sap-blue border border-blue-200">#${sec.sequenceOrder}</span>
                                </a>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </aside>
        </c:if>

    </div>

    <!-- Edit Page Modal -->
    <div class="fixed inset-0 z-50 bg-slate-900/40 backdrop-blur-sm hidden items-center justify-center p-4" id="editPageModal">
        <div class="sap-card rounded-lg w-full max-w-md border border-sap-border overflow-hidden shadow-2xl">
            <div class="p-4 bg-slate-50 border-b border-sap-border flex items-center justify-between">
                <h3 class="text-sm font-semibold text-sap-text">Edit Page Details</h3>
                <button type="button" class="text-sap-muted hover:text-sap-text transition-colors" onclick="closeModal('editPageModal')">&times;</button>
            </div>
            <form action="pages" method="post">
                <input type="hidden" name="action" value="updatePage">
                <input type="hidden" name="id" id="editPageId">
                <div class="p-5 space-y-4">
                    <div>
                        <label for="editPageTitle" class="block text-xs font-semibold text-sap-muted mb-1">Page Title</label>
                        <input type="text" id="editPageTitle" name="title" required class="sap-input w-full px-3 py-2 rounded text-xs">
                    </div>
                    <div>
                        <label for="editPageSlug" class="block text-xs font-semibold text-sap-muted mb-1">URL Slug</label>
                        <input type="text" id="editPageSlug" name="slug" required class="sap-input w-full px-3 py-2 rounded text-xs font-mono">
                    </div>
                    <div>
                        <label for="editParentId" class="block text-xs font-semibold text-sap-muted mb-1">Parent Page</label>
                        <select id="editParentId" name="parentId" class="sap-input w-full px-3 py-2 rounded text-xs">
                            <option value="">-- None (Top Level Menu) --</option>
                            <c:forEach var="p" items="${pages}">
                                <option value="${p.id}">${fn:escapeXml(p.title)} (/${fn:escapeXml(p.slug)})</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="p-4 bg-slate-50 border-t border-sap-border flex justify-end gap-2">
                    <button type="button" class="px-4 py-2 rounded bg-slate-100 hover:bg-slate-200 border border-slate-300 text-xs text-sap-text font-semibold transition-colors" onclick="closeModal('editPageModal')">Cancel</button>
                    <button type="submit" class="btn-sap-primary px-4 py-2 rounded text-xs font-semibold">Save Changes</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Edit Section Modal -->
    <div class="fixed inset-0 z-50 bg-slate-900/40 backdrop-blur-sm hidden items-center justify-center p-4" id="editSectionModal">
        <div class="sap-card rounded-lg w-full max-w-lg border border-sap-border overflow-hidden shadow-2xl">
            <div class="p-4 bg-slate-50 border-b border-sap-border flex items-center justify-between">
                <h3 class="text-sm font-semibold text-sap-text">Edit Section Block</h3>
                <button type="button" class="text-sap-muted hover:text-sap-text transition-colors" onclick="closeModal('editSectionModal')">&times;</button>
            </div>
            <form action="pages" method="post">
                <input type="hidden" name="action" value="updateSection">
                <input type="hidden" name="sectionId" id="editSectionId">
                <input type="hidden" name="pageId" value="${activePage.id}">
                <div class="p-5 space-y-4">
                    <div class="grid grid-cols-1 md:grid-cols-12 gap-3">
                        <div class="md:col-span-5">
                            <label for="editSectionType" class="block text-xs font-semibold text-sap-muted mb-1">Type</label>
                            <select id="editSectionType" name="sectionType" class="sap-input w-full px-3 py-2 rounded text-xs">
                                <option value="hero">Hero</option>
                                <option value="DISTINCT">DISTINCT</option>
                                <option value="DESC">DESC</option>
                                <option value="DESC2">DESC2</option>
                                <option value="DESC3">DESC3</option>
                                <option value="SIDE_DESIGN">SIDE_DESIGN</option>
                                <option value="person_details">PERSON-DETAILS</option>
                            </select>
                        </div>
                        <div class="md:col-span-3">
                            <label for="editSectionSeq" class="block text-xs font-semibold text-sap-muted mb-1">Sequence</label>
                            <input type="number" id="editSectionSeq" name="sequenceOrder" min="1" required class="sap-input w-full px-3 py-2 rounded text-xs">
                        </div>
                        <div class="md:col-span-4">
                            <label for="editSectionTitle" class="block text-xs font-semibold text-sap-muted mb-1">Title</label>
                            <input type="text" id="editSectionTitle" name="title" required class="sap-input w-full px-3 py-2 rounded text-xs">
                        </div>
                    </div>
                    <div>
                        <label for="editSectionContent" class="block text-xs font-semibold text-sap-muted mb-1">Content Description</label>
                        <textarea id="editSectionContent" name="content" rows="4" class="sap-input w-full px-3 py-2 rounded text-xs resize-none"></textarea>
                    </div>
                </div>
                <div class="p-4 bg-slate-50 border-t border-sap-border flex justify-end gap-2">
                    <button type="button" class="px-4 py-2 rounded bg-slate-100 hover:bg-slate-200 border border-slate-300 text-xs text-sap-text font-semibold transition-colors" onclick="closeModal('editSectionModal')">Cancel</button>
                    <button type="submit" class="btn-sap-primary px-4 py-2 rounded text-xs font-semibold">Update Section</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Edit Asset Modal -->
    <div class="fixed inset-0 z-50 bg-slate-900/40 backdrop-blur-sm hidden items-center justify-center p-4" id="editImageModal">
        <div class="sap-card rounded-lg w-full max-w-lg border border-sap-border overflow-hidden shadow-2xl">
            <div class="p-4 bg-slate-50 border-b border-sap-border flex items-center justify-between">
                <h3 class="text-sm font-semibold text-sap-text">Edit Asset Metadata</h3>
                <button type="button" class="text-sap-muted hover:text-sap-text transition-colors" onclick="closeModal('editImageModal')">&times;</button>
            </div>
            <form action="pages" method="post">
                <input type="hidden" name="action" value="updateImageMeta">
                <input type="hidden" name="imageId" id="editImageId">
                <input type="hidden" name="pageId" value="${activePage.id}">
                <div class="p-5 space-y-4">
                    <div class="grid grid-cols-2 gap-3">
                        <div>
                            <label for="editImageH1" class="block text-xs font-semibold text-sap-muted mb-1">Heading 1</label>
                            <input type="text" id="editImageH1" name="heading1" class="sap-input w-full px-3 py-2 rounded text-xs">
                        </div>
                        <div>
                            <label for="editImageH2" class="block text-xs font-semibold text-sap-muted mb-1">Heading 2</label>
                            <input type="text" id="editImageH2" name="heading2" class="sap-input w-full px-3 py-2 rounded text-xs">
                        </div>
                    </div>
                    <div class="grid grid-cols-12 gap-3">
                        <div class="col-span-9">
                            <label for="editImageAlt" class="block text-xs font-semibold text-sap-muted mb-1">Alt Text / Description</label>
                            <textarea id="editImageAlt" name="altText" rows="3" class="sap-input w-full px-3 py-2 rounded text-xs resize-none"></textarea>
                        </div>
                        <div class="col-span-3">
                            <label for="editImageSeq" class="block text-xs font-semibold text-sap-muted mb-1">Seq #</label>
                            <input type="number" id="editImageSeq" name="sequenceOrder" min="1" required class="sap-input w-full px-3 py-2 rounded text-xs">
                        </div>
                    </div>
                </div>
                <div class="p-4 bg-slate-50 border-t border-sap-border flex justify-end gap-2">
                    <button type="button" class="px-4 py-2 rounded bg-slate-100 hover:bg-slate-200 border border-slate-300 text-xs text-sap-text font-semibold transition-colors" onclick="closeModal('editImageModal')">Cancel</button>
                    <button type="submit" class="btn-sap-primary px-4 py-2 rounded text-xs font-semibold">Save Metadata</button>
                </div>
            </form>
        </div>
    </div>

</body>

<script>
document.addEventListener('DOMContentLoaded', function() {
    
    // ==========================================
    // 1. PAGE TREE EXPAND / COLLAPSE TOGGLE
    // ==========================================
    var toggleBtns = document.querySelectorAll('.tree-toggle-btn');
    toggleBtns.forEach(function(btn) {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            var targetClass = btn.getAttribute('data-toggle-target');
            var rows = document.querySelectorAll('.' + 'child-' + targetClass);
            
            var isCollapsed = btn.innerText.trim() === '▶';
            btn.innerText = isCollapsed ? '▼' : '▶';
            
            rows.forEach(function(row) {
                if (isCollapsed) {
                    row.classList.remove('is-hidden');
                } else {
                    row.classList.add('is-hidden');
                }
            });
        });
    });

    // ==========================================
    // 2. MODAL HELPER FUNCTIONS
    // ==========================================
    window.openModal = function(modalId) {
        var modal = document.getElementById(modalId);
        if (modal) {
            modal.style.display = 'flex';
        }
    };

    window.closeModal = function(modalId) {
        var modal = document.getElementById(modalId);
        if (modal) {
            modal.style.display = 'none';
        }
    };

    // Close modal on backdrop click
    document.querySelectorAll('[id$="Modal"]').forEach(function(backdrop) {
        backdrop.addEventListener('click', function(e) {
            if (e.target === backdrop) {
                backdrop.style.display = 'none';
            }
        });
    });

    // ==========================================
    // 3. EDIT PAGE DETAILS MODAL
    // ==========================================
    document.querySelectorAll('.btn-edit-page').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var pageId = btn.getAttribute('data-id') || '';
            var title = btn.getAttribute('data-title') || '';
            var slug = btn.getAttribute('data-slug') || '';
            var parentId = btn.getAttribute('data-parent-id') || '';

            document.getElementById('editPageId').value = pageId;
            document.getElementById('editPageTitle').value = title;
            document.getElementById('editPageSlug').value = slug;
            
            var parentSelect = document.getElementById('editParentId');
            if (parentSelect) {
                parentSelect.value = parentId;
            }

            openModal('editPageModal');
        });
    });

    // ==========================================
    // 4. EDIT SECTION BLOCK MODAL
    // ==========================================
    document.querySelectorAll('.btn-edit-section').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var sectionId = btn.getAttribute('data-id') || '';
            var type = btn.getAttribute('data-type') || '';
            var seq = btn.getAttribute('data-seq') || '1';
            var title = btn.getAttribute('data-title') || '';
            
            // Fetch content stored in hidden container to preserve line breaks
            var contentStore = document.getElementById('section-content-data-' + sectionId);
            var content = contentStore ? contentStore.innerText : '';

            document.getElementById('editSectionId').value = sectionId;
            document.getElementById('editSectionType').value = type;
            document.getElementById('editSectionSeq').value = seq;
            document.getElementById('editSectionTitle').value = title;
            document.getElementById('editSectionContent').value = content;

            openModal('editSectionModal');
        });
    });

    // ==========================================
    // 5. EDIT ASSET METADATA MODAL
    // ==========================================
    document.querySelectorAll('.btn-edit-image').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var imageId = btn.getAttribute('data-id') || '';
            var seq = btn.getAttribute('data-seq') || '1';
            var alt = btn.getAttribute('data-alt') || '';
            var h1 = btn.getAttribute('data-h1') || '';
            var h2 = btn.getAttribute('data-h2') || '';

            document.getElementById('editImageId').value = imageId;
            document.getElementById('editImageSeq').value = seq;
            document.getElementById('editImageAlt').value = alt;
            document.getElementById('editImageH1').value = h1;
            document.getElementById('editImageH2').value = h2;

            openModal('editImageModal');
        });
    });

});
</script>
</html>