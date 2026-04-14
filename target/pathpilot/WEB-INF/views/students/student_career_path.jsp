<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    // 🔐 SESSION + CACHE FIX ONLY
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // 🔐 If not logged in → redirect
    if(session == null || session.getAttribute("role") == null){
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Career Paths | PathPilot</title>

    <%-- ✅ REQUIRED: Standardized Fonts and Icons for Navbar Consistency --%>
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
        h1, h2, h3, .font-heading { font-family: 'Poppins', sans-serif; }
        .path-card:hover { transform: translateY(-5px); }
        .path-card { transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
    </style>

    <script>
        function filterPaths() {
            const searchQuery = document.getElementById('pathSearch').value.toLowerCase();
            const cards = document.querySelectorAll('.path-card');
            let hasResults = false;

            cards.forEach(card => {
                const title = card.querySelector('.card-title').innerText.toLowerCase();
                const category = card.querySelector('.card-category')?.innerText.toLowerCase() || '';
                const desc = card.querySelector('.card-desc').innerText.toLowerCase();
                
                if (title.includes(searchQuery) || category.includes(searchQuery) || desc.includes(searchQuery)) {
                    card.style.display = "flex";
                    hasResults = true;
                } else {
                    card.style.display = "none";
                }
            });

            // Toggle No Results message
            document.getElementById('noResults').style.display = hasResults ? "none" : "block";
        }
    </script>
</head>

<body class="bg-[#f8f9fc] antialiased">

<%-- Calling the shared horizontal navbar component --%>
<jsp:include page="/WEB-INF/views/components/user_navbar.jsp"/>

<header class="bg-white border-b border-gray-100 py-16">
    <div class="max-w-7xl mx-auto px-6">
        <nav class="flex text-sm text-gray-400 mb-4 items-center gap-2">
            <a href="<%=request.getContextPath()%>/student/home" class="hover:text-primary transition font-medium">Home</a>
            <span class="material-icons-round text-xs text-gray-300">chevron_right</span>
            <span class="text-gray-900 font-bold font-heading uppercase tracking-widest text-[10px]">Career Paths</span>
        </nav>

        <h1 class="text-4xl md:text-5xl font-800 text-gray-900 mb-4 tracking-tight">
            Choose Your Career Path
        </h1>
        <p class="text-gray-500 max-w-2xl leading-relaxed font-medium">
            Explore our expert-curated roadmaps. Each path is a step-by-step guide from academic theory to industry-ready professionalism.
        </p>
    </div>
</header>

<div class="max-w-7xl mx-auto px-6 -mt-8 relative z-10">
    <div class="bg-white rounded-[1.5rem] shadow-xl shadow-gray-200/50 p-4 border border-gray-50">
        <div class="relative w-full">
            <span class="material-icons-round absolute left-4 top-1/2 -translate-y-1/2 text-gray-400">search</span>
            <input type="text" id="pathSearch" placeholder="Search for a role (e.g. Frontend, DevOps)..." 
                   oninput="filterPaths()"
                   class="w-full pl-12 pr-4 py-3.5 bg-gray-50 border-none rounded-xl outline-none focus:ring-2 focus:ring-primary/20 transition-all font-medium">
        </div>
    </div>
</div>

<main class="max-w-7xl mx-auto px-6 py-20">
    <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-8">

        <%-- 🔄 DYNAMIC CAREER PATHS FROM DATABASE --%>
        <c:if test="${empty careerPaths}">
            <div class="col-span-full text-center py-20">
                <p class="text-gray-500 font-medium">No career paths available at the moment.</p>
            </div>
        </c:if>

        <c:forEach var="pathInfo" items="${careerPaths}">
            <c:set var="path" value="${pathInfo.path}" />
            <c:set var="isEnrolled" value="${pathInfo.isEnrolled}" />
            
            <c:set var="bgColor" value="indigo-50" />
            <c:set var="borderColor" value="indigo-100" />
            <c:set var="hoverColor" value="indigo-100" />
            <c:set var="iconClass" value="fa-code" />
            <c:set var="iconColor" value="text-primary" />
            
            <%-- Assign colors based on path title --%>
            <c:choose>
                <c:when test="${fn:containsIgnoreCase(path.title, 'Backend') || fn:containsIgnoreCase(path.title, 'Java')}">
                    <c:set var="bgColor" value="amber-50" />
                    <c:set var="hoverColor" value="amber-100" />
                    <c:set var="iconClass" value="fa-server" />
                    <c:set var="iconColor" value="text-amber-600" />
                </c:when>
                <c:when test="${fn:containsIgnoreCase(path.title, 'Full Stack')}">
                    <c:set var="bgColor" value="green-50" />
                    <c:set var="hoverColor" value="green-100" />
                    <c:set var="iconClass" value="fa-layer-group" />
                    <c:set var="iconColor" value="text-green-600" />
                </c:when>
                <c:when test="${fn:containsIgnoreCase(path.title, 'DevOps') || fn:containsIgnoreCase(path.title, 'Cloud') || fn:containsIgnoreCase(path.title, 'AWS')}">
                    <c:set var="bgColor" value="blue-50" />
                    <c:set var="hoverColor" value="blue-100" />
                    <c:set var="iconClass" value="fa-cloud" />
                    <c:set var="iconColor" value="text-blue-600" />
                </c:when>
                <c:when test="${fn:containsIgnoreCase(path.title, 'Security') || fn:containsIgnoreCase(path.title, 'Cyber')}">
                    <c:set var="bgColor" value="red-50" />
                    <c:set var="hoverColor" value="red-100" />
                    <c:set var="iconClass" value="fa-shield-alt" />
                    <c:set var="iconColor" value="text-red-600" />
                </c:when>
            </c:choose>

            <div class="bg-white rounded-[2rem] overflow-hidden border border-gray-100 shadow-sm path-card transition-all duration-300 flex flex-col group">
                <div class="h-40 bg-${bgColor} flex items-center justify-center group-hover:bg-${hoverColor} transition-colors relative">
                    <div class="w-16 h-16 bg-white rounded-2xl flex items-center justify-center shadow-sm">
                        <i class="fas ${iconClass} ${iconColor} text-2xl"></i>
                    </div>
                    <c:if test="${pathInfo.isCreator}">
                        <div class="absolute top-4 right-4 bg-purple-100 text-purple-700 px-3 py-1 rounded-full text-xs font-bold flex items-center gap-1">
                            <span class="material-icons-round text-sm">star</span>
                            Your Path
                        </div>
                    </c:if>
                    <c:if test="${isEnrolled && !pathInfo.isCreator}">
                        <div class="absolute top-4 right-4 bg-green-100 text-green-700 px-3 py-1 rounded-full text-xs font-bold flex items-center gap-1">
                            <span class="material-icons-round text-sm">check_circle</span>
                            Enrolled
                        </div>
                    </c:if>
                </div>
                <div class="p-8 flex-grow flex flex-col">
                    <h3 class="font-bold text-xl text-gray-900 mb-2 group-hover:text-primary transition-colors card-title">${path.title}</h3>
                    <p class="text-gray-500 text-sm mb-6 leading-relaxed font-medium card-desc">${path.description}</p>
                    <div class="flex gap-2 mb-8 flex-wrap">
                        <c:if test="${not empty path.category}">
                            <span class="card-category px-3 py-1 bg-gray-50 text-gray-600 rounded-full text-[10px] font-black uppercase tracking-widest">${path.category}</span>
                        </c:if>
                        <c:if test="${not empty path.level}">
                            <span class="px-3 py-1 bg-gray-100 text-gray-700 rounded-full text-[10px] font-black uppercase tracking-widest">${path.level}</span>
                        </c:if>
                    </div>
                    <div class="flex items-center justify-between pt-6 border-t border-gray-50 mt-auto">
                        <span class="text-[10px] text-gray-400 font-black uppercase tracking-widest">${path.totalPhases} Phases</span>
                        <a href="<%=request.getContextPath()%>/student/view-path?id=${path.pathId}" 
                           class="text-primary font-bold text-sm hover:underline flex items-center gap-1">
                            <span class="material-icons-round text-sm">arrow_forward</span>
                            View Path
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>

    </div>

    <%-- No Results Message --%>
    <div id="noResults" class="col-span-full text-center py-20">
        <span class="material-icons-round text-5xl text-gray-300 mb-4 block">search_off</span>
        <p class="text-gray-500 font-medium text-lg">No career paths match your search.</p>
        <p class="text-gray-400 text-sm mt-2">Try searching for keywords like "Backend", "Cloud", "Security", etc.</p>
    </div>
</main>

<%-- Footer inclusion --%>
<jsp:include page="/WEB-INF/views/components/student_footer.jsp" />

</body>
</html>