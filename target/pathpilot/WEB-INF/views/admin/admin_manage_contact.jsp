<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    /**
     * Formal Security Guard: Ensures only authenticated Administrators can access the Contact Manager.
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
    <title>Manage Contact Content | PathPilot Admin</title>

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
        
        /* Form Element Standardizations */
        .input-field { 
            @apply w-full bg-gray-50 border-none rounded-2xl px-5 py-4 focus:ring-2 
            focus:ring-primary/20 transition-all outline-none font-medium text-sm; 
        }
        
        .config-card { 
            @apply bg-white rounded-[2.5rem] p-10 border border-gray-100 shadow-sm 
            mb-10 relative transition-all duration-300 hover:shadow-lg; 
        }

        .icon-box {
            @apply w-12 h-12 rounded-xl bg-indigo-50 flex items-center justify-center shrink-0;
        }
        
        /* Toast Animation Logic */
        @keyframes slideUp {
            from { transform: translate(-50%, 100%); opacity: 0; }
            to { transform: translate(-50%, 0); opacity: 1; }
        }
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
                    <span class="text-primary font-bold">Contact Manager</span>
                </nav>
                <h1 class="text-2xl font-800 text-gray-900 tracking-tight">Support Center Configuration</h1>
            </div>
            
            <div class="flex gap-4">
                <%-- ✅ SYNCED: Professional Action Trigger --%>
                <button type="button" 
                        id="submitBtn"
                        onclick="handleSaveAction()" 
                        class="bg-primary text-white px-8 py-3 rounded-2xl font-bold text-sm shadow-xl shadow-primary/20 hover:bg-primary-dark transition-all active:scale-95 flex items-center gap-2">
                    <span class="material-icons-round">contact_mail</span>
                    <span id="btnText">Update Contact Info</span>
                </button>
            </div>
        </header>

        <main class="flex-1 overflow-y-auto pb-32">
            
            <form id="contactManageForm" action="<%=request.getContextPath()%>/admin/manage-contact" method="POST" class="max-w-5xl mx-auto px-12 py-12">
                
                <section class="config-card">
                    <h2 class="text-xl font-800 text-gray-900 mb-8 flex items-center gap-3">
                        <span class="w-8 h-8 rounded-lg bg-indigo-50 text-primary flex items-center justify-center">
                            <span class="material-icons-round text-sm">question_answer</span>
                        </span>
                        Support Hero Section
                    </h2>

                    <div class="space-y-6">
                        <div>
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Hero Heading</label>
                            <input type="text" name="contactHeroTitle" class="input-field" value="How can we help?">
                        </div>
                        <div>
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Hero Description</label>
                            <textarea name="contactHeroDesc" rows="3" class="input-field resize-none">Have questions about your current roadmap or need technical assistance? Our team is dedicated to your engineering success.</textarea>
                        </div>
                    </div>
                </section>

                <section class="config-card">
                    <h2 class="text-xl font-800 text-gray-900 mb-8 flex items-center gap-3">
                        <span class="w-8 h-8 rounded-lg bg-indigo-50 text-primary flex items-center justify-center">
                            <span class="material-icons-round text-sm">alternate_email</span>
                        </span>
                        Direct Contact Info
                    </h2>

                    <div class="grid md:grid-cols-2 gap-8">
                        <div class="space-y-2">
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block ml-1">Support Email Address</label>
                            <div class="flex items-center gap-4">
                                <div class="icon-box">
                                    <span class="material-icons-round text-primary/60">mail</span>
                                </div>
                                <input type="email" name="supportEmail" class="input-field" value="support@pathpilot.io">
                            </div>
                        </div>

                        <div class="space-y-2">
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block ml-1">Discord/Community Link</label>
                            <div class="flex items-center gap-4">
                                <div class="icon-box bg-purple-50">
                                    <span class="material-icons-round text-purple-500/60">forum</span>
                                </div>
                                <input type="text" name="communityLink" class="input-field" value="Join the PathPilot Discord">
                            </div>
                        </div>

                        <div class="md:col-span-2 space-y-2">
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block ml-1">Campus Office Address</label>
                            <div class="flex items-start gap-4">
                                <div class="icon-box mt-1">
                                    <span class="material-icons-round text-primary/60">location_on</span>
                                </div>
                                <textarea name="officeAddress" rows="2" class="input-field resize-none">RK University, Rajkot, Gujarat, India</textarea>
                            </div>
                        </div>
                    </div>
                </section>

            </form>
        </main>
    </div>
</div>

<div id="saveToast" class="fixed bottom-10 left-1/2 -translate-x-1/2 bg-gray-900 text-white px-8 py-4 rounded-2xl shadow-2xl z-[100] hidden items-center gap-3">
    <span class="material-icons-round text-green-400">check_circle</span>
    <span class="text-sm font-bold">Contact information updated and synced!</span>
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
        
        // Strategic Delayed Submission
        setTimeout(() => {
            document.getElementById('contactManageForm').submit();
        }, 1500);
    }
</script>

</body>
</html>