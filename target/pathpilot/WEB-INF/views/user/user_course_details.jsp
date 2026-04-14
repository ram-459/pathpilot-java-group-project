<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>${param.title} Roadmap - PathPilot</title>

    <%-- ✅ REQUIRED: Load the same fonts as the Navbar --%>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet"/>
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

        .timeline-line {
            width: 2px;
            background: #e5e7eb;
            position: absolute;
            top: 0;
            bottom: 0;
            left: 19px;
            z-index: 0;
        }
        .phase-card {
            @apply bg-white rounded-[2rem] border border-gray-100 p-8 shadow-sm relative z-10 transition-all duration-300 hover:shadow-md;
        }
    </style>
</head>

<body class="bg-[#f8f9fc] antialiased">

<%-- Calling the standardized horizontal navbar --%>
<jsp:include page="/WEB-INF/views/components/user_navbar.jsp"/>

<header class="max-w-5xl mx-auto px-6 pt-12 pb-8">
    <div class="flex flex-col md:flex-row md:items-center justify-between border-b border-gray-100 pb-12 gap-6">
        <div>
            <span class="text-[10px] font-black text-gray-400 uppercase tracking-[0.2em] flex items-center gap-2 mb-2">
                <span class="material-icons-round text-sm text-primary">school</span>
                Enrolled Course
            </span>

            <h1 class="text-4xl md:text-5xl font-800 text-gray-900 tracking-tight">
                ${param.title != null ? param.title : "Career Path"}
            </h1>

            <p class="text-gray-500 mt-3 font-medium">
                Master modern engineering from zero to job-ready professional.
            </p>
        </div>

        <%-- ✅ FIXED: Points to /user/enroll mapping --%>
        <a href="<%=request.getContextPath()%>/user/enroll?title=${param.title}"
           class="bg-primary hover:bg-primary-dark text-white px-8 py-4 rounded-2xl font-bold shadow-xl shadow-primary/20 transition-all flex items-center gap-2 active:scale-95">
            <span class="material-icons-round">add_task</span>
            Enroll Now
        </a>
    </div>
</header>



<main class="max-w-5xl mx-auto px-6 py-12 relative">

    <div class="timeline-line hidden md:block"></div>

    <div class="space-y-12">

        <div class="relative pl-0 md:pl-16 opacity-60">
            <div class="absolute left-4 top-0 hidden md:flex w-10 h-10 bg-gray-200 rounded-full items-center justify-center text-gray-400 z-20 shadow-inner">
                <span class="material-icons-round text-sm">lock</span>
            </div>

            <div class="phase-card">
                <div class="flex justify-between items-start mb-4">
                    <span class="text-[10px] font-black text-gray-400 uppercase tracking-widest">
                        Phase 1 • Locked
                    </span>
                    <span class="text-[10px] text-gray-400 font-black bg-gray-50 px-3 py-1 rounded-full uppercase tracking-widest">
                        4 Weeks
                    </span>
                </div>
                <h3 class="text-2xl font-800 text-gray-900">Foundational Basics</h3>
                <p class="text-sm text-gray-500 mt-2 font-medium">
                    Core building blocks including environment setup, version control, and basic architecture.
                </p>
            </div>
        </div>

        <div class="relative pl-0 md:pl-16 opacity-60">
            <div class="absolute left-4 top-0 hidden md:flex w-10 h-10 bg-gray-200 rounded-full items-center justify-center text-gray-400 z-20 shadow-inner">
                <span class="material-icons-round text-sm">lock</span>
            </div>

            <div class="phase-card">
                <div class="flex justify-between items-start mb-4">
                    <span class="text-[10px] font-black text-gray-400 uppercase tracking-widest">
                        Phase 2 • Locked
                    </span>
                    <span class="text-[10px] text-gray-400 font-black bg-gray-50 px-3 py-1 rounded-full uppercase tracking-widest">
                        6 Weeks
                    </span>
                </div>
                <h3 class="text-2xl font-800 text-gray-900">Advanced Logic</h3>
                <p class="text-sm text-gray-500 mt-2 font-medium">
                    Deep dive into core programming concepts, async patterns, and data manipulation.
                </p>
            </div>
        </div>

        <div class="relative pl-0 md:pl-16 opacity-60">
            <div class="absolute left-4 top-0 hidden md:flex w-10 h-10 bg-gray-200 rounded-full items-center justify-center text-gray-400 z-20 shadow-inner">
                <span class="material-icons-round text-sm">lock</span>
            </div>

            <div class="phase-card">
                <div class="flex justify-between items-start mb-4">
                    <span class="text-[10px] font-black text-gray-400 uppercase tracking-widest">
                        Phase 3 • Locked
                    </span>
                    <span class="text-[10px] text-gray-400 font-black bg-gray-50 px-3 py-1 rounded-full uppercase tracking-widest">
                        8 Weeks
                    </span>
                </div>
                <h3 class="text-2xl font-800 text-gray-900">Framework Mastery</h3>
                <p class="text-sm text-gray-500 mt-2 font-medium">
                    Building scalable industry-grade applications using modern frameworks and state management.
                </p>
            </div>
        </div>

    </div>
</main>

<%-- Footer inclusion --%>
<jsp:include page="/WEB-INF/views/components/user_footer.jsp"/>

</body>
</html>