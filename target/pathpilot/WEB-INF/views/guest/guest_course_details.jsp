<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>${param.title} Roadmap - PathPilot</title>

    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Poppins:wght@600;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet"/>

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: { 'primary': '#1313ec' },
                    fontFamily: {
                        'sans': ['Inter'],
                        'heading': ['Poppins']
                    }
                }
            }
        }
    </script>

    <style type="text/tailwindcss">
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
            @apply bg-white rounded-2xl border border-gray-100 p-6 shadow-sm relative z-10;
        }
    </style>
</head>

<body class="bg-[#f8f9fc] antialiased">

<jsp:include page="/WEB-INF/views/components/gnavbar.jsp"/>


<header class="max-w-5xl mx-auto px-6 pt-12 pb-8">
    <div class="flex items-start justify-between border-b border-gray-200 pb-8">
        <div>
            <span class="text-xs font-bold text-gray-400 uppercase tracking-widest flex items-center gap-2">
                <span class="material-icons-round text-sm">school</span>
                Enrolled Course
            </span>

            <h1 class="text-4xl font-bold text-gray-900 mt-2">
                ${param.title} Career Path
            </h1>

            <p class="text-gray-500 mt-2">
                Master modern web development from zero to job-ready professional.
            </p>
        </div>

        <a href="<%=request.getContextPath()%>/login"
           class="bg-primary hover:bg-blue-700 text-white px-8 py-3.5 rounded-xl font-bold shadow-lg shadow-primary/20 transition-all flex items-center gap-2">
            <span class="material-icons-round">add_task</span>
            Enroll Now
        </a>
    </div>
</header>

<main class="max-w-5xl mx-auto px-6 py-12 relative">

    <!-- Timeline Line -->
    <div class="timeline-line hidden md:block"></div>

    <div class="space-y-12">

        <!-- Phase 1 Locked -->
        <div class="relative pl-0 md:pl-16 opacity-60">

            <div class="absolute left-4 top-0 hidden md:flex w-10 h-10 bg-gray-200 rounded-full items-center justify-center text-gray-400 z-20">
                <span class="material-icons-round text-sm">lock</span>
            </div>

            <div class="phase-card">
                <div class="flex justify-between items-start mb-4">
                    <span class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">
                        Phase 1 • Locked
                    </span>

                    <span class="text-[10px] text-gray-400 font-bold bg-gray-100 px-2 py-1 rounded">
                        4 Weeks
                    </span>
                </div>

                <h3 class="text-xl font-bold text-gray-900">
                    Web Development Basics
                </h3>

                <p class="text-sm text-gray-500 mt-2">
                    Foundational building blocks including HTML5, CSS3, and Git.
                </p>
            </div>
        </div>

        <!-- Phase 2 Locked -->
        <div class="relative pl-0 md:pl-16 opacity-60">

            <div class="absolute left-4 top-0 hidden md:flex w-10 h-10 bg-gray-200 rounded-full items-center justify-center text-gray-400 z-20">
                <span class="material-icons-round text-sm">lock</span>
            </div>

            <div class="phase-card">
                <div class="flex justify-between items-start mb-4">
                    <span class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">
                        Phase 2 • Locked
                    </span>

                    <span class="text-[10px] text-gray-400 font-bold bg-gray-100 px-2 py-1 rounded">
                        6 Weeks
                    </span>
                </div>

                <h3 class="text-xl font-bold text-gray-900">
                    JavaScript Mastery
                </h3>

                <p class="text-sm text-gray-500 mt-2">
                    Deep dive into ES6+, async programming, and DOM manipulation.
                </p>
            </div>
        </div>

        <!-- Phase 3 Locked (React) -->
        <div class="relative pl-0 md:pl-16 opacity-60">

            <div class="absolute left-4 top-0 hidden md:flex w-10 h-10 bg-gray-200 rounded-full items-center justify-center text-gray-400 z-20">
                <span class="material-icons-round text-sm">lock</span>
            </div>

            <div class="phase-card">
                <div class="flex justify-between items-start mb-4">
                    <span class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">
                        Phase 3 • Locked
                    </span>

                    <span class="text-[10px] text-gray-400 font-bold bg-gray-100 px-2 py-1 rounded">
                        8 Weeks
                    </span>
                </div>

                <h3 class="text-xl font-bold text-gray-900">
                    React Framework
                </h3>

                <p class="text-sm text-gray-500 mt-2">
                    Build complex SPAs with components, hooks, and state management.
                </p>
            </div>
        </div>

    </div>
</main>

<jsp:include page="/WEB-INF/views/components/guest_footer.jsp"/>


</body>
</html>
