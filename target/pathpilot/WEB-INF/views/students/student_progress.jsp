<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

                <% // 🔐 SERVER-SIDE SESSION + CACHE VALIDATION
                    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate" );
                    response.setHeader("Pragma", "no-cache" ); response.setDateHeader("Expires", 0); if(session==null ||
                    session.getAttribute("role")==null){ response.sendRedirect(request.getContextPath() + "/login" );
                    return; } %>

                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Learning Progress - PathPilot</title>

                        <!-- External Resources -->
                        <script src="https://cdn.tailwindcss.com?plugins=forms"></script>
                        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
                        <link
                            href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Poppins:wght@500;600;700;800&display=swap"
                            rel="stylesheet" />
                        <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet" />

                        <script>
                            tailwind.config = {
                                theme: {
                                    extend: {
                                        colors: {
                                            primary: "#4913ec",
                                            "primary-dark": "#3a0fb5",
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
                            body { font-family: 'Plus Jakarta Sans', sans-serif; @apply bg-[#f8f9fc] antialiased; }
        h1, h2, h3, .font-800 { font-family: 'Poppins', sans-serif; font-weight: 800; }
    </style>
                    </head>

                    <body>

                        <%-- Student Navbar --%>
                            <jsp:include page="/WEB-INF/views/components/user_navbar.jsp" />

                            <div class="max-w-7xl mx-auto py-16 px-6">

                                <%-- Header Section --%>
                                    <div class="flex flex-col md:flex-row justify-between items-center mb-12 gap-6">
                                        <div>
                                            <span
                                                class="text-[10px] text-primary uppercase font-black tracking-widest bg-indigo-50 px-3 py-1 rounded-md">Enrolled
                                                Career Path</span>
                                            <h1 class="text-4xl text-gray-900 mt-2 tracking-tight">
                                                <c:choose>
                                                    <c:when test="${not empty careerPath.title}">
                                                        ${careerPath.title}
                                                    </c:when>
                                                    <c:otherwise>
                                                        My Roadmap
                                                    </c:otherwise>
                                                </c:choose>
                                            </h1>
                                            <p class="text-gray-500 mt-2 font-medium">
                                                <c:choose>
                                                    <c:when test="${not empty careerPath.description}">
                                                        ${fn:substring(careerPath.description, 0, 80)}...
                                                    </c:when>
                                                    <c:otherwise>
                                                        Track your phase-by-phase learning progress.
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                        </div>

                                        <a href="${pageContext.request.contextPath}/student/resources"
                                            class="bg-white border border-gray-200 text-gray-700 px-8 py-3 rounded-2xl font-bold shadow-sm hover:bg-gray-50 transition active:scale-95">
                                            Back to Paths
                                        </a>
                                    </div>

                                    <%-- Stats Grid --%>
                                        <div class="grid md:grid-cols-3 gap-8 mb-12">
                                            <div
                                                class="bg-white p-8 rounded-[2rem] shadow-sm border border-gray-100 text-center">
                                                <p
                                                    class="text-[10px] font-black text-gray-400 uppercase tracking-widest">
                                                    Overall Progress</p>
                                                <h2 class="text-5xl text-primary mt-3 tracking-tighter">${not empty
                                                    userStats.progress_percentage ? userStats.progress_percentage : 0}%
                                                </h2>
                                                <p class="text-gray-400 font-bold text-xs mt-2">COMPLETED</p>
                                            </div>

                                            <div
                                                class="bg-white p-8 rounded-[2rem] shadow-sm border border-gray-100 text-center">
                                                <p
                                                    class="text-[10px] font-black text-gray-400 uppercase tracking-widest">
                                                    Learning Time</p>
                                                <h2 class="text-4xl text-gray-800 mt-3 tracking-tight">
                                                    <c:set var="minutes"
                                                        value="${not empty userStats.total_learning_minutes_week ? userStats.total_learning_minutes_week : 0}" />
                                                    <c:set var="hours" value="${minutes > 0 ? minutes / 60 : 0}" />
                                                    <fmt:formatNumber value="${hours}" maxFractionDigits="0" /> Hours
                                                </h2>
                                                <p class="text-gray-400 text-xs font-bold mt-2">THIS WEEK</p>
                                            </div>

                                            <div
                                                class="bg-white p-8 rounded-[2rem] shadow-sm border border-gray-100 text-center">
                                                <p
                                                    class="text-[10px] font-black text-gray-400 uppercase tracking-widest">
                                                    Current Streak</p>
                                                <h2 class="text-4xl text-gray-800 mt-3 tracking-tight">${not empty
                                                    userStats.current_streak ? userStats.current_streak : 0} Days 🔥
                                                </h2>
                                                <p class="text-gray-400 text-xs font-bold mt-2">KEEP GOING</p>
                                            </div>
                                        </div>

                                        <%-- Certificate Section (Show when >= 60% progress) --%>
                                        <c:if test="${certificateEarned}">
                                            <div class="mb-12 bg-gradient-to-r from-yellow-400 via-orange-400 to-red-400 rounded-3xl p-8 shadow-lg border-4 border-yellow-300">
                                                <div class="grid md:grid-cols-2 gap-8 items-center">
                                                    <div class="text-white">
                                                        <div class="flex items-center gap-3 mb-4">
                                                            <span class="material-icons-round text-5xl">workspace_premium</span>
                                                            <h3 class="text-3xl font-bold font-heading">Certificate Earned!</h3>
                                                        </div>
                                                        <p class="text-lg text-white/90 mb-2">You've achieved <strong>${userStats.progress_percentage}% progress</strong> in this career path!</p>
                                                        <p class="text-sm text-white/80 mb-6">Download and share your certificate to showcase your achievement.</p>
                                                        <div class="flex flex-wrap gap-3">
                                                            <button onclick="downloadCertificateQuick()" class="px-6 py-3 bg-white text-orange-600 font-bold rounded-xl hover:bg-yellow-50 flex items-center gap-2 transition">
                                                                <span class="material-icons-round text-sm">download</span>
                                                                Download Certificate
                                                            </button>
                                                            <button onclick="viewFullCertificate()" class="px-6 py-3 bg-white/20 text-white font-bold rounded-xl hover:bg-white/30 border-2 border-white flex items-center gap-2 transition">
                                                                <span class="material-icons-round text-sm">open_in_new</span>
                                                                View Full
                                                            </button>
                                                        </div>
                                                    </div>
                                                    <div class="text-center text-white">
                                                        <p class="text-sm font-bold uppercase tracking-widest mb-2">Certificate ID</p>
                                                        <p class="text-3xl font-mono font-bold mb-4">${certificateId}</p>
                                                        <div class="bg-white/20 rounded-2xl p-6 border-2 border-white/50">
                                                            <span class="material-icons-round text-7xl inline-block">verified</span>
                                                            <p class="text-lg font-bold mt-3">Officially Verified</p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>

                                        <%-- Phase List --%>
                                            <div class="space-y-6">
                                                <c:choose>
                                                    <c:when test="${not empty phasesList}">
                                                        <c:set var="previousCompleted" value="true" scope="page" />
                                                        <c:forEach var="phase" items="${phasesList}" varStatus="loop">
                                                            <c:set var="phaseProgress" value="${null}" />
                                                            <c:forEach var="pp" items="${phaseProgressList}">
                                                                <c:if test="${pp.phase_id == phase.phaseId}">
                                                                    <c:set var="phaseProgress" value="${pp}" />
                                                                </c:if>
                                                            </c:forEach>

                                                            <c:set var="isCompletedNow"
                                                                value="${phaseProgress != null && phaseProgress.is_completed}" />
                                                            <c:set var="isInProgressNow"
                                                                value="${phaseProgress != null && phaseProgress.attempts > 0}" />
                                                            <c:set var="isUnlockedNow"
                                                                value="${loop.first || previousCompleted}" />

                                                            <c:choose>
                                                                <c:when test="${isCompletedNow}">
                                                                    <div
                                                                        class="bg-white p-8 rounded-[2.5rem] border border-gray-100 shadow-sm">
                                                                        <span
                                                                            class="text-[10px] text-green-600 font-black uppercase tracking-widest">Phase
                                                                            ${phase.phaseNumber} • Completed</span>
                                                                        <h3 class="text-xl text-gray-900 mt-1">
                                                                            ${phase.title}</h3>
                                                                        <p
                                                                            class="text-sm text-gray-500 mt-1 font-medium">
                                                                            ${fn:substring(phase.content, 0, 100)}...
                                                                        </p>

                                                                        <div
                                                                            class="flex items-center justify-between mt-8">
                                                                            <div class="flex-1 mr-10">
                                                                                <div
                                                                                    class="w-full bg-gray-100 h-2 rounded-full overflow-hidden">
                                                                                    <div
                                                                                        class="bg-green-500 h-2 rounded-full w-full shadow-sm">
                                                                                    </div>
                                                                                </div>
                                                                                <p
                                                                                    class="text-[10px] text-green-600 mt-3 font-black uppercase tracking-widest">
                                                                                    ${phaseProgress.best_score != null ?
                                                                                    phaseProgress.best_score : '100'}%
                                                                                    Complete
                                                                                </p>
                                                                            </div>
                                                                            <a href="${pageContext.request.contextPath}/student/module?phaseId=${phase.phaseId}&path=${careerPath.pathId}&enrollmentId=${enrollmentId}"
                                                                                class="px-8 py-3 text-xs font-black text-green-600 border-2 border-green-600 rounded-xl hover:bg-green-50 transition uppercase tracking-widest">
                                                                                Review
                                                                            </a>
                                                                        </div>
                                                                    </div>
                                                                </c:when>

                                                                <c:when test="${isUnlockedNow && isInProgressNow}">
                                                                    <div
                                                                        class="bg-white p-8 rounded-[2.5rem] border border-gray-100 shadow-sm ring-2 ring-primary/5">
                                                                        <span
                                                                            class="text-[10px] text-primary font-black uppercase tracking-widest">Phase
                                                                            ${phase.phaseNumber} • In Progress</span>
                                                                        <h3 class="text-xl text-gray-900 mt-1">
                                                                            ${phase.title}</h3>
                                                                        <p
                                                                            class="text-sm text-gray-500 mt-1 font-medium">
                                                                            ${fn:substring(phase.content, 0, 100)}...
                                                                        </p>

                                                                        <div
                                                                            class="flex items-center justify-between mt-8">
                                                                            <div class="flex-1 mr-10">
                                                                                <div
                                                                                    class="w-full bg-gray-100 h-2 rounded-full overflow-hidden">
                                                                                    <c:set var="progressPercent"
                                                                                        value="${phaseProgress.best_score != null ? phaseProgress.best_score : 50}" />
                                                                                    <div class="bg-primary h-2 rounded-full shadow-sm"
                                                                                        style="width: ${progressPercent}%">
                                                                                    </div>
                                                                                </div>
                                                                                <p
                                                                                    class="text-[10px] text-primary mt-3 font-black uppercase tracking-widest">
                                                                                    ${progressPercent}% Complete •
                                                                                    ${phaseProgress.attempts} Attempt(s)
                                                                                </p>
                                                                            </div>
                                                                            <a href="${pageContext.request.contextPath}/student/module?phaseId=${phase.phaseId}&path=${careerPath.pathId}&enrollmentId=${enrollmentId}"
                                                                                class="px-8 py-3 text-xs font-black text-white bg-primary rounded-xl hover:bg-primary-dark shadow-xl shadow-primary/20 transition active:scale-95 uppercase tracking-widest">
                                                                                Continue
                                                                            </a>
                                                                        </div>
                                                                    </div>
                                                                </c:when>

                                                                <c:when test="${isUnlockedNow}">
                                                                    <div
                                                                        class="bg-white p-8 rounded-[2.5rem] border border-gray-100 shadow-sm">
                                                                        <span
                                                                            class="text-[10px] text-indigo-600 font-black uppercase tracking-widest">Phase
                                                                            ${phase.phaseNumber} • Ready to Start</span>
                                                                        <h3 class="text-xl text-gray-900 mt-1">
                                                                            ${phase.title}</h3>
                                                                        <p
                                                                            class="text-sm text-gray-500 mt-1 font-medium">
                                                                            ${fn:substring(phase.content, 0, 100)}...
                                                                        </p>

                                                                        <div
                                                                            class="flex items-center justify-between mt-8">
                                                                            <div class="flex-1 mr-10">
                                                                                <div
                                                                                    class="w-full bg-gray-100 h-2 rounded-full overflow-hidden">
                                                                                    <div class="bg-indigo-400 h-2 rounded-full shadow-sm"
                                                                                        style="width: 0%"></div>
                                                                                </div>
                                                                                <p
                                                                                    class="text-[10px] text-indigo-600 mt-3 font-black uppercase tracking-widest">
                                                                                    Not Started</p>
                                                                            </div>
                                                                            <a href="${pageContext.request.contextPath}/student/module?phaseId=${phase.phaseId}&path=${careerPath.pathId}&enrollmentId=${enrollmentId}"
                                                                                class="px-8 py-3 text-xs font-black text-white bg-primary rounded-xl hover:bg-primary-dark shadow-xl shadow-primary/20 transition active:scale-95 uppercase tracking-widest">
                                                                                Start
                                                                            </a>
                                                                        </div>
                                                                    </div>
                                                                </c:when>

                                                                <c:otherwise>
                                                                    <div
                                                                        class="bg-white p-8 rounded-[2.5rem] border border-gray-100 shadow-sm opacity-50 grayscale-[0.5]">
                                                                        <span
                                                                            class="text-[10px] text-gray-400 font-black uppercase tracking-widest">Phase
                                                                            ${phase.phaseNumber} • Locked</span>
                                                                        <h3 class="text-xl text-gray-500 mt-1">
                                                                            ${phase.title}</h3>
                                                                        <p
                                                                            class="text-sm text-gray-400 mt-1 font-medium">
                                                                            ${fn:substring(phase.content, 0, 100)}...
                                                                        </p>
                                                                    </div>
                                                                </c:otherwise>
                                                            </c:choose>

                                                            <c:set var="previousCompleted" value="${isCompletedNow}"
                                                                scope="page" />
                                                        </c:forEach>
                                                    </c:when>

                                                    <c:otherwise>
                                                        <div
                                                            class="bg-white p-12 rounded-[2.5rem] border border-gray-100 shadow-sm text-center">
                                                            <p class="text-gray-400 font-semibold">No phases available
                                                                for this path yet.</p>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>

                                            </div>
                            </div>

                            <jsp:include page="/WEB-INF/views/components/student_footer.jsp" />

                            <script>
                                window.onload = function () {
                                    const urlParams = new URLSearchParams(window.location.search);
                                    if (urlParams.get('enrolled') === 'true') {
                                        Swal.fire({
                                            title: 'Enrollment Complete!',
                                            text: 'You have successfully enrolled in this path.',
                                            icon: 'success',
                                            confirmButtonColor: '#4913ec',
                                            customClass: {
                                                popup: 'rounded-[32px]',
                                                confirmButton: 'rounded-xl px-8 py-3 font-bold'
                                            }
                                        });
                                    }
                                }

                                function downloadCertificateQuick() {
                                    window.print();
                                }

                                function viewFullCertificate() {
                                    window.location.href = '${pageContext.request.contextPath}/student/certificate/${enrollmentId}';
                                }
                            </script>

                    </body>

                    </html>