<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    // 🔐 CACHE & SESSION GUARD
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
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Career Roadmaps | PathPilot Creator</title>

    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: { 
                        primary: "#4913ec",
                        "primary-dark": "#3a0fb5",
                        "bg-light": "#f8f9fc"
                    },
                    fontFamily: {
                        sans: ["'Plus Jakarta Sans'", "sans-serif"],
                        heading: ["Poppins", "sans-serif"]
                    }
                }
            }
        }
    </script>

    <style type="text/tailwindcss">
        body { font-family: 'Plus Jakarta Sans', sans-serif; }
        h1, h2, h3, .font-heading { font-family: 'Poppins', sans-serif; }
        
        .roadmap-row-card { 
            @apply bg-white rounded-[2rem] p-6 border border-gray-100 shadow-sm transition-all duration-300 
            hover:shadow-xl hover:border-primary/10 flex flex-col md:flex-row items-center justify-between gap-6; 
        }

        .metric-card {
            @apply bg-white/60 backdrop-blur-md rounded-[2.5rem] p-6 border border-white/50 shadow-sm;
        }

        /* Status Badge Variants */
        .status-live { @apply bg-green-50 text-green-600 border-green-100; }
        .status-draft { @apply bg-amber-50 text-amber-600 border-amber-100; }

        @keyframes slideUp { from { transform: translate(-50%, 100%); opacity: 0; } to { transform: translate(-50%, 0); opacity: 1; } }
        .animate-pop { animation: slideUp 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275) forwards; }
    </style>
</head>

<body class="bg-bg-light antialiased overflow-hidden">

    <div class="flex h-screen">
        <%-- SIDEBAR --%>
        <%@ include file="/WEB-INF/views/components/user_sidebar.jsp" %>

        <div class="flex-1 flex flex-col overflow-hidden">
            
            <%-- Header Navigation Bar --%>
            <header class="h-16 bg-white/80 backdrop-blur-md border-b border-gray-100 flex items-center justify-between px-10 z-20">
                <nav class="text-sm text-gray-400 flex items-center font-medium">
                    Creator
                    <span class="material-icons-round mx-2 text-xs">chevron_right</span>
                    <span class="text-primary font-bold">Manage Career Paths</span>
                </nav>
                <div class="flex items-center gap-2">
                    <span class="w-2 h-2 rounded-full bg-green-500 animate-pulse"></span>
                    <span class="text-[10px] font-black uppercase text-gray-400 tracking-widest">Creator Mode Active</span>
                </div>
            </header>

            <main class="flex-1 overflow-y-auto p-10">
                
                <%-- Page Introduction --%>
                <div class="max-w-6xl mx-auto flex flex-col md:flex-row justify-between items-center mb-10 gap-4">
                    <div>
                        <h1 class="text-3xl font-800 text-gray-900 tracking-tight">Roadmap Management</h1>
                        <p class="text-gray-500 text-sm font-medium mt-1">Author and monitor the impact of your learning paths.</p>
                    </div>
                    <%-- ✅ Link to UserController @GetMapping("/create-path") --%>
                    <a href="<%=request.getContextPath()%>/user/create-path"
                       class="px-8 py-3.5 bg-primary text-white rounded-2xl flex items-center gap-2 hover:bg-primary-dark transition shadow-lg shadow-primary/20 font-bold active:scale-95">
                        <span class="material-icons-round">add</span> 
                        Add Career Path
                    </a>
                </div>

                <div class="max-w-6xl mx-auto space-y-6">

                    <%-- 🌀 DYNAMIC DATABASE CONTENT --%>
                    <c:forEach var="path" items="${myPaths}">
                        <div class="roadmap-row-card group">
                            <div class="flex items-center gap-6 flex-1">
                                <%-- Logic for Dynamic Icon based on path category --%>
                                <div class="w-16 h-16 rounded-2xl flex items-center justify-center transition-all duration-500 shadow-sm
                                    ${path.category.contains('Web') ? 'bg-indigo-50 text-primary group-hover:bg-primary' : 
                                      path.category.contains('Java') ? 'bg-amber-50 text-amber-600 group-hover:bg-amber-600' : 
                                      'bg-purple-50 text-purple-600 group-hover:bg-purple-600'} group-hover:text-white">
                                    <i class="fas ${path.category.contains('Web') ? 'fa-code' : 
                                                   path.category.contains('Java') ? 'fa-server' : 'fa-layer-group'} text-2xl"></i>
                                </div>
                                
                                <div>
                                    <h3 class="text-lg font-800 text-gray-900 leading-tight">${path.title}</h3>
                                    <div class="flex flex-wrap items-center gap-4 mt-2">
                                        <span class="text-[10px] font-black uppercase text-gray-400 tracking-widest flex items-center gap-1">
                                            <span class="material-icons-round text-xs">layers</span> ${path.phaseCount} PHASES
                                        </span>
                                        <span class="text-[10px] font-black uppercase text-gray-400 tracking-widest flex items-center gap-1">
                                            <span class="material-icons-round text-xs">schedule</span> ${path.duration != null ? path.duration : 'N/A'}
                                        </span>
                                        <span class="px-3 py-1 rounded-full text-[9px] font-black uppercase tracking-widest border 
                                            ${path.status == 'PUBLISHED' || path.status == 'LIVE' ? 'status-live' : 'status-draft'}">
                                            ${path.status == 'PUBLISHED' ? 'LIVE' : path.status}
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <div class="flex items-center gap-3">
                                <%-- ✅ Link to UserController @GetMapping("/edit-path") --%>
                                <a href="<%=request.getContextPath()%>/user/edit-path?id=${path.id}" 
                                   class="w-10 h-10 rounded-xl bg-gray-50 text-gray-400 hover:bg-primary/10 hover:text-primary transition-all flex items-center justify-center shadow-sm"
                                   title="Edit Roadmap">
                                    <span class="material-icons-round text-lg">edit</span>
                                </a>
                                
                                <%-- ✅ Controller must handle POST /user/delete-path --%>
                                <form action="<%=request.getContextPath()%>/user/delete-path" method="POST" class="inline" onsubmit="return confirm('Are you sure you want to delete this roadmap permanently?')">
                                    <input type="hidden" name="pathId" value="${path.id}">
                                    <button type="submit" class="w-10 h-10 rounded-xl bg-gray-50 text-gray-400 hover:bg-red-50 hover:text-red-500 transition-all flex items-center justify-center shadow-sm" title="Delete">
                                        <span class="material-icons-round text-lg">delete</span>
                                    </button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>

                    <%-- Empty State if no roadmaps exist --%>
                    <c:if test="${empty myPaths}">
                        <div class="py-20 text-center bg-white border-2 border-dashed border-gray-100 rounded-[3rem]">
                            <div class="w-20 h-20 bg-gray-50 rounded-full flex items-center justify-center mx-auto mb-6">
                                <span class="material-icons-round text-4xl text-gray-200">add_road</span>
                            </div>
                            <h3 class="text-xl font-bold text-gray-400">No roadmaps discovered.</h3>
                            <p class="text-gray-300 text-sm mt-2 mb-8 max-w-xs mx-auto">Start sharing your expertise by launching your first structured learning path.</p>
                            <a href="<%=request.getContextPath()%>/user/create-path" class="text-primary font-bold hover:underline">Launch First Path</a>
                        </div>
                    </c:if>
                </div>

            </main>
        </div>
    </div>

    <%-- Success Feedback Toast --%>
    <div id="saveToast" class="fixed bottom-10 left-1/2 -translate-x-1/2 bg-gray-900 text-white px-8 py-4 rounded-2xl shadow-2xl z-[100] hidden items-center gap-3">
        <span class="material-icons-round text-green-400">verified</span>
        <span class="text-xs font-black uppercase tracking-[0.2em]">Platform Synchronized Successfully</span>
    </div>

    <script>
        // ✅ Show Toast if redirected with success parameter
        window.onload = function() {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.has('success') || urlParams.has('status')) {
                const toast = document.getElementById('saveToast');
                toast.classList.remove('hidden');
                toast.classList.add('flex', 'animate-pop');
                setTimeout(() => {
                    toast.classList.add('hidden');
                }, 3000);
            }
        }
    </script>

</body>
</html>