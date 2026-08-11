<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    isELIgnored="false" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Raw Image Load Test</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            background-color: #f7f5f2;
        }

        .diagnostic-container {
            padding: 20px;
        }

        /* ========================================== */
        /* FULL SCREEN HERO SLIDESHOW STYLES          */
        /* ========================================== */
        .hero-fullscreen-container {
            position: relative;
            width: 100vw;
            height: 100vh;
            overflow: hidden;
            background-color: #000;
        }

        .hero-slide {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            opacity: 0;
            transition: opacity 1s ease-in-out;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .hero-slide.active {
            opacity: 1;
            z-index: 1;
        }

        /* Fullscreen Image Cover */
        .hero-slide img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            object-position: center;
        }

        /* Overlay text for diagnostic image status */
        .hero-slide-info {
            position: absolute;
            bottom: 60px;
            left: 30px;
            z-index: 2;
            color: #fff;
            background: rgba(0, 0, 0, 0.6);
            padding: 15px 20px;
            border-radius: 8px;
            backdrop-filter: blur(4px);
        }

        /* Navigation Arrows */
        .hero-nav {
            position: absolute;
            top: 50%;
            width: 100%;
            display: flex;
            justify-content: space-between;
            transform: translateY(-50%);
            z-index: 10;
            pointer-events: none;
        }

        .hero-nav button {
            pointer-events: auto;
            background: rgba(0, 0, 0, 0.4);
            color: white;
            border: none;
            padding: 20px 15px;
            cursor: pointer;
            font-size: 24px;
            transition: background 0.3s;
        }

        .hero-nav button:hover {
            background: rgba(0, 0, 0, 0.8);
        }

        /* Pagination Dots */
        .hero-dots {
            position: absolute;
            bottom: 20px;
            width: 100%;
            text-align: center;
            z-index: 10;
        }

        .dot {
            height: 14px;
            width: 14px;
            margin: 0 6px;
            background-color: rgba(255, 255, 255, 0.5);
            border-radius: 50%;
            display: inline-block;
            cursor: pointer;
            transition: background-color 0.3s, transform 0.3s;
        }

        .dot.active, .dot:hover {
            background-color: #ffffff;
            transform: scale(1.2);
        }

        /* ========================================== */
        /* DISTINCT / DISTRICT SECTION STYLES         */
        /* ========================================== */
        .distinct-section-wrapper {
            max-width: 1200px;
            margin: 60px auto;
            padding: 0 20px;
            position: relative;
        }

        /* Orange Accent Block in Background */
        .distinct-accent-bg {
            position: absolute;
            bottom: -30px;
            right: 0;
            width: 60%;
            height: 60%;
            background-color: #e06d38;
            z-index: 1;
        }

        .distinct-grid {
            position: relative;
            z-index: 2;
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }

        .distinct-header-card {
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 20px;
        }

        .distinct-header-card h2 {
            font-family: 'Merriweather', serif;
            font-size: 36px;
            color: #5b2d0a;
            margin-bottom: 15px;
        }

        .distinct-header-card p {
            color: #555;
            line-height: 1.6;
            font-size: 16px;
        }

        .distinct-img-card {
            position: relative;
            aspect-ratio: 1 / 1;
            overflow: hidden;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.15);
            background: #222;
            cursor: pointer;
        }

        .distinct-img-card img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
            transition: transform 0.4s ease;
        }

        .distinct-img-card:hover img {
            transform: scale(1.08);
        }

        /* Overlay hidden by default, revealed on hover */
        .distinct-img-overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(to top, rgba(0, 0, 0, 0.85) 0%, rgba(0, 0, 0, 0.3) 50%, rgba(0, 0, 0, 0) 100%);
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            padding: 20px;
            color: #fff;
            opacity: 0;
            transition: opacity 0.3s ease-in-out;
        }

        .distinct-img-card:hover .distinct-img-overlay {
            opacity: 1;
        }

        .distinct-img-overlay h3 {
            margin: 0;
            font-family: Calibri, Arial, sans-serif;
            font-size: 16px;
            font-weight: 700;
            line-height: 1.4; /* Adds clean spacing when text wraps to 2 lines */
            letter-spacing: 0.3px;
            text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.9);
            transform: translateY(10px);
            transition: transform 0.3s ease-in-out;
            word-wrap: break-word;
        }

        .distinct-img-card:hover .distinct-img-overlay h3 {
            transform: translateY(0);
        }

        @media (max-width: 900px) {
            .distinct-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            .distinct-header-card {
                grid-column: span 2;
            }
            .distinct-accent-bg {
                width: 100%;
            }
        }

        @media (max-width: 600px) {
            .distinct-grid {
                grid-template-columns: 1fr;
            }
            .distinct-header-card {
                grid-column: span 1;
            }
        }
    </style>
</head>

<body>

<%@ include file="Header.jsp" %>

<c:choose>

    <c:when test="${not empty pageData and not empty pageData.sections}">

        <c:forEach
            var="sec"
            items="${pageData.sections}"
            varStatus="secLoop">

            <c:choose>

                <%-- HERO SECTION: FULLSCREEN AUTOMATIC SLIDESHOW --%>
                <c:when test="${fn:toLowerCase(sec.sectionType) eq 'hero'}">

                    <div id="slideshow-${secLoop.index}" class="hero-fullscreen-container" data-autoplay="true" data-interval="4000">

                        <c:choose>

                            <c:when test="${not empty sec.images}">

                                <c:forEach var="img" items="${sec.images}" varStatus="imgLoop">

                                    <div class="hero-slide ${imgLoop.first ? 'active' : ''}">
                                        
                                        <img
                                            src="${pageContext.request.contextPath}/imageStream?id=${img.id}"
                                            alt="${img.altText}"
                                            onload="
                                                this.nextElementSibling.querySelector('.status').innerText='LOAD SUCCESS';
                                                this.nextElementSibling.querySelector('.status').style.color='#4EAE4E';
                                            "
                                            onerror="
                                                this.nextElementSibling.querySelector('.status').innerText='LOAD FAILED';
                                                this.nextElementSibling.querySelector('.status').style.color='#FF4D4D';
                                            "
                                        >

                                        <div class="hero-slide-info">
                                            <h3 style="margin:0 0 5px 0;"><c:out value="${sec.title}" /></h3>
                                            <p style="margin:0 0 5px 0;">
                                                <strong>Image ID:</strong> <c:out value="${img.id}" /> | 
                                                <strong>Alt:</strong> <c:out value="${img.altText}" />
                                            </p>
                                            <div class="status" style="font-weight:bold;">Testing stream...</div>
                                        </div>

                                    </div>

                                </c:forEach>

                                <!-- Navigation Arrows -->
                                <c:if test="${sec.images.size() > 1}">
                                    <div class="hero-nav">
                                        <button type="button" onclick="manualChangeSlide('slideshow-${secLoop.index}', -1)">&#10094;</button>
                                        <button type="button" onclick="manualChangeSlide('slideshow-${secLoop.index}', 1)">&#10095;</button>
                                    </div>

                                    <!-- Dots -->
                                    <div class="hero-dots">
                                        <c:forEach var="img" items="${sec.images}" varStatus="imgLoop">
                                            <span class="dot ${imgLoop.first ? 'active' : ''}" onclick="manualGoToSlide('slideshow-${secLoop.index}', ${imgLoop.index})"></span>
                                        </c:forEach>
                                    </div>
                                </c:if>

                            </c:when>

                            <c:otherwise>
                                <div style="color:white; text-align:center; padding-top:20vh;">
                                    <h3>Section: <c:out value="${sec.title}" /></h3>
                                    <p style="color:orange;">No images found in <code>section_images</code> for this Hero section ID.</p>
                                </div>
                            </c:otherwise>

                        </c:choose>

                    </div>

                </c:when>

                <%-- DISTINCT / DISTRICT SECTION: GRID WITH HOVER ALT TEXT & ACCENT BG --%>
                <c:when test="${fn:toLowerCase(sec.sectionType) eq 'distinct' or fn:toLowerCase(sec.sectionType) eq 'district'}">

                    <div class="distinct-section-wrapper">
                        
                        <!-- Background Accent Box -->
                        <div class="distinct-accent-bg"></div>

                        <div class="distinct-grid">

                            <!-- Top Left Text / Title Block -->
                            <div class="distinct-header-card">
                                <h2><c:out value="${sec.title}" default="Distinctly SRS" /></h2>
                                <p>Discover our school by navigating through our posts, blogs and news.</p>
                            </div>

                            <!-- Dynamic Image Grid (Hover shows altText from DB) -->
                            <c:choose>
                                <c:when test="${not empty sec.images}">
                                    <c:forEach var="img" items="${sec.images}">
                                        <div class="distinct-img-card">
                                            <img
                                                src="${pageContext.request.contextPath}/imageStream?id=${img.id}"
                                                alt="${img.altText}"
                                            >
                                            <div class="distinct-img-overlay">
                                                <h3>
                                                    <c:choose>
                                                        <c:when test="${not empty img.altText}">
                                                            <c:out value="${img.altText}" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:out value="${img.imageType}" default="Explore" />
                                                        </c:otherwise>
                                                    </c:choose>
                                                </h3>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="distinct-img-card" style="grid-column: span 2; display:flex; align-items:center; justify-content:center; color:#fff;">
                                        <p style="padding: 20px;">No images available for this section.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                        </div>

                    </div>

                </c:when>

                <%-- STANDARD SECTION: GRID DISPLAY --%>
                <c:otherwise>

                    <div class="diagnostic-container" style="margin-bottom:30px;">

                        <h3>
                            Section #${secLoop.index + 1}:
                            <c:out value="${sec.title}" />
                            (Type: <code><c:out value="${sec.sectionType}" /></code>)
                        </h3>

                        <p>
                            Total Images linked to Section ID <strong><c:out value="${sec.id}" /></strong>:
                            <strong><c:out value="${sec.images.size()}" default="0" /></strong>
                        </p>

                        <c:choose>
                            <c:when test="${not empty sec.images}">
                                <div style="display:flex; gap:15px; flex-wrap:wrap;">
                                    <c:forEach var="img" items="${sec.images}">
                                        <div style="border:1px dashed #666; padding:10px;">
                                            <p>
                                                <strong>Image ID:</strong> <c:out value="${img.id}" /><br>
                                                <strong>Type:</strong> <c:out value="${img.imageType}" /><br>
                                                <strong>Alt:</strong> <c:out value="${img.altText}" />
                                            </p>
                                            <img
                                                src="${pageContext.request.contextPath}/imageStream?id=${img.id}"
                                                alt="${img.altText}"
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
                                            <div style="font-weight:bold; margin-top:5px;">Testing stream...</div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <p style="color:orange;">
                                    No images found in <code>section_images</code> for this section ID.
                                </p>
                            </c:otherwise>
                        </c:choose>

                    </div>

                </c:otherwise>

            </c:choose>

        </c:forEach>

    </c:when>

    <c:otherwise>

        <div class="diagnostic-container">
            <p style="color:red; font-weight:bold;">
                No sections found in pageData. Verify 'pages' table entry with slug='home'.
            </p>
        </div>

    </c:otherwise>

</c:choose>

<hr>

<!-- SECTION 3: NEWS IMAGES -->
<div class="diagnostic-container">
    <h2>3. News Section Images</h2>

    <c:choose>

        <c:when test="${not empty newsList}">

            <div style="display:flex; gap:15px; flex-wrap:wrap;">

                <c:forEach var="news" items="${newsList}">

                    <div style="border:1px solid #ccc; padding:10px; width:200px;">

                        <h4><c:out value="${news.title}" /></h4>

                        <p>Path: <code><c:out value="${news.image}" /></code></p>

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

            <p>No news items fetched from DB.</p>

        </c:otherwise>

    </c:choose>
</div>

<!-- AUTOMATIC SLIDESHOW SCRIPT -->
<script>
    const autoPlayTimers = {};

    function showSlide(container, index) {
        const slides = container.querySelectorAll('.hero-slide');
        const dots = container.querySelectorAll('.dot');
        
        if (slides.length === 0) return;

        slides.forEach((slide, i) => {
            slide.classList.toggle('active', i === index);
        });

        dots.forEach((dot, i) => {
            dot.classList.toggle('active', i === index);
        });
    }

    function nextSlide(containerId) {
        const container = document.getElementById(containerId);
        const slides = container.querySelectorAll('.hero-slide');
        let currentIndex = -1;

        slides.forEach((slide, index) => {
            if (slide.classList.contains('active')) {
                currentIndex = index;
            }
        });

        let newIndex = (currentIndex + 1) % slides.length;
        showSlide(container, newIndex);
    }

    function manualChangeSlide(containerId, step) {
        const container = document.getElementById(containerId);
        const slides = container.querySelectorAll('.hero-slide');
        let currentIndex = -1;

        slides.forEach((slide, index) => {
            if (slide.classList.contains('active')) {
                currentIndex = index;
            }
        });

        let newIndex = currentIndex + step;
        if (newIndex >= slides.length) newIndex = 0;
        if (newIndex < 0) newIndex = slides.length - 1;

        showSlide(container, newIndex);
        resetAutoplay(containerId);
    }

    function manualGoToSlide(containerId, index) {
        const container = document.getElementById(containerId);
        showSlide(container, index);
        resetAutoplay(containerId);
    }

    function startAutoplay(containerId, interval) {
        autoPlayTimers[containerId] = setInterval(() => {
            nextSlide(containerId);
        }, interval);
    }

    function resetAutoplay(containerId) {
        const container = document.getElementById(containerId);
        const interval = parseInt(container.getAttribute('data-interval')) || 4000;
        
        if (autoPlayTimers[containerId]) {
            clearInterval(autoPlayTimers[containerId]);
        }
        startAutoplay(containerId, interval);
    }

    // Initialize Autoplay on page load
    document.addEventListener("DOMContentLoaded", () => {
        document.querySelectorAll('.hero-fullscreen-container[data-autoplay="true"]').forEach(container => {
            const interval = parseInt(container.getAttribute('data-interval')) || 4000;
            startAutoplay(container.id, interval);
        });
    });
</script>

</body>
</html>