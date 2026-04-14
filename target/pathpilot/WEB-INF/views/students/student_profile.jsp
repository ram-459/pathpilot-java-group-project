<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
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
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>My Learning Dashboard - PathPilot</title>

    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet"/>
    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>

    <script>
        tailwind.config = {
            theme:{
                extend:{
                    colors:{
                        primary:'#4913ec', 
                        'primary-dark': '#3a0fb5',
                        'bg-main':'#f8f9fc'
                    },
                    fontFamily:{
                        sans:['Plus Jakarta Sans','sans-serif']
                    }
                }
            }
        }
    </script>

    <style type="text/tailwindcss">
        body{font-family:'Plus Jakarta Sans',sans-serif;}
        .progress-bar{ height:6px; border-radius:10px; @apply bg-gray-100; }
        .progress-fill{ height:100%; border-radius:10px; @apply bg-green-500 shadow-sm; }
    </style>
</head>

<body class="bg-bg-main min-h-screen flex antialiased">

<jsp:include page="/WEB-INF/views/components/user_sidebar.jsp"/>

<main class="flex-grow p-6 lg:p-10 overflow-y-auto">

    <div class="max-w-7xl mx-auto bg-white rounded-[2.5rem] p-8 border border-gray-100 shadow-sm flex flex-col md:flex-row items-center justify-between mb-12 gap-6">
        <div class="flex items-center gap-6">
            <div class="relative">
                <%
                    String profilePic = (String) session.getAttribute("profilePic");
                    String imgSrc = request.getContextPath() + "/assets/images/default-avatar.png";
                    if (profilePic != null && !profilePic.isEmpty()) {
                        String filename = profilePic.substring(profilePic.lastIndexOf('/') + 1);
                        imgSrc = request.getContextPath() + "/student/file/" + filename;
                    }
                %>
                <img src="<%= imgSrc %>"
                     class="w-24 h-24 rounded-3xl object-cover border-4 border-indigo-50 shadow-md">
                <span class="absolute -bottom-1 -right-1 w-6 h-6 bg-green-500 border-4 border-white rounded-full"></span>
            </div>

            <div>
                <h2 class="text-2xl font-800 text-gray-900 tracking-tight">${sessionScope.userName}</h2>
                <p class="text-gray-400 text-sm font-medium mt-1">${sessionScope.userEmail}</p>

                <div class="flex items-center gap-4 mt-4 text-[10px] font-black uppercase tracking-widest text-gray-400">
                    <span class="flex items-center gap-1">
                        <span class="material-icons-round text-sm">verified</span> Verified Student
                    </span>
                    <span class="flex items-center gap-1">
                        <span class="material-icons-round text-sm">school</span> RK University
                    </span>
                </div>
            </div>
        </div>

        <a href="<%=request.getContextPath()%>/student/settings"
           class="bg-indigo-50 px-8 py-4 rounded-2xl text-primary font-bold text-xs hover:bg-primary hover:text-white transition-all active:scale-95 shadow-sm shadow-indigo-100 flex items-center gap-2">
           <span class="material-icons-round text-sm">settings_suggest</span>
           Edit Profile 
        </a>
    </div>

    <div class="max-w-7xl mx-auto">
        <div class="flex items-center justify-between mb-8">
            <h3 class="text-xl font-800 text-gray-900 tracking-tight">Active Learning Paths</h3>
            <a href="<%=request.getContextPath()%>/student/home" class="text-primary font-bold text-xs hover:underline flex items-center gap-1">
                View All <span class="material-icons-round text-xs">arrow_forward</span>
            </a>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            
            <c:if test="${empty enrolledPaths}">
                <div class="col-span-full text-center py-12">
                    <span class="material-icons-round text-5xl text-gray-200 mb-4 block">school</span>
                    <p class="text-gray-500 font-medium text-lg">No active learning paths yet</p>
                    <a href="<%=request.getContextPath()%>/student/career" class="text-primary font-bold hover:underline inline-block mt-4">
                        Explore career paths →
                    </a>
                </div>
            </c:if>

            <c:forEach var="pathInfo" items="${enrolledPaths}">
                <c:set var="path" value="${pathInfo.path}" />
                <div class="bg-white p-8 rounded-[2.5rem] border border-gray-100 shadow-sm group hover:shadow-xl transition-all duration-300">
                    <div class="flex items-center justify-between mb-8">
                        <div class="w-12 h-12 bg-indigo-50 text-primary rounded-2xl flex items-center justify-center">
                            <span class="material-icons-round">code</span>
                        </div>
                        <span class="bg-green-50 text-green-600 text-[10px] font-black px-4 py-1.5 rounded-full uppercase tracking-widest">
                            ${pathInfo.completionPercentage}% Completed
                        </span>
                    </div>

                    <h4 class="font-800 text-gray-900 text-lg tracking-tight">${path.title}</h4>
                    <p class="text-gray-400 text-xs font-bold mt-2 uppercase tracking-widest">
                        <c:if test="${not empty pathInfo.nextPhase}">
                            Next: ${pathInfo.nextPhase.title}
                        </c:if>
                        <c:if test="${empty pathInfo.nextPhase}">
                            Completed!
                        </c:if>
                    </p>

                    <div class="progress-bar mt-8">
                        <div class="progress-fill" style="width:${pathInfo.completionPercentage}%;"></div>
                    </div>

                    <a href="<%=request.getContextPath()%>/student/progress?enrollmentId=${pathInfo.enrollmentId}"
                       class="block w-full mt-8 py-4 bg-indigo-50 text-primary font-bold rounded-2xl text-center hover:bg-primary hover:text-white transition-all active:scale-95 text-sm">
                       ${pathInfo.completionPercentage == 100 ? 'View Certificate' : 'Continue Journey'}
                    </a>
                </div>
            </c:forEach>

        </div>
    </div>

</main>

</body>
</html>