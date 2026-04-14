<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // 🔐 SESSION + CACHE GUARD
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // 🔐 If not logged in → redirect
    if (session == null || session.getAttribute("role") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>${param.title} Roadmap - PathPilot</title>

    <%-- ✅ REQUIRED: Load the same fonts as the Navbar --%>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        'primary': '#4913ec',
                        'primary-dark': '#3a0fb5'
                    },
                    fontFamily: {
                        'sans': ["'Plus Jakarta Sans'", 'sans-serif'],
                        'heading': ['Poppins', 'sans-serif']
                    }
                }
            }
        }
    </script>

    <style type="text/tailwindcss">
        body { font-family: 'Plus Jakarta Sans', sans-serif; }
        h1, h2, h3, .font-heading { font-family: 'Poppins', sans-serif; }

        .timeline-line {
            width: 2px;
            background: #e5e7eb;
            position: absolute;
            top: 0;
            bottom: 0;
            left: 19px;
            z-index: 0;
        }
        .phase-card {
            @apply bg-white rounded-[2rem] border border-gray-100 p-8 shadow-sm relative z-10 transition-all duration-300 hover:shadow-md;
        }
    </style>
</head>

<body class="bg-[#f8f9fc] antialiased">

    <%-- Calling the standardized horizontal navbar --%>
    <jsp:include page="/WEB-INF/views/components/user_navbar.jsp" />

    <header class="max-w-5xl mx-auto px-6 pt-12 pb-8">
        <div class="flex flex-col md:flex-row md:items-center justify-between border-b border-gray-100 pb-12 gap-6">
            <div class="flex-1">
                <span class="text-[10px] font-black text-gray-400 uppercase tracking-[0.2em] flex items-center gap-2 mb-2">
                    <span class="material-icons-round text-sm text-primary">school</span>
                    ${careerPath.status} Course
                </span>

                <h1 class="text-3xl sm:text-4xl md:text-5xl font-800 text-gray-900 tracking-tight">
                    ${careerPath != null ? careerPath.title : "Career Path"}
                </h1>

                <p class="text-gray-500 mt-3 font-medium text-sm sm:text-base">
                    ${careerPath != null ? careerPath.description : "Master modern engineering from zero to job-ready professional."}
                </p>

                <c:if test="${careerPath != null}">
                    <div class="flex flex-wrap gap-4 mt-6">
                        <div class="flex items-center gap-2">
                            <span class="text-xs font-bold text-gray-400 uppercase">Level:</span>
                            <span class="text-sm font-bold text-primary">${careerPath.level}</span>
                        </div>
                        <div class="flex items-center gap-2">
                            <span class="text-xs font-bold text-gray-400 uppercase">Category:</span>
                            <span class="text-sm font-bold text-primary">${careerPath.category}</span>
                        </div>
                    </div>
                </c:if>
            </div>

            <%-- ✅ Conditional: Continue or Enrollment Form --%>
            <c:if test="${careerPath != null}">
                <c:choose>
                    <c:when test="${isEnrolled}">
                        <c:choose>
                            <c:when test="${firstPhaseId != null}">
                                <a href="<%=request.getContextPath()%>/student/module?phaseId=${firstPhaseId}&path=${careerPath.pathId}&enrollmentId=${enrollmentId}" class="bg-green-600 hover:bg-green-700 text-white px-6 sm:px-8 py-3 sm:py-4 rounded-2xl font-bold shadow-xl shadow-green-600/20 transition-all flex items-center justify-center gap-2 active:scale-95 whitespace-nowrap inline-flex">
                                    <span class="material-icons-round text-lg sm:text-base">play_circle</span>
                                    <span class="hidden sm:inline">Continue</span>
                                    <span class="sm:hidden">Continue</span>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="<%=request.getContextPath()%>/student/progress?enrollmentId=${enrollmentId}" class="bg-green-600 hover:bg-green-700 text-white px-6 sm:px-8 py-3 sm:py-4 rounded-2xl font-bold shadow-xl shadow-green-600/20 transition-all flex items-center justify-center gap-2 active:scale-95 whitespace-nowrap inline-flex">
                                    <span class="material-icons-round text-lg sm:text-base">play_circle</span>
                                    <span class="hidden sm:inline">Continue</span>
                                    <span class="sm:hidden">Continue</span>
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <form method="POST" action="<%=request.getContextPath()%>/student/enroll" class="w-full md:w-[360px] bg-white border border-gray-100 rounded-2xl p-5 shadow-sm space-y-3">
                            <input type="hidden" name="pathId" value="${careerPath.pathId}">
                            <div>
                                <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Name</label>
                                <input type="text" value="${studentUser != null ? studentUser.name : ''}" readonly class="w-full mt-1 rounded-xl border border-gray-200 bg-gray-50 text-gray-700 text-sm px-3 py-2.5">
                            </div>
                            <div>
                                <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Email</label>
                                <input type="email" value="${studentUser != null ? studentUser.email : ''}" readonly class="w-full mt-1 rounded-xl border border-gray-200 bg-gray-50 text-gray-700 text-sm px-3 py-2.5">
                            </div>
                            <div>
                                <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Contact Number</label>
                                <input type="text" name="contact" value="${studentUser != null ? studentUser.phone : ''}" placeholder="Enter contact number" class="w-full mt-1 rounded-xl border border-gray-200 bg-white text-gray-700 text-sm px-3 py-2.5" pattern="[0-9+\-\s]{7,20}" title="Enter a valid contact number">
                            </div>
                            <button type="submit" class="bg-primary hover:bg-primary-dark text-white px-6 sm:px-8 py-3 sm:py-4 rounded-2xl font-bold shadow-xl shadow-primary/20 transition-all flex items-center justify-center gap-2 active:scale-95 whitespace-nowrap">
                                <span class="material-icons-round text-lg sm:text-base">add_task</span>
                                <span class="hidden sm:inline">Enroll Now</span>
                                <span class="sm:hidden">Enroll</span>
                            </button>
                        </form>
                    </c:otherwise>
                </c:choose>
            </c:if>
        </div>
    </header>

    <main class="max-w-5xl mx-auto px-6 py-12 relative">

        <div class="timeline-line hidden md:block"></div>

        <div class="space-y-12">

            <c:choose>
                <c:when test="${not empty phases}">
                    <c:forEach var="phase" items="${phases}" varStatus="phaseLoop">
                        <%-- Find progress for this phase if enrolled --%>
                        <c:set var="phaseProgressData" value="${null}" />
                        <c:if test="${isEnrolled}">
                            <c:forEach var="prog" items="${phaseProgress}">
                                <c:if test="${prog.phaseId == phase.phaseId}">
                                    <c:set var="phaseProgressData" value="${prog}" />
                                </c:if>
                            </c:forEach>
                        </c:if>

                        <div class="relative pl-0 md:pl-16">
                            <div class="absolute left-4 top-0 hidden md:flex w-10 h-10 bg-primary rounded-full items-center justify-center text-white z-20 shadow-lg shadow-primary/20">
                                <span class="material-icons-round text-base font-bold">${phaseLoop.count}</span>
                            </div>

                            <div class="phase-card">
                                <div class="flex flex-col sm:flex-row sm:justify-between sm:items-start gap-4 mb-4">
                                    <div>
                                        <span class="text-[10px] font-black text-gray-400 uppercase tracking-widest">
                                            Phase ${phase.phaseNumber} • <c:choose>
                                                <c:when test="${isEnrolled}">Active</c:when>
                                                <c:otherwise>Locked</c:otherwise>
                                            </c:choose>
                                        </span>
                                        <c:if test="${isEnrolled && phaseProgressData != null}">
                                            <c:if test="${phaseProgressData.completed}">
                                                <span class="text-[10px] font-black text-green-600 uppercase tracking-widest ml-3">✓ Completed</span>
                                            </c:if>
                                        </c:if>
                                    </div>

                                    <c:if test="${isEnrolled && phaseProgressData != null}">
                                        <div class="text-right">
                                            <div class="text-sm font-bold text-primary">
                                                ${phaseProgressData.bestScore != null ? phaseProgressData.bestScore : '--'}/100
                                            </div>
                                            <div class="text-[10px] text-gray-500">Best Score • <c:out value="${phaseProgressData.attempts}" /> attempt<c:if test="${phaseProgressData.attempts != 1}">s</c:if></div>
                                        </div>
                                    </c:if>
                                </div>

                                <h3 class="text-xl sm:text-2xl font-800 text-gray-900">${phase.title}</h3>
                                <p class="text-sm text-gray-500 mt-3 font-medium leading-relaxed">${phase.content}</p>

                                <div class="mt-6 pt-6 border-t border-gray-100 flex items-center justify-between gap-4">
                                    <c:choose>
                                        <c:when test="${isEnrolled}">
                                            <a href="<%=request.getContextPath()%>/student/module?phaseId=${phase.phaseId}&path=${careerPath.pathId}&enrollmentId=${enrollmentId}" class="text-primary font-bold text-sm hover:underline flex items-center gap-2 transition-all hover:gap-3">
                                                <span>View Content</span>
                                                <span class="material-icons-round text-base">arrow_forward</span>
                                            </a>
                                            <a href="<%=request.getContextPath()%>/student/quiz?path=${careerPath.pathId}" class="bg-primary/10 hover:bg-primary/20 text-primary font-bold text-sm px-4 py-2 rounded-lg transition-all flex items-center gap-2">
                                                <span class="material-icons-round text-base">quiz</span>
                                                <span>Assessment</span>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="button" disabled class="text-gray-400 font-bold text-sm flex items-center gap-2 cursor-not-allowed">
                                                <span>Locked - Enroll to Access</span>
                                                <span class="material-icons-round text-base">lock</span>
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-20">
                        <span class="material-icons-round text-5xl text-gray-200 flex justify-center mb-4">info</span>
                        <h3 class="text-xl font-bold text-gray-900">No phases available</h3>
                        <p class="text-gray-500 mt-2">This course doesn't have any phases yet.</p>
                    </div>
                </c:otherwise>
            </c:choose>

        </div>
    </main>

    <script>
        function viewPhaseDetails(phaseId, pathId) {
            // Navigate to module content page
            window.location.href = "<%=request.getContextPath()%>/student/module?phaseId=" + phaseId + "&path=" + pathId;
        }

        function takeAssessment(pathId) {
            // Navigate to quiz selection page
            window.location.href = "<%=request.getContextPath()%>/student/quiz?path=" + pathId;
        }
    </script>

    <%-- Footer inclusion --%>
    <jsp:include page="/WEB-INF/views/components/student_footer.jsp" />

</body>

</html>