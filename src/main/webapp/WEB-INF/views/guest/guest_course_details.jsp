<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>${careerPath != null ? careerPath.title : 'Course'} Roadmap - PathPilot</title>

    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>

    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet"/>

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
            @apply bg-white rounded-[2rem] border border-gray-100 p-8 shadow-sm relative z-10;
        }
    </style>
</head>

<body class="bg-[#f8f9fc] antialiased">

<jsp:include page="/WEB-INF/views/components/gnavbar.jsp"/>

<header class="max-w-5xl mx-auto px-6 pt-12 pb-8">
    <div class="flex flex-col md:flex-row md:items-center justify-between border-b border-gray-100 pb-12 gap-6">
        <div class="flex-1">
            <span class="text-[10px] font-black text-gray-400 uppercase tracking-[0.2em] flex items-center gap-2 mb-2">
                <span class="material-icons-round text-sm text-primary">school</span>
                <c:out value="${careerPath != null ? careerPath.status : 'Published'}"/> Course
            </span>

            <h1 class="text-3xl sm:text-4xl md:text-5xl font-800 text-gray-900 tracking-tight">
                <c:out value="${careerPath != null ? careerPath.title : 'Career Path'}"/>
            </h1>

            <p class="text-gray-500 mt-3 font-medium text-sm sm:text-base">
                <c:out value="${careerPath != null ? careerPath.description : 'Explore the learning roadmap and sign in to unlock full access.'}"/>
            </p>

            <c:if test="${careerPath != null}">
                <div class="flex flex-wrap gap-4 mt-6">
                    <div class="flex items-center gap-2">
                        <span class="text-xs font-bold text-gray-400 uppercase">Level:</span>
                        <span class="text-sm font-bold text-primary"><c:out value="${careerPath.level}"/></span>
                    </div>
                    <div class="flex items-center gap-2">
                        <span class="text-xs font-bold text-gray-400 uppercase">Category:</span>
                        <span class="text-sm font-bold text-primary"><c:out value="${careerPath.category}"/></span>
                    </div>
                </div>
            </c:if>
        </div>

        <a href="<%=request.getContextPath()%>/login"
           class="bg-primary hover:bg-primary-dark text-white px-8 py-3.5 rounded-xl font-bold shadow-lg shadow-primary/20 transition-all flex items-center gap-2">
            <span class="material-icons-round">add_task</span>
            Enroll Now
        </a>
    </div>
</header>

<main class="max-w-5xl mx-auto px-6 py-12 relative">

    <div class="timeline-line hidden md:block"></div>

    <div class="space-y-12">
        <c:choose>
            <c:when test="${not empty phases}">
                <c:forEach var="phase" items="${phases}" varStatus="phaseLoop">
                    <div class="relative pl-0 md:pl-16 opacity-70">
                        <div class="absolute left-4 top-0 hidden md:flex w-10 h-10 bg-gray-200 rounded-full items-center justify-center text-gray-500 z-20">
                            <span class="material-icons-round text-sm"><c:out value="${phaseLoop.count}"/></span>
                        </div>

                        <div class="phase-card">
                            <div class="flex justify-between items-start mb-4 gap-4">
                                <span class="text-[10px] font-black text-gray-400 uppercase tracking-widest">
                                    Phase <c:out value="${phase.phaseNumber}"/> • Locked Preview
                                </span>

                                <span class="text-[10px] text-gray-400 font-bold bg-gray-100 px-2 py-1 rounded flex items-center gap-1">
                                    <span class="material-icons-round text-[14px]">lock</span>
                                    Login Required
                                </span>
                            </div>

                            <h3 class="text-xl sm:text-2xl font-800 text-gray-900"><c:out value="${phase.title}"/></h3>
                            <p class="text-sm text-gray-500 mt-3 font-medium leading-relaxed"><c:out value="${phase.content}"/></p>

                            <div class="mt-6 pt-6 border-t border-gray-100 flex items-center justify-between gap-4">
                                <button type="button" disabled class="text-gray-400 font-bold text-sm flex items-center gap-2 cursor-not-allowed">
                                    <span>Locked - Login to Access</span>
                                    <span class="material-icons-round text-base">lock</span>
                                </button>
                                <a href="<%=request.getContextPath()%>/login" class="bg-primary/10 hover:bg-primary/20 text-primary font-bold text-sm px-4 py-2 rounded-lg transition-all flex items-center gap-2">
                                    <span class="material-icons-round text-base">login</span>
                                    <span>Sign In</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="text-center py-20">
                    <span class="material-icons-round text-5xl text-gray-200 flex justify-center mb-4">info</span>
                    <h3 class="text-xl font-bold text-gray-900">
                        <c:choose>
                            <c:when test="${careerPath == null}">Course not found</c:when>
                            <c:otherwise>No phases available</c:otherwise>
                        </c:choose>
                    </h3>
                    <p class="text-gray-500 mt-2">
                        <c:choose>
                            <c:when test="${careerPath == null}">The requested course could not be loaded.</c:when>
                            <c:otherwise>This course does not have any phases yet.</c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="/WEB-INF/views/components/guest_footer.jsp"/>

</body>
</html>
