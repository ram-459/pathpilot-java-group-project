<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // 🔐 CACHE CONTROL
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // 🔐 ADMIN SESSION CHECK
    if(session == null || session.getAttribute("role") == null || !"ADMIN".equals(session.getAttribute("role"))){
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - PathPilot</title>

    <!-- ✅ MATCHING FONTS: Plus Jakarta Sans & Poppins -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet"/>
    
    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>

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
        /* ✅ MATCHING GLOBAL STYLES */
        body { font-family: 'Plus Jakarta Sans', sans-serif; }
        h1, h2, h3, .font-heading { font-family: 'Poppins', sans-serif; }
        
        .stat-card { @apply bg-white p-8 rounded-[2rem] border border-gray-100 shadow-sm hover:shadow-lg transition-all duration-300; }
    </style>
</head>

<body class="bg-bg-light antialiased overflow-hidden">

<div class="flex h-screen">

    <!-- ✅ Sidebar (Now inherits correct fonts) -->
    <%@ include file="/WEB-INF/views/components/admin_sidebar.jsp" %>

    <div class="flex-1 flex flex-col h-screen overflow-hidden">

        <!-- Header matching the Builder style -->
        <header class="h-20 bg-white/80 backdrop-blur-md border-b border-gray-100 flex items-center justify-between px-12 sticky top-0 z-10">
            <div>
                <nav class="text-[10px] font-black uppercase tracking-widest text-gray-400 mb-1 flex items-center">
                    <span>Admin</span>
                    <span class="material-icons-round text-xs mx-2">chevron_right</span>
                    <span class="text-primary font-bold">Dashboard</span>
                </nav>
                <h1 class="text-xl font-800 text-gray-900 tracking-tight">Overview</h1>
            </div>

            <div class="flex items-center gap-6">
                <button class="relative p-2.5 bg-gray-50 text-gray-400 hover:text-primary rounded-xl transition-colors">
                    <span class="material-icons-round text-xl">notifications</span>
                    <span class="absolute top-2 right-2 w-2 h-2 bg-red-500 border-2 border-white rounded-full"></span>
                </button>

                <div class="h-8 w-[1px] bg-gray-100"></div>

                <div class="flex items-center gap-3">
    <div class="text-right hidden sm:block">
        <p class="text-xs font-800 text-gray-900">Administrator</p>
        <p class="text-[10px] font-bold text-gray-400 uppercase tracking-tighter">Super User</p>
    </div>
    <img class="h-10 w-10 rounded-2xl object-cover border-2 border-white shadow-sm"
         src="${pageContext.request.contextPath}/assets/images/rpk.jpg" 
         alt="Admin Avatar" />
</div>
            </div>
        </header>

        <main class="flex-1 overflow-y-auto p-12 space-y-12">

            <!-- Welcome Section -->
            <div>
                <h1 class="text-3xl font-800 text-gray-900 tracking-tight">
                    Welcome back Admin 👋
                </h1>
                <p class="text-gray-500 font-medium mt-1">
                    Here’s a snapshot of PathPilot’s performance today.
                </p>
            </div>

            <!-- Stats Grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-8">

                <!-- Users -->
                <div class="stat-card">
                    <div class="flex items-center justify-between mb-6">
                        <div class="w-12 h-12 bg-indigo-50 text-primary rounded-2xl flex items-center justify-center">
                            <span class="material-icons-round">groups</span>
                        </div>
                        <span class="px-3 py-1 bg-green-50 text-green-600 rounded-full text-[10px] font-black uppercase tracking-widest">+12%</span>
                    </div>
                    <h2 class="text-3xl font-800 text-gray-900 tracking-tighter">1,284</h2>
                    <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest mt-2">Total Users</p>
                </div>

                <!-- Career Paths -->
                <div class="stat-card">
                    <div class="flex items-center justify-between mb-6">
                        <div class="w-12 h-12 bg-purple-50 text-purple-600 rounded-2xl flex items-center justify-center">
                            <span class="material-icons-round">route</span>
                        </div>
                        <span class="px-3 py-1 bg-green-50 text-green-600 rounded-full text-[10px] font-black uppercase tracking-widest">+5%</span>
                    </div>
                    <h2 class="text-3xl font-800 text-gray-900 tracking-tighter">42</h2>
                    <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest mt-2">Career Paths</p>
                </div>

                <!-- Enrollments -->
                <div class="stat-card">
                    <div class="flex items-center justify-between mb-6">
                        <div class="w-12 h-12 bg-blue-50 text-blue-600 rounded-2xl flex items-center justify-center">
                            <span class="material-icons-round">school</span>
                        </div>
                        <span class="px-3 py-1 bg-green-50 text-green-600 rounded-full text-[10px] font-black uppercase tracking-widest">+18%</span>
                    </div>
                    <h2 class="text-3xl font-800 text-gray-900 tracking-tighter">3,920</h2>
                    <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest mt-2">Enrollments</p>
                </div>

                <!-- Revenue -->
                <div class="stat-card">
                    <div class="flex items-center justify-between mb-6">
                        <div class="w-12 h-12 bg-green-50 text-green-600 rounded-2xl flex items-center justify-center">
                            <span class="material-icons-round">payments</span>
                        </div>
                        <span class="px-3 py-1 bg-gray-50 text-gray-400 rounded-full text-[10px] font-black uppercase tracking-widest">Global</span>
                    </div>
                    <h2 class="text-3xl font-800 text-gray-900 tracking-tighter">Free</h2>
                    <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest mt-2">Platform Plan</p>
                </div>
            </div>

            <!-- Activity Section -->
            <div class="bg-white p-10 rounded-[2.5rem] border border-gray-100 shadow-sm">
                <h2 class="text-xl font-800 text-gray-900 mb-8 tracking-tight">Recent Activity</h2>

                <div class="space-y-6">
                    <div class="flex items-center justify-between p-5 bg-gray-50 rounded-2xl">
                        <div class="flex items-center gap-4">
                            <div class="w-2 h-2 bg-primary rounded-full"></div>
                            <span class="text-sm font-medium text-gray-600">New user registered — Rahul Sharma</span>
                        </div>
                        <span class="text-[10px] font-bold text-gray-400 uppercase">2 min ago</span>
                    </div>

                    <div class="flex items-center justify-between p-5 bg-gray-50 rounded-2xl">
                        <div class="flex items-center gap-4">
                            <div class="w-2 h-2 bg-purple-500 rounded-full"></div>
                            <span class="text-sm font-medium text-gray-600">Frontend Path updated by Admin</span>
                        </div>
                        <span class="text-[10px] font-bold text-gray-400 uppercase">1 hr ago</span>
                    </div>

                    <div class="flex items-center justify-between p-5 bg-gray-50 rounded-2xl">
                        <div class="flex items-center gap-4">
                            <div class="w-2 h-2 bg-green-500 rounded-full"></div>
                            <span class="text-sm font-medium text-gray-600">New certificate issued to Priya Singh</span>
                        </div>
                        <span class="text-[10px] font-bold text-gray-400 uppercase">Today</span>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

</body>
</html>