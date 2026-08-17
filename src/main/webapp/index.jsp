<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
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
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Page Builder | Enterprise Control Panel</title>
    <!-- Inter Font -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- External CSS -->
    <link rel="stylesheet" href="css/page.css">
    
    <style>
        :root {
            /* Salesforce Lightning Design System Palette */
            --slds-brand: #0176d3;
            --slds-brand-hover: #014486;
            --slds-brand-light: #eef4fe;
            --slds-text-primary: #180828;
            --slds-text-secondary: #444444;
            --slds-text-weak: #747474;
            --slds-bg-canvas: #f3f3f3;
            --slds-bg-card: #ffffff;
            --slds-border: #c9c9c9;
            --slds-border-subtle: #e5e5e5;
            --slds-destructive: #ba0517;
            --slds-destructive-hover: #8e0312;
            --slds-radius: 4px;
            --slds-shadow: 0 2px 4px rgba(0, 0, 0, 0.07);
        }

        html { scroll-behavior: smooth; }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background-color: var(--slds-bg-canvas);
            color: var(--slds-text-primary);
            margin: 0;
            padding: 0;
            font-size: 13px;
            -webkit-font-smoothing: antialiased;
        }

        /* Salesforce Global Header */
        .app-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0.6rem 1.5rem;
            background: #ffffff;
            border-bottom: 1px solid var(--slds-border);
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }

        .header-brand {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .header-brand-icon {
            width: 28px;
            height: 28px;
            background: var(--slds-brand);
            border-radius: var(--slds-radius);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            font-weight: 700;
            font-size: 0.85rem;
        }

        .header-brand h1 {
            margin: 0;
            font-size: 1rem;
            font-weight: 700;
            color: var(--slds-text-primary);
            letter-spacing: -0.01em;
        }

        .user-nav { display: flex; align-items: center; gap: 1rem; }
        .user-info { font-size: 0.8rem; color: var(--slds-text-secondary); }
        .user-info strong { color: var(--slds-text-primary); }

        .btn-logout {
            background-color: #ffffff;
            color: var(--slds-text-secondary);
            padding: 0.35rem 0.75rem;
            font-size: 0.775rem;
            font-weight: 600;
            border-radius: var(--slds-radius);
            text-decoration: none;
            border: 1px solid var(--slds-border);
            transition: all 0.15s ease;
        }
        .btn-logout:hover {
            background-color: var(--slds-destructive);
            color: #ffffff;
            border-color: var(--slds-destructive);
        }

        /* Main Workspace Grid */
        .app-container {
            display: grid;
            grid-template-columns: 310px 1fr 240px;
            gap: 1.25rem;
            padding: 1.25rem;
            max-width: 1720px;
            margin: 0 auto;
        }

        @media (max-width: 1300px) {
            .app-container { grid-template-columns: 290px 1fr; }
            .page-nav-sidebar { display: none; }
        }

        .sidebar {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        /* SLDS Card Component */
        .slds-card {
            background: var(--slds-bg-card);
            border: 1px solid var(--slds-border);
            border-radius: var(--slds-radius);
            box-shadow: var(--slds-shadow);
            overflow: hidden;
        }

        .slds-card-header {
            padding: 0.75rem 1rem;
            background: #ffffff;
            border-bottom: 1px solid var(--slds-border-subtle);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .slds-card-header h3 {
            margin: 0;
            font-size: 0.875rem;
            font-weight: 700;
            color: var(--slds-text-primary);
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .slds-card-body { padding: 1rem; }
        .slds-card-body.no-padding { padding: 0; }

        /* Form Controls */
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
            margin-bottom: 0.75rem;
        }

        .form-group label {
            font-size: 0.725rem;
            font-weight: 700;
            color: var(--slds-text-secondary);
            text-transform: uppercase;
        }

        .form-group input, .form-group select, .form-group textarea,
        .form-row input, .form-row select {
            padding: 0.45rem 0.65rem;
            border: 1px solid var(--slds-border);
            border-radius: var(--slds-radius);
            font-size: 0.825rem;
            color: var(--slds-text-primary);
            background: #ffffff;
            outline: none;
            transition: border-color 0.15s, box-shadow 0.15s;
        }

        .form-group input:focus, .form-group select:focus, .form-group textarea:focus,
        .form-row input:focus, .form-row select:focus {
            border-color: var(--slds-brand);
            box-shadow: 0 0 0 2px var(--slds-brand-light);
        }

        /* Buttons System */
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0.4rem 0.85rem;
            font-size: 0.8rem;
            font-weight: 600;
            border-radius: var(--slds-radius);
            border: 1px solid transparent;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.15s ease-in-out;
            gap: 0.35rem;
        }

        .btn-brand {
            background-color: var(--slds-brand);
            color: #ffffff;
        }
        .btn-brand:hover { background-color: var(--slds-brand-hover); }

        .btn-neutral {
            background-color: #ffffff;
            color: var(--slds-text-primary);
            border-color: var(--slds-border);
        }
        .btn-neutral:hover {
            background-color: var(--slds-bg-canvas);
            border-color: var(--slds-border);
        }

        .btn-destructive {
            background-color: #ffffff;
            color: var(--slds-destructive);
            border-color: var(--slds-border);
        }
        .btn-destructive:hover {
            background-color: var(--slds-destructive);
            color: #ffffff;
            border-color: var(--slds-destructive);
        }

        .btn-sm { padding: 0.25rem 0.5rem; font-size: 0.75rem; }
        .btn-full { width: 100%; }

        /* Tables */
        .directory-table table {
            width: 100%;
            border-collapse: collapse;
        }

        .directory-table th {
            padding: 0.55rem 0.85rem;
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            color: var(--slds-text-weak);
            background: #fafafa;
            border-bottom: 1px solid var(--slds-border);
            text-align: left;
        }

        .directory-table td {
            padding: 0.65rem 0.85rem;
            border-bottom: 1px solid var(--slds-border-subtle);
            font-size: 0.825rem;
        }

        .slug-pill {
            display: inline-block;
            padding: 0.1rem 0.35rem;
            background: #eef4fe;
            color: var(--slds-brand);
            border-radius: var(--slds-radius);
            font-family: monospace;
            font-size: 0.725rem;
            font-weight: 600;
        }

        /* Active Page Workspace */
        .main-content {
            display: flex;
            flex-direction: column;
            gap: 1rem;
            min-width: 0;
        }

        .section-card {
            background: #ffffff;
            border: 1px solid var(--slds-border);
            border-radius: var(--slds-radius);
            box-shadow: var(--slds-shadow);
            overflow: hidden;
            scroll-margin-top: 4.5rem;
        }

        .section-header {
            padding: 0.65rem 1rem;
            background: #fafafa;
            border-bottom: 1px solid var(--slds-border);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .section-title-group { display: flex; align-items: center; gap: 0.5rem; }

        .badge {
            display: inline-flex;
            align-items: center;
            padding: 0.15rem 0.45rem;
            border-radius: 12px;
            font-size: 0.7rem;
            font-weight: 700;
            background: var(--slds-bg-canvas);
            color: var(--slds-text-secondary);
            border: 1px solid var(--slds-border);
        }

        .badge-type {
            background: var(--slds-brand-light);
            color: var(--slds-brand);
            border-color: transparent;
            text-transform: uppercase;
        }

        .section-body { padding: 1rem; }
        .section-description {
            font-size: 0.85rem;
            color: var(--slds-text-secondary);
            margin-top: 0;
            margin-bottom: 1rem;
            line-height: 1.45;
        }

        /* Asset Gallery Grid */
        .gallery-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(190px, 1fr));
            gap: 0.85rem;
            margin-bottom: 1rem;
        }

        .img-card {
            background: #ffffff;
            border: 1px solid var(--slds-border);
            border-radius: var(--slds-radius);
            padding: 0.5rem;
            position: relative;
            display: flex;
            flex-direction: column;
            gap: 0.4rem;
        }

        .img-container {
            width: 100%;
            height: 120px;
            background: var(--slds-bg-canvas);
            border-radius: 2px;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .img-container img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .badge-overlay {
            position: absolute;
            top: 0.75rem;
            left: 0.75rem;
            background: rgba(24, 8, 40, 0.85);
            color: #ffffff;
            border: none;
        }

        .img-headings {
            padding: 0.3rem 0.45rem;
            background: var(--slds-bg-canvas);
            border-radius: 2px;
            font-size: 0.725rem;
        }
        .img-headings strong { display: block; color: var(--slds-text-primary); }
        .img-headings em { color: var(--slds-text-weak); font-style: normal; }

        .img-meta {
            font-size: 0.75rem;
            color: var(--slds-text-secondary);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        /* Form Sub-Panels */
        .nested-form-block {
            background: var(--slds-bg-canvas);
            border: 1px dashed var(--slds-border);
            border-radius: var(--slds-radius);
            padding: 0.85rem;
        }

        .nested-form-block.solid-border {
            border-style: solid;
            background: #ffffff;
        }

        .form-row {
            display: flex;
            gap: 0.75rem;
            align-items: flex-end;
        }

        .col-type { width: 130px; }
        .col-seq-sm { width: 80px; }
        .col-seq-xs { width: 65px; }
        .col-title { flex: 1; }
        .col-file { flex: 1; }
        .col-alt { flex: 1; }

        /* Right Sticky Navigation */
        .page-nav-sidebar {
            position: sticky;
            top: 4.5rem;
            align-self: flex-start;
        }

        .nav-list {
            list-style: none;
            margin: 0;
            padding: 0.25rem 0;
        }

        .nav-link {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0.45rem 0.85rem;
            color: var(--slds-text-secondary);
            text-decoration: none;
            font-size: 0.8rem;
            font-weight: 500;
            border-left: 3px solid transparent;
            transition: all 0.15s ease-in-out;
        }

        .nav-link:hover, .nav-link.active {
            background: var(--slds-brand-light);
            color: var(--slds-brand);
            border-left-color: var(--slds-brand);
        }

        .nav-link-title {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 130px;
        }

        /* Modal Box System */
        .modal-backdrop {
            display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh;
            background: rgba(8, 7, 7, 0.55); backdrop-filter: blur(2px); z-index: 999;
            align-items: center; justify-content: center;
        }
        .modal-backdrop.active { display: flex; }

        .modal-card {
            background: #ffffff; width: 100%; max-width: 540px; border-radius: var(--slds-radius);
            box-shadow: 0 12px 28px rgba(0, 0, 0, 0.2); overflow: hidden; animation: modalFadeIn 0.15s ease-out;
        }
        @keyframes modalFadeIn {
            from { opacity: 0; transform: translateY(4px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .modal-header {
            padding: 0.85rem 1rem; background: #fafafa; border-bottom: 1px solid var(--slds-border);
            display: flex; align-items: center; justify-content: space-between;
        }
        .modal-header h3 { margin: 0; font-size: 0.95rem; font-weight: 700; color: var(--slds-text-primary); }
        .modal-close { background: transparent; border: none; font-size: 1.25rem; cursor: pointer; color: var(--slds-text-weak); }
        .modal-close:hover { color: var(--slds-text-primary); }
        .modal-body { padding: 1rem; }
        .modal-footer {
            padding: 0.75rem 1rem; background: #fafafa; border-top: 1px solid var(--slds-border);
            display: flex; justify-content: flex-end; gap: 0.5rem;
        }
        
        .action-group { display: flex; gap: 0.35rem; }
        .align-right { text-align: right; }
        .sub-header { margin: 0 0 0.75rem 0; font-size: 0.8rem; font-weight: 700; color: var(--slds-text-primary); text-transform: uppercase; }
        .hidden-content-store { display: none; }
        .empty-state { text-align: center; padding: 2.5rem 1.5rem; }
        .empty-state h3 { margin: 0 0 0.5rem 0; font-size: 1rem; color: var(--slds-text-primary); }
        .empty-state p { margin: 0; font-size: 0.825rem; color: var(--slds-text-secondary); }
    </style>
</head>
<body>

    <!-- GLOBAL APEX HEADER -->
    <header class="app-header">
        <div class="header-brand">
            <div class="header-brand-icon">P</div>
            <h1>Dynamic Page Builder</h1>
        </div>
        <div class="user-nav">
            <span class="user-info">
                Authenticated user: <strong>${fn:escapeXml(user)}</strong> (${fn:escapeXml(role)})
                <% if (branch != null && !branch.trim().isEmpty()) { %>
                    | Branch: <strong>${fn:escapeXml(branch)}</strong>
                <% } %>
            </span>
            <a href="Logout.jsp" class="btn-logout">Logout</a>
        </div>
    </header>

    <div class="app-container">
        
        <!-- LEFT SIDEBAR -->
        <aside class="sidebar">
            <div class="slds-card">
                <div class="slds-card-header">
                    <h3>Create New Page</h3>
                </div>
                <div class="slds-card-body">
                    <form action="pages" method="post">
                        <input type="hidden" name="action" value="createPage">
                        <div class="form-group">
                            <label for="title">Page Title</label>
                            <input type="text" id="title" name="title" required placeholder="e.g. Landing Page">
                        </div>
                        <div class="form-group">
                            <label for="slug">URL Slug</label>
                            <input type="text" id="slug" name="slug" required placeholder="e.g. home">
                        </div>
                        <button type="submit" class="btn btn-brand btn-full" style="margin-top:0.35rem;">+ Create Page</button>
                    </form>
                </div>
            </div>

            <div class="slds-card">
                <div class="slds-card-header">
                    <h3>Pages Directory</h3>
                </div>
                <div class="slds-card-body no-padding">
                    <div class="directory-table">
                        <table>
                            <thead>
                                <tr>
                                    <th>Page Details</th>
                                    <th class="align-right">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${pages}">
                                    <tr>
                                        <td>
                                            <strong style="color:var(--slds-text-primary);">${fn:escapeXml(p.title)}</strong><br>
                                            <code class="slug-pill">/${fn:escapeXml(p.slug)}</code>
                                        </td>
                                        <td class="align-right">
                                            <div class="action-group" style="justify-content: flex-end;">
                                                <button type="button" 
                                                        class="btn btn-neutral btn-sm btn-edit-page" 
                                                        data-id="${p.id}"
                                                        data-title="${fn:escapeXml(p.title)}"
                                                        data-slug="${fn:escapeXml(p.slug)}">
                                                    Edit
                                                </button>
                                                <a href="pages?action=view&id=${p.id}" class="btn btn-brand btn-sm">Manage</a>
                                                <a href="pages?action=delete&id=${p.id}" onclick="return confirm('Delete page?')" class="btn btn-destructive btn-sm">Delete</a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </aside>

        <!-- MAIN WORKSPACE -->
        <main class="main-content">
            <c:choose>
                <c:when test="${not empty activePage}">
                    
                    <div class="slds-card" id="page-overview">
                        <div class="slds-card-header">
                            <div>
                                <h3 style="margin:0 0 0.15rem 0;">Editing: ${fn:escapeXml(activePage.title)}</h3>
                                <code class="slug-pill">Path: /${fn:escapeXml(activePage.slug)}</code>
                            </div>
                            <button type="button" 
                                    class="btn btn-neutral btn-sm btn-edit-page"
                                    data-id="${activePage.id}"
                                    data-title="${fn:escapeXml(activePage.title)}"
                                    data-slug="${fn:escapeXml(activePage.slug)}">
                                Edit Page Details
                            </button>
                        </div>
                        <div class="slds-card-body">
                            <!-- ADD SECTION FORM -->
                            <div class="nested-form-block solid-border">
                                <h4 class="sub-header">Add New Section Block</h4>
                                <form action="pages" method="post">
                                    <input type="hidden" name="action" value="addSection">
                                    <input type="hidden" name="pageId" value="${activePage.id}">
                                    
                                    <div class="form-row">
                                        <div class="form-group col-type">
                                            <label>Type</label>
                                            <select name="sectionType">
                                                <option value="hero">Hero</option>
                                                <option value="district">District</option>
                                                <option value="popup_modal">Pop-up Modal</option>
                                                <option value="person_details">PERSON-DETAILS</option>
                                            </select>
                                        </div>

                                        <div class="form-group col-seq-sm">
                                            <label>Sequence</label>
                                            <input type="number" name="sequenceOrder" value="1" min="1" required>
                                        </div>

                                        <div class="form-group col-title">
                                            <label>Section Title</label>
                                            <input type="text" name="title" placeholder="Enter title">
                                        </div>
                                    </div>

                                    <div class="form-group" style="margin-top: 0.35rem;">
                                        <label>Content Description</label>
                                        <textarea name="content" rows="2" placeholder="Write section body content..."></textarea>
                                    </div>

                                    <button type="submit" class="btn btn-brand">+ Add Section Block</button>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- SECTIONS LOOP -->
                    <c:forEach var="sec" items="${activePage.sections}">
                        <div class="section-card" id="section-${sec.id}">
                            <div class="section-header">
                                <div class="section-title-group">
                                    <span class="badge">#${sec.sequenceOrder}</span>
                                    <span class="badge badge-type">${fn:escapeXml(sec.sectionType.toUpperCase())}</span>
                                    <strong style="color:var(--slds-text-primary); font-size:0.875rem;">${fn:escapeXml(sec.title)}</strong>
                                </div>
                                <div class="action-group">
                                    <button type="button" 
                                            class="btn btn-neutral btn-sm btn-edit-section"
                                            data-id="${sec.id}"
                                            data-type="${sec.sectionType}"
                                            data-seq="${sec.sequenceOrder}"
                                            data-title="${fn:escapeXml(sec.title)}">
                                        Edit Section
                                    </button>
                                    <div class="hidden-content-store" id="section-content-data-${sec.id}">${fn:escapeXml(sec.content)}</div>

                                    <a href="pages?action=deleteSection&sectionId=${sec.id}&pageId=${activePage.id}" 
                                       class="btn btn-destructive btn-sm"
                                       onclick="return confirm('Delete Section?')">Remove</a>
                                </div>
                            </div>

                            <div class="section-body">
                                <p class="section-description">${fn:escapeXml(sec.content)}</p>

                                <h4 class="sub-header">Sequenced Assets</h4>
                                
                                <div class="gallery-grid">
                                    <c:forEach var="img" items="${sec.images}">
                                        <div class="img-card">
                                            <span class="badge badge-overlay">Seq ${img.sequenceOrder}</span>
                                            
                                            <div class="img-container">
                                                <img src="pages?action=renderImage&imageId=${img.id}" alt="${fn:escapeXml(img.altText)}">
                                            </div>

                                            <c:if test="${not empty img.heading1 or not empty img.heading2}">
                                                <div class="img-headings">
                                                    <c:if test="${not empty img.heading1}"><strong>H1: ${fn:escapeXml(img.heading1)}</strong></c:if>
                                                    <c:if test="${not empty img.heading2}"><em>H2: ${fn:escapeXml(img.heading2)}</em></c:if>
                                                </div>
                                            </c:if>
                                            
                                            <div class="img-meta" title="${fn:escapeXml(img.altText)}">
                                                <c:choose>
                                                    <c:when test="${not empty img.altText}">${fn:escapeXml(img.altText)}</c:when>
                                                    <c:otherwise><span style="color:var(--slds-text-weak);">No description</span></c:otherwise>
                                                </c:choose>
                                            </div>
                                            
                                            <div class="action-group" style="margin-top:auto;">
                                                <button type="button" 
                                                        class="btn btn-neutral btn-sm btn-full btn-edit-image"
                                                        data-id="${img.id}"
                                                        data-seq="${img.sequenceOrder}"
                                                        data-alt="${fn:escapeXml(img.altText)}"
                                                        data-h1="${fn:escapeXml(img.heading1)}"
                                                        data-h2="${fn:escapeXml(img.heading2)}">
                                                    Edit
                                                </button>
                                                <a href="pages?action=deleteImage&imageId=${img.id}&pageId=${activePage.id}" 
                                                   class="btn btn-destructive btn-sm btn-full"
                                                   onclick="return confirm('Delete asset?')">Delete</a>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>

                                <!-- UPLOAD ASSET FORM -->
                                <div class="nested-form-block">
                                    <form action="pages?action=uploadImage" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="pageId" value="${activePage.id}">
                                        <input type="hidden" name="sectionId" value="${sec.id}">
                                        
                                        <div class="form-row">
                                            <div class="form-group col-file">
                                                <label>Select File</label>
                                                <input type="file" name="imageFile" accept="image/*" required>
                                            </div>
                                            <div class="form-group col-alt">
                                                <label>Heading 1</label>
                                                <input type="text" name="heading1" placeholder="Main Heading">
                                            </div>
                                            <div class="form-group col-alt">
                                                <label>Heading 2</label>
                                                <input type="text" name="heading2" placeholder="Sub Heading">
                                            </div>
                                        </div>

                                        <div class="form-row" style="margin-top:0.35rem;">
                                            <div class="form-group col-alt">
                                                <label>Alt Text / Description</label>
                                                <input type="text" name="altText" placeholder="Image description">
                                            </div>
                                            <div class="form-group col-seq-xs">
                                                <label>Seq #</label>
                                                <input type="number" name="sequenceOrder" value="1" min="1" required>
                                            </div>
                                            <div style="margin-bottom:0.75rem;">
                                                <button type="submit" class="btn btn-neutral">Upload Asset</button>
                                            </div>
                                        </div>
                                    </form>
                                </div>

                            </div>
                        </div>
                    </c:forEach>

                </c:when>

                <c:otherwise>
                    <div class="slds-card">
                        <div class="empty-state">
                            <h3>No Page Selected</h3>
                            <p>Select a page from the directory sidebar on the left to configure dynamic layout sections and media items.</p>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>

        <!-- RIGHT SIDEBAR: PAGE NAVIGATION -->
        <c:if test="${not empty activePage}">
            <aside class="page-nav-sidebar">
                <div class="slds-card">
                    <div class="slds-card-header">
                        <h3>Page Structure</h3>
                        <span class="badge">${fn:length(activePage.sections)} Sections</span>
                    </div>
                    <ul class="nav-list">
                        <li>
                            <a href="#page-overview" class="nav-link active">
                                <span class="nav-link-title">Overview & Form</span>
                            </a>
                        </li>
                        <c:forEach var="sec" items="${activePage.sections}">
                            <li>
                                <a href="#section-${sec.id}" class="nav-link">
                                    <span class="nav-link-title">
                                        <c:choose>
                                            <c:when test="${not empty sec.title}">${fn:escapeXml(sec.title)}</c:when>
                                            <c:otherwise>#${sec.sequenceOrder} ${fn:escapeXml(sec.sectionType)}</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span class="badge" style="font-size:0.65rem;">${fn:length(sec.images)} img</span>
                                </a>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </aside>
        </c:if>

    </div>

    <!-- EDIT PAGE MODAL -->
    <div class="modal-backdrop" id="editPageModal">
        <div class="modal-card">
            <div class="modal-header">
                <h3>Edit Page Details</h3>
                <button type="button" class="modal-close" onclick="closeModal('editPageModal')">&times;</button>
            </div>
            <form action="pages" method="post">
                <div class="modal-body">
                    <input type="hidden" name="action" value="editPage">
                    <input type="hidden" name="pageId" id="modalPageId">

                    <div class="form-group">
                        <label for="modalPageTitle">Page Title</label>
                        <input type="text" name="title" id="modalPageTitle" required>
                    </div>

                    <div class="form-group" style="margin-top:0.75rem;">
                        <label for="modalPageSlug">URL Slug</label>
                        <input type="text" name="slug" id="modalPageSlug" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-neutral" onclick="closeModal('editPageModal')">Cancel</button>
                    <button type="submit" class="btn btn-brand">Save Page</button>
                </div>
            </form>
        </div>
    </div>

    <!-- EDIT SECTION MODAL -->
    <div class="modal-backdrop" id="editSectionModal">
        <div class="modal-card">
            <div class="modal-header">
                <h3>Edit Section Block</h3>
                <button type="button" class="modal-close" onclick="closeModal('editSectionModal')">&times;</button>
            </div>
            <form action="pages" method="post">
                <div class="modal-body">
                    <input type="hidden" name="action" value="updateSection">
                    <input type="hidden" name="pageId" value="${activePage.id}">
                    <input type="hidden" name="sectionId" id="modalSectionId">

                    <div class="form-row">
                        <div class="form-group col-type">
                            <label>Type</label>
                            <select name="sectionType" id="modalSectionType">
                                <option value="hero">Hero</option>
                                <option value="district">District</option>
                                <option value="popup_modal">Pop-up Modal</option>
                                <option value="person_details">PERSON-DETAILS</option>
                            </select>
                        </div>

                        <div class="form-group col-seq-sm">
                            <label>Sequence</label>
                            <input type="number" name="sequenceOrder" id="modalSectionSequence" min="1" required>
                        </div>

                        <div class="form-group col-title">
                            <label>Section Title</label>
                            <input type="text" name="title" id="modalSectionTitle">
                        </div>
                    </div>

                    <div class="form-group" style="margin-top:0.75rem;">
                        <label>Content Description</label>
                        <textarea name="content" id="modalSectionContent" rows="5"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-neutral" onclick="closeModal('editSectionModal')">Cancel</button>
                    <button type="submit" class="btn btn-brand">Save Changes</button>
                </div>
            </form>
        </div>
    </div>

    <!-- EDIT IMAGE / MEDIA MODAL -->
    <div class="modal-backdrop" id="editImageModal">
        <div class="modal-card">
            <div class="modal-header">
                <h3>Edit Asset Metadata & Headings</h3>
                <button type="button" class="modal-close" onclick="closeModal('editImageModal')">&times;</button>
            </div>
            <form action="pages?action=updateImage" method="post" enctype="multipart/form-data">
                <div class="modal-body">
                    <input type="hidden" name="pageId" value="${activePage.id}">
                    <input type="hidden" name="imageId" id="modalImageId">

                    <div class="form-group">
                        <label>Replace Image (Optional)</label>
                        <input type="file" name="imageFile" accept="image/*">
                    </div>

                    <div class="form-row">
                        <div class="form-group col-alt">
                            <label>Heading 1</label>
                            <input type="text" name="heading1" id="modalImageHeading1">
                        </div>
                        <div class="form-group col-alt">
                            <label>Heading 2</label>
                            <input type="text" name="heading2" id="modalImageHeading2">
                        </div>
                    </div>

                    <div class="form-row" style="margin-top:0.35rem;">
                        <div class="form-group col-alt">
                            <label>Alt Text / Description</label>
                            <input type="text" name="altText" id="modalImageAltText">
                        </div>
                        <div class="form-group col-seq-xs">
                            <label>Seq #</label>
                            <input type="number" name="sequenceOrder" id="modalImageSequence" min="1" required>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-neutral" onclick="closeModal('editImageModal')">Cancel</button>
                    <button type="submit" class="btn btn-brand">Update Asset</button>
                </div>
            </form>
        </div>
    </div>

    <!-- JS EVENT HANDLERS -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            
            // Highlight active link in section navigation on scroll
            const navLinks = document.querySelectorAll('.page-nav-sidebar .nav-link');
            const sections = document.querySelectorAll('.main-content > div[id]');

            window.addEventListener('scroll', function () {
                let current = '';
                sections.forEach(function (section) {
                    const sectionTop = section.offsetTop - 90;
                    if (window.pageYOffset >= sectionTop) {
                        current = section.getAttribute('id');
                    }
                });

                navLinks.forEach(function (link) {
                    link.classList.remove('active');
                    if (link.getAttribute('href') === '#' + current) {
                        link.classList.add('active');
                    }
                });
            });

            // Handle Edit Page Modal
            document.querySelectorAll('.btn-edit-page').forEach(function (btn) {
                btn.addEventListener('click', function () {
                    document.getElementById('modalPageId').value = this.dataset.id;
                    document.getElementById('modalPageTitle').value = this.dataset.title;
                    document.getElementById('modalPageSlug').value = this.dataset.slug;
                    document.getElementById('editPageModal').classList.add('active');
                });
            });

            // Handle Edit Section Modal
            document.querySelectorAll('.btn-edit-section').forEach(function (btn) {
                btn.addEventListener('click', function () {
                    const secId = this.dataset.id;
                    const contentStore = document.getElementById('section-content-data-' + secId);
                    
                    document.getElementById('modalSectionId').value = secId;
                    document.getElementById('modalSectionType').value = this.dataset.type;
                    document.getElementById('modalSectionSequence').value = this.dataset.seq;
                    document.getElementById('modalSectionTitle').value = this.dataset.title || '';
                    
                    document.getElementById('modalSectionContent').value = contentStore ? contentStore.textContent.trim() : '';
                    document.getElementById('editSectionModal').classList.add('active');
                });
            });

            // Handle Edit Image Modal
            document.querySelectorAll('.btn-edit-image').forEach(function (btn) {
                btn.addEventListener('click', function () {
                    document.getElementById('modalImageId').value = this.dataset.id;
                    document.getElementById('modalImageSequence').value = this.dataset.seq;
                    document.getElementById('modalImageAltText').value = this.dataset.alt || '';
                    document.getElementById('modalImageHeading1').value = this.dataset.h1 || '';
                    document.getElementById('modalImageHeading2').value = this.dataset.h2 || '';
                    document.getElementById('editImageModal').classList.add('active');
                });
            });
        });

        function closeModal(modalId) {
            document.getElementById(modalId).classList.remove('active');
        }

        // Close modal when clicking on backdrop
        window.addEventListener('click', function(event) {
            if (event.target.classList.contains('modal-backdrop')) {
                event.target.classList.remove('active');
            }
        });
    </script>
</body>
</html>