<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    /**
     * Formal Security Guard: Ensures only authenticated Administrators can access.
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
    <title>Manage Home Content | PathPilot Admin</title>

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
        .config-card { @apply bg-white rounded-[2.5rem] p-10 border border-gray-100 shadow-sm mb-8 relative transition-all duration-300 hover:shadow-lg; }
        
        /* Toast Animation */
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
                    <span class="text-primary font-bold">Content Manager</span>
                </nav>
                <h1 class="text-2xl font-800 text-gray-900 tracking-tight">Manage Home Content</h1>
            </div>
            
            <div class="flex gap-4">
                <select id="roleSelector" onchange="switchContext(this.value)" class="bg-gray-100 border-none rounded-xl text-[10px] font-black uppercase tracking-widest px-6 py-3 cursor-pointer focus:ring-0">
                    <option value="student">Student Home</option>
                    <option value="guest">Guest Home</option>
                </select>

                <%-- ✅ SYNCED: Professional Action Button --%>
                <button type="button" id="submitBtn" onclick="handleSaveAction()" class="bg-primary text-white px-8 py-3 rounded-2xl font-bold text-sm shadow-xl shadow-primary/20 hover:bg-primary-dark transition-all active:scale-95 flex items-center gap-2">
                    <span class="material-icons-round">cloud_done</span>
                    <span id="btnText">Update Content</span>
                </button>
            </div>
        </header>

        <main class="flex-1 overflow-y-auto pb-32">
            
            <form id="contentForm" action="<%=request.getContextPath()%>/admin/manage-home" method="POST" enctype="multipart/form-data" class="max-w-5xl mx-auto px-12 py-12">
                
                <section class="config-card">
                    <h2 class="text-xl font-800 text-gray-900 mb-8 flex items-center gap-3">
                        <span class="w-8 h-8 rounded-lg bg-indigo-50 text-primary flex items-center justify-center">
                            <span class="material-icons-round text-sm">text_fields</span>
                        </span>
                        Hero Section Content
                    </h2>

                    <div class="space-y-8">
                        <div>
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Main Heading (Hero Title)</label>
                            <input type="text" id="heroTitle" name="heroTitle" class="input-field" value="Continue Your IT Career Journey 🚀">
                        </div>
                        <div>
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Sub-heading (Hero Description)</label>
                            <textarea id="heroDesc" name="heroDesc" rows="3" class="input-field resize-none">Track progress, explore learning paths, and unlock projects tailored to your goals.</textarea>
                        </div>
                    </div>
                </section>

                <section class="config-card">
                    <h2 class="text-xl font-800 text-gray-900 mb-8 flex items-center gap-3">
                        <span class="w-8 h-8 rounded-lg bg-indigo-50 text-primary flex items-center justify-center">
                            <span class="material-icons-round text-sm">image</span>
                        </span>
                        Hero Visuals and Media
                    </h2>

                    <div class="grid md:grid-cols-2 gap-10">
                        <div>
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-4 ml-1">Hero Background Image</label>
                            <div class="relative group cursor-pointer border-2 border-dashed border-gray-100 rounded-3xl p-4 hover:border-primary/30 transition-all bg-gray-50/50">
                                <img id="heroPreview" src="https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?q=80&w=600&auto=format&fit=crop" class="w-full h-48 object-cover rounded-2xl shadow-sm">
                                <input type="file" name="heroImg" class="absolute inset-0 opacity-0 cursor-pointer" onchange="previewHero(this)">
                                <div class="absolute inset-0 bg-primary/20 opacity-0 group-hover:opacity-100 rounded-2xl flex items-center justify-center transition-all">
                                    <span class="bg-white text-primary p-3 rounded-full shadow-xl">
                                        <span class="material-icons-round">add_photo_alternate</span>
                                    </span>
                                </div>
                            </div>
                        </div>

                        <div class="space-y-6">
                            <div>
                                <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Dashboard Badge Text</label>
                                <input type="text" id="badgeText" name="badgeText" class="input-field" value="Member Dashboard">
                            </div>
                            <div>
                                <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Hero Gradient Theme</label>
                                <select name="themeGradient" class="input-field font-bold text-primary">
                                    <option value="indigo-purple">Indigo to Purple</option>
                                    <option value="blue-cyan">Ocean Blue</option>
                                    <option value="dark-slate">Midnight Slate</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </section>

            </form>
        </main>
    </div>
</div>

<%-- ✅ SYNCED: Professional Toast Component --%>
<div id="saveToast" class="fixed bottom-10 left-1/2 -translate-x-1/2 bg-gray-900 text-white px-8 py-4 rounded-2xl shadow-2xl z-[100] hidden items-center gap-3">
    <span class="material-icons-round text-green-400">verified</span>
    <span class="text-sm font-bold">Home Page content synchronized!</span>
</div>

<script>
    /**
     * Context Switching Logic for localized content management.
     */
    function switchContext(role) {
        const titleInput = document.getElementById('heroTitle');
        const descInput = document.getElementById('heroDesc');
        const badgeInput = document.getElementById('badgeText');

        if (role === 'guest') {
            titleInput.value = "Chart Your Path in Tech 🧭";
            descInput.value = "Expert-curated roadmaps to take you from student to industry professional.";
            badgeInput.value = "Welcome to PathPilot";
        } else {
            titleInput.value = "Continue Your IT Career Journey 🚀";
            descInput.value = "Track progress, explore learning paths, and unlock projects tailored to your goals.";
            badgeInput.value = "Member Dashboard";
        }
    }

    /**
     * Client-side media preview logic.
     */
    function previewHero(input) {
        if (input.files && input.files[0]) {
            let reader = new FileReader();
            reader.onload = e => {
                document.getElementById('heroPreview').src = e.target.result;
            };
            reader.readAsDataURL(input.files[0]);
        }
    }

    /**
     * ✅ SYNCED: Form Submission Trigger with UI feedback.
     */
    function handleSaveAction() {
        const toast = document.getElementById('saveToast');
        const btn = document.getElementById('submitBtn');
        const btnText = document.getElementById('btnText');

        // Visual Feedback
        btn.classList.add('opacity-75', 'cursor-not-allowed');
        btnText.innerText = "Synchronizing...";
        
        // Show Success Toast
        toast.classList.remove('hidden');
        toast.classList.add('flex', 'animate-pop');
        
        // Final Submission with delay
        setTimeout(() => {
            document.getElementById('contentForm').submit();
        }, 1500);
    }
</script>

</body>
</html>