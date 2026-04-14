<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // 🔐 SESSION + CACHE GUARD
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if(session == null || session.getAttribute("role") == null){
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Curated Paths Hub - PathPilot</title>
    
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
        h1, h2, h3, h4, .font-heading { font-family: 'Poppins', sans-serif; }
        .domain-card:hover .domain-icon { @apply scale-110 rotate-3; }
    </style>
</head>
<body class="bg-[#f8f9fc] antialiased">

    <jsp:include page="/WEB-INF/views/components/user_navbar.jsp"/>

    <header class="max-w-7xl mx-auto px-6 pt-16 pb-8">
        <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
            <div>
                <nav class="flex text-[10px] font-black uppercase tracking-widest text-gray-400 mb-2">
                    <span>Resources</span>
                    <span class="mx-2">/</span>
                    <span class="text-primary font-bold">Curated Domains</span>
                </nav>
                <h1 class="text-4xl font-800 text-gray-900 mb-4 tracking-tight">Learning Paths Hub</h1>
                <p class="text-gray-500 max-w-2xl leading-relaxed font-medium">Explore structured roadmaps across the most in-demand tech domains.</p>
            </div>
        </div>

        <div class="mt-12 flex flex-col md:flex-row gap-4 items-center">
            <div class="relative flex-grow max-w-md w-full">
                <span class="material-icons-round absolute left-4 top-1/2 -translate-y-1/2 text-gray-400">search</span>
                <input type="text" id="searchInput" onkeyup="filterResources()" placeholder="Search paths (e.g. React, AWS)..." 
                       class="w-full pl-12 pr-4 py-3.5 bg-white border border-gray-100 rounded-xl outline-none focus:ring-2 focus:ring-primary/10 transition-all shadow-sm">
            </div>
        </div>
    </header>

    <main class="max-w-7xl mx-auto px-6 py-12">
        <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-8" id="resourceGrid">
            
            <c:forEach var="path" items="${careerPaths}" varStatus="pathLoop">
                <!-- Determine color and icon based on category -->
                <c:set var="bgColor" value="indigo-600"/>
                <c:set var="icon" value="code"/>
                <c:set var="category" value="development"/>
                <c:set var="statusColor" value="green-500"/>
                
                <c:if test="${path.category == 'Cloud Computing' || path.category == 'Cloud'}">
                    <c:set var="bgColor" value="blue-500"/>
                    <c:set var="icon" value="cloud"/>
                    <c:set var="category" value="cloud"/>
                    <c:set var="statusColor" value="blue-500"/>
                </c:if>
                
                <c:if test="${path.category == 'Cyber Security' || path.category == 'Security'}">
                    <c:set var="bgColor" value="gray-900"/>
                    <c:set var="icon" value="shield"/>
                    <c:set var="category" value="security"/>
                    <c:set var="statusColor" value="red-500"/>
                </c:if>

                <div class="resource-card domain-card bg-white rounded-[2.5rem] overflow-hidden shadow-sm border border-gray-100 transition-all duration-300 hover:shadow-xl hover:border-primary/20" data-category="${category}" data-title="${path.title}" data-description="${path.description}">
                    <div class="h-52 bg-${bgColor} flex items-center justify-center p-8 relative overflow-hidden">
                        <div class="absolute inset-0 bg-gradient-to-br from-white/10 to-transparent"></div>
                        <span class="absolute top-4 left-4 bg-white/20 backdrop-blur-md text-white text-[10px] font-black px-3 py-1.5 rounded-full uppercase tracking-widest">${path.category}</span>
                        <i class="fas fa-${icon} text-white text-6xl opacity-40 domain-icon transition-transform duration-500"></i>
                    </div>
                    <div class="p-8">
                        <h3 class="resource-title font-bold text-lg text-gray-900 mb-3">${path.title}</h3>
                        <p class="resource-desc text-gray-500 text-sm mb-6 leading-relaxed">${path.description}</p>
                        <div class="flex items-center justify-between pt-5 border-t border-gray-50">
                            <div class="flex items-center gap-2">
                                <span class="w-2 h-2 rounded-full bg-${statusColor}"></span>
                                <span class="text-[10px] text-gray-400 font-black uppercase">${path.status} • BY ${not empty path.createdByName ? path.createdByName : path.createdBy}</span>
                            </div>
                            <a href="<%=request.getContextPath()%>/student/course-details/${path.pathId}" class="text-primary font-bold text-sm hover:underline">Explore Path</a>
                        </div>
                    </div>
                </div>
            </c:forEach>

        </div>

        <div id="noResults" class="hidden text-center py-20">
            <div class="w-20 h-20 bg-white rounded-full flex items-center justify-center mx-auto mb-6 shadow-sm border border-gray-100">
                <span class="material-icons-round text-4xl text-gray-200">search_off</span>
            </div>
            <h3 class="text-xl font-bold text-gray-900">No paths found</h3>
            <p class="text-gray-500 mt-2 font-medium">We couldn't find any roadmap matching your current filters.</p>
        </div>
    </main>

    <script>
        function filterResources() {
            const searchText = document.getElementById('searchInput').value.toLowerCase();
            const cards = document.querySelectorAll('.resource-card');
            let visibleCount = 0;

            cards.forEach(card => {
                const title = card.getAttribute('data-title') ? card.getAttribute('data-title').toLowerCase() : '';
                const desc = card.getAttribute('data-description') ? card.getAttribute('data-description').toLowerCase() : '';

                const matchesSearch = title.includes(searchText) || desc.includes(searchText);

                if (matchesSearch) {
                    card.classList.remove('hidden');
                    visibleCount++;
                } else {
                    card.classList.add('hidden');
                }
            });

            const noResults = document.getElementById('noResults');
            if (visibleCount === 0) {
                noResults.classList.remove('hidden');
            } else {
                noResults.classList.add('hidden');
            }
        }
    </script>

    <jsp:include page="/WEB-INF/views/components/student_footer.jsp"/>
</body>
</html>