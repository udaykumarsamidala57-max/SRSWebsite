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
    <title>Dynamic Page Manager | Builder</title>
    <!-- Inter Font -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- External CSS -->
    <link rel="stylesheet" href="css/page.css">
    
    <style>
        .app-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 1rem 2rem;
            background: #ffffff;
            border-bottom: 1px solid #e2e8f0;
        }
        .header-brand h1 { margin: 0; font-size: 1.25rem; color: #0f172a; }
        .user-nav { display: flex; align-items: center; gap: 1rem; }
        .user-info { font-size: 0.875rem; color: #475569; }
        .btn-logout {
            background-color: #ef4444; color: #ffffff; padding: 0.4rem 0.85rem;
            font-size: 0.85rem; font-weight: 500; border-radius: 6px;
            text-decoration: none; border: none; cursor: pointer; transition: background-color 0.2s;
        }
        .btn-logout:hover { background-color: #dc2626; }

        .modal-backdrop {
            display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh;
            background: rgba(15, 23, 42, 0.65); backdrop-filter: blur(4px); z-index: 999;
            align-items: center; justify-content: center;
        }
        .modal-backdrop.active { display: flex; }
        .modal-card {
            background: #ffffff; width: 100%; max-width: 580px; border-radius: 12px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            overflow: hidden; animation: modalFadeIn 0.2s ease-out;
        }
        @keyframes modalFadeIn {
            from { opacity: 0; transform: scale(0.96); }
            to { opacity: 1; transform: scale(1); }
        }
        .modal-header {
            padding: 1rem 1.5rem; background: #f8fafc; border-bottom: 1px solid #e2e8f0;
            display: flex; align-items: center; justify-content: space-between;
        }
        .modal-header h3 { margin: 0; font-size: 1.1rem; color: #0f172a; }
        .modal-close { background: transparent; border: none; font-size: 1.5rem; line-height: 1; cursor: pointer; color: #64748b; }
        .modal-body { padding: 1.5rem; }
        .modal-footer {
            padding: 1rem 1.5rem; background: #f8fafc; border-top: 1px solid #e2e8f0;
            display: flex; justify-content: flex-end; gap: 0.5rem;
        }
        .action-group { display: flex; gap: 0.35rem; }
        .img-headings {
            padding: 4px 8px; background: #f1f5f9; border-radius: 4px; margin-bottom: 6px; font-size: 0.8rem;
        }
        .img-headings strong { color: #0f172a; }
        .img-headings em { color: #64748b; display: block; }
        .hidden-content-store { display: none; }
    </style>
</head>
<body>

    <!-- HEADER NAV -->
    <header class="app-header">
        <div class="header-brand">
            <h1>Dynamic Page Builder</h1>
        </div>
        <div class="user-nav">
            <span class="user-info">
                Logged in as <strong><%= user %></strong> (<%= role %>)
                <% if (branch != null && !branch.trim().isEmpty()) { %>
                    | Branch: <strong><%= branch %></strong>
                <% } %>
            </span>
            <a href="Logout.jsp" class="btn-logout">Logout</a>
        </div>
    </header>

    <div class="app-container">
        
        <!-- LEFT SIDEBAR -->
        <aside class="sidebar">
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
                        <button type="submit" class="btn btn-brand btn-submit-spaced">+ Create Page</button>
                    </form>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <h3>Pages Directory</h3>
                </div>
                <div class="card-body no-padding">
                    <div class="slds-table-container directory-table">
                        <table>
                            <thead>
                                <tr>
                                    <th>Page details</th>
                                    <th class="align-right">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${pages}">
                                    <tr>
                                        <td>
                                            <strong class="page-title">${fn:escapeXml(p.title)}</strong><br>
                                            <code class="slug-pill">/${fn:escapeXml(p.slug)}</code>
                                        </td>
                                        <td class="align-right">
                                            <div class="action-group">
                                                <button type="button" 
                                                        class="btn btn-neutral btn-sm btn-edit-page" 
                                                        data-id="${p.id}"
                                                        data-title="${fn:escapeXml(p.title)}"
                                                        data-slug="${fn:escapeXml(p.slug)}">
                                                    Edit
                                                </button>
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

        <!-- MAIN CONTENT AREA -->
        <main class="main-content">
            <c:choose>
                <c:when test="${not empty activePage}">
                    
                    <div class="card">
                        <div class="card-header">
                            <div>
                                <h2>Editing Page: <span class="card-header-title">${fn:escapeXml(activePage.title)}</span></h2>
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
                        <div class="card-body">
                            <!-- ADD SECTION FORM -->
                            <div class="nested-form-block solid-border">
                                <h4 class="sub-header form-heading">Add New Section</h4>
                                <form action="pages" method="post">
                                    <input type="hidden" name="action" value="addSection">
                                    <input type="hidden" name="pageId" value="${activePage.id}">
                                    
                                    <div class="form-row">
                                        <div class="col-type">
                                            <label>Type</label>
                                            <select name="sectionType">
                                                <option value="hero">Hero</option>
                                                <option value="district">District</option>
                                                <option value="popup_modal">Pop-up Modal</option>
                                                <option value="person_details">PERSON-DETAILS</option>
                                            </select>
                                        </div>

                                        <div class="col-seq-sm">
                                            <label>Sequence</label>
                                            <input type="number" name="sequenceOrder" value="1" min="1" required>
                                        </div>

                                        <div class="col-title">
                                            <label>Section Title</label>
                                            <input type="text" name="title" placeholder="Enter title">
                                        </div>
                                    </div>

                                    <div class="form-group spacing-vertical">
                                        <label>Content Description</label>
                                        <textarea name="content" rows="2" placeholder="Write section body content..."></textarea>
                                    </div>

                                    <button type="submit" class="btn btn-brand">Add Section Block</button>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- SECTIONS LOOP -->
                    <c:forEach var="sec" items="${activePage.sections}">
                        <div class="section-card" id="section-card-${sec.id}">
                            <div class="section-header">
                                <div class="section-title-group">
                                    <span class="badge">#${sec.sequenceOrder}</span>
                                    <span class="badge badge-type">${sec.sectionType.toUpperCase()}</span>
                                    <strong class="section-title-text">${fn:escapeXml(sec.title)}</strong>
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
                                    <!-- HIDDEN CONTAINER FOR SAFE LARGE TEXT RETRIEVAL -->
                                    <div class="hidden-content-store" id="section-content-data-${sec.id}">${fn:escapeXml(sec.content)}</div>

                                    <a href="pages?action=deleteSection&sectionId=${sec.id}&pageId=${activePage.id}" 
                                       class="btn btn-destructive btn-sm"
                                       onclick="return confirm('Delete Section?')">Remove Section</a>
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
                                                    <c:otherwise><em>No description</em></c:otherwise>
                                                </c:choose>
                                            </div>
                                            
                                            <div class="action-group">
                                                <button type="button" 
                                                        class="btn btn-neutral btn-sm btn-full btn-edit-image"
                                                        data-id="${img.id}"
                                                        data-seq="${img.sequenceOrder}"
                                                        data-alt="${fn:escapeXml(img.altText)}"
                                                        data-h1="${fn:escapeXml(img.heading1)}"
                                                        data-h2="${fn:escapeXml(img.heading2)}">
                                                    Edit Asset
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
                                            <div class="col-file">
                                                <label>Select File</label>
                                                <input type="file" name="imageFile" accept="image/*" required>
                                            </div>
                                            <div class="col-alt">
                                                <label>Heading 1</label>
                                                <input type="text" name="heading1" placeholder="Main Heading">
                                            </div>
                                            <div class="col-alt">
                                                <label>Heading 2</label>
                                                <input type="text" name="heading2" placeholder="Sub Heading">
                                            </div>
                                        </div>

                                        <div class="form-row spacing-vertical">
                                            <div class="col-alt">
                                                <label>Alt Text / Description</label>
                                                <input type="text" name="altText" placeholder="Image description">
                                            </div>
                                            <div class="col-seq-xs">
                                                <label>Seq #</label>
                                                <input type="number" name="sequenceOrder" value="1" min="1" required>
                                            </div>
                                            <div>
                                                <label>&nbsp;</label>
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
                            <h3>No Page Selected</h3>
                            <p>Select a page from the directory sidebar on the left to configure dynamic layout sections and media items.</p>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>

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

                    <div class="form-group spacing-vertical">
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
                        <div class="col-type">
                            <label>Type</label>
                            <select name="sectionType" id="modalSectionType">
                                <option value="hero">Hero</option>
                                <option value="district">District</option>
                                <option value="popup_modal">Pop-up Modal</option>
                                <option value="person_details">PERSON-DETAILS</option>
                            </select>
                        </div>

                        <div class="col-seq-sm">
                            <label>Sequence</label>
                            <input type="number" name="sequenceOrder" id="modalSectionSequence" min="1" required>
                        </div>

                        <div class="col-title">
                            <label>Section Title</label>
                            <input type="text" name="title" id="modalSectionTitle">
                        </div>
                    </div>

                    <div class="form-group spacing-vertical">
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
                        <div class="col-alt">
                            <label>Heading 1</label>
                            <input type="text" name="heading1" id="modalImageHeading1">
                        </div>
                        <div class="col-alt">
                            <label>Heading 2</label>
                            <input type="text" name="heading2" id="modalImageHeading2">
                        </div>
                    </div>

                    <div class="form-row spacing-vertical">
                        <div class="col-alt">
                            <label>Alt Text / Description</label>
                            <input type="text" name="altText" id="modalImageAltText">
                        </div>
                        <div class="col-seq-xs">
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
                    
                    // Safely extract full text content regardless of size or linebreaks
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