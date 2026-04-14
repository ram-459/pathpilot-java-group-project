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
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Admin Hub | PathPilot</title>

    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>

    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Poppins:wght@500;600;700;800&display=swap" rel="stylesheet"/>
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
        /* Very small, compact card styling */
        .config-card { @apply bg-white rounded-[2rem] p-6 border border-gray-100 shadow-sm transition-all duration-300 hover:shadow-xl hover:-translate-y-1 flex flex-col justify-between; }
        .input-field { @apply w-full bg-gray-50 border-none rounded-xl px-4 py-3 focus:ring-2 focus:ring-primary/20 transition-all outline-none font-medium text-sm; }
    </style>
</head>

<body class="bg-bg-light antialiased overflow-hidden">

<div class="flex h-screen">

    <%@ include file="/WEB-INF/views/components/admin_sidebar.jsp" %>

    <div class="flex-1 flex flex-col overflow-hidden">

        <div class="sticky top-0 z-30 bg-white/80 backdrop-blur-md border-b border-gray-100 px-12 py-4 flex items-center justify-between">
            <div class="flex items-center gap-4">
                <img id="stickyAvatar" 
     src="${pageContext.request.contextPath}/assets/images/rpk.jpg" 
     class="w-10 h-10 rounded-xl object-cover shadow-sm">
                <div>
                    <p class="text-sm font-800 text-gray-900 leading-none">Ram Parkash Kurmi</p>
                    <p class="text-[10px] font-black text-primary uppercase tracking-widest mt-1">Administrator</p>
                </div>
            </div>
            <div class="flex gap-3">
                <button onclick="saveAllSettings()" class="bg-primary text-white px-6 py-2.5 rounded-xl font-bold text-xs shadow-lg shadow-primary/20 hover:bg-primary-dark transition-all active:scale-95">
                    SAVE ALL CHANGES
                </button>
            </div>
        </div>

        <main class="flex-1 overflow-y-auto pb-20">
            
            <div class="h-48 bg-gradient-to-br from-indigo-700 via-primary to-purple-800 w-full"></div>

            <div class="max-w-7xl mx-auto px-12 -mt-24">
                
                <section class="bg-white rounded-[2.5rem] shadow-xl shadow-indigo-900/5 border border-gray-100 p-10 mb-12">
                    <div class="flex flex-col md:flex-row gap-12 items-start">
                        
                        <div class="relative group mx-auto md:mx-0">
                            <img id="profilePreview"
                                 src="${pageContext.request.contextPath}/assets/images/rpk.jpg" 
                                 class="w-40 h-40 rounded-[2.5rem] object-cover border-8 border-white shadow-2xl transition-transform group-hover:scale-[1.02]">
                            
                            <input type="file" id="imgUpload" hidden onchange="previewImage(this)">
                            
                            <button onclick="document.getElementById('imgUpload').click()"
                                    class="absolute -bottom-2 -right-2 bg-white text-primary p-3 rounded-2xl shadow-xl hover:bg-primary hover:text-white transition-all">
                                <span class="material-icons-round">photo_camera</span>
                            </button>
                        </div>

                        <div class="flex-1 w-full space-y-6">
                            <h2 class="text-2xl font-800 text-gray-900 tracking-tight flex items-center gap-2">
                                <span class="material-icons-round text-primary">manage_accounts</span>
                                Admin Profile Settings
                            </h2>
                            
                            <div class="grid md:grid-cols-2 gap-6">
                                <div>
                                    <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Full Name</label>
                                    <input type="text" id="adminName" class="input-field" value="Ram Parkash Kurmi">
                                </div>
                                <div>
                                    <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Email Address</label>
                                    <input type="email" id="adminEmail" class="input-field" value="admin@pathpilot.com">
                                </div>
                            </div>

                            <div class="pt-4 flex items-center justify-between border-t border-gray-50">
                                <p class="text-[10px] text-gray-400 font-medium">Last Login: Feb 19, 2026 • 05:20 PM</p>
                                <button onclick="showToast('Credentials updated!')" class="text-primary font-bold text-xs hover:underline">Update Credentials</button>
                            </div>
                        </div>
                    </div>
                </section>

                <h2 class="text-xl font-800 text-gray-900 mb-8 tracking-tight flex items-center gap-2 px-2">
                    <span class="material-icons-round text-primary">dashboard_customize</span>
                    Platform Management Hub
                </h2>

                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    
                    <div class="config-card">
                        <div>
                            <div class="w-10 h-10 bg-indigo-50 text-primary rounded-xl flex items-center justify-center mb-4">
                                <span class="material-icons-round text-xl">home</span>
                            </div>
                            <h3 class="text-lg font-800 text-gray-900 mb-2">Home Page</h3>
                            <p class="text-gray-500 text-xs font-medium leading-relaxed mb-6">Edit hero slogans and landing banners.</p>
                        </div>
                        <button onclick="openConfig('manage-home')" class="w-full py-3 bg-gray-50 hover:bg-primary hover:text-white rounded-xl font-bold text-[10px] transition-all text-primary uppercase tracking-widest">Configure</button>
                    </div>

                    <div class="config-card">
                        <div>
                            <div class="w-10 h-10 bg-purple-50 text-purple-600 rounded-xl flex items-center justify-center mb-4">
                                <span class="material-icons-round text-xl">extension</span>
                            </div>
                            <h3 class="text-lg font-800 text-gray-900 mb-2">Features</h3>
                            <p class="text-gray-500 text-xs font-medium leading-relaxed mb-6">Manage platform tools and capabilities.</p>
                        </div>
                        <button onclick="openConfig('manage-features')" class="w-full py-3 bg-gray-50 hover:bg-primary hover:text-white rounded-xl font-bold text-[10px] transition-all text-primary uppercase tracking-widest">Configure</button>
                    </div>

                    <div class="config-card">
                        <div>
                            <div class="w-10 h-10 bg-amber-50 text-amber-600 rounded-xl flex items-center justify-center mb-4">
                                <span class="material-icons-round text-xl">info</span>
                            </div>
                            <h3 class="text-lg font-800 text-gray-900 mb-2">About Us</h3>
                            <p class="text-gray-500 text-xs font-medium leading-relaxed mb-6">Refine mission and team profiles.</p>
                        </div>
                        <button onclick="openConfig('manage-about')" class="w-full py-3 bg-gray-50 hover:bg-primary hover:text-white rounded-xl font-bold text-[10px] transition-all text-primary uppercase tracking-widest">Configure</button>
                    </div>

                    <div class="config-card">
                        <div>
                            <div class="w-10 h-10 bg-red-50 text-red-600 rounded-xl flex items-center justify-center mb-4">
                                <span class="material-icons-round text-xl">contact_support</span>
                            </div>
                            <h3 class="text-lg font-800 text-gray-900 mb-2">Contact</h3>
                            <p class="text-gray-500 text-xs font-medium leading-relaxed mb-6">Update campus info and support links.</p>
                        </div>
                        <button onclick="openConfig('manage-contact')" class="w-full py-3 bg-gray-50 hover:bg-primary hover:text-white rounded-xl font-bold text-[10px] transition-all text-primary uppercase tracking-widest">Configure</button>
                    </div>

                    <div class="config-card">
                        <div>
                            <div class="w-10 h-10 bg-cyan-50 text-cyan-600 rounded-xl flex items-center justify-center mb-4">
                                <span class="material-icons-round text-xl">segment</span>
                            </div>
                            <h3 class="text-lg font-800 text-gray-900 mb-2">Footer Links</h3>
                            <p class="text-gray-500 text-xs font-medium leading-relaxed mb-6">Manage social links and footer layout.</p>
                        </div>
                        <button onclick="openConfig('manage-footer')" class="w-full py-3 bg-gray-50 hover:bg-primary hover:text-white rounded-xl font-bold text-[10px] transition-all text-primary uppercase tracking-widest">Configure</button>
                    </div>

                    <div class="config-card bg-gray-900 border-none shadow-2xl">
                        <div>
                            <div class="w-10 h-10 bg-white/10 text-white rounded-xl flex items-center justify-center mb-4">
                                <span class="material-icons-round text-xl text-white">palette</span>
                            </div>
                            <h3 class="text-lg font-800 text-white mb-2">Theme & UI</h3>
                            <p class="text-gray-400 text-xs font-medium leading-relaxed mb-6">Customize brand colors and fonts.</p>
                        </div>
                        <%-- ✅ SYNCED: Points to /admin/settings for global UI controls --%>
                        <button onclick="openConfig('settings')" class="w-full py-3 bg-white/10 hover:bg-white text-gray-900 rounded-xl font-bold text-[10px] transition-all text-white hover:text-gray-900 uppercase tracking-widest">Configure</button>
                    </div>

                </div>
            </div>
        </main>
    </div>
</div>

<div id="toast" class="fixed bottom-8 left-1/2 -translate-x-1/2 bg-gray-900 text-white px-8 py-4 rounded-2xl shadow-2xl z-[200] hidden items-center gap-3">
    <span class="material-icons-round text-green-400">verified</span>
    <span id="toastMsg" class="text-sm font-bold">Changes saved successfully</span>
</div>

<script>
    function previewImage(input){
        if (input.files && input.files[0]) {
            let reader = new FileReader();
            reader.onload = e => {
                document.getElementById("profilePreview").src = e.target.result;
                document.getElementById("stickyAvatar").src = e.target.result;
            };
            reader.readAsDataURL(input.files[0]);
            showToast('Avatar updated!');
        }
    }

    function showToast(msg = "Changes saved successfully"){
        const t = document.getElementById("toast");
        const m = document.getElementById("toastMsg");
        m.innerText = msg;
        t.classList.remove("hidden");
        t.classList.add("flex");
        setTimeout(() => {
            t.classList.add("hidden");
            t.classList.remove("flex");
        }, 3000);
    }

    function saveAllSettings() {
        showToast("System-wide sync complete ✅");
    }

    // ✅ REDIRECTION LOGIC: Navigates to AdminController endpoints
    function openConfig(endpoint) {
        window.location.href = "<%=request.getContextPath()%>/admin/" + endpoint;
    }
</script>

</body>
</html>