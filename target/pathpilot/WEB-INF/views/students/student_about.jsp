<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // 🔐 SESSION + CACHE FIX (NO UI CHANGE)
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
    <title>About PathPilot | Student Portal</title>
    
    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet"/>

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: { 
                        primary: "#4913ec",
                        "primary-dark": "#3a0fb5",
                    },
                    fontFamily: { sans: ["'Plus Jakarta Sans'", "sans-serif"] }
                }
            }
        }
    </script>

    <style type="text/tailwindcss">
        body { font-family: 'Plus Jakarta Sans', sans-serif; }
        .text-gradient {
            @apply bg-clip-text text-transparent bg-gradient-to-r from-indigo-600 to-purple-600;
        }
        .glass-card {
            @apply bg-white/80 backdrop-blur-md border border-white shadow-xl;
        }
    </style>
</head>

<body class="bg-[#f8f9fc] text-gray-900 antialiased">

<jsp:include page="/WEB-INF/views/components/user_navbar.jsp"/>

<section class="relative bg-gradient-to-br from-indigo-700 via-primary to-purple-800 text-white py-32 px-6 overflow-hidden">
    <div class="absolute inset-0 opacity-10 bg-[url('https://www.transparenttextures.com/patterns/cubes.png')]"></div>
    
    <div class="max-w-6xl mx-auto text-center relative z-10">
        <span class="bg-white/10 border border-white/20 px-6 py-2 rounded-full text-[10px] font-black uppercase tracking-[0.2em]">
            Member Insights
        </span>
        <h1 class="text-5xl md:text-7xl font-800 mt-10 leading-[1.1] tracking-tight">
            Elevate Your <span class="text-yellow-300">Potential</span><br>
            Master Your <span class="text-white underline decoration-yellow-400 decoration-4 underline-offset-8">Future</span>
        </h1>
        <p class="text-indigo-100 text-lg max-w-2xl mx-auto mt-8 font-medium leading-relaxed">
            You're not just a student; you're an engineer in training. PathPilot provides the structure you need to move from theory to high-performance mastery.
        </p>
    </div>
</section>

<section class="max-w-5xl mx-auto px-6 -mt-20 relative z-20">
    <div class="glass-card rounded-[2.5rem] p-12 text-center">
        <h2 class="text-3xl md:text-4xl font-800 mb-6 text-gray-900 tracking-tight">
            Bridging the gap between<br>
            <span class="text-gradient uppercase text-sm tracking-widest font-black">College & Corporate</span>
        </h2>
        <p class="text-gray-500 max-w-3xl mx-auto leading-relaxed font-medium">
            Standard curriculums often lag behind tech trends. We simplify career building by converting complex industry expectations into clear, step-by-step learning paths.
        </p>
    </div>
</section>

<section class="max-w-6xl mx-auto grid grid-cols-2 md:grid-cols-4 gap-8 py-24 px-6">
    <div class="bg-white p-10 rounded-3xl shadow-sm text-center border border-gray-100 group transition-all">
        <p class="text-5xl font-800 text-primary group-hover:scale-110 transition-transform">500+</p>
        <p class="text-[10px] font-black text-gray-400 mt-4 uppercase tracking-widest">Roadmaps</p>
    </div>
    <div class="bg-white p-10 rounded-3xl shadow-sm text-center border border-gray-100 group transition-all">
        <p class="text-5xl font-800 text-primary group-hover:scale-110 transition-transform">10K+</p>
        <p class="text-[10px] font-black text-gray-400 mt-4 uppercase tracking-widest">Engineers</p>
    </div>
    <div class="bg-white p-10 rounded-3xl shadow-sm text-center border border-gray-100 group transition-all">
        <p class="text-5xl font-800 text-primary group-hover:scale-110 transition-transform">50+</p>
        <p class="text-[10px] font-black text-gray-400 mt-4 uppercase tracking-widest">Mentors</p>
    </div>
    <div class="bg-white p-10 rounded-3xl shadow-sm text-center border border-gray-100 group transition-all">
        <p class="text-5xl font-800 text-primary group-hover:scale-110 transition-transform">100%</p>
        <p class="text-[10px] font-black text-gray-400 mt-4 uppercase tracking-widest">Placement Focus</p>
    </div>
</section> 

<section class="bg-gray-900 text-white py-28 text-center relative overflow-hidden">
    <div class="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-primary to-purple-600"></div>
    <h2 class="text-4xl md:text-5xl font-800 mb-10 tracking-tight">
        Ready to take the next step? 🚀
    </h2>

    <div class="flex justify-center gap-6 flex-wrap">
        <a href="<%=request.getContextPath()%>/user/career"
           class="bg-primary hover:bg-primary-dark text-white px-10 py-5 rounded-2xl font-bold shadow-xl shadow-primary/20 transition-all active:scale-95">
           View My Roadmaps 
        </a>

        <a href="<%=request.getContextPath()%>/user/contact"
           class="bg-white/10 hover:bg-white/20 border border-white/20 px-10 py-5 rounded-2xl font-bold transition-all">
           Get Support 
        </a>
    </div>
</section>

<jsp:include page="/WEB-INF/views/components/student_footer.jsp"/>

<script>
    const notifBtn = document.getElementById("notifBtn");
    notifBtn.addEventListener("click", (e) => {
        alert("You have new course updates!");
    });
</script>

</body>
</html>