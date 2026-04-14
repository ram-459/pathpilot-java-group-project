<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    // 🔐 SESSION + CACHE FIX ONLY
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // 🔐 If not logged in → redirect
    if(session == null || session.getAttribute("role") == null){
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    // Get studentId from request
    String studentId = request.getParameter("studentId");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>Student Detail - PathPilot</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: "#4913ec",
                        "primary-dark": "#3a0fb5",
                        "background-light": "#f6f6f8"
                    },
                    fontFamily: { sans: ["'Plus Jakarta Sans'", "sans-serif"] }
                }
            }
        }
    </script>
</head>

<body class="bg-background-light font-sans overflow-hidden">
    <div class="flex h-screen">
        <%-- SIDEBAR --%>
        <jsp:include page="../components/user_sidebar.jsp" />

        <div class="flex-1 flex flex-col overflow-hidden">
            <header class="h-16 bg-white/80 backdrop-blur-md border-b flex items-center justify-between px-10">
                <nav class="text-xs font-black uppercase tracking-widest text-gray-400 flex items-center">
                    Creator
                    <span class="material-icons-round mx-2 text-xs text-gray-300">chevron_right</span>
                    <a href="<%=request.getContextPath()%>/user/learner-mgmt" class="hover:text-primary transition cursor-pointer">Learner Management</a>
                    <span class="material-icons-round mx-2 text-xs text-gray-300">chevron_right</span>
                    <span class="text-primary">Student Profile</span>
                </nav>
                <a href="<%=request.getContextPath()%>/user/learner-mgmt" class="flex items-center gap-2 px-4 py-2 text-sm font-semibold text-gray-600 hover:text-primary transition">
                    <span class="material-icons-round text-lg">arrow_back</span>
                    Back
                </a>
            </header>

            <main class="flex-1 overflow-y-auto p-10">
                <!-- Student Header Section - Compact Row Layout -->
                <div class="mb-8">
                    <div class="bg-white rounded-[2.5rem] border border-gray-100 shadow-sm p-6">
                        <div class="flex items-center justify-between gap-6">
                            <!-- Left: Profile Picture & Name -->
                            <div class="flex items-center gap-4 flex-1">
                                <!-- Profile Picture -->
                                <c:choose>
                                    <c:when test="${student.profilePic != null && student.profilePic != ''}">
                                        <%
                                            String picPath = pageContext.getAttribute("student") != null ? 
                                                ((java.util.Map) pageContext.getAttribute("student")).get("profilePic").toString() : "";
                                            String filename = picPath.substring(Math.max(picPath.lastIndexOf('/'), 0) + 1);
                                            String fileUrl = request.getContextPath() + "/student/file/" + filename;
                                        %>
                                        <img src="<%= fileUrl %>" alt="${student.name}" class="w-16 h-16 rounded-full object-cover border-2 border-indigo-200">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="w-16 h-16 rounded-full bg-gradient-to-br from-indigo-500 to-indigo-600 flex items-center justify-center text-2xl font-bold text-white">
                                            ${fn:substring(student.name, 0, 1)}
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                
                                <!-- Name & Email -->
                                <div>
                                    <h1 class="text-xl font-800 text-gray-900">${student.name}</h1>
                                    <p class="text-xs text-gray-500">${student.email}</p>
                                </div>
                            </div>
                            
                            <!-- Middle: Course Enrolled - Now shows all courses with Show buttons -->
                            <div class="flex-1 border-l border-gray-100 pl-6">
                                <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-2">Enrolled Courses</p>
                                <div class="flex flex-wrap gap-2">
                                    <c:forEach var="enrollment" items="${allEnrollments}">
                                        <a href="<%=request.getContextPath()%>/user/student-detail?studentId=<%=studentId%>&enrollmentId=${enrollment.enrollment_id}" 
                                           class="px-3 py-1.5 rounded-lg text-xs font-bold transition ${enrollment.enrollment_id == selectedEnrollment.enrollment_id ? 'bg-indigo-600 text-white' : 'bg-gray-100 text-gray-700 hover:bg-gray-200'}">
                                            ${fn:substring(enrollment.path_title, 0, 20)}...
                                        </a>
                                    </c:forEach>
                                </div>
                            </div>
                            
                            <!-- Middle-Right: Progress -->
                            <div class="flex-1 border-l border-gray-100 pl-6">
                                <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-1">Progress</p>
                                <div class="flex items-center gap-2">
                                    <div class="flex-1 h-1.5 bg-gray-100 rounded-full overflow-hidden">
                                        <div class="bg-indigo-600 h-full" style="width: ${selectedEnrollment.progress_percentage}%"></div>
                                    </div>
                                    <span class="text-sm font-bold text-gray-900 min-w-fit">${selectedEnrollment.progress_percentage}%</span>
                                </div>
                            </div>
                            
                            <!-- Right: Certification Status - Simple Done/Not Done -->
                            <div class="border-l border-gray-100 pl-6">
                                <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-2">Certified</p>
                                <c:choose>
                                    <c:when test="${selectedEnrollment.is_completed}">
                                        <span class="px-3 py-1 bg-green-100 text-green-700 rounded-lg text-xs font-black inline-block">✓ Done</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="px-3 py-1 bg-gray-100 text-gray-600 rounded-lg text-xs font-black inline-block">Not Done</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Two Columns Layout -->
                <div class="grid grid-cols-3 gap-8">
                    <!-- Left: Enrollment Details (2 cols) -->
                    <div class="col-span-2 space-y-8">
                        <!-- Enrollment Path Info -->
                        <div class="bg-white rounded-[2.5rem] border border-gray-100 shadow-sm p-8">
                            <h2 class="text-xl font-800 text-gray-900 mb-6 flex items-center gap-2">
                                <span class="material-icons-round text-indigo-600">path</span>
                                Enrollment Details
                            </h2>
                            
                            <div class="space-y-6">
                                <div class="grid grid-cols-2 gap-6">
                                    <!-- Path Title -->
                                    <div>
                                        <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Path</label>
                                        <p class="text-lg font-bold text-gray-900 mt-2">${selectedEnrollment.path_title}</p>
                                    </div>
                                    
                                    <!-- Level -->
                                    <div>
                                        <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Level</label>
                                        <p class="text-lg font-bold text-gray-900 mt-2">
                                            <span class="px-3 py-1 bg-indigo-100 text-indigo-600 rounded-lg text-xs font-black">${selectedEnrollment.level}</span>
                                        </p>
                                    </div>
                                    
                                    <!-- Category -->
                                    <div>
                                        <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Category</label>
                                        <p class="text-lg font-bold text-gray-900 mt-2">${selectedEnrollment.category != null ? selectedEnrollment.category : 'N/A'}</p>
                                    </div>
                                    
                                    <!-- Total Phases -->
                                    <div>
                                        <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Total Phases</label>
                                        <p class="text-lg font-bold text-gray-900 mt-2">${selectedEnrollment.total_phases} phases</p>
                                    </div>
                                </div>
                                
                                <!-- Path Description -->
                                <div>
                                    <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Description</label>
                                    <p class="text-gray-700 mt-2 leading-relaxed">
                                        ${selectedEnrollment.path_description != null ? selectedEnrollment.path_description : 'No description available'}
                                    </p>
                                </div>
                                
                                <!-- Enrollment Timeline -->
                                <div class="grid grid-cols-2 gap-6 pt-4 border-t border-gray-100">
                                    <div>
                                        <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Enrolled Date</label>
                                        <p class="text-gray-900 font-semibold mt-2">
                                            <fmt:formatDate value="${selectedEnrollment.enrolled_date}" pattern="MMM dd, yyyy"/>
                                        </p>
                                    </div>
                                    <c:if test="${selectedEnrollment.completion_date != null}">
                                        <div>
                                            <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Completed Date</label>
                                            <p class="text-gray-900 font-semibold mt-2">
                                                <fmt:formatDate value="${selectedEnrollment.completion_date}" pattern="MMM dd, yyyy"/>
                                            </p>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <!-- Progress by Phase -->
                        <div class="bg-white rounded-[2.5rem] border border-gray-100 shadow-sm p-8">
                            <h2 class="text-xl font-800 text-gray-900 mb-6 flex items-center gap-2">
                                <span class="material-icons-round text-indigo-600">assignment_turned_in</span>
                                Phase Progress
                            </h2>
                            
                            <div class="space-y-4">
                                <c:choose>
                                    <c:when test="${not empty phaseProgress}">
                                        <c:forEach var="phase" items="${phaseProgress}" varStatus="status">
                                            <div class="border border-gray-100 rounded-2xl p-6 hover:border-indigo-200 hover:bg-indigo-50/30 transition">
                                                <div class="flex items-start justify-between">
                                                    <div class="flex-1">
                                                        <div class="flex items-center gap-3 mb-2">
                                                            <span class="w-8 h-8 rounded-full bg-indigo-100 text-indigo-600 flex items-center justify-center font-bold text-sm">
                                                                ${phase.phase_number}
                                                            </span>
                                                            <h3 class="text-lg font-bold text-gray-900">${phase.phase_title}</h3>
                                                            <c:if test="${phase.is_completed}">
                                                                <span class="material-icons-round text-green-500 text-xl">task_alt</span>
                                                            </c:if>
                                                        </div>
                                                        
                                                        <c:if test="${phase.phase_content != null}">
                                                            <p class="text-gray-600 text-sm ml-11 mb-3">${fn:substring(phase.phase_content, 0, 150)}...</p>
                                                        </c:if>
                                                        
                                                        <div class="ml-11 grid grid-cols-3 gap-4 text-sm">
                                                            <div>
                                                                <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Attempts</p>
                                                                <p class="text-gray-900 font-bold mt-1">${phase.attempts > 0 ? phase.attempts : 'None'}</p>
                                                            </div>
                                                            <div>
                                                                <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Best Score</p>
                                                                <p class="text-gray-900 font-bold mt-1">
                                                                    ${phase.best_score != null ? phase.best_score : 'N/A'}
                                                                </p>
                                                            </div>
                                                            <div>
                                                                <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Status</p>
                                                                <p class="mt-1">
                                                                    <c:choose>
                                                                        <c:when test="${phase.is_completed}">
                                                                            <span class="px-2 py-1 bg-green-100 text-green-700 rounded-md text-xs font-bold">Completed</span>
                                                                        </c:when>
                                                                        <c:when test="${phase.attempts > 0}">
                                                                            <span class="px-2 py-1 bg-yellow-100 text-yellow-700 rounded-md text-xs font-bold">In Progress</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="px-2 py-1 bg-gray-100 text-gray-600 rounded-md text-xs font-bold">Not Started</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </p>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-12 text-gray-400">
                                            <p class="font-semibold mb-2">No phase progress yet</p>
                                            <p class="text-sm">Student hasn't started any phases.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <!-- Right: Summary Stats (1 col) -->
                    <div class="space-y-6">
                        <!-- Overall Progress Card -->
                        <div class="bg-white rounded-[2.5rem] border border-gray-100 shadow-sm p-8">
                            <h3 class="text-sm font-black text-gray-400 uppercase tracking-widest mb-4">Overall Progress</h3>
                            
                            <div class="mb-6">
                                <div class="flex items-center justify-between mb-2">
                                    <span class="text-3xl font-800 text-gray-900">${selectedEnrollment.progress_percentage}%</span>
                                </div>
                                <div class="h-3 bg-gray-100 rounded-full overflow-hidden">
                                    <div class="bg-gradient-to-r from-indigo-500 to-indigo-600 h-full transition-all" style="width: ${selectedEnrollment.progress_percentage}%"></div>
                                </div>
                            </div>
                            
                            <div class="text-center">
                                <c:choose>
                                    <c:when test="${selectedEnrollment.progress_percentage >= 100}">
                                        <span class="px-4 py-2 bg-green-100 text-green-700 rounded-lg text-sm font-bold inline-block">✓ Completed</span>
                                    </c:when>
                                    <c:when test="${selectedEnrollment.progress_percentage >= 75}">
                                        <span class="px-4 py-2 bg-blue-100 text-blue-700 rounded-lg text-sm font-bold inline-block">Almost There</span>
                                    </c:when>
                                    <c:when test="${selectedEnrollment.progress_percentage >= 50}">
                                        <span class="px-4 py-2 bg-indigo-100 text-indigo-700 rounded-lg text-sm font-bold inline-block">Half Way</span>
                                    </c:when>
                                    <c:when test="${selectedEnrollment.progress_percentage > 0}">
                                        <span class="px-4 py-2 bg-yellow-100 text-yellow-700 rounded-lg text-sm font-bold inline-block">Getting Started</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="px-4 py-2 bg-gray-100 text-gray-600 rounded-lg text-sm font-bold inline-block">Not Started</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Quick Stats -->
                        <div class="bg-white rounded-[2.5rem] border border-gray-100 shadow-sm p-8">
                            <h3 class="text-sm font-black text-gray-400 uppercase tracking-widest mb-6">Statistics</h3>
                            
                            <div class="space-y-5">
                                <!-- Completed Phases -->
                                <div class="flex items-center justify-between">
                                    <div class="flex items-center gap-3">
                                        <div class="w-10 h-10 rounded-lg bg-green-100 flex items-center justify-center">
                                            <span class="material-icons-round text-green-600 text-xl">check_circle</span>
                                        </div>
                                        <span class="text-gray-700 font-semibold">Phases Completed</span>
                                    </div>
                                    <span class="text-2xl font-bold text-green-600">
                                        <c:set var="completedCount" value="0"/>
                                        <c:forEach var="phase" items="${phaseProgress}">
                                            <c:if test="${phase.is_completed}">
                                                <c:set var="completedCount" value="${completedCount + 1}"/>
                                            </c:if>
                                        </c:forEach>
                                        ${completedCount}
                                    </span>
                                </div>
                                
                                <!-- In Progress Phases -->
                                <div class="flex items-center justify-between">
                                    <div class="flex items-center gap-3">
                                        <div class="w-10 h-10 rounded-lg bg-yellow-100 flex items-center justify-center">
                                            <span class="material-icons-round text-yellow-600 text-xl">pending</span>
                                        </div>
                                        <span class="text-gray-700 font-semibold">In Progress</span>
                                    </div>
                                    <span class="text-2xl font-bold text-yellow-600">
                                        <c:set var="inProgressCount" value="0"/>
                                        <c:forEach var="phase" items="${phaseProgress}">
                                            <c:if test="${!phase.is_completed && phase.attempts > 0}">
                                                <c:set var="inProgressCount" value="${inProgressCount + 1}"/>
                                            </c:if>
                                        </c:forEach>
                                        ${inProgressCount}
                                    </span>
                                </div>
                                
                                <!-- Not Started -->
                                <div class="flex items-center justify-between">
                                    <div class="flex items-center gap-3">
                                        <div class="w-10 h-10 rounded-lg bg-gray-100 flex items-center justify-center">
                                            <span class="material-icons-round text-gray-600 text-xl">schedule</span>
                                        </div>
                                        <span class="text-gray-700 font-semibold">Not Started</span>
                                    </div>
                                    <span class="text-2xl font-bold text-gray-600">
                                        <c:set var="notStartedCount" value="0"/>
                                        <c:forEach var="phase" items="${phaseProgress}">
                                            <c:if test="${phase.attempts == 0}">
                                                <c:set var="notStartedCount" value="${notStartedCount + 1}"/>
                                            </c:if>
                                        </c:forEach>
                                        ${notStartedCount}
                                    </span>
                                </div>
                            </div>
                        </div>

                        <!-- Enrollment Duration -->
                        <div class="bg-white rounded-[2.5rem] border border-gray-100 shadow-sm p-8">
                            <h3 class="text-sm font-black text-gray-400 uppercase tracking-widest mb-6">Duration</h3>
                            
                            <div class="space-y-4">
                                <div>
                                    <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Starting Date</label>
                                    <p class="text-lg font-bold text-gray-900 mt-2">
                                        <fmt:formatDate value="${selectedEnrollment.enrolled_date}" pattern="MMM dd, yyyy"/>
                                    </p>
                                </div>
                                
                                <c:if test="${selectedEnrollment.completion_date != null}">
                                    <div>
                                        <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Completion Date</label>
                                        <p class="text-lg font-bold text-gray-900 mt-2">
                                            <fmt:formatDate value="${selectedEnrollment.completion_date}" pattern="MMM dd, yyyy"/>
                                        </p>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script>
    </script>
</body>
</html>
