<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Sandur Residential School</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Merriweather:wght@300;400;700&family=Open+Sans:wght@300;400;600&display=swap" rel="stylesheet">

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
}

body{
    font-family:'Open Sans',sans-serif;
    background:#f7f5f2;
}

/* ================= TOP STRIP ================= */

.top-strip{
    width:100%;
    height:8px;
    background:#FA8405;
}

/* ================= HEADER ================= */

.top-header{
    background:white;
    padding:20px 6%;
    display:flex;
    justify-content:space-between;
    align-items:center;
    border-bottom:1px solid #ddd;
}

.logo-area{
    display:flex;
    align-items:center;
    gap:20px;
}

.logo-area img{
    width:90px;
}

.logo-area h1{
    font-family:'Merriweather',serif;
    font-size:38px;
    color:#5b2d0a;
}

.top-links{
    display:flex;
    gap:30px;
}

.top-links a{
    text-decoration:none;
    color:#5b2d0a;
    font-weight:600;
    font-size:15px;
}

/* ================= MOBILE MENU BUTTON ================= */

.menu-toggle{
    display:none;
    background:#f1efec;
    padding:16px 20px;
    font-size:24px;
    cursor:pointer;
    border-bottom:1px solid #ddd;
}

/* ================= NAVIGATION ================= */

nav{
    background:#f1efec;
    position:sticky;
    top:0;
    z-index:999;
    border-bottom:1px solid #ddd;
}

.main-menu{
    list-style:none;
    display:flex;
    justify-content:center;
}

.main-menu li{
    position:relative;
}

.main-menu li a{
    display:block;
    padding:22px 25px;
    text-decoration:none;
    color:#111;
    font-weight:700;
    font-size:17px;
    transition:0.3s;
}

.main-menu li:hover{
    background:#e6ddd3;
}

/* ================= DROPDOWN ================= */

.dropdown{
    display:none;
    position:absolute;
    top:100%;
    left:0;
    background:white;
    min-width:260px;
    list-style:none;
    box-shadow:0 5px 15px rgba(0,0,0,0.15);
}

.dropdown li{
    width:100%;
}

.dropdown li a{
    padding:15px 20px;
    border-bottom:1px solid #eee;
    color:#333;
    font-size:15px;
    font-weight:600;
}

.dropdown li a:hover{
    background:#d66f2d;
    color:white;
}

.main-menu li:hover .dropdown{
    display:block;
}

/* ================= MOBILE ================= */

@media(max-width:900px){

.top-header{
    flex-direction:column;
    gap:20px;
    text-align:center;
}

.logo-area{
    flex-direction:column;
}

.logo-area h1{
    font-size:28px;
}

.top-links{
    flex-wrap:wrap;
    justify-content:center;
    gap:15px;
}

/* MOBILE BUTTON */

.menu-toggle{
    display:block;
}

/* NAVIGATION */

nav{
    display:none;
    position:relative;
}

nav.active{
    display:block;
}

.main-menu{
    flex-direction:column;
    width:100%;
}

.main-menu li{
    width:100%;
    border-bottom:1px solid #ddd;
}

.main-menu li a{
    padding:18px 20px;
    font-size:16px;
}

/* DROPDOWN */

.dropdown{
    position:static;
    width:100%;
    box-shadow:none;
    background:#fafafa;
}

.main-menu li:hover .dropdown{
    display:none;
}

.main-menu li.active .dropdown{
    display:block;
}

.dropdown li a{
    padding-left:40px;
}

}

</style>

</head>

<body>

<!-- TOP STRIP -->

<div class="top-strip"></div>

<!-- ================= HEADER ================= -->

<header>

<div class="top-header">

    <div class="logo-area">

        <img src="${pageContext.request.contextPath}/Home/logo.png" alt="Logo">

        <h1>Sandur Residential School</h1>

    </div>

    <div class="top-links">

        <a href="#">Calendar</a>

        <a href="#">Quick Links</a>

        <a href="#">Portal Login</a>

        <a href="#">
            <i class="fa fa-search"></i>
        </a>

    </div>

</div>

<!-- MOBILE MENU BUTTON -->

<div class="menu-toggle">
    <i class="fa fa-bars"></i>
</div>

<!-- ================= NAVIGATION ================= -->

<nav>

<ul class="main-menu">

<!-- HOME -->

<li>
<a href="${pageContext.request.contextPath}/index.jsp">Home</a>
</li>

<!-- ABOUT -->

<li>

<a href="${pageContext.request.contextPath}/about.jsp">About</a>

<ul class="dropdown">

<li><a href="${pageContext.request.contextPath}/ABOUT/OurLegacy.jsp">Our Legacy</a></li>
<li><a href="${pageContext.request.contextPath}/ABOUT/LeadershipandGovernance.jsp">Leadership and Governance</a></li>
<li><a href="${pageContext.request.contextPath}/ABOUT/Mission.jsp">Mission</a></li>
<li><a href="${pageContext.request.contextPath}/ABOUT/Vision.jsp">Vision</a></li>
<li><a href="${pageContext.request.contextPath}/ABOUT/Infrastructure.jsp">Infrastructure</a></li>
<li><a href="${pageContext.request.contextPath}/ABOUT/Affiliations.jsp">Affiliations</a></li>
</ul>

</li>

<!-- ADMISSIONS -->

<li>

<a href="${pageContext.request.contextPath}/admissions.jsp">Admissions</a>

<ul class="dropdown">

<li><a href="${pageContext.request.contextPath}/apply.jsp">Enquire and visit</a></li>
<li><a href="${pageContext.request.contextPath}/fees.jsp">Admission process</a></li>
<li><a href="${pageContext.request.contextPath}/scholarships.jsp">Fees payment</a></li>
<li><a href="${pageContext.request.contextPath}/transport.jsp">Scholarship Programme</a></li>
<li><a href="${pageContext.request.contextPath}/transport.jsp">Admission FAQ</a></li>

</ul>

</li>

<!-- LEARNING -->

<li>

<a href="${pageContext.request.contextPath}/learning.jsp">Learning</a>

<ul class="dropdown">

<li><a href="${pageContext.request.contextPath}/academics.jsp">Curriculum</a></li>
<li><a href="${pageContext.request.contextPath}/library.jsp">Nursery</a></li>
<li><a href="${pageContext.request.contextPath}/labs.jsp">Primary school</a></li>
<li><a href="${pageContext.request.contextPath}/exams.jsp">Middle school</a></li>
<li><a href="${pageContext.request.contextPath}/exams.jsp">High school</a></li>
<li><a href="${pageContext.request.contextPath}/exams.jsp">Term dates and school hours</a></li>

</ul>

</li>

<!-- STUDENT LIFE -->

<li>

<a href="${pageContext.request.contextPath}/studentlife.jsp">Student Life</a>

<ul class="dropdown">

<li><a href="${pageContext.request.contextPath}/sports.jsp">Boarding</a></li>
<li><a href="${pageContext.request.contextPath}/hostel.jsp">Sports</a></li>
<li><a href="${pageContext.request.contextPath}/activities.jsp">Library</a></li>
<li><a href="${pageContext.request.contextPath}/clubs.jsp">Co-curricular activities</a></li>
<li><a href="${pageContext.request.contextPath}/clubs.jsp">Counselling</a></li>
<li><a href="${pageContext.request.contextPath}/clubs.jsp">Calendar</a></li>

</ul>

</li>

<!-- ENGAGE -->

<li>

<a href="${pageContext.request.contextPath}/engage.jsp">Engage</a>

<ul class="dropdown">

<li><a href="${pageContext.request.contextPath}/events.jsp">Engage</a></li>
<li><a href="${pageContext.request.contextPath}/parents.jsp">Community</a></li>
<li><a href="${pageContext.request.contextPath}/community.jsp">Environment</a></li>
<li><a href="${pageContext.request.contextPath}/community.jsp">Research</a></li>
<li><a href="${pageContext.request.contextPath}/community.jsp">Flora</a></li>
<li><a href="${pageContext.request.contextPath}/community.jsp">Fauna</a></li>

</ul>

</li>

<!-- EXPLORE -->

<li>

<a href="${pageContext.request.contextPath}/explore.jsp">Explore SRS</a>

<ul class="dropdown">

<li><a href="${pageContext.request.contextPath}/gallery.jsp">Publications</a></li>
<li><a href="${pageContext.request.contextPath}/achievements.jsp">Alumni</a></li>
<li><a href="${pageContext.request.contextPath}/virtualtour.jsp">Roll Of Honour</a></li>
<li><a href="${pageContext.request.contextPath}/news.jsp">Current job openings</a></li>
<li><a href="${pageContext.request.contextPath}/news.jsp">Teacher training</a></li>

</ul>

</li>

<!-- CONTACT -->

<li>

<a href="${pageContext.request.contextPath}/contact.jsp">Contact Us</a>

<ul class="dropdown">

<li><a href="${pageContext.request.contextPath}/contactdetails.jsp">Mail us here</a></li>
<li><a href="${pageContext.request.contextPath}/map.jsp">How to get here</a></li>

</ul>

</li>

</ul>

</nav>

</header>

<!-- ================= JAVASCRIPT ================= -->

<script>

/* MOBILE MENU */

const menuToggle = document.querySelector(".menu-toggle");
const nav = document.querySelector("nav");

menuToggle.addEventListener("click", () => {
    nav.classList.toggle("active");
});

/* MOBILE DROPDOWN */

document.querySelectorAll(".main-menu > li").forEach(item => {

    item.addEventListener("click", function(e){

        if(window.innerWidth <= 900){

            const dropdown = this.querySelector(".dropdown");

            if(dropdown){

                e.preventDefault();

                this.classList.toggle("active");
            }

        }

    });

});

</script>

</body>
</html>