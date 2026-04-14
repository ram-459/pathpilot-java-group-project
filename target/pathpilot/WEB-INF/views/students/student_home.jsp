<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PathPilot - Student HOME</title>

    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Poppins:wght@500;600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet"/>
    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>

    <script>
        tailwind.config = {
            theme:{
                extend:{
                    colors:{ primary:'#4913ec', 'primary-dark':'#3a0fb5' },
                    fontFamily:{ sans:['Plus Jakarta Sans','sans-serif'], heading:['Poppins','sans-serif'] }
                }
            }
        }
    </script>

    <style type="text/tailwindcss">
        body{font-family:'Plus Jakarta Sans',sans-serif;}
        h1,h2,h3,.font-heading{font-family:'Poppins',sans-serif;}
        .hero-gradient{ background:linear-gradient(135deg,#6366f1 0%,#a855f7 100%); }
    </style>
</head>

<body class="bg-[#f8f9fc] antialiased">

<jsp:include page="/WEB-INF/views/components/user_navbar.jsp"/>

<section class="hero-gradient text-white py-24 px-4 text-center">
    <span class="bg-white/20 px-4 py-1.5 rounded-full text-[10px] font-black uppercase tracking-widest">
        Member Dashboard
    </span>
    <h1 class="text-5xl md:text-6xl font-extrabold mt-8 mb-6 leading-tight tracking-tight">
        Continue Your IT Career<br/>Journey 🚀
    </h1>
    <p class="text-indigo-100 text-lg mb-12 max-w-2xl mx-auto leading-relaxed">
        Track progress, explore learning paths, and unlock projects tailored to your goals.
    </p>
</section>

<jsp:include page="/WEB-INF/views/components/student_footer.jsp"/>

</body>
</html>