<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>Learner Management - PathPilot</title>
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
                    <span class="text-primary">Learner Management</span>
                </nav>
            </header>

            <main class="flex-1 overflow-y-auto p-10">
                <div class="mb-10">
                    <h1 class="text-3xl font-800 text-gray-900 tracking-tight">Learner Analytics</h1>
                    <p class="text-gray-500 text-sm font-medium mt-1">Monitor enrollment and moderate access for your career paths.</p>
                </div>

                <div class="bg-white rounded-[2.5rem] border border-gray-100 shadow-sm overflow-hidden">
                    <table class="w-full text-sm text-left">
                        <thead class="bg-gray-50/50 border-b border-gray-50">
                            <tr>
                                <th class="px-8 py-5 text-[10px] font-black text-gray-400 uppercase tracking-widest">Learner</th>
                                <th class="px-8 py-5 text-[10px] font-black text-gray-400 uppercase tracking-widest">Enrolled Path</th>
                                <th class="px-8 py-5 text-[10px] font-black text-gray-400 uppercase tracking-widest">Progress</th>
                                <th class="px-8 py-5 text-[10px] font-black text-gray-400 uppercase tracking-widest text-center">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-50">
                            <c:choose>
                                <c:when test="${not empty enrolledStudents}">
                                    <c:forEach var="student" items="${enrolledStudents}">
                                        <tr class="hover:bg-gray-50/30 transition-colors">
                                            <td class="px-8 py-6 flex items-center gap-4">
                                                <div class="w-10 h-10 rounded-full bg-indigo-100 flex items-center justify-center text-indigo-600 font-bold">
                                                    ${fn:substring(student.student_name, 0, 1)}
                                                </div>
                                                <div>
                                                    <p class="font-bold text-gray-900">${student.student_name}</p>
                                                    <p class="text-[10px] text-gray-400">${student.student_email}</p>
                                                </div>
                                            </td>
                                            <td class="px-8 py-6">
                                                <span class="px-3 py-1 bg-gray-100 text-gray-600 rounded-lg text-[10px] font-black uppercase tracking-tight">${student.path_title}</span>
                                            </td>
                                            <td class="px-8 py-6">
                                                <div class="flex items-center gap-3">
                                                    <div class="flex-1 h-1.5 bg-gray-100 rounded-full overflow-hidden">
                                                        <div class="bg-indigo-600 h-full" style="width: ${student.progress_percentage}%"></div>
                                                    </div>
                                                    <span class="text-[10px] font-black text-gray-800">${student.progress_percentage}%</span>
                                                </div>
                                            </td>
                                            <td class="px-8 py-6">
                                                <div class="flex justify-center gap-2">
                                                    <a href="<%=request.getContextPath()%>/user/student-detail?studentId=${student.student_id}&enrollmentId=${student.enrollment_id}" 
                                                            class="p-2 bg-indigo-50 text-primary rounded-xl hover:bg-indigo-100 transition shadow-sm">
                                                        <span class="material-icons-round text-lg">visibility</span>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="4" class="px-8 py-12 text-center">
                                            <div class="text-gray-400">
                                                <p class="font-semibold mb-2">No enrolled students yet</p>
                                                <p class="text-xs">Students who enroll in your career paths will appear here.</p>
                                            </div>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>
    </div>

    <script>
    </script>
</body>
</html>