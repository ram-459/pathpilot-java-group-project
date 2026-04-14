<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Learning Resources Hub - PathPilot</title>
    
    <link href="https://fonts.googleapis.com" rel="preconnect"/>
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
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
                        'sans': ["'Plus Jakarta Sans'", 'sans-serif'], 
                        'heading': ['Poppins', 'sans-serif'] 
                    }
                }
            }
        }
    </script>
    <style type="text/tailwindcss">
        body { font-family: 'Plus Jakarta Sans', sans-serif; }
        h1, h2, h3, h4, .font-heading { font-family: 'Poppins', sans-serif; }
        .premium-overlay { background: rgba(255, 255, 255, 0.1); backdrop-blur: 8px; }
        .filter-btn.active { 
            @apply bg-primary text-white shadow-lg shadow-primary/20 border-primary !important; 
        }
    </style>
</head>
<body class="bg-[#f8f9fc] antialiased">

    <%-- Standard Guest Navbar --%>
    <jsp:include page="/WEB-INF/views/components/gnavbar.jsp"/>

    <header class="max-w-7xl mx-auto px-6 pt-16 pb-8">
        <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
            <div>
                <h1 class="text-4xl font-bold text-gray-900 mb-4 tracking-tight">Learning Resources Hub</h1>
                <p class="text-gray-500 max-w-2xl leading-relaxed">Expert-curated documentation and guides filtered by your career domain.</p>
            </div>
        </div>

        <div class="mt-12 flex flex-col md:flex-row gap-4 items-center">
            <div class="relative flex-grow max-w-md w-full">
                <span class="material-icons-round absolute left-4 top-1/2 -translate-y-1/2 text-gray-400">search</span>
                <input type="text" id="resourceSearch" onkeyup="filterBySearch()" placeholder="Search React, Docker, Security..." class="w-full pl-12 pr-4 py-3.5 bg-white border border-gray-200 rounded-xl outline-none focus:ring-2 focus:ring-primary/10 focus:border-primary transition-all shadow-sm">
            </div>
            
            <div class="flex gap-2 overflow-x-auto pb-2 w-full md:w-auto">
                <button onclick="filterResources('all', this)" class="filter-btn active bg-white text-gray-600 border border-gray-200 px-6 py-2.5 rounded-full text-sm font-medium hover:bg-gray-50 transition-all whitespace-nowrap">All Domains</button>
                <button onclick="filterResources('web', this)" class="filter-btn bg-white text-gray-600 border border-gray-200 px-6 py-2.5 rounded-full text-sm font-medium hover:bg-gray-50 transition-all whitespace-nowrap">Web Dev</button>
                <button onclick="filterResources('devops', this)" class="filter-btn bg-white text-gray-600 border border-gray-200 px-6 py-2.5 rounded-full text-sm font-medium hover:bg-gray-50 transition-all whitespace-nowrap">DevOps</button>
                <button onclick="filterResources('security', this)" class="filter-btn bg-white text-gray-600 border border-gray-200 px-6 py-2.5 rounded-full text-sm font-medium hover:bg-gray-50 transition-all whitespace-nowrap">Cyber Security</button>
            </div>
        </div>
    </header>

    <main class="max-w-7xl mx-auto px-6 py-12">
        <div id="resourceGrid" class="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            
            <!-- Web Dev Card -->
            <div class="resource-card bg-white rounded-[2.5rem] overflow-hidden shadow-sm border border-gray-100 hover:shadow-xl hover:-translate-y-1 transition-all duration-300 group" data-category="web">
                <div class="h-52 bg-[#2eb086] flex items-center justify-center p-8 relative">
                    <span class="absolute top-4 left-4 bg-white/20 backdrop-blur-md text-white text-[10px] font-black px-3 py-1 rounded-full uppercase">Standard</span>
                    <div class="border-2 border-white/30 rounded-2xl p-6 text-center">
                        <i class="fa-solid fa-code text-white text-4xl mb-2"></i>
                        <h4 class="text-white font-bold text-xl uppercase tracking-tighter">Frontend Mastery</h4>
                    </div>
                </div>
                <div class="p-8">
                    <h3 class="resource-title font-bold text-lg text-gray-900 mb-2">Modern React Architecture 2024</h3>
                    <div class="flex items-center justify-between pt-6 border-t border-gray-50">
                        <span class="text-xs text-gray-400 font-bold uppercase tracking-widest">Free Resource</span>
                        <%-- ✅ REDIRECT TO COURSE DETAILS --%>
                        <a href="<%=request.getContextPath()%>/guest/course_detail?title=React+Architecture" class="text-primary font-bold text-sm hover:underline">Quick View</a>
                    </div>
                </div>
            </div>

            <!-- DevOps Card (Locked) -->
            <div class="resource-card bg-white rounded-[2.5rem] overflow-hidden shadow-sm border border-gray-100 group relative" data-category="devops">
                <div class="h-52 bg-slate-900 relative flex flex-col items-center justify-center text-center p-6">
                    <img src="https://images.unsplash.com/photo-1667372393119-3d4c48d07fc9?q=80&w=400" class="absolute inset-0 w-full h-full object-cover opacity-30 grayscale" alt="DevOps">
                    <div class="absolute inset-0 premium-overlay flex flex-col items-center justify-center">
                        <div class="w-12 h-12 bg-white rounded-full flex items-center justify-center shadow-xl mb-3">
                            <span class="material-icons-round text-primary text-xl">lock</span>
                        </div>
                        <a href="<%=request.getContextPath()%>/login" class="mt-4 bg-primary hover:bg-primary-dark text-white text-xs font-bold px-6 py-3 rounded-2xl shadow-lg shadow-primary/20 transition-all">Login to Unlock</a>
                    </div>
                </div>
                <div class="p-8">
                    <span class="text-[10px] bg-indigo-50 text-primary font-black px-3 py-1 rounded-full uppercase tracking-widest">Premium Guide</span>
                    <h3 class="resource-title font-bold text-lg text-gray-900 mt-3">Kubernetes & Docker Orchestration</h3>
                    <div class="flex items-center justify-between pt-6 border-t border-gray-50 mt-4">
                        <span class="text-xs text-gray-400 font-bold uppercase tracking-widest">Locked</span>
                        <%-- ✅ REDIRECT TO COURSE DETAILS --%>
                        <a href="<%=request.getContextPath()%>/guest/course_detail?title=Kubernetes+Mastery" class="text-primary font-bold text-sm hover:underline">Quick View</a>
                    </div>
                </div>
            </div>

            <!-- Cyber Security Card -->
            <div class="resource-card bg-white rounded-[2.5rem] overflow-hidden shadow-sm border border-gray-100 hover:shadow-xl hover:-translate-y-1 transition-all duration-300 group" data-category="security">
                <div class="h-52 bg-red-600 flex items-center justify-center relative">
                    <span class="absolute top-4 left-4 bg-black/30 backdrop-blur-md text-white text-[10px] font-black px-3 py-1 rounded-full uppercase">Standard</span>
                    <div class="text-center text-white">
                        <i class="fa-solid fa-shield-halved text-5xl mb-2"></i>
                        <h4 class="font-bold text-xl uppercase tracking-tighter">Pentesting</h4>
                    </div>
                </div>
                <div class="p-8">
                    <h3 class="resource-title font-bold text-lg text-gray-900 mb-2">Network Security Fundamentals</h3>
                    <div class="flex items-center justify-between pt-6 border-t border-gray-50">
                        <span class="text-xs text-gray-400 font-bold uppercase tracking-widest">Free Resource</span>
                        <%-- ✅ REDIRECT TO COURSE DETAILS --%>
                        <a href="<%=request.getContextPath()%>/guest/course_detail?title=Network+Security" class="text-primary font-bold text-sm hover:underline">Quick View</a>
                    </div>
                </div>
            </div>

            <!-- Additional Web Dev Card -->
            <div class="resource-card bg-white rounded-[2.5rem] overflow-hidden shadow-sm border border-gray-100 hover:shadow-xl hover:-translate-y-1 transition-all duration-300 group" data-category="web">
                <div class="h-52 bg-amber-500 flex items-center justify-center relative">
                    <span class="absolute top-4 left-4 bg-black/10 text-white text-[10px] font-black px-3 py-1 rounded-full uppercase">Advanced</span>
                    <i class="fa-brands fa-js text-white text-7xl"></i>
                </div>
                <div class="p-8">
                    <h3 class="resource-title font-bold text-lg text-gray-900 mb-2">JavaScript Advanced Patterns</h3>
                    <div class="flex items-center justify-between pt-6 border-t border-gray-50">
                        <span class="text-xs text-gray-400 font-bold uppercase tracking-widest">Community Resource</span>
                        <%-- ✅ REDIRECT TO COURSE DETAILS --%>
                        <a href="<%=request.getContextPath()%>/guest/course_detail?title=JavaScript+Patterns" class="text-primary font-bold text-sm hover:underline">Quick View</a>
                    </div>
                </div>
            </div>

        </div>
    </main>

    <jsp:include page="/WEB-INF/views/components/guest_footer.jsp" />

    <script>
        function filterResources(category, btn) {
            document.querySelectorAll('.filter-btn').forEach(b => {
                b.classList.remove('active', 'bg-primary', 'text-white');
            });
            btn.classList.add('active', 'bg-primary', 'text-white');

            const cards = document.querySelectorAll('.resource-card');
            cards.forEach(card => {
                if (category === 'all' || card.getAttribute('data-category') === category) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        }

        function filterBySearch() {
            const query = document.getElementById('resourceSearch').value.toLowerCase();
            const cards = document.querySelectorAll('.resource-card');

            cards.forEach(card => {
                const title = card.querySelector('.resource-title').innerText.toLowerCase();
                if (title.includes(query)) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        }
    </script>
</body>
</html>