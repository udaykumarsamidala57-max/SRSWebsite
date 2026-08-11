<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    isELIgnored="false" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Raw Image Load Test</title>
</head>

<body>

<h1>Servlet Image Diagnostic Page</h1>

<p>
    Page Loaded:
    <strong>
        <c:out value="${pageData.title}" default="Page Data Not Found" />
    </strong>
    (Slug:
    <code><c:out value="${pageData.slug}" /></code>,
    ID:
    <code><c:out value="${pageData.id}" /></code>)
</p>

<hr>

<!-- ========================================================= -->
<!-- SECTION 1: DIRECT IMAGE STREAM TEST -->
<!-- ========================================================= -->

<h2>1. Direct ImageStreamServlet Test</h2>

<p>
    Testing direct fetch using
    <code>/imageStream?id=1</code>:
</p>

<div>

    <img
        src="${pageContext.request.contextPath}/imageStream?id=1"
        alt="Test Image ID 1"
        width="200"
        onload="
            document.getElementById('status-1').innerText='LOADED OK';
            document.getElementById('status-1').style.color='green';
        "
        onerror="
            document.getElementById('status-1').innerText='FAILED (Check DB or Servlet Log)';
            document.getElementById('status-1').style.color='red';
        "
    >

    <br>

    Status:
    <span id="status-1">Testing...</span>

</div>

<hr>

<!-- ========================================================= -->
<!-- SECTION 2: DYNAMIC SECTION IMAGES -->
<!-- ========================================================= -->

<h2>
    2. Dynamic Images from PageBean
    (
    <c:out value="${pageData.sections.size()}" default="0" />
    Sections Found
    )
</h2>

<c:choose>

    <c:when test="${not empty pageData and not empty pageData.sections}">

        <c:forEach
            var="sec"
            items="${pageData.sections}"
            varStatus="secLoop">

            <div style="margin-bottom:20px;">

                <h3>
                    Section #${secLoop.index + 1}:
                    <c:out value="${sec.title}" />
                    (Type:
                    <code>
                        <c:out value="${sec.sectionType}" />
                    </code>)
                </h3>

                <p>
                    Total Images linked to Section ID
                    <strong>
                        <c:out value="${sec.id}" />
                    </strong>:

                    <strong>
                        <c:out value="${sec.images.size()}" default="0" />
                    </strong>
                </p>

                <c:choose>

                    <c:when test="${not empty sec.images}">

                        <div style="
                            display:flex;
                            gap:15px;
                            flex-wrap:wrap;
                        ">

                            <c:forEach
                                var="img"
                                items="${sec.images}">

                                <div style="
                                    border:1px dashed #666;
                                    padding:10px;
                                ">

                                    <p>
                                        <strong>Image ID:</strong>
                                        <c:out value="${img.id}" />
                                        <br>

                                        <strong>Type:</strong>
                                        <c:out value="${img.imageType}" />
                                        <br>

                                        <strong>Alt:</strong>
                                        <c:out value="${img.altText}" />
                                    </p>

                                    <img
                                        src="${pageContext.request.contextPath}/imageStream?id=${img.id}"
                                        alt="<c:out value='${img.altText}' />"
                                        width="250"
                                        onload="
                                            this.nextElementSibling.innerText='LOAD SUCCESS';
                                            this.nextElementSibling.style.color='green';
                                        "
                                        onerror="
                                            this.nextElementSibling.innerText='LOAD FAILED';
                                            this.nextElementSibling.style.color='red';
                                        "
                                    >

                                    <div style="
                                        font-weight:bold;
                                        margin-top:5px;
                                    ">
                                        Testing stream...
                                    </div>

                                </div>

                            </c:forEach>

                        </div>

                    </c:when>

                    <c:otherwise>

                        <p style="color:orange;">
                            No images found in
                            <code>section_images</code>
                            for this section ID.
                        </p>

                    </c:otherwise>

                </c:choose>

            </div>

        </c:forEach>

    </c:when>

    <c:otherwise>

        <p style="
            color:red;
            font-weight:bold;
        ">
            No sections found in pageData.
            Verify 'pages' table entry with slug='home'.
        </p>

    </c:otherwise>

</c:choose>

<hr>

<!-- ========================================================= -->
<!-- SECTION 3: NEWS IMAGES -->
<!-- ========================================================= -->

<h2>3. News Section Images</h2>

<c:choose>

    <c:when test="${not empty newsList}">

        <div style="
            display:flex;
            gap:15px;
            flex-wrap:wrap;
        ">

            <c:forEach
                var="news"
                items="${newsList}">

                <div style="
                    border:1px solid #ccc;
                    padding:10px;
                    width:200px;
                ">

                    <h4>
                        <c:out value="${news.title}" />
                    </h4>

                    <p>
                        Path:
                        <code>
                            <c:out value="${news.image}" />
                        </code>
                    </p>

                    <img
                        src="${pageContext.request.contextPath}/uploads/${news.image}"
                        alt="News Image"
                        width="180"
                        onload="
                            this.nextElementSibling.innerText='OK';
                            this.nextElementSibling.style.color='green';
                        "
                        onerror="
                            this.nextElementSibling.innerText='IMAGE NOT FOUND IN /uploads/';
                            this.nextElementSibling.style.color='red';
                        "
                    >

                    <div>Testing...</div>

                </div>

            </c:forEach>

        </div>

    </c:when>

    <c:otherwise>

        <p>
            No news items fetched from DB.
        </p>

    </c:otherwise>

</c:choose>

</body>
</html>