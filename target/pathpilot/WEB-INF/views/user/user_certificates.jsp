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
    <title>My Achievements | PathPilot</title>

    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Great+Vibes&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet"/>

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
                        sans:['Plus Jakarta Sans','sans-serif'],
                        script:['Great Vibes','cursive']
                    }
                }
            }
        }
    </script>

    <style type="text/tailwindcss">
        body { font-family: 'Plus Jakarta Sans', sans-serif; }
        .cert-card { 
            @apply bg-white rounded-[2rem] p-8 border border-gray-100 shadow-sm transition-all duration-300 
            hover:shadow-xl hover:-translate-y-1 border-b-4 border-b-transparent hover:border-b-primary; 
        }
        .icon-shield {
            @apply w-12 h-12 rounded-xl bg-indigo-50 text-primary flex items-center justify-center mb-6;
        }
    </style>
</head>

<body class="bg-bg-main min-h-screen flex antialiased">

    <jsp:include page="/WEB-INF/views/components/user_sidebar.jsp"/>

    <main class="flex-grow p-8 lg:p-12">
        
        <header class="max-w-6xl mx-auto mb-12">
            <span class="bg-indigo-50 text-primary px-4 py-1.5 rounded-full text-[10px] font-black uppercase tracking-widest border border-indigo-100">
                Academic Achievements
            </span>
            <h1 class="text-4xl font-800 text-gray-900 mt-6 tracking-tight">Certification Vault</h1>
            <p class="text-gray-500 mt-2 font-medium">Verify, download, and share your industry-standard credentials.</p>
        </header>

        <div class="max-w-6xl mx-auto grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            
            <div class="cert-card">
                <div class="icon-shield">
                    <span class="material-icons-round">verified_user</span>
                </div>
                <h3 class="text-lg font-800 text-gray-900 leading-tight mb-2">Frontend Development Masterclass</h3>
                <p class="text-[10px] font-black uppercase text-gray-400 tracking-widest mb-6">Issued: Feb 19, 2026</p>
                
                <div class="flex items-center gap-3">
                    <button class="flex-1 bg-primary text-white py-3 rounded-xl font-bold text-xs hover:bg-primary-dark transition-all">
                        VIEW CERT
                    </button>
                    <button class="w-11 h-11 border border-gray-100 text-gray-400 rounded-xl hover:bg-gray-50 flex items-center justify-center">
                        <span class="material-icons-round text-sm">download</span>
                    </button>
                </div>
            </div>

            <div class="cert-card">
                <div class="icon-shield">
                    <span class="material-icons-round">settings_suggest</span>
                </div>
                <h3 class="text-lg font-800 text-gray-900 leading-tight mb-2">Java Backend Engineering</h3>
                <p class="text-[10px] font-black uppercase text-gray-400 tracking-widest mb-6">Issued: Jan 12, 2026</p>
                
                <div class="flex items-center gap-3">
                    <button class="flex-1 bg-primary text-white py-3 rounded-xl font-bold text-xs hover:bg-primary-dark transition-all">
                        VIEW CERT
                    </button>
                    <button class="w-11 h-11 border border-gray-100 text-gray-400 rounded-xl hover:bg-gray-50 flex items-center justify-center">
                        <span class="material-icons-round text-sm">download</span>
                    </button>
                </div>
            </div>

            <div class="cert-card">
                <div class="icon-shield">
                    <span class="material-icons-round">cloud_done</span>
                </div>
                <h3 class="text-lg font-800 text-gray-900 leading-tight mb-2">Cloud Infrastructure Associate</h3>
                <p class="text-[10px] font-black uppercase text-gray-400 tracking-widest mb-6">Issued: Dec 05, 2025</p>
                
                <div class="flex items-center gap-3">
                    <button class="flex-1 bg-primary text-white py-3 rounded-xl font-bold text-xs hover:bg-primary-dark transition-all">
                        VIEW CERT
                    </button>
                    <button class="w-11 h-11 border border-gray-100 text-gray-400 rounded-xl hover:bg-gray-50 flex items-center justify-center">
                        <span class="material-icons-round text-sm">download</span>
                    </button>
                </div>
            </div>

        </div>

        <div class="hidden max-w-6xl mx-auto py-20 text-center border-2 border-dashed border-gray-200 rounded-[3rem] mt-12">
            <span class="material-icons-round text-gray-200 text-6xl">workspace_premium</span>
            <p class="text-gray-400 font-bold mt-4">Complete a roadmap to unlock your first certificate!</p>
        </div>

    </main>

</body>
</html>