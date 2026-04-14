<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    /**
     * Formal Security Guard: Ensures only authenticated Administrators can access the Features Manager.
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
    <title>Manage Platform Features | PathPilot Admin</title>

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
        
        /* Toast Animation Logic */
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
                    <span class="text-primary font-bold">Features Manager</span>
                </nav>
                <h1 class="text-2xl font-800 text-gray-900 tracking-tight">Configure Platform Features</h1>
            </div>
            
            <div class="flex gap-4">
                <%-- ✅ SYNCED: Professional Action Button --%>
                <button type="button" id="submitBtn" onclick="handleSaveAction()" class="bg-primary text-white px-8 py-3 rounded-2xl font-bold text-sm shadow-xl shadow-primary/20 hover:bg-primary-dark transition-all active:scale-95 flex items-center gap-2">
                    <span class="material-icons-round">auto_fix_high</span>
                    <span id="btnText">Update Features</span>
                </button>
            </div>
        </header>

        <main class="flex-1 overflow-y-auto pb-32">
            
            <form id="featuresForm" action="<%=request.getContextPath()%>/admin/manage-features" method="POST" class="max-w-5xl mx-auto px-12 py-12">
                
                <section class="config-card">
                    <h2 class="text-xl font-800 text-gray-900 mb-8 flex items-center gap-3">
                        <span class="w-8 h-8 rounded-lg bg-indigo-50 text-primary flex items-center justify-center">
                            <span class="material-icons-round text-sm">campaign</span>
                        </span>
                        Page Introduction
                    </h2>

                    <div class="space-y-6">
                        <div>
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Page Main Heading</label>
                            <input type="text" name="pageHeading" class="input-field" value="Why PathPilot?">
                        </div>
                        <div>
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Introductory Text</label>
                            <textarea name="pageIntro" rows="3" class="input-field resize-none">We've built a comprehensive ecosystem designed to take you from a curious beginner to a job-ready professional using structured mastery.</textarea>
                        </div>
                    </div>
                </section>

                <h2 class="text-xl font-800 text-gray-900 mb-8 px-2 tracking-tight">Manage Feature Sections</h2>
                
                <div id="featuresContainer">
                    <div class="config-card group border-l-4 border-l-primary">
                        <div class="flex justify-between items-start mb-8">
                            <h3 class="text-lg font-800 text-gray-900 flex items-center gap-2">
                                <span class="material-icons-round text-primary">dynamic_feed</span>
                                Section 1: Expert Roadmaps
                            </h3>
                            <button type="button" class="text-gray-300 hover:text-red-500 transition-colors">
                                <span class="material-icons-round">delete_outline</span>
                            </button>
                        </div>

                        <div class="grid md:grid-cols-2 gap-10">
                            <div class="space-y-6">
                                <div>
                                    <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Section Title</label>
                                    <input type="text" name="featTitle[]" class="input-field" value="Expert-Curated Roadmaps">
                                </div>
                                <div>
                                    <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Description</label>
                                    <textarea name="featDesc[]" rows="4" class="input-field resize-none">Stop wasting time on scattered tutorials. PathPilot organizes skills in the precise order industry experts demand.</textarea>
                                </div>
                            </div>

                            <div class="space-y-6 bg-gray-50/50 p-6 rounded-[2rem] border border-gray-100">
                                <div>
                                    <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-4 ml-1">Section Visual Accent</label>
                                    <div class="flex items-center gap-4">
                                        <input type="color" name="featColor[]" class="w-12 h-12 rounded-xl border-none p-1 bg-white shadow-sm cursor-pointer" value="#2eb086">
                                        <input type="text" name="featLabel[]" class="input-field bg-white" value="Web Development">
                                    </div>
                                </div>
                                <div>
                                    <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Icon Style</label>
                                    <select name="featIcon[]" class="input-field bg-white font-bold text-primary">
                                        <option value="code">Code (Programming)</option>
                                        <option value="school">School (Academics)</option>
                                        <option value="rocket">Rocket (Career)</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <button type="button" class="w-full py-8 border-2 border-dashed border-gray-200 rounded-[2.5rem] text-gray-400 font-bold flex flex-col items-center justify-center hover:border-primary/40 hover:text-primary hover:bg-white transition-all group">
                    <span class="material-icons-round text-4xl mb-2 group-hover:scale-110 transition-transform">add_task</span>
                    Add New Feature Section
                </button>

            </form>
        </main>
    </div>
</div>

<div id="saveToast" class="fixed bottom-10 left-1/2 -translate-x-1/2 bg-gray-900 text-white px-8 py-4 rounded-2xl shadow-2xl z-[100] hidden items-center gap-3">
    <span class="material-icons-round text-green-400">verified</span>
    <span class="text-sm font-bold">Platform features synchronized successfully!</span>
</div>

<script>
    /**
     * ✅ SYNCED: Form Submission Logic with UI Feedback.
     */
    function handleSaveAction() {
        const toast = document.getElementById('saveToast');
        const btn = document.getElementById('submitBtn');
        const btnText = document.getElementById('btnText');

        // Visual Interaction Feedback
        btn.classList.add('opacity-75', 'cursor-not-allowed');
        btnText.innerText = "Synchronizing...";
        
        // Notification Display
        toast.classList.remove('hidden');
        toast.classList.add('flex', 'animate-pop');
        
        // Strategic Delayed Submission
        setTimeout(() => {
            document.getElementById('featuresForm').submit();
        }, 1500);
    }
</script>

</body>
</html>