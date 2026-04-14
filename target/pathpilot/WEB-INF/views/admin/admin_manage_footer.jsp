<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    /**
     * Formal Security Guard: Ensures only authenticated Administrators can access the Footer Manager.
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
    <title>Manage Footer Links | PathPilot Admin</title>

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
        .input-field { @apply w-full bg-gray-50 border-none rounded-2xl px-5 py-4 focus:ring-2 focus:ring-primary/20 transition-all outline-none font-medium text-sm; }
        .config-card { @apply bg-white rounded-[2.5rem] p-10 border border-gray-100 shadow-sm mb-10 relative transition-all duration-300 hover:shadow-lg; }
        
        /* Toggle Switch Styling */
        .toggle-checkbox:checked { @apply right-0; right: 0; border-color: #4ade80; }
        .toggle-checkbox:checked + .toggle-label { @apply bg-green-400; background-color: #4ade80; }

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
                    <span class="text-primary font-bold">Footer Manager</span>
                </nav>
                <h1 class="text-2xl font-800 text-gray-900 tracking-tight">Manage Links & Visibility</h1>
            </div>
            
            <div class="flex gap-4">
                <select id="footerRoleSelector" onchange="switchRole(this.value)" class="bg-gray-100 border-none rounded-xl text-[10px] font-black uppercase tracking-widest px-6 py-3 cursor-pointer focus:ring-0">
                    <option value="user">User Footer</option>
                    <option value="guest">Guest Footer</option>
                </select>

                <%-- ✅ SYNCED: Professional Action Trigger --%>
                <button type="button" id="submitBtn" onclick="handleSaveAction()" class="bg-primary text-white px-8 py-3 rounded-2xl font-bold text-sm shadow-xl shadow-primary/20 hover:bg-primary-dark transition-all active:scale-95 flex items-center gap-2">
                    <span class="material-icons-round">cloud_sync</span>
                    <span id="btnText">Update Footer</span>
                </button>
            </div>
        </header>

        <main class="flex-1 overflow-y-auto pb-32">
            
            <form id="footerManageForm" action="<%=request.getContextPath()%>/admin/manage-footer" method="POST" class="max-w-5xl mx-auto px-12 py-12">
                
                <section class="config-card">
                    <h2 class="text-xl font-800 text-gray-900 mb-8 flex items-center gap-3">
                        <span class="w-8 h-8 rounded-lg bg-indigo-50 text-primary flex items-center justify-center">
                            <span class="material-icons-round text-sm">branding_watermark</span>
                        </span>
                        Footer Brand Message
                    </h2>

                    <div>
                        <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Company Catchphrase</label>
                        <textarea id="footerSlogan" name="footerSlogan" rows="2" class="input-field resize-none">Guiding the next generation of tech talent with clarity, structure, and purpose.</textarea>
                    </div>
                </section>

                <h2 class="text-xl font-800 text-gray-900 mb-8 px-2 tracking-tight">Social Media & Connectivity</h2>
                
                <div class="grid md:grid-cols-2 gap-8">
                    
                    <div class="config-card p-8 group">
                        <div class="flex justify-between items-center mb-6">
                            <div class="flex items-center gap-4">
                                <div class="w-12 h-12 bg-blue-50 text-blue-600 rounded-2xl flex items-center justify-center">
                                    <i class="fab fa-facebook-f text-xl"></i>
                                </div>
                                <span class="font-800 text-gray-900">Facebook</span>
                            </div>
                            <div class="relative inline-block w-10 mr-2 align-middle select-none transition duration-200 ease-in">
                                <input type="checkbox" name="fb_visible" id="fb_toggle" checked class="toggle-checkbox absolute block w-6 h-6 rounded-full bg-white border-4 appearance-none cursor-pointer focus:ring-0"/>
                                <label for="fb_toggle" class="toggle-label block overflow-hidden h-6 rounded-full bg-gray-300 cursor-pointer"></label>
                            </div>
                        </div>
                        <div class="space-y-4">
                            <input type="text" name="fb_name" class="input-field text-xs" value="PathPilot Facebook">
                            <input type="url" name="fb_link" class="input-field text-xs bg-white border border-gray-100" value="https://facebook.com/pathpilot">
                        </div>
                    </div>

                    <div class="config-card p-8 group">
                        <div class="flex justify-between items-center mb-6">
                            <div class="flex items-center gap-4">
                                <div class="w-12 h-12 bg-pink-50 text-pink-600 rounded-2xl flex items-center justify-center">
                                    <i class="fab fa-instagram text-xl"></i>
                                </div>
                                <span class="font-800 text-gray-900">Instagram</span>
                            </div>
                            <div class="relative inline-block w-10 mr-2 align-middle select-none">
                                <input type="checkbox" name="ig_visible" id="ig_toggle" checked class="toggle-checkbox absolute block w-6 h-6 rounded-full bg-white border-4 appearance-none cursor-pointer focus:ring-0"/>
                                <label for="ig_toggle" class="toggle-label block overflow-hidden h-6 rounded-full bg-gray-300 cursor-pointer"></label>
                            </div>
                        </div>
                        <div class="space-y-4">
                            <input type="text" name="ig_name" class="input-field text-xs" value="PathPilot Official">
                            <input type="url" name="ig_link" class="input-field text-xs bg-white border border-gray-100" value="https://instagram.com/pathpilot">
                        </div>
                    </div>

                    <div class="config-card p-8 group">
                        <div class="flex justify-between items-center mb-6">
                            <div class="flex items-center gap-4">
                                <div class="w-12 h-12 bg-gray-900 text-white rounded-2xl flex items-center justify-center">
                                    <i class="fab fa-x-twitter text-xl"></i>
                                </div>
                                <span class="font-800 text-gray-900">Twitter / X</span>
                            </div>
                            <div class="relative inline-block w-10 mr-2 align-middle select-none">
                                <input type="checkbox" name="tw_visible" id="tw_toggle" class="toggle-checkbox absolute block w-6 h-6 rounded-full bg-white border-4 appearance-none cursor-pointer focus:ring-0"/>
                                <label for="tw_toggle" class="toggle-label block overflow-hidden h-6 rounded-full bg-gray-300 cursor-pointer"></label>
                            </div>
                        </div>
                        <div class="space-y-4">
                            <input type="text" name="tw_name" class="input-field text-xs" value="PathPilot_X">
                            <input type="url" name="tw_link" class="input-field text-xs bg-white border border-gray-100" value="https://twitter.com/pathpilot">
                        </div>
                    </div>

                    <div class="config-card p-8 group">
                        <div class="flex justify-between items-center mb-6">
                            <div class="flex items-center gap-4">
                                <div class="w-12 h-12 bg-indigo-50 text-indigo-900 rounded-2xl flex items-center justify-center">
                                    <i class="fab fa-github text-xl"></i>
                                </div>
                                <span class="font-800 text-gray-900">GitHub</span>
                            </div>
                            <div class="relative inline-block w-10 mr-2 align-middle select-none">
                                <input type="checkbox" name="gh_visible" id="gh_toggle" checked class="toggle-checkbox absolute block w-6 h-6 rounded-full bg-white border-4 appearance-none cursor-pointer focus:ring-0"/>
                                <label for="gh_toggle" class="toggle-label block overflow-hidden h-6 rounded-full bg-gray-300 cursor-pointer"></label>
                            </div>
                        </div>
                        <div class="space-y-4">
                            <input type="text" name="gh_name" class="input-field text-xs" value="PathPilot Repository">
                            <input type="url" name="gh_link" class="input-field text-xs bg-white border border-gray-100" value="https://github.com/pathpilot">
                        </div>
                    </div>

                </div>

            </form>
        </main>
    </div>
</div>

<div id="saveToast" class="fixed bottom-10 left-1/2 -translate-x-1/2 bg-gray-900 text-white px-8 py-4 rounded-2xl shadow-2xl z-[100] hidden items-center gap-3">
    <span class="material-icons-round text-green-400">verified</span>
    <span class="text-sm font-bold">Global footer configuration synced!</span>
</div>

<script>
    /**
     * Context Switching Logic for localized role footers.
     */
    function switchRole(role) {
        const slogan = document.getElementById('footerSlogan');
        if (role === 'guest') {
            slogan.value = "Join thousands of students starting their engineering journey today.";
        } else {
            slogan.value = "Guiding the next generation of tech talent with clarity, structure, and purpose.";
        }
    }

    /**
     * ✅ SYNCED: Form Submission Logic with UX Feedback.
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
            document.getElementById('footerManageForm').submit();
        }, 1500);
    }
</script>

</body>
</html>