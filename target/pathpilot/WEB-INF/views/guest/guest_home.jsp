<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PathPilot - Start Your IT Journey</title>

    <link href="https://fonts.googleapis.com" rel="preconnect"/>
    <link crossorigin href="https://fonts.gstatic.com" rel="preconnect"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Poppins:wght@500;600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>

    <script>
        tailwind.config = {
            theme:{
                extend:{
                    colors:{
                        primary:'#1313ec',
                        'indigo-600':'#4913ec'
                    },
                    fontFamily:{
                        sans:['Inter','sans-serif'],
                        heading:['Poppins','sans-serif']
                    }
                }
            }
        }
    </script>

    <style type="text/tailwindcss">
        body{font-family:'Inter',sans-serif;}
        h1,h2,h3,.font-heading{font-family:'Poppins',sans-serif;}
        .hero-gradient{
            background:linear-gradient(135deg,#6366f1 0%,#a855f7 100%);
        }
    </style>
</head>

<body class="bg-gray-50 antialiased">

<jsp:include page="/WEB-INF/views/components/gnavbar.jsp"/>

<section class="hero-gradient text-white py-24 px-4 text-center">
    <span class="bg-white/20 px-4 py-1.5 rounded-full text-[10px] font-bold tracking-widest uppercase">
        Guest Access
    </span>

    <h1 class="text-5xl md:text-6xl font-extrabold mt-8 mb-6 leading-tight tracking-tight">
        Start Your IT Career<br/>Journey with Guidance
    </h1>

    <p class="text-indigo-100 text-lg mb-12 max-w-2xl mx-auto leading-relaxed">
        Explore career roadmaps, discover skill gaps, and get industry guidance —
        but create an account to unlock full learning features.
    </p>

    <div class="flex justify-center gap-6 flex-wrap">
        <a href="<%=request.getContextPath()%>/register" 
           class="px-8 py-3.5 rounded-xl font-bold text-primary bg-white hover:scale-105 transition shadow-xl">
            Join PathPilot Now
        </a>
        <a href="<%=request.getContextPath()%>/login" 
           class="px-8 py-3.5 rounded-xl font-bold text-white border border-white/40 hover:bg-white/10 transition">
            Member Login
        </a>
    </div>
</section>

<section class="max-w-7xl mx-auto py-24 px-6">
    <div class="flex justify-between items-baseline mb-12">
        <div>
            <h2 class="text-3xl font-bold text-gray-900">Popular Career Paths</h2>
            <p class="text-gray-500 mt-2">Preview industry-ready roadmaps.</p>
        </div>
        <a href="<%=request.getContextPath()%>/login"
           class="text-primary font-bold flex items-center gap-2 hover:underline">
            Login to Explore
            <span class="material-icons-round text-sm">arrow_forward</span>
        </a>
    </div>

    <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-md transition h-full flex flex-col group">
            <div class="h-32 bg-indigo-50 flex items-center justify-center group-hover:bg-indigo-100">
                <div class="bg-white p-3 rounded-lg shadow-sm">
                    <i class="fas fa-code text-indigo-600 text-xl"></i>
                </div>
            </div>
            <div class="p-6 flex-grow flex flex-col">
                <h3 class="font-bold text-xl text-gray-800 group-hover:text-primary">Frontend Developer</h3>
                <p class="text-gray-500 text-sm mt-2 flex-grow">Build interactive UI using React & modern CSS.</p>
                <div class="flex gap-2 mt-4">
                    <span class="text-[10px] bg-blue-50 text-blue-600 px-2.5 py-1 rounded font-bold">React</span>
                    <span class="text-[10px] bg-purple-50 text-purple-600 px-2.5 py-1 rounded font-bold">JavaScript</span>
                </div>
                <div class="mt-8 pt-4 border-t flex justify-between items-center">
                    <span class="text-xs text-gray-400 font-medium"><i class="far fa-clock mr-1"></i> 8 Steps</span>
                    <a href="<%=request.getContextPath()%>/register"
                       class="bg-indigo-50 text-indigo-600 hover:bg-indigo-600 hover:text-white px-4 py-2 rounded-lg font-bold text-sm transition">
                        Enroll
                    </a>
                </div>
            </div>
        </div>

        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-md transition h-full flex flex-col group">
            <div class="h-32 bg-indigo-50 flex items-center justify-center group-hover:bg-indigo-100">
                <div class="bg-white p-3 rounded-lg shadow-sm">
                    <i class="fas fa-server text-indigo-600 text-xl"></i>
                </div>
            </div>
            <div class="p-6 flex-grow flex flex-col">
                <h3 class="font-bold text-xl text-gray-800 group-hover:text-primary">Backend Developer</h3>
                <p class="text-gray-500 text-sm mt-2 flex-grow">Master APIs, databases & scalable systems.</p>
                <div class="flex gap-2 mt-4">
                    <span class="text-[10px] bg-blue-50 text-blue-600 px-2.5 py-1 rounded font-bold">Java</span>
                    <span class="text-[10px] bg-purple-50 text-purple-600 px-2.5 py-1 rounded font-bold">Spring</span>
                </div>
                <div class="mt-8 pt-4 border-t flex justify-between items-center">
                    <span class="text-xs text-gray-400 font-medium"><i class="far fa-clock mr-1"></i> 10 Steps</span>
                    <a href="<%=request.getContextPath()%>/register"
                       class="bg-indigo-50 text-indigo-600 hover:bg-indigo-600 hover:text-white px-4 py-2 rounded-lg font-bold text-sm transition">
                        Enroll
                    </a>
                </div>
            </div>
        </div>

        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-md transition h-full flex flex-col group">
            <div class="h-32 bg-indigo-50 flex items-center justify-center group-hover:bg-indigo-100">
                <div class="bg-white p-3 rounded-lg shadow-sm">
                    <i class="fas fa-cloud text-indigo-600 text-xl"></i>
                </div>
            </div>
            <div class="p-6 flex-grow flex flex-col">
                <h3 class="font-bold text-xl text-gray-800 group-hover:text-primary">DevOps Engineer</h3>
                <p class="text-gray-500 text-sm mt-2 flex-grow">Automate deployment & cloud infrastructure.</p>
                <div class="flex gap-2 mt-4">
                    <span class="text-[10px] bg-blue-50 text-blue-600 px-2.5 py-1 rounded font-bold">AWS</span>
                    <span class="text-[10px] bg-purple-50 text-purple-600 px-2.5 py-1 rounded font-bold">Docker</span>
                </div>
                <div class="mt-8 pt-4 border-t flex justify-between items-center">
                    <span class="text-xs text-gray-400 font-medium"><i class="far fa-clock mr-1"></i> 9 Steps</span>
                    <a href="<%=request.getContextPath()%>/register"
                       class="bg-indigo-50 text-indigo-600 hover:bg-indigo-600 hover:text-white px-4 py-2 rounded-lg font-bold text-sm transition">
                        Enroll
                    </a>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/WEB-INF/views/components/guest_footer.jsp"/>

</body>
</html>