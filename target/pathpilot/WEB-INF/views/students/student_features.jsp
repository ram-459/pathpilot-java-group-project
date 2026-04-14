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
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Platform Features - PathPilot</title>

    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Poppins:wght@500;600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet"/>

    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>

    <script>
        tailwind.config = {
            theme:{
                extend:{
                    colors:{
                        primary:"#4913ec",
                        "primary-dark":"#3a0fb5"
                    },
                    fontFamily:{
                        sans:['Plus Jakarta Sans','sans-serif'],
                        heading:['Poppins','sans-serif']
                    }
                }
            }
        }
    </script>

    <style type="text/tailwindcss">
        body{font-family:'Plus Jakarta Sans',sans-serif;}
        h1,h2,h3,h4{font-family:'Poppins',sans-serif;}
    </style>
</head>

<body class="bg-[#f8f9fc] antialiased">

<%-- This call ensures the exact same navbar design is used --%>
<jsp:include page="/WEB-INF/views/components/user_navbar.jsp"/>

<header class="max-w-7xl mx-auto px-6 py-24">
    <span class="bg-indigo-50 text-primary px-4 py-2 rounded-full text-[10px] font-black uppercase tracking-widest border border-indigo-100">
        Platform Ecosystem
    </span>

    <h1 class="text-5xl md:text-7xl font-800 text-gray-900 mt-10 mb-8 leading-[1.1] tracking-tight">
        Why PathPilot?
    </h1>

    <p class="text-gray-500 text-lg max-w-2xl leading-relaxed font-medium">
        We've built a comprehensive ecosystem designed to take you from a curious beginner to a job-ready professional using structured mastery.
    </p>

    <div class="flex gap-4 mt-12">
        <a href="<%=request.getContextPath()%>/student/career"
           class="bg-primary hover:bg-primary-dark text-white px-10 py-5 rounded-2xl font-bold shadow-xl shadow-primary/20 transition-all active:scale-95">
            Start Exploring 
        </a>
    </div>
</header>

<main class="space-y-32 pb-32">
    <section class="max-w-7xl mx-auto px-6 grid md:grid-cols-2 gap-20 items-center">
        
        <div class="bg-[#2eb086] rounded-[3rem] p-16 shadow-2xl relative overflow-hidden group">
            <div class="absolute inset-0 bg-white/10 opacity-0 group-hover:opacity-100 transition-opacity duration-500"></div>
            <div class="border-4 border-white/30 rounded-3xl p-10 text-center relative z-10">
                <h4 class="text-white text-5xl font-black uppercase tracking-[0.2em]">Web</h4>
                <p class="text-white/80 font-black mt-4 tracking-[0.3em] uppercase text-xs">Development</p>
            </div>
        </div>

        <div class="max-w-lg">
            <h2 class="text-4xl font-800 text-gray-900 mb-6 tracking-tight">
                Expert-Curated Roadmaps
            </h2>
            <p class="text-gray-500 text-lg leading-relaxed font-medium">
                Stop wasting time on scattered, outdated tutorials. PathPilot organizes skills in the precise order industry experts demand, ensuring every hour you study counts.
            </p>
            <div class="mt-10 space-y-4">
                <div class="flex items-center gap-3 text-sm font-bold text-gray-700">
                    <span class="material-icons-round text-primary">check_circle</span>
                    Step-by-step skill progression
                </div>
                <div class="flex items-center gap-3 text-sm font-bold text-gray-700">
                    <span class="material-icons-round text-primary">check_circle</span>
                    Real-world project benchmarks
                </div>
            </div>
        </div>
    </section>
</main>

<jsp:include page="/WEB-INF/views/components/student_footer.jsp"/>

</body>
</html>