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
    <title>Path Builder | Intelligent Assessments</title>

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
        .input-field { @apply w-full bg-gray-50 border border-transparent rounded-2xl px-5 py-4 focus:ring-2 focus:ring-primary/20 transition-all outline-none font-medium text-sm; }
        .input-error { @apply border-red-500 bg-red-50/30 focus:ring-red-200 !important; }
        .error-text { @apply text-[10px] font-bold text-red-500 mt-1 ml-2 hidden; }
        
        .phase-card { @apply bg-white rounded-[2.5rem] p-10 border border-gray-100 shadow-sm mb-12 relative transition-all duration-300; }
        .quiz-input { @apply w-full bg-white border border-gray-100 rounded-xl px-4 py-3 focus:ring-2 focus:ring-primary/10 outline-none text-[11px] font-medium; }
        
        .correct-radio { @apply w-5 h-5 text-primary border-gray-300 focus:ring-primary/20 cursor-pointer transition-all; }
        
        /* Status Badges */
        .badge-draft { @apply bg-amber-50 text-amber-600 border-amber-100; }
        .badge-live { @apply bg-emerald-50 text-emerald-600 border-emerald-100; }
        
        /* Toggle Styling */
        .toggle-dot { @apply transition-transform duration-300 transform translate-x-0; }
        input:checked ~ .toggle-dot { @apply translate-x-6; }
        input:checked ~ .toggle-bg { @apply bg-primary; }

        @keyframes slideUp { from { transform: translate(-50%, 100%); opacity: 0; } to { transform: translate(-50%, 0); opacity: 1; } }
        .animate-pop { animation: slideUp 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275) forwards; }
    </style>
</head>

<body class="bg-bg-light antialiased overflow-hidden">

<div class="flex h-screen">

    <jsp:include page="../components/admin_sidebar.jsp" />

    <div class="flex-1 flex flex-col overflow-hidden">

        <header class="sticky top-0 z-30 bg-white/80 backdrop-blur-md border-b border-gray-100 px-12 py-5 flex items-center justify-between">
            <div>
                <nav class="flex text-[10px] font-black uppercase tracking-widest text-gray-400 mb-1">
                    <span>Creator Mode</span>
                    <span class="mx-2">/</span>
                    <span class="text-primary font-bold">Intelligent Path Builder</span>
                </nav>
                <h1 class="text-2xl font-800 text-gray-900 tracking-tight">Edit Roadmap</h1>
            </div>

            <div class="flex items-center gap-8">
                <!-- Toggle Switch -->
                <div class="flex items-center gap-3 bg-gray-100/50 p-2 rounded-2xl border border-gray-200/50">
                    <span class="text-[10px] font-black uppercase tracking-widest text-gray-400 ml-2" id="toggleLabel">Draft</span>
                    <label class="relative inline-flex items-center cursor-pointer">
                        <input type="checkbox" id="statusToggle" class="sr-only peer" onchange="toggleStatus(this)">
                        <div class="toggle-bg w-12 h-6 bg-gray-300 rounded-full peer transition-all"></div>
                        <div class="toggle-dot absolute left-1 top-1 bg-white w-4 h-4 rounded-full shadow-sm transition-all"></div>
                    </label>
                    <span class="text-[10px] font-black uppercase tracking-widest text-gray-400 mr-2">Live</span>
                </div>

                <div class="flex gap-4">
                    <a href="<%=request.getContextPath()%>/admin/career-path" 
                       class="px-6 py-3 rounded-2xl font-bold text-xs text-gray-400 hover:bg-gray-100 transition-all uppercase tracking-widest flex items-center">CANCEL</a>
                    
                    <button type="button" id="submitBtn" onclick="handleUpdateAction()" 
                            class="bg-primary text-white px-8 py-3 rounded-2xl font-bold text-sm shadow-xl shadow-primary/20 hover:bg-primary-dark transition-all active:scale-95 flex items-center gap-2">
                        <span class="material-icons-round" id="btnIcon">save</span>
                        <span id="btnText">Save Draft</span>
                    </button>
                </div>
            </div>
        </header>

        <main class="flex-1 overflow-y-auto pb-32">
            <form id="roadmapForm" action="<%=request.getContextPath()%>/admin/create-path" method="POST" enctype="multipart/form-data" class="max-w-5xl mx-auto px-12 py-12">
                
                <!-- Hidden Status Field -->
                <input type="hidden" name="status" id="pathStatus" value="DRAFT">

                <!-- Section 01 -->
                <section class="bg-white rounded-[2.5rem] p-10 border border-gray-100 shadow-sm mb-12">
                    <div class="flex justify-between items-start mb-8">
                        <h2 class="text-xl font-800 text-gray-900 flex items-center gap-3">
                            <span class="w-8 h-8 rounded-lg bg-indigo-50 text-primary flex items-center justify-center text-sm">01</span>
                            Core Path Information
                        </h2>
                        <div id="statusBadge" class="flex items-center gap-2 px-4 py-2 rounded-full border badge-draft">
                            <span id="badgeDot" class="w-2 h-2 bg-amber-500 rounded-full"></span>
                            <span id="badgeText" class="text-[10px] font-black uppercase tracking-widest">Draft</span>
                        </div>
                    </div>

                    <div class="grid md:grid-cols-2 gap-8">
                        <div class="md:col-span-2">
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Roadmap Title</label>
                            <input type="text" name="title" class="input-field validate-required" placeholder="e.g. Full Stack Web Engineering">
                            <span class="error-text">Title is required</span>
                        </div>
                        <div>
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Complexity Level</label>
                            <select name="level" class="input-field font-bold text-primary">
                                <option value="Beginner">Beginner</option>
                                <option value="Intermediate">Intermediate</option>
                                <option value="Advanced">Advanced</option>
                            </select>
                        </div>
                        <div>
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Category</label>
                            <input type="text" name="category" class="input-field validate-required" placeholder="e.g. Web Development">
                            <span class="error-text">Category is required</span>
                        </div>
                        <div class="md:col-span-2">
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Path Description</label>
                            <textarea name="description" rows="3" class="input-field resize-none validate-required" placeholder="Provide a brief overview..."></textarea>
                            <span class="error-text">Description is required</span>
                        </div>
                    </div>
                </section>

                <h2 class="text-xl font-800 text-gray-900 mb-8 px-2 tracking-tight">Structured Curriculum & Assessments</h2>

                <div id="phasesContainer"></div>

                <button type="button" onclick="addPhase()" class="w-full py-10 border-2 border-dashed border-gray-200 rounded-[2.5rem] text-gray-400 font-bold flex flex-col items-center justify-center hover:border-primary/40 hover:text-primary hover:bg-white transition-all group">
                    <span class="material-icons-round text-4xl mb-2 group-hover:scale-110 transition-transform">add_circle</span>
                    Add Learning Phase (Phase <span id="nextPhaseNum">1</span>)
                </button>
            </form>
        </main>
    </div>
</div>

<div id="saveToast" class="fixed bottom-10 left-1/2 -translate-x-1/2 bg-gray-900 text-white px-8 py-4 rounded-2xl shadow-2xl z-[100] hidden items-center gap-3 animate-pop">
    <span class="material-icons-round text-green-400">check_circle</span>
    <span id="toastMessage" class="text-xs font-black uppercase tracking-[0.2em]">Roadmap Published Successfully</span>
</div>

<!-- PHASE TEMPLATE -->
<template id="phaseTemplate">
    <div class="phase-card group">
        <div class="flex justify-between items-center mb-10">
            <h3 class="text-xl font-800 text-gray-900 flex items-center gap-3">
                <span class="w-10 h-10 rounded-full bg-primary text-white flex items-center justify-center text-sm shadow-lg shadow-primary/20 phase-label">1</span>
                Phase Content
            </h3>
            <button type="button" onclick="removePhase(this)" class="text-gray-300 hover:text-red-500 transition-colors">
                <span class="material-icons-round">delete_outline</span>
            </button>
        </div>

        <div class="grid md:grid-cols-2 gap-8 mb-8">
            <div class="md:col-span-2">
                <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Phase Title</label>
                <input type="text" name="phaseTitles[]" class="input-field validate-required" placeholder="e.g. Getting Started with Environment">
                <span class="error-text">Phase title is required</span>
            </div>
            <div class="md:col-span-2">
                <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Learning Content</label>
                <textarea name="phaseContents[]" rows="3" class="input-field resize-none validate-required" placeholder="Detail the learning steps..."></textarea>
                <span class="error-text">Learning content is required</span>
            </div>
        </div>

        <div class="bg-indigo-50/50 rounded-[2rem] p-8 border border-indigo-100 mb-8">
            <div class="flex items-center justify-between mb-6">
                <h4 class="text-sm font-800 text-indigo-900 uppercase tracking-widest flex items-center gap-2">
                    <span class="material-icons-round text-indigo-500">quiz</span>
                    Phase Assessment
                </h4>
                <span class="text-[10px] font-bold text-indigo-400 bg-white px-3 py-1 rounded-full border border-indigo-100">Select the correct radio option</span>
            </div>
            
            <div class="space-y-6 quiz-group">
                <% for(int i=1; i<=5; i++) { %>
                <div class="bg-white p-6 rounded-2xl border border-indigo-50 shadow-sm question-block">
                    <div class="flex items-center justify-between mb-4">
                        <span class="text-[10px] font-black text-indigo-400 uppercase">Question <%=i%></span>
                    </div>
                    <input type="text" name="phaseQuiz_Q<%=i%>[]" class="input-field mb-1 bg-indigo-50/30 text-xs validate-required" placeholder="Question statement...">
                    <span class="error-text mb-4">Question is required</span>
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mt-4">
                        <div>
                            <div class="flex items-center gap-3 bg-gray-50 rounded-xl px-4 py-2 border border-gray-100 focus-within:border-primary/30 transition-all">
                                <input type="radio" value="A" class="correct-radio" name="phaseQuiz_Correct_Q<%=i%>_temp">
                                <input type="text" name="phaseQuiz_A_Q<%=i%>[]" class="quiz-input border-none bg-transparent focus:ring-0 validate-required" placeholder="Option A">
                            </div>
                            <span class="error-text">Required</span>
                        </div>
                        <div>
                            <div class="flex items-center gap-3 bg-gray-50 rounded-xl px-4 py-2 border border-gray-100 focus-within:border-primary/30 transition-all">
                                <input type="radio" value="B" class="correct-radio" name="phaseQuiz_Correct_Q<%=i%>_temp">
                                <input type="text" name="phaseQuiz_B_Q<%=i%>[]" class="quiz-input border-none bg-transparent focus:ring-0 validate-required" placeholder="Option B">
                            </div>
                            <span class="error-text">Required</span>
                        </div>
                        <div>
                            <div class="flex items-center gap-3 bg-gray-50 rounded-xl px-4 py-2 border border-gray-100 focus-within:border-primary/30 transition-all">
                                <input type="radio" value="C" class="correct-radio" name="phaseQuiz_Correct_Q<%=i%>_temp">
                                <input type="text" name="phaseQuiz_C_Q<%=i%>[]" class="quiz-input border-none bg-transparent focus:ring-0 validate-required" placeholder="Option C">
                            </div>
                            <span class="error-text">Required</span>
                        </div>
                        <div>
                            <div class="flex items-center gap-3 bg-gray-50 rounded-xl px-4 py-2 border border-gray-100 focus-within:border-primary/30 transition-all">
                                <input type="radio" value="D" class="correct-radio" name="phaseQuiz_Correct_Q<%=i%>_temp">
                                <input type="text" name="phaseQuiz_D_Q<%=i%>[]" class="quiz-input border-none bg-transparent focus:ring-0 validate-required" placeholder="Option D">
                            </div>
                            <span class="error-text">Required</span>
                        </div>
                    </div>
                    <div class="radio-validation-msg mt-3 hidden">
                        <span class="text-[10px] font-bold text-red-500 uppercase flex items-center gap-1">
                            <span class="material-icons-round text-xs">error_outline</span>
                            Select the correct answer
                        </span>
                    </div>
                </div>
                <% } %>
            </div>
        </div>

        <div class="grid md:grid-cols-2 gap-8 p-8 bg-gray-50 rounded-3xl border border-gray-100">
            <div>
                <label class="text-[10px] font-black uppercase text-indigo-400 tracking-widest block mb-3 ml-1">Study Material (PDF)</label>
                <div class="relative bg-white border-2 border-dashed border-indigo-100 rounded-2xl p-6 text-center hover:border-primary/50 transition-all">
                    <input type="file" name="phaseAttachments[]" class="absolute inset-0 opacity-0 cursor-pointer">
                    <span class="material-icons-round text-primary/50 text-2xl mb-1">upload_file</span>
                    <p class="text-[10px] font-bold text-gray-400 uppercase">Upload PDF / GUIDE</p>
                </div>
            </div>
            <div>
                <label class="text-[10px] font-black uppercase text-indigo-400 tracking-widest block mb-3 ml-1">Video Resource</label>
                <div class="flex items-center gap-2 bg-white rounded-2xl px-4 border border-indigo-50">
                    <span class="material-icons-round text-red-500">smart_display</span>
                    <input type="url" name="phaseLinks[]" class="w-full border-none focus:ring-0 text-sm py-4 font-medium validate-url" placeholder="YouTube Link">
                </div>
                <span class="error-text">Invalid URL (e.g. https://youtube.com/...)</span>
            </div>
        </div>
    </div>
</template>

<script>
    let phaseCount = 0;
    let isChanged = false;

    /**
     * ✅ UI LOGIC: Status Toggle Handler
     */
    function toggleStatus(checkbox) {
        const isLive = checkbox.checked;
        const statusBadge = document.getElementById('statusBadge');
        const badgeDot = document.getElementById('badgeDot');
        const badgeText = document.getElementById('badgeText');
        const btnText = document.getElementById('btnText');
        const btnIcon = document.getElementById('btnIcon');
        const statusInput = document.getElementById('pathStatus');
        const toggleLabel = document.getElementById('toggleLabel');

        if (isLive) {
            statusBadge.className = "flex items-center gap-2 px-4 py-2 rounded-full border transition-all badge-live";
            badgeDot.className = "w-2 h-2 bg-emerald-500 rounded-full animate-pulse";
            badgeText.innerText = "Published";
            btnText.innerText = "Publish Path";
            btnIcon.innerText = "rocket_launch";
            statusInput.value = "PUBLISHED";
            toggleLabel.classList.add('text-primary');
        } else {
            statusBadge.className = "flex items-center gap-2 px-4 py-2 rounded-full border transition-all badge-draft";
            badgeDot.className = "w-2 h-2 bg-amber-500 rounded-full";
            badgeText.innerText = "Draft";
            btnText.innerText = "Save Draft";
            btnIcon.innerText = "save";
            statusInput.value = "DRAFT";
            toggleLabel.classList.remove('text-primary');
        }
    }

    /**
     * ✅ UI LOGIC: Phase Management
     */
    function addPhase() {
        phaseCount++;
        const container = document.getElementById('phasesContainer');
        const template = document.getElementById('phaseTemplate').content.cloneNode(true);
        
        const questions = template.querySelectorAll('.question-block');
        questions.forEach((q, qIndex) => {
            const qNum = qIndex + 1;
            const radios = q.querySelectorAll('input[type="radio"]');
            radios.forEach(radio => {
                radio.name = "phaseQuiz_Correct_P" + phaseCount + "_Q" + qNum;
            });
        });

        container.appendChild(template);
        updateLabels();
        isChanged = true;
    }

    function removePhase(btn) {
        btn.closest('.phase-card').remove();
        updateLabels();
        isChanged = true;
    }

    function updateLabels() {
        const labels = document.querySelectorAll('.phase-label');
        labels.forEach((label, index) => {
            label.innerText = (index + 1).toString().padStart(2, '0');
        });
        const nextNum = document.getElementById('nextPhaseNum');
        if(nextNum) nextNum.innerText = labels.length + 1;
    }

    /**
     * ✅ VALIDATION LOGIC
     */
    function validateForm() {
        let isValid = true;
        const form = document.getElementById('roadmapForm');

        document.querySelectorAll('.error-text, .radio-validation-msg').forEach(el => el.classList.add('hidden'));
        document.querySelectorAll('.input-field, .quiz-input').forEach(el => el.classList.remove('input-error'));

        form.querySelectorAll('.validate-required').forEach(input => {
            if (!input.value.trim()) {
                showError(input);
                isValid = false;
            }
        });

        const urlRegex = /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/;
        form.querySelectorAll('.validate-url').forEach(input => {
            if (input.value.trim() && !urlRegex.test(input.value.trim())) {
                showError(input);
                isValid = false;
            }
        });

        const phaseCards = form.querySelectorAll('.phase-card');
        phaseCards.forEach((card) => {
            const questions = card.querySelectorAll('.question-block');
            questions.forEach((qBlock) => {
                const radios = qBlock.querySelectorAll('input[type="radio"]');
                let checked = false;
                radios.forEach(r => { if(r.checked) checked = true; });
                if (!checked) {
                    qBlock.querySelector('.radio-validation-msg').classList.remove('hidden');
                    isValid = false;
                }
            });
        });

        if (!isValid) {
            const firstError = document.querySelector('.input-error, .radio-validation-msg:not(.hidden)');
            if (firstError) firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
        return isValid;
    }

    function showError(element) {
        element.classList.add('input-error');
        let sibling = element.nextElementSibling;
        while (sibling) {
            if (sibling.classList.contains('error-text')) {
                sibling.classList.remove('hidden');
                break;
            }
            sibling = sibling.nextElementSibling;
        }
    }

    /**
     * ✅ CORE LOGIC: AJAX Submission
     */
    function handleUpdateAction() {
        if (!validateForm()) return;

        const toast = document.getElementById('saveToast');
        const toastMsg = document.getElementById('toastMessage');
        const btn = document.getElementById('submitBtn');
        const btnText = document.getElementById('btnText');
        const form = document.getElementById('roadmapForm');
        const isPublished = document.getElementById('statusToggle').checked;

        btn.disabled = true;
        btn.classList.add('opacity-75', 'cursor-not-allowed');
        btnText.innerText = "Synchronizing...";

        fetch(form.action, {
            method: "POST",
            body: new FormData(form)
        })
        .then(response => {
            if(response.ok) {
                isChanged = false; 
                toastMsg.innerText = isPublished ? "Roadmap Published Successfully" : "Draft Saved Successfully";
                toast.classList.remove('hidden');
                toast.classList.add('flex', 'animate-pop');
                setTimeout(() => {
                    window.location.href = "<%=request.getContextPath()%>/admin/career-path?status=saved";
                }, 1500);
            } else {
                throw new Error("Server synchronization failed");
            }
        })
        .catch(err => {
            alert("Error: " + err.message);
            btn.disabled = false;
            btn.classList.remove('opacity-75', 'cursor-not-allowed');
            btnText.innerText = isPublished ? "Publish Path" : "Save Draft";
        });
    }

    /**
     * ✅ SAFETY & INITIALIZATION
     */
    window.onbeforeunload = function() {
        if (isChanged) return "Unsaved changes detected.";
    };

    document.addEventListener('input', (e) => {
        if (e.target.closest('#roadmapForm')) {
            isChanged = true;
            if (e.target.value.trim() !== "") {
                e.target.classList.remove('input-error');
                let sibling = e.target.nextElementSibling;
                if (sibling && sibling.classList.contains('error-text')) sibling.classList.add('hidden');
            }
        }
    });

    window.onload = function() {
        if(document.getElementById('phasesContainer').children.length === 0) {
            addPhase();
        }
        isChanged = false; 
    };
</script>

</body>
</html>