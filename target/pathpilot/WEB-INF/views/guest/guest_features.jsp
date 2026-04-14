<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html lang="en">
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>Platform Features - PathPilot</title>

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Poppins:wght@500;600;700&display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet"/>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

<script src="https://cdn.tailwindcss.com?plugins=forms"></script>

<script>
tailwind.config = {
theme:{
extend:{
colors:{
primary:"#1313ec",
"indigo-600":"#4913ec"
},
fontFamily:{
sans:["Inter","sans-serif"],
heading:["Poppins","sans-serif"]
}
}
}
}
</script>

<style type="text/tailwindcss">
body{font-family:'Inter',sans-serif;}
h1,h2,h3,h4{font-family:'Poppins',sans-serif;}
</style>

</head>

<body class="bg-[#f6f6f8] antialiased">

<!-- NAVBAR -->

<jsp:include page="/WEB-INF/views/components/gnavbar.jsp"/>

<header class="max-w-7xl mx-auto px-6 py-24">

<span class="bg-indigo-50 text-primary px-4 py-1.5 rounded-full text-xs font-bold uppercase tracking-widest">
Platform Features
</span>

<h1 class="text-5xl md:text-6xl font-bold text-gray-900 mt-8 mb-6 leading-tight">
Why PathPilot?
</h1>

<p class="text-gray-500 text-lg max-w-2xl leading-relaxed">
We've built a comprehensive ecosystem designed to take you from a curious beginner to a job-ready professional.
</p>

<div class="flex gap-4 mt-12">

<a href="<%=request.getContextPath()%>/guest/careerpath"
class="bg-primary hover:bg-blue-700 text-white px-10 py-4 rounded-xl font-bold shadow-lg transition">
Start Exploring </a>

<button class="bg-white border border-gray-200 text-gray-700 px-10 py-4 rounded-xl font-bold hover:bg-gray-50">
Watch Demo
</button>

</div>
</header>

<!-- CONTENT SAME AS YOUR UI -->

<!-- (I kept UI unchanged as asked) -->

<main class="space-y-32 pb-32">

<section class="max-w-7xl mx-auto px-6 grid md:grid-cols-2 gap-20 items-center">

<div class="bg-[#2eb086] rounded-[2.5rem] p-16 shadow-2xl relative overflow-hidden">
<div class="border-4 border-white/30 rounded-2xl p-10 text-center">
<h4 class="text-white text-5xl font-black uppercase tracking-[0.2em]">Web</h4>
<p class="text-white/80 font-bold mt-4 tracking-widest uppercase">
Development
</p>
</div>
</div>

<div class="max-w-lg">
<h2 class="text-4xl font-bold text-gray-900 mb-6">
Expert-Curated Roadmaps
</h2>

<p class="text-gray-500 text-lg leading-relaxed">
Stop wasting time on scattered tutorials. Learn skills in the right order.
</p>
</div>

</section>

</main>

<!-- FOOTER -->

<jsp:include page="/WEB-INF/views/components/guest_footer.jsp"/>

</body>
</html>
