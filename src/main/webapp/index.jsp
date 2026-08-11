<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Dynamic Page Manager</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background: #f4f4f9; }
        .container { display: flex; gap: 20px; }
        .sidebar { width: 30%; background: #fff; padding: 15px; border-radius: 5px; box-shadow: 0 0 5px #ccc; }
        .main { width: 70%; background: #fff; padding: 15px; border-radius: 5px; box-shadow: 0 0 5px #ccc; }
        table { border-collapse: collapse; width: 100%; margin-top: 10px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        .section-box { border: 2px solid #007bff; padding: 15px; margin-top: 15px; border-radius: 5px; }
        .img-card { display: inline-block; border: 1px solid #ccc; padding: 5px; margin: 5px; text-align: center; background: #fff; }
        .img-card img { max-height: 80px; display: block; margin-bottom: 5px; }
        .form-block { background: #eef2f5; padding: 10px; margin-top: 10px; border-radius: 4px; }
    </style>
</head>
<body>

    <h1>Dynamic Web Page Builder</h1>

    <div class="container">
        
        <!-- LEFT SIDEBAR: CREATE & LIST PAGES -->
        <div class="sidebar">
            <h3>Create New Page</h3>
            <form action="pages" method="post">
                <input type="hidden" name="action" value="createPage">
                <p>Title:<br><input type="text" name="title" required style="width:90%;"></p>
                <p>Slug:<br><input type="text" name="slug" required placeholder="e.g. home" style="width:90%;"></p>
                <button type="submit">Create Page</button>
            </form>

            <hr>

            <h3>Pages</h3>
            <table>
                <tr>
                    <th>Title</th>
                    <th>Action</th>
                </tr>
                <c:forEach var="p" items="${pages}">
                    <tr>
                        <td><strong>${p.title}</strong><br><small>/${p.slug}</small></td>
                        <td>
                            <a href="pages?action=view&id=${p.id}">Manage</a> | 
                            <a href="pages?action=delete&id=${p.id}" onclick="return confirm('Delete page?')" style="color:red;">Delete</a>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </div>

        <!-- RIGHT MAIN AREA: SECTIONS & SEQUENCED IMAGES -->
        <div class="main">
            <c:choose>
                <c:when test="${not empty activePage}">
                    <h2>Editing Page: ${activePage.title} <code>(/${activePage.slug})</code></h2>

                    <!-- ADD SECTION FORM -->
                    <div class="form-block">
                        <h4>Add New Section</h4>
                        <form action="pages" method="post">
                            <input type="hidden" name="action" value="addSection">
                            <input type="hidden" name="pageId" value="${activePage.id}">
                            
                            Type: 
                            <select name="sectionType">
                                <option value="hero">Hero</option>
                                <option value="district">District</option>
                                <option value="popup_modal">Pop-up Modal</option>
                            </select>

                            Sequence #: <input type="number" name="sequenceOrder" value="1" min="1" style="width:50px;" required>
                            Title: <input type="text" name="title"><br><br>
                            Content:<br>
                            <textarea name="content" rows="2" style="width:95%;"></textarea><br><br>
                            <button type="submit">Add Section</button>
                        </form>
                    </div>

                    <!-- SECTIONS LIST -->
                    <c:forEach var="sec" items="${activePage.sections}">
                        <div class="section-box">
                            <h3>
                                #${sec.sequenceOrder} [${sec.sectionType.toUpperCase()}] ${sec.title}
                                <a href="pages?action=deleteSection&sectionId=${sec.id}&pageId=${activePage.id}" 
                                   style="color:red; font-size:12px; float:right;" 
                                   onclick="return confirm('Delete Section?')">Delete Section</a>
                            </h3>
                            <p>${sec.content}</p>

                            <!-- IMAGES SEQUENCE -->
                            <h4>Sequenced Images</h4>
                            <div>
                                <c:forEach var="img" items="${sec.images}">
                                    <div class="img-card">
                                        <small>Order #${img.sequenceOrder}</small><br>
                                        
                                        <!-- Calls renderImage servlet action using the image primary key -->
                                        <img src="pages?action=renderImage&imageId=${img.id}" alt="${img.altText}">
                                        
                                        <small>${img.altText}</small><br>
                                        <a href="pages?action=deleteImage&imageId=${img.id}&pageId=${activePage.id}" style="color:red;">Delete</a>
                                    </div>
                                </c:forEach>
                            </div>

                            <!-- UPLOAD IMAGE FORM -->
                            <div class="form-block">
                                <form action="pages?action=uploadImage" method="post" enctype="multipart/form-data">
                                    <input type="hidden" name="pageId" value="${activePage.id}">
                                    <input type="hidden" name="sectionId" value="${sec.id}">
                                    
                                    Select Image: <input type="file" name="imageFile" accept="image/*" required>
                                    Alt Text: <input type="text" name="altText" placeholder="Description">
                                    Seq #: <input type="number" name="sequenceOrder" value="1" min="1" style="width:40px;" required>
                                    <button type="submit">Upload Image</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>

                <c:otherwise>
                    <h3>Select a page from the left sidebar to edit its dynamic sections and image sequences.</h3>
                </c:otherwise>
            </c:choose>
        </div>

    </div>

</body>
</html>