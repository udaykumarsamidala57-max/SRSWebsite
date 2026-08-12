<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dynamic Page Manager | Builder</title>
    <!-- Inter Font -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --slds-navy: #0176D3;
            --slds-navy-dark: #005FB2;
            --slds-bg-main: #B0C4DF;
            --slds-bg-page: #F3F3F3;
            --slds-card-bg: #FFFFFF;
            --slds-border: #DDDBDA;
            --slds-text-primary: #181818;
            --slds-text-secondary: #444444;
            --slds-text-muted: #747474;
            --slds-danger: #BA0517;
            --slds-danger-bg: #FEF1F1;
            --slds-shadow: 0 2px 4px rgba(0, 0, 0, 0.07);
            --slds-radius: 4px;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background-color: var(--slds-bg-page);
            color: var(--slds-text-primary);
            font-size: 13px;
            line-height: 1.5;
        }

        /* Top Header Navigation */
        .app-header {
            background-color: #001639;
            color: #FFFFFF;
            padding: 12px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 4px rgba(0,0,0,0.15);
        }

        .app-header h1 {
            font-size: 16px;
            font-weight: 600;
            letter-spacing: 0.5px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .app-header h1::before {
            content: '';
            display: inline-block;
            width: 12px;
            height: 12px;
            background-color: var(--slds-navy);
            border-radius: 2px;
        }

        .app-container {
            display: grid;
            grid-template-columns: 320px 1fr;
            gap: 20px;
            padding: 24px;
            max-width: 1600px;
            margin: 0 auto;
        }

        /* Cards & Containers */
        .card {
            background: var(--slds-card-bg);
            border: 1px solid var(--slds-border);
            border-radius: var(--slds-radius);
            box-shadow: var(--slds-shadow);
            margin-bottom: 20px;
            overflow: hidden;
        }

        .card-header {
            padding: 12px 16px;
            border-bottom: 1px solid var(--slds-border);
            background-color: #FAFAFB;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .card-header h3, .card-header h2 {
            font-size: 14px;
            font-weight: 600;
            color: var(--slds-text-primary);
        }

        .card-body {
            padding: 16px;
        }

        /* Forms & Inputs */
        .form-group {
            margin-bottom: 12px;
        }

        .form-group label {
            display: block;
            font-size: 12px;
            font-weight: 600;
            color: var(--slds-text-secondary);
            margin-bottom: 4px;
        }

        .form-row {
            display: flex;
            gap: 12px;
            align-items: flex-end;
            flex-wrap: wrap;
        }

        input[type="text"],
        input[type="number"],
        select,
        textarea {
            width: 100%;
            padding: 6px 10px;
            border: 1px solid var(--slds-border);
            border-radius: var(--slds-radius);
            font-family: inherit;
            font-size: 13px;
            color: var(--slds-text-primary);
            background-color: #FFFFFF;
            transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
        }

        input[type="text"]:focus,
        input[type="number"]:focus,
        select:focus,
        textarea:focus {
            outline: none;
            border-color: var(--slds-navy);
            box-shadow: 0 0 0 1px var(--slds-navy);
        }

        textarea {
            resize: vertical;
        }

        /* Buttons */
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 6px 14px;
            font-size: 12px;
            font-weight: 600;
            border-radius: var(--slds-radius);
            border: 1px solid transparent;
            cursor: pointer;
            transition: all 0.15s ease;
            text-decoration: none;
            white-space: nowrap;
        }

        .btn-brand {
            background-color: var(--slds-navy);
            color: #FFFFFF;
            border-color: var(--slds-navy);
        }

        .btn-brand:hover {
            background-color: var(--slds-navy-dark);
            border-color: var(--slds-navy-dark);
        }

        .btn-neutral {
            background-color: #FFFFFF;
            color: var(--slds-navy);
            border-color: var(--slds-border);
        }

        .btn-neutral:hover {
            background-color: #F3F3F3;
        }

        .btn-destructive {
            color: var(--slds-danger);
            background-color: transparent;
        }

        .btn-destructive:hover {
            background-color: var(--slds-danger-bg);
        }

        .btn-sm {
            padding: 3px 8px;
            font-size: 11px;
        }

        /* Tables */
        .slds-table-container {
            border: 1px solid var(--slds-border);
            border-radius: var(--slds-radius);
            overflow: hidden;
            margin-top: 12px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            background: #FFFFFF;
        }

        th {
            background-color: #FAFAFB;
            color: var(--slds-text-secondary);
            font-weight: 600;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 8px 12px;
            border-bottom: 1px solid var(--slds-border);
        }

        td {
            padding: 10px 12px;
            border-bottom: 1px solid var(--slds-border);
            vertical-align: middle;
        }

        tr:last-child td {
            border-bottom: none;
        }

        tr:hover td {
            background-color: #F3F3F3;
        }

        /* Badges & Tags */
        .badge {
            display: inline-block;
            padding: 2px 6px;
            font-size: 10px;
            font-weight: 700;
            text-transform: uppercase;
            border-radius: 2px;
            background-color: #EAF4FE;
            color: var(--slds-navy-dark);
            border: 1px solid #C2E0FF;
        }

        .badge-type {
            background-color: #ECEBEA;
            color: var(--slds-text-primary);
            border-color: var(--slds-border);
        }

        /* Code Pill */
        code.slug-pill {
            font-family: monospace;
            background: #F3F3F3;
            padding: 2px 6px;
            border-radius: 3px;
            color: var(--slds-text-muted);
            font-size: 11px;
        }

        /* Section Block */
        .section-card {
            border: 1px solid var(--slds-border);
            border-left: 4px solid var(--slds-navy);
            border-radius: var(--slds-radius);
            background: #FFFFFF;
            margin-bottom: 16px;
            box-shadow: var(--slds-shadow);
        }

        .section-header {
            padding: 12px 16px;
            background-color: #FAFAFB;
            border-bottom: 1px solid var(--slds-border);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .section-body {
            padding: 16px;
        }

        /* Image Gallery Grid */
        .gallery-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(130px, 1fr));
            gap: 12px;
            margin: 12px 0;
        }

        .img-card {
            border: 1px solid var(--slds-border);
            border-radius: var(--slds-radius);
            padding: 8px;
            background: #FFFFFF;
            text-align: center;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
            transition: box-shadow 0.15s ease;
        }

        .img-card:hover {
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .img-container {
            height: 90px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #FAFAFB;
            border-radius: 2px;
            margin-bottom: 6px;
            overflow: hidden;
        }

        .img-card img {
            max-height: 100%;
            max-width: 100%;
            object-fit: contain;
        }

        .img-meta {
            font-size: 11px;
            color: var(--slds-text-muted);
            margin-bottom: 4px;
            word-break: break-word;
        }

        .nested-form-block {
            background-color: #FAFAFB;
            border: 1px dashed var(--slds-border);
            padding: 12px;
            border-radius: var(--slds-radius);
            margin-top: 12px;
        }

        .empty-state {
            padding: 40px;
            text-align: center;
            color: var(--slds-text-muted);
        }

        /* Action Links Group */
        .action-group {
            display: flex;
            gap: 6px;
            align-items: center;
        }
    </style>
</head>
<body>

    <!-- LIGHTNING HEADER NAV -->
    <header class="app-header">
        <h1>Dynamic Page Manager</h1>
        <span style="font-size: 11px; color: #B0C4DF; font-weight: 500;">Content Builder v2.4</span>
    </header>

    <div class="app-container">
        
        <!-- LEFT SIDEBAR: CREATE & LIST PAGES -->
        <aside class="sidebar">
            
            <!-- CREATE PAGE CARD -->
            <div class="card">
                <div class="card-header">
                    <h3>Create New Page</h3>
                </div>
                <div class="card-body">
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
                        
                        <button type="submit" class="btn btn-brand" style="width: 100%; margin-top: 4px;">+ Create Page</button>
                    </form>
                </div>
            </div>

            <!-- PAGE DIRECTORY CARD -->
            <div class="card">
                <div class="card-header">
                    <h3>Pages Directory</h3>
                </div>
                <div class="card-body" style="padding: 0;">
                    <div class="slds-table-container" style="border: none; margin-top: 0;">
                        <table>
                            <thead>
                                <tr>
                                    <th>Page details</th>
                                    <th style="text-align: right;">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${pages}">
                                    <tr>
                                        <td>
                                            <strong style="color: var(--slds-text-primary);">${p.title}</strong><br>
                                            <code class="slug-pill">/${p.slug}</code>
                                        </td>
                                        <td style="text-align: right;">
                                            <div class="action-group" style="justify-content: flex-end;">
                                                <a href="pages?action=view&id=${p.id}" class="btn btn-neutral btn-sm">Manage</a>
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

        <!-- RIGHT MAIN CANVAS AREA -->
        <main class="main-content">
            <c:choose>
                <c:when test="${not empty activePage}">
                    
                    <!-- ACTIVE PAGE CONTROL BAR -->
                    <div class="card">
                        <div class="card-header">
                            <h2>Editing Page: <span style="color: var(--slds-navy);">${activePage.title}</span></h2>
                            <code class="slug-pill">Path: /${activePage.slug}</code>
                        </div>
                        <div class="card-body">
                            
                            <!-- ADD SECTION FORM -->
                            <div class="nested-form-block" style="background-color: #FFFFFF; border-style: solid;">
                                <h4 style="margin-bottom: 12px; font-size: 12px; text-transform: uppercase; letter-spacing: 0.5px; color: var(--slds-text-muted);">Add New Section</h4>
                                <form action="pages" method="post">
                                    <input type="hidden" name="action" value="addSection">
                                    <input type="hidden" name="pageId" value="${activePage.id}">
                                    
                                    <div class="form-row">
                                        <div style="flex: 1; min-width: 140px;">
                                            <label>Type</label>
                                            <select name="sectionType">
                                                <option value="hero">Hero</option>
                                                <option value="district">District</option>
                                                <option value="popup_modal">Pop-up Modal</option>
                                            </select>
                                        </div>

                                        <div style="width: 80px;">
                                            <label>Sequence</label>
                                            <input type="number" name="sequenceOrder" value="1" min="1" required>
                                        </div>

                                        <div style="flex: 2; min-width: 200px;">
                                            <label>Section Title</label>
                                            <input type="text" name="title" placeholder="Enter title">
                                        </div>
                                    </div>

                                    <div class="form-group" style="margin-top: 10px; margin-bottom: 10px;">
                                        <label>Content Description</label>
                                        <textarea name="content" rows="2" placeholder="Write section body content..."></textarea>
                                    </div>

                                    <button type="submit" class="btn btn-brand">Add Section Block</button>
                                </form>
                            </div>

                        </div>
                    </div>

                    <!-- SECTIONS STACK -->
                    <c:forEach var="sec" items="${activePage.sections}">
                        <div class="section-card">
                            <div class="section-header">
                                <div style="display: flex; align-items: center; gap: 8px;">
                                    <span class="badge">#${sec.sequenceOrder}</span>
                                    <span class="badge badge-type">${sec.sectionType.toUpperCase()}</span>
                                    <strong style="font-size: 13px;">${sec.title}</strong>
                                </div>
                                <a href="pages?action=deleteSection&sectionId=${sec.id}&pageId=${activePage.id}" 
                                   class="btn btn-destructive btn-sm"
                                   onclick="return confirm('Delete Section?')">Remove Section</a>
                            </div>

                            <div class="section-body">
                                <p style="color: var(--slds-text-secondary); margin-bottom: 14px;">${sec.content}</p>

                                <!-- IMAGES GALLERY HEADER -->
                                <h4 style="font-size: 11px; font-weight: 700; text-transform: uppercase; color: var(--slds-text-muted); margin-bottom: 8px;">Sequenced Assets</h4>
                                
                                <div class="gallery-grid">
                                    <c:forEach var="img" items="${sec.images}">
                                        <div class="img-card">
                                            <span class="badge" style="position: absolute; top: 4px; left: 4px; font-size: 9px;">Seq ${img.sequenceOrder}</span>
                                            
                                            <div class="img-container">
                                                <img src="pages?action=renderImage&imageId=${img.id}" alt="${img.altText}">
                                            </div>
                                            
                                            <div class="img-meta" title="${img.altText}">
                                                <c:choose>
                                                    <c:when test="${not empty img.altText}">${img.altText}</c:when>
                                                    <c:otherwise><em>No description</em></c:otherwise>
                                                </c:choose>
                                            </div>
                                            
                                            <a href="pages?action=deleteImage&imageId=${img.id}&pageId=${activePage.id}" class="btn btn-destructive btn-sm" style="width: 100%;">Delete</a>
                                        </div>
                                    </c:forEach>
                                </div>

                                <!-- UPLOAD IMAGE FORM -->
                                <div class="nested-form-block">
                                    <form action="pages?action=uploadImage" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="pageId" value="${activePage.id}">
                                        <input type="hidden" name="sectionId" value="${sec.id}">
                                        
                                        <div class="form-row">
                                            <div style="flex: 2; min-width: 180px;">
                                                <label>Select File</label>
                                                <input type="file" name="imageFile" accept="image/*" required style="background: transparent; border: none; padding: 0;">
                                            </div>
                                            <div style="flex: 2; min-width: 150px;">
                                                <label>Alt Text</label>
                                                <input type="text" name="altText" placeholder="Image description">
                                            </div>
                                            <div style="width: 70px;">
                                                <label>Seq #</label>
                                                <input type="number" name="sequenceOrder" value="1" min="1" required>
                                            </div>
                                            <div>
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
                    <div class="card">
                        <div class="empty-state">
                            <h3 style="margin-bottom: 6px; color: var(--slds-text-primary);">No Page Selected</h3>
                            <p>Select a page from the directory sidebar on the left to configure dynamic layout sections and media items.</p>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>

    </div>

</body>
</html>