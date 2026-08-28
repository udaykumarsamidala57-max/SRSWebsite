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
    <title>Page Builder | Enterprise Control Panel</title>
    <!-- Inter Font -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- External CSS -->
    <link rel="stylesheet" href="<c:url value='/css/page.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/index.css'/>">
    <!-- External JS -->
    <script type="module" src="<c:url value='/js/index.js'/>" defer></script>
</head>
<body>
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
                        <div class="form-group">
                            <label for="parentId">Parent Page (Sub-Navigation)</label>
                            <select id="parentId" name="parentId">
                                <option value="">-- None (Top Level Menu) --</option>
                                <c:forEach var="p" items="${pages}">
                                    <c:if test="${empty p.parentId}">
                                        <option value="${p.id}">${fn:escapeXml(p.title)}</option>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-brand btn-full" style="margin-top:0.35rem;">+ Create Page</button>
                    </form>
                </div>
            </div>

            <!-- PROFESSIONALLY ALIGNED PAGES DIRECTORY -->
            <div class="slds-card">
                <div class="slds-card-header">
                    <h3>Pages Directory</h3>
                </div>
                <div class="slds-card-body no-padding">
                    <div class="directory-table">
                        <table>
                            <thead>
                                <tr>
                                    <th>Page Hierarchy</th>
                                    <th class="align-right">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${pages}">
                                    <c:if test="${empty p.parentId}">
                                        <!-- Root Page Row -->
                                        <tr>
                                            <td>
                                                <div class="page-title-block">
                                                    <span class="page-name">
                                                        <span class="badge-nav-root">Root</span>
                                                        ${fn:escapeXml(p.title)}
                                                    </span>
                                                    <code class="slug-pill">/${fn:escapeXml(p.slug)}</code>
                                                </div>
                                            </td>
                                            <td class="align-right">
                                                <div class="action-group" style="justify-content: flex-end;">
                                                    <button type="button" 
                                                            class="btn btn-neutral btn-sm btn-edit-page" 
                                                            data-id="${p.id}"
                                                            data-title="${fn:escapeXml(p.title)}"
                                                            data-slug="${fn:escapeXml(p.slug)}"
                                                            data-parent-id="${p.parentId}">
                                                        Edit
                                                    </button>
                                                    <a href="pages?action=view&id=${p.id}" class="btn btn-brand btn-sm">Manage</a>
                                                    <a href="pages?action=delete&id=${p.id}" onclick="return confirm('Delete page?')" class="btn btn-destructive btn-sm">Delete</a>
                                                </div>
                                            </td>
                                        </tr>

                                        <!-- Sub-Navigation Children Rows -->
                                        <c:forEach var="sub" items="${pages}">
                                            <c:if test="${sub.parentId == p.id}">
                                                <tr class="sub-page-row">
                                                    <td class="sub-page-cell">
                                                        <div class="page-title-block">
                                                            <span class="page-name">
                                                                <span class="tree-connector">↳</span>
                                                                <span class="badge-nav-sub">Sub</span>
                                                                ${fn:escapeXml(sub.title)}
                                                            </span>
                                                            <code class="slug-pill">/${fn:escapeXml(sub.slug)}</code>
                                                        </div>
                                                    </td>
                                                    <td class="align-right">
                                                        <div class="action-group" style="justify-content: flex-end;">
                                                            <button type="button" 
                                                                    class="btn btn-neutral btn-sm btn-edit-page" 
                                                                    data-id="${sub.id}"
                                                                    data-title="${fn:escapeXml(sub.title)}"
                                                                    data-slug="${fn:escapeXml(sub.slug)}"
                                                                    data-parent-id="${sub.parentId}">
                                                                Edit
                                                            </button>
                                                            <a href="pages?action=view&id=${sub.id}" class="btn btn-brand btn-sm">Manage</a>
                                                            <a href="pages?action=delete&id=${sub.id}" onclick="return confirm('Delete sub-page?')" class="btn btn-destructive btn-sm">Delete</a>
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
                                <c:if test="${not empty activePage.parentId}">
                                    <span class="badge" style="margin-left: 0.5rem;">Sub-page of Parent #${activePage.parentId}</span>
                                </c:if>
                            </div>
                            <button type="button" 
                                    class="btn btn-neutral btn-sm btn-edit-page"
                                    data-id="${activePage.id}"
                                    data-title="${fn:escapeXml(activePage.title)}"
                                    data-slug="${fn:escapeXml(activePage.slug)}"
                                    data-parent-id="${activePage.parentId}">
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
                                                <option value="DISTINCT">DISTINCT</option>
                                                <option value="DESC">DESC</option>
                                                <option value="DESC2">DESC2</option>
                                                <option value="DESC3">DESC3</option>
                                                <option value="SIDE_DESIGN">SIDE_DESIGN</option>
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
                                            <div class="form-group col-alt" style="flex: 1;">
                                                <label for="uploadAltText">Alt Text / Description</label>
                                                <textarea id="uploadAltText" name="altText" rows="3" placeholder="Image description..." style="width: 100%; resize: vertical;"></textarea>
                                            </div>
                                            <div class="form-group col-seq-xs">
                                                <label>Seq #</label>
                                                <input type="number" name="sequenceOrder" value="1" min="1" required>
                                            </div>
                                            <div style="margin-bottom:0.75rem; align-self: flex-end;">
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
                    <!-- EMPTY STATE WHEN NO PAGE IS SELECTED -->
                    <div class="slds-card">
                        <div class="slds-card-body empty-state">
                            <h3>No Page Selected</h3>
                            <p>Select a page from the directory on the left to edit its content and manage sections, or create a new page to get started.</p>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>

        <!-- RIGHT STICKY NAVIGATION SIDEBAR -->
        <c:if test="${not empty activePage and not empty activePage.sections}">
            <aside class="page-nav-sidebar">
                <div class="slds-card">
                    <div class="slds-card-header">
                        <h3>Page Structure</h3>
                    </div>
                    <div class="slds-card-body no-padding">
                        <ul class="nav-list">
                            <li>
                                <a href="#page-overview" class="nav-link">
                                    <span class="nav-link-title">Overview</span>
                                    <span class="badge">Top</span>
                                </a>
                            </li>
                            <c:forEach var="sec" items="${activePage.sections}">
                                <li>
                                    <a href="#section-${sec.id}" class="nav-link">
                                        <span class="nav-link-title">${fn:escapeXml(sec.title)}</span>
                                        <span class="badge badge-type">#${sec.sequenceOrder}</span>
                                    </a>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
            </aside>
        </c:if>

    </div>

    <!-- MODAL: EDIT PAGE DETAILS -->
    <div class="modal-backdrop" id="editPageModal">
        <div class="modal-card">
            <div class="modal-header">
                <h3>Edit Page Details</h3>
                <button type="button" class="modal-close" onclick="closeModal('editPageModal')">&times;</button>
            </div>
            <form action="pages" method="post">
                <input type="hidden" name="action" value="updatePage">
                <input type="hidden" name="id" id="editPageId">
                <div class="modal-body">
                    <div class="form-group">
                        <label for="editPageTitle">Page Title</label>
                        <input type="text" id="editPageTitle" name="title" required>
                    </div>
                    <div class="form-group">
                        <label for="editPageSlug">URL Slug</label>
                        <input type="text" id="editPageSlug" name="slug" required>
                    </div>
                    <div class="form-group">
                        <label for="editParentId">Parent Page (Sub-Navigation)</label>
                        <select id="editParentId" name="parentId">
                            <option value="">-- None (Top Level Menu) --</option>
                            <c:forEach var="p" items="${pages}">
                                <option value="${p.id}">${fn:escapeXml(p.title)}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-neutral" onclick="closeModal('editPageModal')">Cancel</button>
                    <button type="submit" class="btn btn-brand">Save Changes</button>
                </div>
            </form>
        </div>
    </div>

    <!-- MODAL: EDIT SECTION -->
    <div class="modal-backdrop" id="editSectionModal">
        <div class="modal-card">
            <div class="modal-header">
                <h3>Edit Section Block</h3>
                <button type="button" class="modal-close" onclick="closeModal('editSectionModal')">&times;</button>
            </div>
            <form action="pages" method="post">
                <input type="hidden" name="action" value="updateSection">
                <input type="hidden" name="sectionId" id="editSectionId">
                <input type="hidden" name="pageId" value="${activePage.id}">
                <div class="modal-body">
                    <div class="form-row">
                        <div class="form-group col-type">
                            <label for="editSectionType">Type</label>
                            <select id="editSectionType" name="sectionType">
                                <option value="hero">Hero</option>
                                                <option value="DISTINCT">DISTINCT</option>
                                                <option value="DESC">DESC</option>
                                                <option value="DESC2">DESC2</option>
                                                <option value="DESC3">DESC3</option>
                                                <option value="SIDE_DESIGN">SIDE_DESIGN</option>
                                                <option value="person_details">PERSON-DETAILS</option>
                            </select>
                        </div>
                        <div class="form-group col-seq-sm">
                            <label for="editSectionSeq">Sequence</label>
                            <input type="number" id="editSectionSeq" name="sequenceOrder" min="1" required>
                        </div>
                        <div class="form-group col-title">
                            <label for="editSectionTitle">Title</label>
                            <input type="text" id="editSectionTitle" name="title" required>
                        </div>
                    </div>
                    <div class="form-group" style="margin-top: 0.35rem;">
                        <label for="editSectionContent">Content Description</label>
                        <textarea id="editSectionContent" name="content" rows="4"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-neutral" onclick="closeModal('editSectionModal')">Cancel</button>
                    <button type="submit" class="btn btn-brand">Update Section</button>
                </div>
            </form>
        </div>
    </div>

    <!-- MODAL: EDIT IMAGE METADATA -->
    <div class="modal-backdrop" id="editImageModal">
        <div class="modal-card">
            <div class="modal-header">
                <h3>Edit Asset Metadata</h3>
                <button type="button" class="modal-close" onclick="closeModal('editImageModal')">&times;</button>
            </div>
            <form action="pages" method="post">
                <input type="hidden" name="action" value="updateImageMeta">
                <input type="hidden" name="imageId" id="editImageId">
                <input type="hidden" name="pageId" value="${activePage.id}">
                <div class="modal-body">
                    <div class="form-row">
                        <div class="form-group col-alt">
                            <label for="editImageH1">Heading 1</label>
                            <input type="text" id="editImageH1" name="heading1">
                        </div>
                        <div class="form-group col-alt">
                            <label for="editImageH2">Heading 2</label>
                            <input type="text" id="editImageH2" name="heading2">
                        </div>
                    </div>
                    <div class="form-row" style="margin-top:0.35rem;">
                        <div class="form-group col-alt" style="flex: 1;">
                            <label for="editImageAlt">Alt Text / Description</label>
                            <textarea id="editImageAlt" name="altText" rows="3" placeholder="Image description..." style="width: 100%; resize: vertical;"></textarea>
                        </div>
                        <div class="form-group col-seq-xs">
                            <label for="editImageSeq">Seq #</label>
                            <input type="number" id="editImageSeq" name="sequenceOrder" min="1" required>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-neutral" onclick="closeModal('editImageModal')">Cancel</button>
                    <button type="submit" class="btn btn-brand">Save Asset</button>
                </div>
            </form>
        </div>
    </div>

</body>
</html>