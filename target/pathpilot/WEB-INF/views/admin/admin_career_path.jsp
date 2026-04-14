<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<%
    // 🔐 CACHE CONTROL
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // 🔐 ADMIN SESSION CHECK (IMPORTANT)
    if(session == null || session.getAttribute("role") == null || 
       !"ADMIN".equals(session.getAttribute("role"))){

        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Career Roadmaps | PathPilot Admin</title>

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
    </style>
</head>

<body class="bg-bg-light antialiased overflow-hidden">

    <div class="flex h-screen">
        <%-- SIDEBAR --%>
        <%@ include file="/WEB-INF/views/components/admin_sidebar.jsp" %>

        <div class="flex-1 flex flex-col overflow-hidden">
            <header class="h-16 bg-white/80 backdrop-blur-md border-b border-gray-100 flex items-center justify-between px-10 z-20">
                <nav class="text-sm text-gray-400 flex items-center font-medium">
                    Admin
                    <span class="material-icons-round mx-2 text-xs">chevron_right</span>
                    <span class="text-primary font-bold">Manage Career Paths</span>
                </nav>
            </header>

            <main class="flex-1 overflow-y-auto p-10">
                
                <div class="max-w-6xl mx-auto flex flex-col md:flex-row justify-between items-center mb-10 gap-4">
                    <div>
                        <h1 class="text-3xl font-800 text-gray-900 tracking-tight">Career Path Management</h1>
                        <p class="text-gray-500 text-sm font-medium mt-1">Create and configure structured learning roadmaps for students.</p>
                    </div>
                    <a href="<%=request.getContextPath()%>/admin/create-path"
                       class="px-8 py-3.5 bg-primary text-white rounded-2xl flex items-center gap-2 hover:bg-primary-dark transition shadow-lg shadow-primary/20 font-bold active:scale-95">
                        <span class="material-icons-round">add</span> 
                        Add Career Path
                    </a>
                </div>

                <div class="max-w-6xl mx-auto space-y-6">

                    <div class="roadmap-row-card group">
                        <div class="flex items-center gap-6 flex-1">
                            <div class="w-16 h-16 bg-indigo-50 rounded-2xl flex items-center justify-center text-primary group-hover:bg-primary group-hover:text-white transition-all duration-500">
                                <i class="fas fa-code text-2xl"></i>
                            </div>
                            <div>
                                <h3 class="text-lg font-800 text-gray-900 leading-tight">Frontend Developer Masterclass</h3>
                                <div class="flex flex-wrap items-center gap-4 mt-2">
                                    <span class="text-[10px] font-black uppercase text-gray-400 tracking-widest flex items-center gap-1">
                                        <span class="material-icons-round text-xs">layers</span> 8 PHASES
                                    </span>
                                    <span class="text-[10px] font-black uppercase text-gray-400 tracking-widest flex items-center gap-1">
                                        <span class="material-icons-round text-xs">schedule</span> 4 MONTHS
                                    </span>
                                    <span class="px-3 py-1 bg-green-50 text-green-600 rounded-full text-[9px] font-black uppercase tracking-widest border border-green-100">Live</span>
                                </div>
                            </div>
                        </div>

                        <div class="flex items-center gap-3">
                            <a href="<%=request.getContextPath()%>/admin/edit-path" 
                               class="w-10 h-10 rounded-xl bg-gray-50 text-gray-400 hover:bg-primary/10 hover:text-primary transition-all flex items-center justify-center shadow-sm">
                                <span class="material-icons-round text-lg">edit</span>
                            </a>
                            <button class="w-10 h-10 rounded-xl bg-gray-50 text-gray-400 hover:bg-red-50 hover:text-red-500 transition-all flex items-center justify-center shadow-sm">
                                <span class="material-icons-round text-lg">delete</span>
                            </button>
                        </div>
                    </div>

                    <div class="roadmap-row-card group">
                        <div class="flex items-center gap-6 flex-1">
                            <div class="w-16 h-16 bg-amber-50 rounded-2xl flex items-center justify-center text-amber-600 group-hover:bg-amber-600 group-hover:text-white transition-all duration-500">
                                <i class="fas fa-server text-2xl"></i>
                            </div>
                            <div>
                                <h3 class="text-lg font-800 text-gray-900 leading-tight">Java Backend Engineering</h3>
                                <div class="flex flex-wrap items-center gap-4 mt-2">
                                    <span class="text-[10px] font-black uppercase text-gray-400 tracking-widest flex items-center gap-1">
                                        <span class="material-icons-round text-xs">layers</span> 12 PHASES
                                    </span>
                                    <span class="text-[10px] font-black uppercase text-gray-400 tracking-widest flex items-center gap-1">
                                        <span class="material-icons-round text-xs">schedule</span> 6 MONTHS
                                    </span>
                                    <span class="px-3 py-1 bg-indigo-50 text-indigo-600 rounded-full text-[9px] font-black uppercase tracking-widest border border-indigo-100">Draft</span>
                                </div>
                            </div>
                        </div>

                        <div class="flex items-center gap-3">
                            <a href="<%=request.getContextPath()%>/admin/edit-path" 
                               class="w-10 h-10 rounded-xl bg-gray-50 text-gray-400 hover:bg-primary/10 hover:text-primary transition-all flex items-center justify-center shadow-sm">
                                <span class="material-icons-round text-lg">edit</span>
                            </a>
                            <button class="w-10 h-10 rounded-xl bg-gray-50 text-gray-400 hover:bg-red-50 hover:text-red-500 transition-all flex items-center justify-center shadow-sm">
                                <span class="material-icons-round text-lg">delete</span>
                            </button>
                        </div>
                    </div>

                    <div class="roadmap-row-card group">
                        <div class="flex items-center gap-6 flex-1">
                            <div class="w-16 h-16 bg-purple-50 rounded-2xl flex items-center justify-center text-purple-600 group-hover:bg-purple-600 group-hover:text-white transition-all duration-500">
                                <i class="fas fa-layer-group text-2xl"></i>
                            </div>
                            <div>
                                <h3 class="text-lg font-800 text-gray-900 leading-tight">MERN Stack Mastery</h3>
                                <div class="flex flex-wrap items-center gap-4 mt-2">
                                    <span class="text-[10px] font-black uppercase text-gray-400 tracking-widest flex items-center gap-1">
                                        <span class="material-icons-round text-xs">layers</span> 20 PHASES
                                    </span>
                                    <span class="text-[10px] font-black uppercase text-gray-400 tracking-widest flex items-center gap-1">
                                        <span class="material-icons-round text-xs">schedule</span> 8 MONTHS
                                    </span>
                                    <span class="px-3 py-1 bg-green-50 text-green-600 rounded-full text-[9px] font-black uppercase tracking-widest border border-green-100">Live</span>
                                </div>
                            </div>
                        </div>

                        <div class="flex items-center gap-3">
                            <a href="<%=request.getContextPath()%>/admin/edit-path" 
                               class="w-10 h-10 rounded-xl bg-gray-50 text-gray-400 hover:bg-primary/10 hover:text-primary transition-all flex items-center justify-center shadow-sm">
                                <span class="material-icons-round text-lg">edit</span>
                            </a>
                            <button class="w-10 h-10 rounded-xl bg-gray-50 text-gray-400 hover:bg-red-50 hover:text-red-500 transition-all flex items-center justify-center shadow-sm">
                                <span class="material-icons-round text-lg">delete</span>
                            </button>
                        </div>
                    </div>
                </div>

            </main>
        </div>
    </div>

</body>
</html>