<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // 🔐 SESSION + CACHE GUARD
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if(session == null || session.getAttribute("role") == null){
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

    <jsp:include page="../components/user_sidebar.jsp" />

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
                    <a href="<%=request.getContextPath()%>/user/career-mgmt" 
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
            <form id="roadmapForm" action="<%=request.getContextPath()%>/user/edit-path" method="POST" class="max-w-5xl mx-auto px-12 py-12">
                
                <input type="hidden" name="pathId" id="pathId" value="${roadmap.pathId}">
                <input type="hidden" name="status" id="pathStatus" value="${roadmap.status}">

                <section class="bg-white rounded-[2.5rem] p-10 border border-gray-100 shadow-sm mb-12">
                    <div class="flex justify-between items-start mb-8">
                        <h2 class="text-xl font-800 text-gray-900 flex items-center gap-3">
                            <span class="w-8 h-8 rounded-lg bg-indigo-50 text-primary flex items-center justify-center text-sm">01</span>
                            Core Path Information
                        </h2>
                        <div id="statusBadge" class="flex items-center gap-2 px-4 py-2 rounded-full border ${roadmap.status == 'PUBLISHED' ? 'badge-live' : 'badge-draft'}">
                            <span id="badgeDot" class="w-2 h-2 ${roadmap.status == 'PUBLISHED' ? 'bg-emerald-500' : 'bg-amber-500'} rounded-full"></span>
                            <span id="badgeText" class="text-[10px] font-black uppercase tracking-widest">${roadmap.status == 'PUBLISHED' ? 'LIVE' : 'Draft'}</span>
                        </div>
                    </div>

                    <div class="grid md:grid-cols-2 gap-8">
                        <div class="md:col-span-2">
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Roadmap Title</label>
                            <input type="text" name="roadmapTitle" class="input-field validate-required" placeholder="e.g. Full Stack Web Engineering" value="${roadmap.title}">
                            <span class="error-text">Title is required</span>
                        </div>
                        <div>
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Complexity Level</label>
                            <select name="level" class="input-field font-bold text-primary">
                                <option value="Beginner" ${roadmap.level == 'Beginner' ? 'selected' : ''}>Beginner</option>
                                <option value="Intermediate" ${roadmap.level == 'Intermediate' ? 'selected' : ''}>Intermediate</option>
                                <option value="Advanced" ${roadmap.level == 'Advanced' ? 'selected' : ''}>Advanced</option>
                            </select>
                        </div>
                        <div>
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Category</label>
                            <input type="text" name="category" class="input-field validate-required" placeholder="e.g. Web Development" value="${roadmap.category}">
                            <span class="error-text">Category is required</span>
                        </div>
                        <div class="md:col-span-2">
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Path Description</label>
                            <textarea name="roadmapDesc" rows="3" class="input-field resize-none validate-required" placeholder="Provide a brief overview...">${roadmap.description}</textarea>
                            <span class="error-text">Description is required</span>
                        </div>
                    </div>
                </section>

                <h2 class="text-xl font-800 text-gray-900 mb-8 px-2 tracking-tight">Structured Curriculum & Assessments</h2>

                <div id="phasesContainer">
                    <c:forEach var="phase" items="${phases}" varStatus="phaseLoop">
                        <div class="phase-card group" data-has-file="${not empty phase.fileResourcePath}">
                            <div class="flex justify-between items-center mb-10">
                                <h3 class="text-xl font-800 text-gray-900 flex items-center gap-3">
                                    <span class="w-10 h-10 rounded-full bg-primary text-white flex items-center justify-center text-sm shadow-lg shadow-primary/20 phase-label">${phaseLoop.count}</span>
                                    Phase ${phase.phaseNumber}
                                </h3>
                                <button type="button" onclick="removePhase(this)" class="text-gray-300 hover:text-red-500 transition-colors">
                                    <span class="material-icons-round">delete_outline</span>
                                </button>
                            </div>

                            <div class="grid md:grid-cols-2 gap-8 mb-8">
                                <div class="md:col-span-2">
                                    <input type="hidden" name="phaseIds[]" value="${phase.phaseId}">
                                    <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Phase Title</label>
                                    <input type="text" name="phaseTitles[]" class="input-field validate-required" placeholder="e.g. Getting Started with Environment" value="${phase.title}">
                                    <span class="error-text">Phase title is required</span>
                                </div>
                                <div class="md:col-span-2">
                                    <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Learning Content</label>
                                    <textarea name="phaseContents[]" rows="3" class="input-field resize-none validate-required" placeholder="Detail the learning steps...">${phase.content}</textarea>
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
                                    <c:forEach var="question" items="${phase.questions}" varStatus="questionLoop">
                                        <div class="bg-white p-6 rounded-2xl border border-indigo-50 shadow-sm question-block">
                                            <div class="flex items-center justify-between mb-4">
                                                <span class="text-[10px] font-black text-indigo-400 uppercase">Question ${question.questionNumber}</span>
                                            </div>
                                            <input type="hidden" class="question-id-input" name="phaseQuiz_Id_P${phaseLoop.count}_Q${question.questionNumber}" value="${question.questionId}">
                                            <input type="text" name="phaseQuiz_P${phaseLoop.count}_Q${question.questionNumber}[]" class="input-field mb-1 bg-indigo-50/30 text-xs validate-required" placeholder="Question statement..." value="${question.questionText}">
                                            <span class="error-text mb-4">Question is required</span>
                                            
                                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mt-4">
                                                <c:forEach var="option" items="${question.options}">
                                                    <div>
                                                        <div class="flex items-center gap-3 bg-gray-50 rounded-xl px-4 py-2 border border-gray-100 focus-within:border-primary/30 transition-all">
                                                            <input type="radio" value="${option.optionLabel}" class="correct-radio" name="phaseQuiz_Correct_P${phaseLoop.count}_Q${question.questionNumber}" 
                                                                <c:if test="${option.optionLabel == question.correctAnswer}">checked</c:if>>
                                                            <input type="text" name="phaseQuiz_P${phaseLoop.count}_${option.optionLabel}_Q${question.questionNumber}[]" class="quiz-input border-none bg-transparent focus:ring-0 validate-required" placeholder="Option ${option.optionLabel}" value="${option.optionText}">
                                                        </div>
                                                        <span class="error-text">Required</span>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                            <div class="radio-validation-msg mt-3 hidden">
                                                <span class="text-[10px] font-bold text-red-500 uppercase flex items-center gap-1">
                                                    <span class="material-icons-round text-xs">error_outline</span>
                                                    Select the correct answer
                                                </span>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>

                            <div class="grid md:grid-cols-2 gap-8 p-8 bg-gray-50 rounded-3xl border border-gray-100">
                                <div>
                                    <label class="text-[10px] font-black uppercase text-indigo-400 tracking-widest block mb-3 ml-1">Study Material (PDF)</label>
                                    <div class="file-upload-wrapper relative bg-white border-2 border-dashed border-indigo-100 rounded-2xl p-6 text-center hover:border-primary/50 transition-all cursor-pointer">
                                        <input type="file" name="phaseAttachments[]" class="file-input absolute inset-0 opacity-0 cursor-pointer" accept=".pdf,.doc,.docx">
                                        <div class="file-upload-content <c:if test='${not empty phase.fileResourcePath}'>hidden</c:if>">
                                            <span class="material-icons-round text-primary/50 text-2xl mb-1">upload_file</span>
                                            <p class="text-[10px] font-bold text-gray-400 uppercase">Upload PDF / GUIDE</p>
                                            <p class="text-[8px] text-gray-300 mt-1">Supported: PDF, DOC, DOCX</p>
                                        </div>
                                        <div class="file-preview <c:if test='${empty phase.fileResourcePath}'>hidden</c:if> mt-3">
                                            <a href="<c:if test='${not empty phase.fileResourcePath}'><%=request.getContextPath()%>${phase.fileResourcePath}</c:if>" target="_blank" class="file-link">
                                                <p class="text-[10px] font-bold text-green-600 flex items-center justify-center gap-2">
                                                    <span class="material-icons-round text-sm">check_circle</span>
                                                    <span class="file-name"><c:choose><c:when test="${not empty phase.fileResourceName}">${phase.fileResourceName}</c:when><c:otherwise>Current File</c:otherwise></c:choose></span>
                                                </p>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                                <div>
                                    <label class="text-[10px] font-black uppercase text-indigo-400 tracking-widest block mb-3 ml-1">Video Resource</label>
                                    <div class="flex items-center gap-2 bg-white rounded-2xl px-4 border border-indigo-50">
                                        <span class="material-icons-round text-red-500">smart_display</span>
                                        <input type="url" name="phaseLinks[]" class="w-full border-none focus:ring-0 text-sm py-4 font-medium validate-url" placeholder="YouTube Link" value="${phase.videoResourceUrl}">
                                    </div>
                                    <span class="error-text">Invalid URL (e.g. https://youtube.com/...)</span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

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

<template id="phaseTemplate">
    <div class="phase-card group" data-has-file="false">
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
                <input type="hidden" name="phaseIds[]" value="">
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
                    <input type="hidden" class="question-id-input" name="phaseQuiz_Id_temp_Q<%=i%>" value="">
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
                <div class="file-upload-wrapper relative bg-white border-2 border-dashed border-indigo-100 rounded-2xl p-6 text-center hover:border-primary/50 transition-all cursor-pointer">
                    <input type="file" name="phaseAttachments[]" class="file-input absolute inset-0 opacity-0 cursor-pointer" accept=".pdf,.doc,.docx">
                    <div class="file-upload-content">
                        <span class="material-icons-round text-primary/50 text-2xl mb-1">upload_file</span>
                        <p class="text-[10px] font-bold text-gray-400 uppercase">Upload PDF / GUIDE</p>
                        <p class="text-[8px] text-gray-300 mt-1">Supported: PDF, DOC, DOCX</p>
                    </div>
                    <div class="file-preview hidden mt-3">
                        <p class="text-[10px] font-bold text-green-600 flex items-center justify-center gap-2">
                            <span class="material-icons-round text-sm">check_circle</span>
                            <span class="file-name"></span>
                        </p>
                    </div>
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
            const radios = q.querySelectorAll('input[type="radio"].correct-radio');
            radios.forEach(radio => {
                radio.name = "phaseQuiz_Correct_P" + phaseCount + "_Q" + qNum;
            });

            const textInputs = q.querySelectorAll('input[type="text"]');
            if (textInputs.length > 0) {
                textInputs[0].name = "phaseQuiz_P" + phaseCount + "_Q" + qNum + "[]";
            }

            const optionLabels = ['A', 'B', 'C', 'D'];
            for (let i = 1; i < textInputs.length && i <= optionLabels.length; i++) {
                textInputs[i].name = "phaseQuiz_P" + phaseCount + "_" + optionLabels[i - 1] + "_Q" + qNum + "[]";
            }
        });

        container.appendChild(template);
        const newlyAddedCard = container.lastElementChild;
        const newFileInput = newlyAddedCard ? newlyAddedCard.querySelector('.file-input') : null;
        if (newFileInput) {
            setupFileUploadListener(newFileInput);
        }
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

        const urlRegex = /^(https?:\/\/)?(www\.)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}([\/\w\-._~:/?#[\]@!$&'()*+,;=]*)?$/;
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

    function syncPhaseInputNames() {
        const phaseCards = document.querySelectorAll('#phasesContainer .phase-card');
        phaseCards.forEach((card, phaseIndex) => {
            const phaseNum = phaseIndex + 1;
            const questionBlocks = card.querySelectorAll('.question-block');

            questionBlocks.forEach((qBlock, qIndex) => {
                const qNum = qIndex + 1;

                const questionInput = qBlock.querySelector('input[type="text"].input-field');
                if (questionInput) {
                    questionInput.name = 'phaseQuiz_P' + phaseNum + '_Q' + qNum + '[]';
                }

                const questionIdInput = qBlock.querySelector('input.question-id-input');
                if (questionIdInput) {
                    questionIdInput.name = 'phaseQuiz_Id_P' + phaseNum + '_Q' + qNum;
                }

                const optionInputs = qBlock.querySelectorAll('input[type="text"].quiz-input');
                const labels = ['A', 'B', 'C', 'D'];
                optionInputs.forEach((optionInput, optionIndex) => {
                    if (optionIndex < labels.length) {
                        optionInput.name = 'phaseQuiz_P' + phaseNum + '_' + labels[optionIndex] + '_Q' + qNum + '[]';
                    }
                });
            });
        });
    }

    function snapshotSelectedAnswers() {
        const selected = [];
        document.querySelectorAll('#phasesContainer .question-block').forEach((qBlock) => {
            const checked = qBlock.querySelector('input.correct-radio:checked');
            selected.push(checked ? checked.value : null);
        });
        return selected;
    }

    function restoreSelectedAnswers(selected) {
        const blocks = document.querySelectorAll('#phasesContainer .question-block');
        blocks.forEach((qBlock, index) => {
            const value = selected[index];
            if (!value) return;
            const target = qBlock.querySelector(`input.correct-radio[value="${value}"]`);
            if (target) target.checked = true;
        });
    }

    function buildSubmissionParams(form) {
        const params = new URLSearchParams();
        const fields = form.querySelectorAll('input, textarea, select');

        fields.forEach(field => {
            if (!field.name || field.disabled) return;
            if (field.type === 'file') return;
            if (field.classList && field.classList.contains('correct-radio')) return;
            if ((field.type === 'radio' || field.type === 'checkbox') && !field.checked) return;
            params.append(field.name, field.value);
        });

        appendQuizPayloadParams(params);

        return params;
    }

    function appendQuizPayloadParams(params) {
        const phaseCards = document.querySelectorAll('#phasesContainer .phase-card');
        phaseCards.forEach((card, phaseIndex) => {
            const phaseNum = phaseIndex + 1;
            const questionBlocks = card.querySelectorAll('.question-block');

            questionBlocks.forEach((qBlock, qIndex) => {
                const qNum = qIndex + 1;

                const questionInput = qBlock.querySelector('input[type="text"].input-field');
                const questionValue = questionInput ? questionInput.value.trim() : '';
                if (!questionValue) return;

                params.append('phaseQuiz_P' + phaseNum + '_Q' + qNum + '[]', questionValue);

                const questionIdInput = qBlock.querySelector('input.question-id-input');
                if (questionIdInput && questionIdInput.value && questionIdInput.value.trim()) {
                    params.append('phaseQuiz_Id_P' + phaseNum + '_Q' + qNum, questionIdInput.value.trim());
                }

                const optionInputs = qBlock.querySelectorAll('input[type="text"].quiz-input');
                const labels = ['A', 'B', 'C', 'D'];
                optionInputs.forEach((optionInput, optionIndex) => {
                    if (optionIndex >= labels.length) return;
                    params.append('phaseQuiz_P' + phaseNum + '_' + labels[optionIndex] + '_Q' + qNum + '[]', optionInput.value ? optionInput.value.trim() : '');
                });

                const checked = qBlock.querySelector('input.correct-radio:checked');
                if (checked) {
                    params.append('phaseQuiz_Correct_P' + phaseNum + '_Q' + qNum, checked.value);
                }
            });
        });
    }

    function getSelectedPhaseFiles(form) {
        const files = [];
        const phaseCards = form.querySelectorAll('.phase-card');
        console.log('[DEBUG] 🔍 getSelectedPhaseFiles: Scanning', phaseCards.length, 'phase cards');
        
        phaseCards.forEach((card, index) => {
            const fileInput = card.querySelector('input[type="file"].file-input');
            console.log(`[DEBUG] 📋 Phase ${index + 1}: fileInput element found?`, !!fileInput);
            
            if (fileInput) {
                console.log(`[DEBUG] 📂 Phase ${index + 1}: fileInput.files.length =`, fileInput.files.length);
                if (fileInput.files && fileInput.files.length > 0) {
                    const file = fileInput.files[0];
                    console.log(`[DEBUG] ✅ Phase ${index + 1}: File selected - name="${file.name}", size=${file.size}, type="${file.type}"`);
                }
            }
            
            const phaseIdInput = card.querySelector('input[name="phaseIds[]"]');
            const parsedPhaseId = phaseIdInput && phaseIdInput.value && phaseIdInput.value.trim()
                ? parseInt(phaseIdInput.value.trim(), 10)
                : 0;
            if (fileInput && fileInput.files && fileInput.files.length > 0 && fileInput.files[0]) {
                const fileObj = {
                    phaseNumber: index + 1,
                    phaseId: Number.isInteger(parsedPhaseId) && parsedPhaseId > 0 ? parsedPhaseId : null,
                    card,
                    file: fileInput.files[0]
                };
                console.log(`[DEBUG] 📤 Phase ${index + 1}: Added to upload queue - phaseId=${fileObj.phaseId}, fileName="${fileObj.file.name}"`);
                files.push(fileObj);
            }
        });
        console.log(`[DEBUG] 📊 FINAL: ${files.length} file(s) ready to upload from ${phaseCards.length} phases`);
        return files;
    }

    async function uploadPhaseFiles(pathId, files) {
        console.log('[UPLOAD][EDIT] 🚀 Starting file upload - pathId:', pathId, 'files.length:', files.length);
        console.log('[UPLOAD][EDIT] 📋 Files:', files.map(f => ({ phaseNumber: f.phaseNumber, phaseId: f.phaseId, name: f.file ? f.file.name : 'NO FILE' })));
        
        // ✅ DEBUG: Verify files are actually accessible
        for (let i = 0; i < files.length; i++) {
            const item = files[i];
            console.log(`[DEBUG] 🔍 Phase ${item.phaseNumber}: file object check:`, {
                hasFile: !!item.file,
                fileName: item.file?.name,
                fileSize: item.file?.size,
                fileType: item.file?.type,
                fileLastModified: item.file?.lastModified
            });
        }
        
        let uploadSuccessCount = 0;
        let uploadFailures = [];
        
        for (const item of files) {
            if (!item || !item.file) {
                uploadFailures.push({
                    phase: item && item.phaseNumber ? item.phaseNumber : 'Unknown',
                    file: item && item.file && item.file.name ? item.file.name : 'Unknown file',
                    error: 'Invalid file payload on client side'
                });
                continue;
            }

            const fd = new FormData();
            fd.append('pathId', String(pathId));
            fd.append('phaseNumber', String(item.phaseNumber));
            if (item.phaseId) {
                fd.append('phaseId', String(item.phaseId));
            }
            fd.append('attachment', item.file);
            
            console.log(`[DEBUG] 📦 Phase ${item.phaseNumber}: FormData prepared - pathId=${pathId}, phaseNumber=${item.phaseNumber}, phaseId=${item.phaseId}, fileName="${item.file.name}", fileSize=${item.file.size}`);

            try {
                const url = "<%=request.getContextPath()%>/user/edit-path/upload-phase-file";
                console.log(`[DEBUG] 🌐 Phase ${item.phaseNumber}: Sending FETCH to ${url}`);
                
                const response = await fetch(url, {
                    method: 'POST',
                    body: fd
                });

                const responseText = (await response.text()).trim();
                console.log(`[DEBUG] 📨 Phase ${item.phaseNumber}: Response received - status=${response.status}, text="${responseText}"`);
                
                if (!response.ok) {
                    uploadFailures.push({
                        phase: item.phaseNumber || 'Unknown',
                        file: item.file && item.file.name ? item.file.name : 'Unknown file',
                        error: responseText || `HTTP ${response.status}`
                    });
                    console.error('[UPLOAD][EDIT] Error uploading phase', item.phaseNumber, ':', responseText);
                } else {
                    uploadSuccessCount++;
                    const parts = responseText.split('|');
                    if (parts[0] === 'RESOURCE_SAVED' && parts.length >= 3) {
                        const filePath = parts[1];
                        const resourceName = parts.slice(2).join('|');
                        const preview = item.card.querySelector('.file-preview');
                        const content = item.card.querySelector('.file-upload-content');
                        const fileLink = item.card.querySelector('.file-link');
                        const fileNameEl = item.card.querySelector('.file-name');

                        if (fileLink) {
                            fileLink.href = `<%=request.getContextPath()%>${filePath}`;
                        }
                        if (fileNameEl) {
                            fileNameEl.textContent = resourceName || item.file.name;
                        }
                        if (content) content.classList.add('hidden');
                        if (preview) preview.classList.remove('hidden');
                        console.log('[UPLOAD][EDIT] phase', item.phaseNumber, 'SUCCESS - saved path:', filePath);
                    }
                }
            } catch (uploadErr) {
                console.error('[UPLOAD][EDIT] Exception uploading phase', item.phaseNumber, ':', uploadErr.message);
                uploadFailures.push({
                    phase: item.phaseNumber || 'Unknown',
                    file: item.file && item.file.name ? item.file.name : 'Unknown file',
                    error: 'Network error: ' + uploadErr.message
                });
            }
        }

        // Report results
        console.log(`[UPLOAD][EDIT] 📊 Summary: ${uploadSuccessCount}/${files.length} files uploaded successfully`);
        
        if (uploadFailures.length > 0) {
            let errorMsg = `❌ FILE UPLOAD FAILED!\n\n${uploadFailures.length} out of ${files.length} file(s) failed:\n\n`;
            uploadFailures.forEach(f => {
                errorMsg += `• Phase ${f.phase}: ${f.file}\n  Error: ${f.error}\n\n`;
            });
            errorMsg += `Your changes were PARTIALLY saved (metadata only).\nFiles must be uploaded successfully.`;
            console.error('[UPLOAD][EDIT] 💥 Upload Failures:', errorMsg);
            throw new Error(errorMsg);
        } else if (files.length > 0) {
            console.log('[UPLOAD][EDIT] ✅ SUCCESS: All files uploaded successfully');
        }
    }

    function setupFileUploadListener(fileInput) {
        fileInput.addEventListener('change', function() {
            const file = this.files[0];
            const wrapper = this.closest('.file-upload-wrapper');
            const phaseCard = this.closest('.phase-card');
            if (!wrapper) return;

            const content = wrapper.querySelector('.file-upload-content');
            const preview = wrapper.querySelector('.file-preview');
            const fileName = wrapper.querySelector('.file-name');
            const fileLink = wrapper.querySelector('.file-link');

            console.log('[FILE LISTENER] 📤 Change event triggered for', this.name);
            console.log('[FILE LISTENER] 📁 Files count:', this.files.length, '| Selected file:', file?.name);

            if (file) {
                const allowedTypes = ['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'];
                const maxSize = 50 * 1024 * 1024;
                const allowedByMime = allowedTypes.includes(file.type) || file.type === '' || file.type === 'application/octet-stream';
                const allowedByExtension = /\.(pdf|doc|docx)$/i.test(file.name || '');

                console.log(`[FILE LISTENER] 🔍 Validation: MIME=${file.type}, allowedByMime=${allowedByMime}, allowedByExtension=${allowedByExtension}`);

                if (!(allowedByMime && allowedByExtension)) {
                    alert('Only PDF and DOC/DOCX files are allowed');
                    this.value = '';
                    if (content) content.classList.remove('hidden');
                    if (preview && (!phaseCard || phaseCard.dataset.hasFile !== 'true')) preview.classList.add('hidden');
                    return;
                }

                if (file.size > maxSize) {
                    alert('File size must be less than 50MB');
                    this.value = '';
                    if (content) content.classList.remove('hidden');
                    if (preview && (!phaseCard || phaseCard.dataset.hasFile !== 'true')) preview.classList.add('hidden');
                    return;
                }

                if (fileName) fileName.textContent = file.name + ' (' + (file.size / 1024).toFixed(2) + ' KB)';
                if (fileLink) fileLink.href = URL.createObjectURL(file);
                if (content) content.classList.add('hidden');
                if (preview) preview.classList.remove('hidden');
                if (phaseCard) {
                    phaseCard.dataset.hasFile = 'true';
                }
                wrapper.classList.remove('border-red-500', 'bg-red-50');
                isChanged = true;
            } else {
                if (content) content.classList.remove('hidden');
                if (preview && (!phaseCard || phaseCard.dataset.hasFile !== 'true')) preview.classList.add('hidden');
            }
        });

        const wrapper = fileInput.closest('.file-upload-wrapper');
        if (!wrapper) return;

        ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
            wrapper.addEventListener(eventName, preventDefaults, false);
        });

        function preventDefaults(e) {
            e.preventDefault();
            e.stopPropagation();
        }

        ['dragenter', 'dragover'].forEach(eventName => {
            wrapper.addEventListener(eventName, () => {
                wrapper.classList.add('border-primary', 'bg-primary/5');
            });
        });

        ['dragleave', 'drop'].forEach(eventName => {
            wrapper.addEventListener(eventName, () => {
                wrapper.classList.remove('border-primary', 'bg-primary/5');
            });
        });

        wrapper.addEventListener('drop', (e) => {
            const dt = e.dataTransfer;
            const files = dt.files;
            fileInput.files = files;
            fileInput.dispatchEvent(new Event('change', { bubbles: true }));
        });
    }

    /**
     * ✅ FILE UPLOAD VALIDATION - Check that all phases have files
     */
    function validatePhaseFiles() {
        const phaseCards = document.querySelectorAll('.phase-card');
        let isValid = true;
        
        phaseCards.forEach((card, index) => {
            const phaseNum = index + 1;
            const fileInput = card.querySelector('input[type="file"].file-input');
            const filePreview = card.querySelector('.file-preview');
            const hasSelectedFile = !!(fileInput && fileInput.files && fileInput.files.length > 0);
            const hasVisiblePreview = !!(filePreview && !filePreview.classList.contains('hidden'));
            const hasPersistedFile = card.dataset.hasFile === 'true';
            const uploadWrapper = card.querySelector('.file-upload-wrapper');
            
            if (!(hasSelectedFile || hasVisiblePreview || hasPersistedFile)) {
                isValid = false;
                if (uploadWrapper) {
                    uploadWrapper.classList.add('border-red-500', 'bg-red-50');
                }
                console.error(`❌ Phase ${phaseNum}: File is required but not provided`);
            } else if (uploadWrapper) {
                uploadWrapper.classList.remove('border-red-500', 'bg-red-50');
            }
        });
        
        return isValid;
    }

    /**
     * ✅ CORE LOGIC: AJAX Submission
     */
    function handleUpdateAction() {
        const selectedBeforeSync = snapshotSelectedAnswers();
        syncPhaseInputNames();
        restoreSelectedAnswers(selectedBeforeSync);
        if (!validateForm()) return;

        // ✅ NEW: Validate that all phases have files
        if (!validatePhaseFiles()) {
            console.error("❌ [SUBMIT BLOCKED] File validation failed");
            alert('⚠️ File Upload Required:\n\n✓ Each phase MUST have a guide (PDF or Document)\n❌ Currently some phases do not have files\n\nPlease upload guides for all phases before publishing.');
            return;
        }

        const toast = document.getElementById('saveToast');
        const toastMsg = document.getElementById('toastMessage');
        const btn = document.getElementById('submitBtn');
        const btnText = document.getElementById('btnText');
        const form = document.getElementById('roadmapForm');
        const isPublished = document.getElementById('statusToggle').checked;
        const originalText = btnText.innerText;

        btn.disabled = true;
        btn.classList.add('opacity-75', 'cursor-not-allowed');
        btnText.innerText = "Synchronizing...";

        const payload = buildSubmissionParams(form);
        const selectedFiles = getSelectedPhaseFiles(form);
        console.log('[UPLOAD][EDIT] 📊 selectedFiles.count=', selectedFiles.length);
        console.log('[UPLOAD][EDIT] 📋 selectedFiles details:', selectedFiles.map(f => ({
            phaseNumber: f.phaseNumber,
            phaseId: f.phaseId,
            fileName: f.file?.name,
            fileSize: f.file?.size,
            fileType: f.file?.type
        })));

        const debugQuizKeys = [];
        payload.forEach((value, key) => {
            if (key.startsWith('phaseQuiz_')) {
                debugQuizKeys.push(key + '=' + value);
            }
        });
        console.log('[EDIT DEBUG] phaseQuiz payload count:', debugQuizKeys.length);
        console.log('[EDIT DEBUG] phaseQuiz payload sample:', debugQuizKeys.slice(0, 30));

        fetch(form.action, {
            method: "POST",
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: payload.toString()
        })
        .then(async response => {
            const responseText = (await response.text()).trim();
            if(response.ok) {
                let pathId = null;
                const match = responseText.match(/PATH_UPDATED\s*:\s*(\d+)/i);
                if (match && match[1]) {
                    pathId = parseInt(match[1], 10);
                }
                if (!Number.isInteger(pathId) || pathId <= 0) {
                    const hiddenPathId = parseInt((document.getElementById('pathId')?.value || '').trim(), 10);
                    if (Number.isInteger(hiddenPathId) && hiddenPathId > 0) {
                        pathId = hiddenPathId;
                    }
                }
                console.log('[SUBMIT] ✅ Path saved successfully - pathId=' + pathId + ', selectedFiles.length=' + selectedFiles.length);

                // Upload files if any were selected
                if (selectedFiles.length > 0) {
                    if (!Number.isInteger(pathId) || pathId <= 0) {
                        throw new Error('Edit saved but valid path ID is missing for file upload');
                    }
                    console.log('[SUBMIT] 📤 Starting file uploads for', selectedFiles.length, 'file(s)');
                    try {
                        await uploadPhaseFiles(pathId, selectedFiles);
                        console.log('[SUBMIT] ✅ All files uploaded successfully');
                    } catch (uploadErr) {
                        console.error('[SUBMIT] ❌ File upload failed:', uploadErr.message);
                        alert('❌ File Upload Failed:\n\n' + uploadErr.message + '\n\nChanges were NOT saved. Please try again.');
                        btn.disabled = false;
                        btn.classList.remove('opacity-75', 'cursor-not-allowed');
                        btnText.innerText = originalText;
                        return; // Stop here, don't redirect
                    }
                } else {
                    console.log('[SUBMIT] ℹ️ No new files selected - only metadata saved');
                }

                isChanged = false; 
                toastMsg.innerText = isPublished ? "Roadmap Published Successfully" : "Draft Saved Successfully";
                toast.classList.remove('hidden');
                toast.classList.add('flex', 'animate-pop');
                setTimeout(() => {
                    window.location.href = "<%=request.getContextPath()%>/user/career-mgmt?status=saved";
                }, 1500);
            } else {
                throw new Error(responseText || "Server synchronization failed");
            }
        })
        .catch(err => {
            alert("Error: " + err.message);
            btn.disabled = false;
            btn.classList.remove('opacity-75', 'cursor-not-allowed');
            btnText.innerText = originalText;
        });
    }

    /**
     * ✅ SAFETY & INITIALIZATION
     */
    window.onbeforeunload = function() {
        if (isChanged) return "Unsaved changes detected.";
    };

    // Clean up input errors when user types
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

    // Clean up radio validation errors IMMEDIATELY when the user clicks a radio button
    document.addEventListener('change', (e) => {
        if (e.target.classList.contains('correct-radio')) {
            const questionBlock = e.target.closest('.question-block');
            if (questionBlock) {
                const validationMsg = questionBlock.querySelector('.radio-validation-msg');
                if (validationMsg) {
                    validationMsg.classList.add('hidden');
                }
            }
        }
    });

    window.onload = function() {
        const phaseCards = document.querySelectorAll('#phasesContainer .phase-card');
        phaseCount = phaseCards.length;
        updateLabels();

        const statusToggle = document.getElementById('statusToggle');
        const currentStatus = (document.getElementById('pathStatus').value || '').toUpperCase();
        if (statusToggle) {
            statusToggle.checked = currentStatus === 'PUBLISHED';
            toggleStatus(statusToggle);
        }

        document.querySelectorAll('.file-input').forEach(setupFileUploadListener);

        if(document.getElementById('phasesContainer').children.length === 0) {
            addPhase();
        }
        isChanged = false; 
    };
</script>

</body>
</html>