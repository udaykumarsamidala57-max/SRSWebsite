<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Sandur Residential School</title>

<style>
/* ----- Global ----- */
body { margin: 0; font-family: Arial, sans-serif; background: #f4f4f4; }

/* ----- Header ----- */
.header { display: flex; align-items: center; flex-wrap: wrap; background-color: white; padding: 20px; gap: 20px; }
.header img { height: 120px; width: auto; }
.header h1 { font-size: 2rem; color: #753906; margin: 0; font-weight: bold; text-align: center; }

/* ----- NAVBAR (Updated) ----- */
.navbar { background-color: #F2F2F2; text-align: center; }
.navbar ul { margin: 0; padding: 0; list-style: none; display: flex; flex-wrap: wrap; justify-content: center; }
.navbar li { position: relative; }

.navbar > ul > li > a {
    display: block;
    color: black;
    text-decoration: none;
    padding: 18px 25px;
    transition: all 0.3s ease;
    font-size: 1.2rem;
}

.navbar > ul > li > a:hover {
    background-color: #753906;
    color: white;
}

/* ----- UPDATED DROPDOWN ----- */
.navbar li ul {
    display: none;
    position: absolute;
    left: 0;
    top: 58px;

    /* Updated color */
    background-color: #753906;

    min-width: 180px;
    z-index: 999;
    list-style: none;
    padding: 0;
    margin: 0;
    border-radius: 0 0 6px 6px;
}

.navbar li:hover > ul { display: block; }

.navbar li ul li a {
    display: block;
    padding: 12px 18px;
    color: white;
    text-decoration: none;
    white-space: nowrap;
    font-size: 1rem;

    /* Better alignment */
    text-align: left;
}

.navbar li ul li a:hover {
    background-color: #5e2d04; /* darker shade */
}

/* ----- Slideshow ----- */
.slideshow-container { position: relative; width: 100%; height: 80vh; overflow: hidden; }
.slide { display: none; width: 100%; height: 100%; }
.slide img { width: 100%; height: 100%; object-fit: cover; }
.fade { animation: fadeEffect 1s ease-in-out; }
@keyframes fadeEffect { from {opacity: 0.4;} to {opacity: 1;} }

/* ----- Director Section ----- */
.director-section { display: flex; flex-wrap: wrap; align-items: stretch; background-color: #e66d26; padding: 0; }
.director-content { display: flex; flex-wrap: wrap; align-items: center; justify-content: center; background-color: #fff; width: 100%; }
.director-video { flex: 1; min-width: 350px; display: flex; justify-content: flex-start; align-items: center; background-color: #e66d26; padding: 40px 0 40px 60px; }
.director-video video { width: 80%; height: auto; border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.3); }
.director-text { flex: 1; min-width: 350px; background-color: #fff; padding: 60px 80px; }
.director-text h2 { font-size: 1.8rem; color: #753906; font-weight: bold; margin-bottom: 15px; }
.director-text h3 { font-size: 2rem; color: #4b2000; margin-bottom: 20px; line-height: 1.3; }
.director-text p { font-size: 1.05rem; line-height: 1.7; color: #333; margin-bottom: 15px; }

/* ----- News & Events Section ----- */
.news-events-section { background: #fff; padding: 60px 0; text-align: center; }
.news-events-section h2 { color: #4b2000; font-size: 2rem; margin-bottom: 10px; }
.news-events-section p { color: #444; margin-bottom: 30px; }
.news-events-container { display: flex; flex-wrap: wrap; justify-content: center; gap: 40px; width: 80%; margin: 0 auto; }

.news-box, .events-box { flex: 1; min-width: 350px; border: 2px solid #e66d26; padding: 25px; border-radius: 4px; text-align: left; }
.news-box h3, .events-box h3 { color: #753906; margin-bottom: 15px; font-weight: bold; }
.news-item { display: flex; align-items: flex-start; gap: 15px; margin-bottom: 25px; border-bottom: 1px solid #ddd; padding-bottom: 15px; }
.news-item img { width: 140px; height: 90px; object-fit: cover; border-radius: 4px; }
.news-item h4 { margin: 0; color: #000; font-size: 1.1rem; font-weight: bold; }
.news-item p { margin: 6px 0; color: #555; font-size: 0.95rem; }
.news-item a { color: #753906; font-weight: bold; text-decoration: none; }
.news-item a:hover { text-decoration: underline; }

.event-item { display: flex; align-items: center; gap: 20px; margin-bottom: 20px; }
.event-date { width: 70px; height: 70px; border: 2px solid #753906; border-radius: 50%; display: flex; flex-direction: column; align-items: center; justify-content: center; color: #753906; font-weight: bold; }
.event-date span:first-child { font-size: 0.8rem; }
.event-date span:last-child { font-size: 1.5rem; }
.event-item h4 { color: #000; font-weight: bold; margin: 0; }
.event-item p { color: #555; margin: 3px 0; }

/* ----- DISTINCTLY SRS (Size Increased 20%) ----- */
.distinctly-section { position: relative; background-color: white; padding: 60px 0; overflow: hidden; }
.distinctly-section::after { content: ""; position: absolute; bottom: 0; right: 0; width: 60%; height: 45%; background-color: #D76A28; z-index: 0; }
.distinctly-container { position: relative; z-index: 2; width: 78%; margin: 0 auto; } /* increased 20% from 65% → 78% */

.distinctly-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 30px; /* slightly increased for spacing */
}

/* Grid Box */
.grid-box { position: relative; width: 100%; aspect-ratio: 1 / 1; background: #fff; border-radius: 6px; overflow: hidden; box-shadow: 0 3px 8px rgba(0,0,0,0.1); transition: transform 0.4s ease; }
.grid-box:hover { transform: scale(1.03); }
.distinctly-text { display: flex; flex-direction: column; justify-content: center; align-items: flex-start; padding: 25px; background: #fff; }
.distinctly-text h2 { color: #753906; font-size: 1.8rem; margin-bottom: 12px; }
.distinctly-text p { color: #444; line-height: 1.6; }
.grid-item img { width: 100%; height: 100%; object-fit: cover; display: block; }
.grid-caption { position: absolute; bottom: 0; left: 0; right: 0; padding: 18px 22px; background: linear-gradient(to top, rgba(0,0,0,0.7), transparent); color: #fff; font-weight: bold; font-size: 1.3rem; text-align: left; z-index: 2; border-bottom-left-radius: 6px; border-bottom-right-radius: 6px; }
.hover-text { position: absolute; inset: 0; background: rgba(0,0,0,0.65); color: #fff; opacity: 0; display: flex; flex-direction: column; justify-content: center; align-items: flex-start; padding: 30px 25px; text-align: left; transition: opacity 0.4s ease; z-index: 3; }
.hover-text h4 { font-size: 1.6rem; margin-bottom: 12px; }
.hover-text p { font-size: 1rem; line-height: 1.6; }
.grid-item:hover .hover-text { opacity: 1; }

/* Footer */
footer { background-color: #333; color: white; text-align: center; padding: 15px 0; }

/* Responsive */
@media (max-width: 992px) { .distinctly-grid { grid-template-columns: repeat(2, 1fr); } }
@media (max-width: 900px) { .director-content { flex-direction: column; } .director-text { padding: 40px 30px; } .director-video { padding: 30px; justify-content: center; } .director-video video { width: 90%; } }
@media (max-width: 600px) { .distinctly-grid { grid-template-columns: 1fr; } .slideshow-container { height: 50vh; } .header { flex-direction: column; text-align: center; } }
</style>
</head>

<body>

<!-- Header -->
<div class="header">
    <img src="Home/logo.png" alt="School Logo">
    <h1>Sandur Residential School</h1>
</div>

<!-- NAVBAR updated -->
<div class="navbar">
    <ul>
        <li><a href="#">Home</a></li>

        <li><a href="#">About ▾</a>
            <ul>
                <li><a href="#">Our Mission</a></li>
                <li><a href="#">Team</a></li>
                <li><a href="#">History</a></li>
            </ul>
        </li>

        <li><a href="#">Admissions ▾</a>
            <ul>
                <li><a href="#">Web Design</a></li>
                <li><a href="#">Development</a></li>
                <li><a href="#">Hosting</a></li>
            </ul>
        </li>

        <li><a href="#">Learning</a></li>
        <li><a href="#">Student Life</a></li>
        <li><a href="#">Engage</a></li>
        <li><a href="#">Explore SRS</a></li>
        <li><a href="#">Contact US</a></li>
    </ul>
</div>

<!-- Slideshow -->
<div class="slideshow-container">
    <div class="slide fade"><img src="Home/1.jpg" alt="Slide 1"></div>
    <div class="slide fade"><img src="Home/2.jpg" alt="Slide 2"></div>
    <div class="slide fade"><img src="Home/3.jpg" alt="Slide 3"></div>
</div>

<!-- Director Section -->
<section class="director-section">
    <div class="director-content">
        <div class="director-video">
            <video width="100%" height="auto" controls autoplay muted loop>
                <source src="Home/MD.mp4" type="video/mp4">
                Your browser does not support the video tag.
            </video>
        </div>
        <div class="director-text">
            <h2>From the Director’s Desk</h2>
            <h3>Welcome to Sandur Residential School</h3>
            <p>Sandur Residential School is proud to present itself spanning over 60 years since its inception in 1959.</p>
            <p>We provide stimulating, engaging academics integrated with enhanced opportunities in sports, literature, community service, environment, and arts.</p>
            <p>As you visit our campus and website, you will see that our learning community is dedicated to the development of knowledgeable, caring, confident, and responsible global citizens. Every child here is cared for and valued.</p>
            <p>We are an ICSE co-educational day-scholar and boarding school for classes from nursery to 10th standard.</p>
        </div>
    </div>
</section>

<!-- News & Events Section -->
<section class="news-events-section">
    <h2>News & Events</h2>
    <p>Campus is always buzzing! Click below to stay up-to-date on our school to see all of the news & announcements and school calendar.</p>

    <div class="news-events-container">
        
        <!-- News -->
        <div class="news-box">
            <h3>LATEST NEWS</h3>
            <c:forEach var="news" items="${newsList}">
                <div class="news-item">
                    <img src="uploads/${news.image}" alt="${news.title}">
                    <div>
                        <h4>${news.title}</h4>
                        <p>${fn:substring(news.description,0,100)}...</p>
                        <a href="${news.link}" target="_blank">Read More →</a>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Events -->
        <div class="events-box">
            <h3>UPCOMING EVENTS</h3>
            <c:forEach var="event" items="${eventList}">
                <div class="event-item">
                    <div class="event-date">
                        <span><fmt:formatDate value="${event.event_date}" pattern="MMM" /></span>
                        <span><fmt:formatDate value="${event.event_date}" pattern="dd" /></span>
                    </div>
                    <div>
                        <h4>${event.title} <span style="color:#e66d26;">&#128276;</span></h4>
                        <p>${event.description}</p>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</section>

<!-- Distinctly SRS -->
<section class="distinctly-section">
    <div class="distinctly-container">
        <div class="distinctly-grid">

            <div class="grid-box distinctly-text">
                <h2>Distinctly SRS</h2>
                <p>
                    Discover our school by navigating through our posts, blogs and news. 


                </p>
            </div>

            <div class="grid-box grid-item">
                <img src="Home/campuslife.jpg" alt="Campus Life">
                <div class="hover-text">
                    <h4>Campus Life</h4>
                    <p>We have a sprawling campus spread over 75 acres, we often teach under the shade of a tree, we are frequented by various birds species and there is plenty to learn from the rich flora around.

<br>We also encourage debates, clubs, community activities of Environmental matters</p>
                </div>
                <div class="grid-caption">Campus Life</div>
            </div>

            <div class="grid-box grid-item">
                <img src="Home/overall.jpg" alt="Overall Development">
                <div class="hover-text">
                    <h4>Overall Development</h4>
                    <p>To instill a strong over all development of a student, we give equal importance to academics, sports, arts, literature, and culture.</p>
                </div>
                <div class="grid-caption">Overall Development</div>
            </div>

            <div class="grid-box grid-item">
                <img src="Home/quickfacts.jpg" alt="Quick Facts">
                <div class="hover-text">
                    <h4>Quick Facts</h4>
                    <p>
                    We provide ICSE curriculum. <br>

We are a Co-educational school.<br>

We have a combination of day-scholars and boarders.<br>

We have 1700 students in our school.<br>

We have a sprawling campus of 25 acres.<br>

Boarding facility is for both boys and girls.<br>
                    
                    </p>
                </div>
                <div class="grid-caption">Quick Facts</div>
            </div>

            <div class="grid-box grid-item">
                <img src="Home/legacy.jpg" alt="Explore our legacy">
                <div class="hover-text">
                    <h4>Explore Our Legacy</h4>
                    <p>Look into the section of 'Our Legacy' and 'History of our school' to read about our story from 1959.

</p>
                </div>
                <div class="grid-caption">Explore Our Legacy</div>
            </div>

            <div class="grid-box grid-item">
                <img src="Home/engage.jpg" alt="Engage">
                <div class="hover-text">
                    <h4>Engage</h4>
                    <p>With a sprawling campus and a rich ecosystem within the space, we inculcate a sense of discovery and inquisitiveness  among our children about nature. We provide them with the learning tools, talks and experiments are conducted by researchers, naturalists and scientists who visit our campus.   

</p>
                </div>
                <div class="grid-caption">Engage</div>
            </div>

        </div>
    </div>
</section>

<!-- Footer -->
<footer>
    <p>© 2025 Sandur Residential School | Designed by Uday Kumar</p>
</footer>

<script>
let slideIndex = 0;
showSlides();

function showSlides() {
    const slides = document.getElementsByClassName("slide");
    for (let i = 0; i < slides.length; i++) slides[i].style.display = "none";
    slideIndex++;
    if (slideIndex > slides.length) slideIndex = 1;
    slides[slideIndex-1].style.display = "block";
    slides[slideIndex-1].classList.add("fade");
    setTimeout(showSlides, 3000);
}
</script>

</body>
</html>
