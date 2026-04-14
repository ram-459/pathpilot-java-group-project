<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>All Career Paths - PathPilot</title>

<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Poppins:wght@500;600;700;800&display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet"/>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

<script src="https://cdn.tailwindcss.com?plugins=forms"></script>

<script>
    tailwind.config = {
        theme: {
            extend: {
                colors: { 
                    'primary': '#4913ec',
                    'primary-dark': '#3a0fb5'
                },
                fontFamily: { 
                    'sans': ['Plus Jakarta Sans', 'sans-serif'], 
                    'heading': ['Poppins', 'sans-serif'] 
                }
            }
        }
    }
</script>

<style type="text/tailwindcss">
    body { font-family: 'Plus Jakarta Sans', sans-serif; }
    h1, h2, h3 { font-family: 'Poppins', sans-serif; }
    .path-card:hover { transform: translateY(-5px); }
    /* Smooth transition for filtering */
    .path-card { transition: all 0.3s ease-in-out; }
</style>
</head>

<body class="bg-[#f8f9fc] antialiased">

<jsp:include page="/WEB-INF/views/components/gnavbar.jsp"/>

<header class="bg-white border-b border-gray-100 py-16">
    <div class="max-w-7xl mx-auto px-6">
        <nav class="flex text-sm text-gray-400 mb-4 items-center gap-2">
            <a href="<%=request.getContextPath()%>/guest/home" class="hover:text-primary transition font-medium">Home</a>
            <span class="material-icons-round text-xs text-gray-300">chevron_right</span>
            <span class="text-gray-900 font-bold font-heading uppercase tracking-widest text-[10px]">Career Paths</span>
        </nav>

        <h1 class="text-4xl md:text-5xl font-800 text-gray-900 mb-4 tracking-tight">
            Choose Your Career Path
        </h1>
        <p class="text-gray-500 max-w-2xl leading-relaxed font-medium">
            Explore our expert-curated roadmaps. Each path is a step-by-step guide from zero to job-ready professional.
        </p>
    </div>
</header>

<div class="max-w-7xl mx-auto px-6 -mt-8 relative z-10">
    <div class="bg-white rounded-2xl shadow-xl shadow-gray-200/50 p-4 border border-gray-50">
        <div class="relative w-full">
            <span class="material-icons-round absolute left-4 top-1/2 -translate-y-1/2 text-gray-400">search</span>
            <input type="text" id="careerSearch" onkeyup="filterCareers()" 
                   placeholder="Search for a role (e.g. Frontend, DevOps)..." 
                   class="w-full pl-12 pr-4 py-3.5 bg-gray-50 border-none rounded-xl outline-none focus:ring-2 focus:ring-primary/20 transition-all font-medium">
        </div>
    </div>
</div>

<main class="max-w-7xl mx-auto px-6 py-20">
    <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-8" id="careerGrid">

        <div class="path-card bg-white rounded-[2rem] overflow-hidden border border-gray-100 shadow-sm flex flex-col group">
            <div class="h-40 bg-indigo-50 flex items-center justify-center group-hover:bg-indigo-100 transition-colors">
                <div class="w-16 h-16 bg-white rounded-2xl flex items-center justify-center shadow-sm">
                    <i class="fas fa-code text-primary text-2xl"></i>
                </div>
            </div>
            <div class="p-8 flex-grow">
                <h3 class="card-title font-bold text-xl text-gray-900 mb-2 group-hover:text-primary transition-colors">Frontend Developer</h3>
                <p class="card-desc text-gray-500 text-sm mb-6 leading-relaxed font-medium">Master the art of building beautiful, interactive user interfaces with React and Tailwind CSS.</p>
                <div class="flex gap-2 mb-8">
                    <span class="px-3 py-1 bg-blue-50 text-blue-600 rounded-full text-[10px] font-black uppercase tracking-widest">React</span>
                    <span class="px-3 py-1 bg-purple-50 text-purple-600 rounded-full text-[10px] font-black uppercase tracking-widest">Tailwind</span>
                </div>
                <div class="flex items-center justify-between pt-6 border-t border-gray-50">
                    <span class="text-[10px] text-gray-400 font-black uppercase tracking-widest">8 Steps • 3 Projects</span>
                    <a href="<%=request.getContextPath()%>/guest/course_detail?title=Frontend+Developer" 
                       class="text-primary font-bold text-sm hover:underline">Quick View</a>
                </div>
            </div>
        </div>

        <div class="path-card bg-white rounded-[2rem] overflow-hidden border border-gray-100 shadow-sm flex flex-col group">
            <div class="h-40 bg-amber-50 flex items-center justify-center group-hover:bg-amber-100 transition-colors">
                <div class="w-16 h-16 bg-white rounded-2xl flex items-center justify-center shadow-sm">
                    <i class="fas fa-server text-amber-600 text-2xl"></i>
                </div>
            </div>
            <div class="p-8 flex-grow">
                <h3 class="card-title font-bold text-xl text-gray-900 mb-2 group-hover:text-primary transition-colors">Backend Developer</h3>
                <p class="card-desc text-gray-500 text-sm mb-6 leading-relaxed font-medium">Build robust server-side logic, master databases, and create scalable APIs using Spring Boot.</p>
                <div class="flex gap-2 mb-8">
                    <span class="px-3 py-1 bg-amber-50 text-amber-600 rounded-full text-[10px] font-black uppercase tracking-widest">Java</span>
                    <span class="px-3 py-1 bg-orange-50 text-orange-600 rounded-full text-[10px] font-black uppercase tracking-widest">SQL</span>
                </div>
                <div class="flex items-center justify-between pt-6 border-t border-gray-50">
                    <span class="text-[10px] text-gray-400 font-black uppercase tracking-widest">12 Steps • 4 Projects</span>
                    <a href="<%=request.getContextPath()%>/guest/course_detail?title=Backend+Developer" 
                       class="text-primary font-bold text-sm hover:underline">Quick View</a>
                </div>
            </div>
        </div>

        <div class="path-card bg-white rounded-[2rem] overflow-hidden border border-gray-100 shadow-sm flex flex-col group">
            <div class="h-40 bg-green-50 flex items-center justify-center group-hover:bg-green-100 transition-colors">
                <div class="w-16 h-16 bg-white rounded-2xl flex items-center justify-center shadow-sm">
                    <i class="fas fa-layer-group text-green-600 text-2xl"></i>
                </div>
            </div>
            <div class="p-8 flex-grow">
                <h3 class="card-title font-bold text-xl text-gray-900 mb-2 group-hover:text-primary transition-colors">Full Stack Developer</h3>
                <p class="card-desc text-gray-500 text-sm mb-6 leading-relaxed font-medium">The complete journey. Master both ends of the stack and learn how to deploy to the cloud.</p>
                <div class="flex gap-2 mb-8">
                    <span class="px-3 py-1 bg-green-50 text-green-600 rounded-full text-[10px] font-black uppercase tracking-widest">MERN</span>
                    <span class="px-3 py-1 bg-blue-50 text-blue-600 rounded-full text-[10px] font-black uppercase tracking-widest">AWS</span>
                </div>
                <div class="flex items-center justify-between pt-6 border-t border-gray-50">
                    <span class="text-[10px] text-gray-400 font-black uppercase tracking-widest">20 Steps • 6 Projects</span>
                    <a href="<%=request.getContextPath()%>/guest/course_detail?title=Full+Stack+Developer" 
                       class="text-primary font-bold text-sm hover:underline">Quick View</a>
                </div>
            </div>
        </div>

    </div>

    <div id="noResults" class="hidden text-center py-20">
        <span class="material-icons-round text-6xl text-gray-200">search_off</span>
        <p class="text-gray-500 mt-4 font-medium">No career paths found matching your search.</p>
    </div>
</main>

<jsp:include page="/WEB-INF/views/components/guest_footer.jsp" />

<script>
    function filterCareers() {
        // 1. Get the search query
        const query = document.getElementById('careerSearch').value.toLowerCase();
        
        // 2. Get all path cards
        const cards = document.querySelectorAll('.path-card');
        let visibleCount = 0;

        // 3. Loop through cards and check for matches
        cards.forEach(card => {
            const title = card.querySelector('.card-title').innerText.toLowerCase();
            const desc = card.querySelector('.card-desc').innerText.toLowerCase();

            if (title.includes(query) || desc.includes(query)) {
                card.style.display = "flex"; // Show
                visibleCount++;
            } else {
                card.style.display = "none"; // Hide
            }
        });

        // 4. Show "No Results" message if zero matches
        const noResults = document.getElementById('noResults');
        if (visibleCount === 0) {
            noResults.classList.remove('hidden');
        } else {
            noResults.classList.add('hidden');
        }
    }
</script>

</body>
</html>