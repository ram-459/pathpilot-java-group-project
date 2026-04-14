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

        // ✅ SEARCH LOGIC: Filters cards based on title and description
        function filterPaths() {
            const searchQuery = document.getElementById('pathSearch').value.toLowerCase();
            const cards = document.querySelectorAll('.path-card');
            let hasResults = false;

            cards.forEach(card => {
                const title = card.querySelector('.card-title').innerText.toLowerCase();
                const desc = card.querySelector('.card-desc').innerText.toLowerCase();
                
                if (title.includes(searchQuery) || desc.includes(searchQuery)) {
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

    <style type="text/tailwindcss">
        body { font-family: 'Plus Jakarta Sans', sans-serif; }
        h1, h2, h3, .font-heading { font-family: 'Poppins', sans-serif; }
        .path-card { transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .path-card:hover { transform: translateY(-8px); }
    </style>
</head>

<body class="bg-[#f8f9fc] antialiased">

<jsp:include page="/WEB-INF/views/components/user_navbar.jsp"/>

<header class="bg-white border-b border-gray-100 py-16">
    <div class="max-w-7xl mx-auto px-6">
        <nav class="flex text-sm text-gray-400 mb-4 items-center gap-2">
            <a href="<%=request.getContextPath()%>/user/UserHome" class="hover:text-primary transition font-medium">Home</a>
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
            <%-- ✅ ADDED: id="pathSearch" and onkeyup listener --%>
            <input type="text" id="pathSearch" onkeyup="filterPaths()" 
                   placeholder="Search for a role (e.g. Frontend, DevOps)..." 
                   class="w-full pl-12 pr-4 py-3.5 bg-gray-50 border-none rounded-xl outline-none focus:ring-2 focus:ring-primary/20 transition-all font-medium">
        </div>
    </div>
</div>

<main class="max-w-7xl mx-auto px-6 py-20">
    
    <%-- ✅ ADDED: No Results Message --%>
    <div id="noResults" class="hidden text-center py-20">
        <span class="material-icons-round text-6xl text-gray-200 mb-4">search_off</span>
        <h3 class="text-xl font-bold text-gray-400">No career paths match your search.</h3>
    </div>

    <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-8" id="pathContainer">
        <%-- 🔄 DYNAMIC CAREER PATHS FROM DATABASE WITH ENROLLMENT STATUS --%>
        <c:if test="${empty careerPaths}">
            <div class="col-span-full text-center py-20">
                <p class="text-gray-500 font-medium">No career paths available at the moment.</p>
            </div>
        </c:if>
        
        <c:forEach var="pathInfo" items="${careerPaths}">
            <c:set var="path" value="${pathInfo.path}" />
            <c:set var="isEnrolled" value="${pathInfo.isEnrolled}" />
            <c:set var="enrollmentStatus" value="${pathInfo.enrollmentStatus}" />
            
            <c:set var="bgColor" value="indigo" />
            <c:set var="iconClass" value="fa-code" />
            <c:set var="textColor" value="text-primary" />
            
            <%-- Assign colors based on category or path name --%>
            <c:choose>
                <c:when test="${fn:containsIgnoreCase(path.title, 'Backend')}">
                    <c:set var="bgColor" value="amber" />
                    <c:set var="iconClass" value="fa-server" />
                    <c:set var="textColor" value="text-amber-600" />
                </c:when>
                <c:when test="${fn:containsIgnoreCase(path.title, 'Full Stack')}">
                    <c:set var="bgColor" value="green" />
                    <c:set var="iconClass" value="fa-layer-group" />
                    <c:set var="textColor" value="text-green-600" />
                </c:when>
                <c:when test="${fn:containsIgnoreCase(path.title, 'DevOps')}">
                    <c:set var="bgColor" value="red" />
                    <c:set var="iconClass" value="fa-cogs" />
                    <c:set var="textColor" value="text-red-600" />
                </c:when>
                <c:when test="${fn:containsIgnoreCase(path.title, 'Data')}">
                    <c:set var="bgColor" value="purple" />
                    <c:set var="iconClass" value="fa-database" />
                    <c:set var="textColor" value="text-purple-600" />
                </c:when>
            </c:choose>

            <div class="bg-white rounded-[2rem] overflow-hidden border border-gray-100 shadow-sm path-card flex flex-col group ${isEnrolled ? 'opacity-75' : ''}">
                <div class="h-40 bg-${bgColor}-50 flex items-center justify-center group-hover:bg-${bgColor}-100 transition-colors relative">
                    <div class="w-16 h-16 bg-white rounded-2xl flex items-center justify-center shadow-sm">
                        <i class="fas ${iconClass} ${textColor} text-2xl"></i>
                    </div>
                    <%-- Show enrollment/creator badge --%>
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
                    <h3 class="card-title font-bold text-xl text-gray-900 mb-2 group-hover:text-primary transition-colors">
                        ${path.title}
                    </h3>
                    <p class="card-desc text-gray-500 text-sm mb-6 leading-relaxed font-medium flex-grow">
                        ${path.description}
                    </p>
                    <c:if test="${not empty pathInfo.phases}">
                        <div class="mb-6">
                            <p class="text-[10px] text-gray-400 font-black uppercase tracking-widest mb-2">Phases</p>
                            <ul class="space-y-1.5">
                                <c:forEach var="phase" items="${pathInfo.phases}" end="2">
                                    <li class="text-sm text-gray-600 font-medium">
                                        Phase ${phase.phaseNumber}: ${phase.title}
                                    </li>
                                </c:forEach>
                                <c:if test="${fn:length(pathInfo.phases) > 3}">
                                    <li class="text-xs text-gray-400 font-semibold">
                                        +${fn:length(pathInfo.phases) - 3} more phases
                                    </li>
                                </c:if>
                            </ul>
                        </div>
                    </c:if>
                    <div class="flex gap-2 mb-8 flex-wrap">
                        <c:if test="${not empty path.category}">
                            <span class="px-3 py-1 bg-${bgColor}-50 text-${bgColor}-600 rounded-full text-[10px] font-black uppercase tracking-widest">
                                ${path.category}
                            </span>
                        </c:if>
                        <c:if test="${not empty path.level}">
                            <span class="px-3 py-1 bg-gray-50 text-gray-600 rounded-full text-[10px] font-black uppercase tracking-widest">
                                ${path.level}
                            </span>
                        </c:if>
                    </div>
                    <div class="flex items-center justify-between pt-6 border-t border-gray-50 mt-auto">
                        <span class="text-[10px] text-gray-400 font-black uppercase tracking-widest">
                            ${path.totalPhases} Phases
                        </span>
                        <%-- Route logic based on creator/enrollment status --%>
                        <a href="<%=request.getContextPath()%>/user/view-path?id=${path.pathId}" 
                           class="text-primary font-bold text-sm hover:underline flex items-center gap-1">
                            <span class="material-icons-round text-sm">arrow_forward</span>
                            View Path
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</main>

<jsp:include page="/WEB-INF/views/components/user_footer.jsp" />

</body>
</html>