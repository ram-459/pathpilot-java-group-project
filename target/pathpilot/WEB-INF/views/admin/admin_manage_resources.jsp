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
    <title>Manage Resources | PathPilot Admin</title>

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
        .resource-row { @apply bg-white rounded-[2rem] p-6 border border-gray-100 shadow-sm transition-all duration-300 hover:shadow-xl hover:border-primary/10 flex items-center justify-between gap-6; }
        .input-field { @apply w-full bg-gray-50 border-none rounded-2xl px-5 py-4 focus:ring-2 focus:ring-primary/20 transition-all outline-none font-medium text-sm; }
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
                    <span class="text-primary font-bold">Resource Manager</span>
                </nav>
                <h1 class="text-2xl font-800 text-gray-900 tracking-tight">Learning Resources</h1>
            </div>
            
            <button onclick="openAddModal()" class="bg-primary text-white px-8 py-3 rounded-2xl font-bold text-sm shadow-xl shadow-primary/20 hover:bg-primary-dark transition-all active:scale-95 flex items-center gap-2">
                <span class="material-icons-round">add</span>
                Add New Resource
            </button>
        </header>

        <main class="flex-1 overflow-y-auto p-12">
            
            <div class="max-w-6xl mx-auto mb-10 flex flex-col md:flex-row gap-4 items-center">
                <div class="relative flex-grow">
                    <span class="material-icons-round absolute left-4 top-1/2 -translate-y-1/2 text-gray-400">search</span>
                    <input type="text" placeholder="Filter resources by title..." class="w-full pl-12 pr-4 py-3 bg-white border border-gray-100 rounded-xl outline-none focus:ring-2 focus:ring-primary/10 transition-all">
                </div>
                <select class="bg-white border border-gray-100 rounded-xl px-6 py-3 text-xs font-bold text-gray-500 uppercase tracking-widest outline-none">
                    <option>All Categories</option>
                    <option>Documentation</option>
                    <option>PDF Guides</option>
                    <option>Video Tutorials</option>
                </select>
            </div>

            <div class="max-w-6xl mx-auto space-y-4">

                <div class="resource-row group">
                    <div class="flex items-center gap-6 flex-1">
                        <div class="w-14 h-14 bg-orange-50 rounded-2xl flex items-center justify-center text-orange-500">
                            <i class="fas fa-file-pdf text-xl"></i>
                        </div>
                        <div>
                            <h3 class="text-lg font-800 text-gray-900 leading-tight">AWS Practitioner Guide</h3>
                            <div class="flex items-center gap-4 mt-1">
                                <span class="text-[9px] font-black uppercase text-gray-400 tracking-widest px-2 py-0.5 bg-gray-50 rounded border border-gray-100">PDF Guide</span>
                                <span class="text-[9px] font-black uppercase text-primary tracking-widest">12 MB</span>
                            </div>
                        </div>
                    </div>
                    <div class="flex items-center gap-3">
                        <button onclick="openEditModal('AWS Guide')" class="w-10 h-10 rounded-xl bg-gray-50 text-gray-400 hover:bg-primary/10 hover:text-primary transition-all flex items-center justify-center">
                            <span class="material-icons-round text-lg">edit</span>
                        </button>
                        <button class="w-10 h-10 rounded-xl bg-gray-50 text-gray-400 hover:bg-red-50 hover:text-red-500 transition-all flex items-center justify-center">
                            <span class="material-icons-round text-lg">delete</span>
                        </button>
                    </div>
                </div>

                <div class="resource-row group">
                    <div class="flex items-center gap-6 flex-1">
                        <div class="w-14 h-14 bg-purple-50 rounded-2xl flex items-center justify-center text-purple-600">
                            <i class="fas fa-play-circle text-xl"></i>
                        </div>
                        <div>
                            <h3 class="text-lg font-800 text-gray-900 leading-tight">UI Design in Figma</h3>
                            <div class="flex items-center gap-4 mt-1">
                                <span class="text-[9px] font-black uppercase text-gray-400 tracking-widest px-2 py-0.5 bg-gray-50 rounded border border-gray-100">Video</span>
                                <span class="text-[9px] font-black uppercase text-primary tracking-widest">Video Tutorial</span>
                            </div>
                        </div>
                    </div>
                    <div class="flex items-center gap-3">
                        <button class="w-10 h-10 rounded-xl bg-gray-50 text-gray-400 hover:bg-primary/10 hover:text-primary transition-all flex items-center justify-center">
                            <span class="material-icons-round text-lg">edit</span>
                        </button>
                        <button class="w-10 h-10 rounded-xl bg-gray-50 text-gray-400 hover:bg-red-50 hover:text-red-500 transition-all flex items-center justify-center">
                            <span class="material-icons-round text-lg">delete</span>
                        </button>
                    </div>
                </div>

            </div>
        </main>
    </div>
</div>

<div id="resourceModal" class="fixed inset-0 bg-black/50 backdrop-blur-sm hidden items-center justify-center z-50">
    <div class="bg-white w-full max-w-xl rounded-[2.5rem] p-10 shadow-2xl">
        <h2 id="modalTitle" class="text-2xl font-800 text-gray-900 mb-2">Add New Resource</h2>
        <p class="text-gray-400 text-sm mb-8">Upload documents or link video tutorials to the student hub.</p>

        <form action="<%=request.getContextPath()%>/admin/settings" method="POST" enctype="multipart/form-data">
            <div class="space-y-6">
                <div>
                    <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Resource Title</label>
                    <input type="text" name="resTitle" class="input-field" placeholder="e.g. Modern React Architecture">
                </div>
                
                <div class="grid grid-cols-2 gap-6">
                    <div>
                        <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Category</label>
                        <select name="resCategory" class="input-field font-bold text-primary">
                            <option value="doc">Documentation</option>
                            <option value="pdf">PDF Guide</option>
                            <option value="video">Video Tutorial</option>
                        </select>
                    </div>
                    <div>
                        <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Metadata (Size/Time)</label>
                        <input type="text" name="resMeta" class="input-field" placeholder="e.g. 15 min read / 12 MB">
                    </div>
                </div>

                <div>
                    <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Description</label>
                    <textarea name="resDesc" rows="2" class="input-field resize-none" placeholder="Short summary for the card..."></textarea>
                </div>

                <div class="p-6 bg-gray-50 rounded-3xl border border-gray-100">
                    <label class="text-[10px] font-black uppercase text-indigo-400 tracking-widest block mb-3 ml-1">Resource Source</label>
                    <div class="grid grid-cols-2 gap-4">
                        <div class="relative bg-white border-2 border-dashed border-indigo-100 rounded-2xl p-4 text-center">
                            <input type="file" name="resFile" class="absolute inset-0 opacity-0 cursor-pointer">
                            <span class="material-icons-round text-primary/50 text-xl">cloud_upload</span>
                            <p class="text-[8px] font-bold text-gray-400 uppercase mt-1">Upload File</p>
                        </div>
                        <div class="bg-white border border-indigo-50 rounded-2xl flex items-center px-4">
                            <span class="material-icons-round text-red-500 mr-2 text-sm">link</span>
                            <input type="url" name="resUrl" class="w-full border-none focus:ring-0 text-[10px] py-3 font-medium" placeholder="Or Paste URL">
                        </div>
                    </div>
                </div>
            </div>

            <div class="flex justify-end gap-4 mt-10">
                <button type="button" onclick="closeModal()" class="px-8 py-3.5 rounded-2xl font-bold text-gray-400 hover:bg-gray-50 transition text-xs uppercase tracking-widest">Cancel</button>
                <button type="submit" class="px-10 py-3.5 bg-primary text-white rounded-2xl font-black shadow-xl shadow-primary/20 hover:bg-primary-dark transition text-xs uppercase tracking-widest">
                    Save Resource
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function openAddModal() {
        document.getElementById('modalTitle').innerText = "Add New Resource";
        document.getElementById('resourceModal').classList.remove('hidden');
        document.getElementById('resourceModal').classList.add('flex');
    }

    function openEditModal(title) {
        document.getElementById('modalTitle').innerText = "Edit: " + title;
        document.getElementById('resourceModal').classList.remove('hidden');
        document.getElementById('resourceModal').classList.add('flex');
    }

    function closeModal() {
        document.getElementById('resourceModal').classList.add('hidden');
        document.getElementById('resourceModal').classList.remove('flex');
    }
</script>

</body>
</html>