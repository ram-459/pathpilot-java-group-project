<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    /**
     * Formal Security Guard: Ensures only authenticated Administrators can access the About Content Manager.
     */
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if(session == null || session.getAttribute("role") == null || !"ADMIN".equals(session.getAttribute("role"))){
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage About Content | PathPilot Admin</title>

    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet"/>

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
        .input-field { @apply w-full bg-gray-50 border-none rounded-2xl px-5 py-4 focus:ring-2 focus:ring-primary/20 transition-all outline-none font-medium text-sm; }
        .config-card { @apply bg-white rounded-[2.5rem] p-10 border border-gray-100 shadow-sm mb-10 relative transition-all duration-300 hover:shadow-lg; }
        
        /* Toast Notification Animation */
        @keyframes slideUp { from { transform: translate(-50%, 100%); opacity: 0; } to { transform: translate(-50%, 0); opacity: 1; } }
        .animate-pop { animation: slideUp 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275) forwards; }
    </style>
</head>

<body class="bg-bg-light antialiased overflow-hidden">

<div class="flex h-screen">

    <%@ include file="/WEB-INF/views/components/admin_sidebar.jsp" %>

    <div class="flex-1 flex flex-col overflow-hidden">

        <header class="sticky top-0 z-30 bg-white/80 backdrop-blur-md border-b border-gray-100 px-12 py-5 flex items-center justify-between">
            <div>
                <nav class="flex text-[10px] font-black uppercase tracking-widest text-gray-400 mb-1">
                    <span>Admin</span>
                    <span class="mx-2">/</span>
                    <span class="text-primary font-bold">About Manager</span>
                </nav>
                <h1 class="text-2xl font-800 text-gray-900 tracking-tight">Configure About Page</h1>
            </div>
            
            <div class="flex gap-4">
                <%-- ✅ SYNCED: High-Quality Action Trigger --%>
                <button type="button" id="submitBtn" onclick="handleSaveAction()" class="bg-primary text-white px-8 py-3 rounded-2xl font-bold text-sm shadow-xl shadow-primary/20 hover:bg-primary-dark transition-all active:scale-95 flex items-center gap-2">
                    <span class="material-icons-round">auto_fix_high</span>
                    <span id="btnText">Update Content</span>
                </button>
            </div>
        </header>

        <main class="flex-1 overflow-y-auto pb-32">
            
            <form id="aboutForm" action="<%=request.getContextPath()%>/admin/manage-about" method="POST" class="max-w-5xl mx-auto px-12 py-12">
                
                <section class="config-card">
                    <h2 class="text-xl font-800 text-gray-900 mb-8 flex items-center gap-3">
                        <span class="w-8 h-8 rounded-lg bg-indigo-50 text-primary flex items-center justify-center">
                            <span class="material-icons-round text-sm">auto_awesome</span>
                        </span>
                        Hero & Main Messaging
                    </h2>

                    <div class="space-y-6">
                        <div>
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Main Headline</label>
                            <input type="text" name="aboutHeroTitle" class="input-field" value="Elevate Your Potential, Master Your Future">
                        </div>
                        <div>
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Description Paragraph</label>
                            <textarea name="aboutHeroDesc" rows="3" class="input-field resize-none">You're not just a student; you're an engineer in training. PathPilot provides the structure you need.</textarea>
                        </div>
                        <div class="grid md:grid-cols-2 gap-6 pt-4 border-t border-gray-50">
                            <div>
                                <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Mission Headline</label>
                                <input type="text" name="missionTitle" class="input-field" value="Bridging the gap between College & Corporate">
                            </div>
                            <div>
                                <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Mission Tagline</label>
                                <input type="text" name="missionTag" class="input-field" value="PathPilot Mastery">
                            </div>
                        </div>
                    </div>
                </section>

                <section class="config-card">
                    <h2 class="text-xl font-800 text-gray-900 mb-8 flex items-center gap-3">
                        <span class="w-8 h-8 rounded-lg bg-indigo-50 text-primary flex items-center justify-center">
                            <span class="material-icons-round text-sm">analytics</span>
                        </span>
                        Platform Statistics
                    </h2>

                    <div class="grid grid-cols-2 md:grid-cols-4 gap-6">
                        <div class="space-y-4">
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block ml-1 text-center">Roadmaps</label>
                            <input type="text" name="statVal1" class="input-field text-center font-bold text-primary" value="500+">
                            <input type="text" name="statLabel1" class="input-field text-[10px] text-center uppercase tracking-widest" value="Roadmaps">
                        </div>
                        <div class="space-y-4">
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block ml-1 text-center">Users</label>
                            <input type="text" name="statVal2" class="input-field text-center font-bold text-primary" value="10K+">
                            <input type="text" name="statLabel2" class="input-field text-[10px] text-center uppercase tracking-widest" value="Engineers">
                        </div>
                        <div class="space-y-4">
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block ml-1 text-center">Mentors</label>
                            <input type="text" name="statVal3" class="input-field text-center font-bold text-primary" value="50+">
                            <input type="text" name="statLabel3" class="input-field text-[10px] text-center uppercase tracking-widest" value="Mentors">
                        </div>
                        <div class="space-y-4">
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block ml-1 text-center">Success</label>
                            <input type="text" name="statVal4" class="input-field text-center font-bold text-primary" value="100%">
                            <input type="text" name="statLabel4" class="input-field text-[10px] text-center uppercase tracking-widest" value="Placement Focus">
                        </div>
                    </div>
                </section>

                <section class="config-card bg-gray-900 border-none shadow-2xl">
                    <h2 class="text-xl font-800 text-white mb-8 flex items-center gap-3">
                        <span class="w-8 h-8 rounded-lg bg-white/10 text-white flex items-center justify-center">
                            <span class="material-icons-round text-sm">rocket_launch</span>
                        </span>
                        Footer Call-to-Action
                    </h2>

                    <div class="space-y-6">
                        <div>
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">CTA Heading</label>
                            <input type="text" name="ctaHeading" class="input-field bg-white/5 text-white" value="Ready to take the next step? 🚀">
                        </div>
                        <div class="grid md:grid-cols-2 gap-6">
                            <div>
                                <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Primary Button Label</label>
                                <input type="text" name="ctaBtn1" class="input-field bg-white/5 text-white" value="View My Roadmaps">
                            </div>
                            <div>
                                <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Secondary Button Label</label>
                                <input type="text" name="ctaBtn2" class="input-field bg-white/5 text-white" value="Get Support">
                            </div>
                        </div>
                    </div>
                </section>

            </form>
        </main>
    </div>
</div>

<div id="saveToast" class="fixed bottom-10 left-1/2 -translate-x-1/2 bg-gray-900 text-white px-8 py-4 rounded-2xl shadow-2xl z-[100] hidden items-center gap-3">
    <span class="material-icons-round text-green-400">verified</span>
    <span class="text-sm font-bold">About Page content updated and synced!</span>
</div>

<script>
    /**
     * ✅ SYNCED: Form Submission Handler with UX Feedback.
     */
    function handleSaveAction() {
        const toast = document.getElementById('saveToast');
        const btn = document.getElementById('submitBtn');
        const btnText = document.getElementById('btnText');

        // Visual Interaction Lock
        btn.classList.add('opacity-75', 'cursor-not-allowed');
        btnText.innerText = "Synchronizing...";
        
        // Notification Display
        toast.classList.remove('hidden');
        toast.classList.add('flex', 'animate-pop');
        
        // Execution Delay for UI Polishing
        setTimeout(() => {
            document.getElementById('aboutForm').submit();
        }, 1500);
    }
</script>

</body>
</html>