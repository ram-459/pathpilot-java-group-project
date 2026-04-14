<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>

<%
    // 🔐 CACHE CONTROL
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // 🔐 ADMIN SESSION CHECK (IMPORTANT)
    if(session == null || session.getAttribute("role") == null || 
       !"ADMIN".equals(session.getAttribute("role"))){

        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<!DOCTYPE html>

<html lang="en">
<head>

<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>Add New User - PathPilot</title>

<!-- Tailwind -->

<script src="https://cdn.tailwindcss.com?plugins=forms"></script>

<!-- Fonts & Icons -->

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet"/>

<script>
tailwind.config = {
theme:{
extend:{
colors:{
primary:"#4913ec",
"primary-dark":"#3a0fb5",
"background-light":"#f6f6f8",
"neutral-border":"#e5e7eb",
"neutral-text-strong":"#111827",
"neutral-text-subtle":"#6b7280"
},
fontFamily:{sans:["Poppins","sans-serif"]}
}
}
}
</script>

<style>
body{font-family:'Poppins',sans-serif;}
.gradient-btn{
background:linear-gradient(135deg,#4913ec 0%,#6366f1 100%);
}
</style>

</head>

<body class="bg-background-light flex h-screen">

<!-- Sidebar -->

<%@ include file="/WEB-INF/views/components/admin_sidebar.jsp" %>

<!-- MAIN -->

<div class="flex-1 flex flex-col">

<!-- HEADER -->

<header class="h-16 bg-white border-b flex items-center px-6">
<nav class="text-sm text-neutral-text-subtle">
Admin › Manage Users ›
<span class="text-primary font-semibold">Add New User</span>
</nav>
</header>

<!-- CONTENT -->

<main class="flex-1 overflow-y-auto p-10">

<div class="max-w-3xl mx-auto">

<h1 class="text-2xl font-bold mb-2">Add New User</h1>
<p class="text-sm text-neutral-text-subtle mb-8">
Onboard a new member to the PathPilot ecosystem.
</p>

<!-- CARD -->

<div class="bg-white rounded-2xl border shadow-sm">

<div class="p-6 border-b">
<h2 class="font-semibold">Create New User Account</h2>
<p class="text-sm text-neutral-text-subtle">
Fill basic information to set up profile.
</p>
</div>

<!-- ================= FORM ================= -->

<form id="addUserForm"
      class="p-6 space-y-6"
      onsubmit="return validateAddUser()">

<div class="grid md:grid-cols-2 gap-6">

<!-- First Name -->

<div>
<label class="text-sm font-semibold">First Name</label>
<input id="fname" type="text"
class="w-full mt-2 border rounded-xl px-4 py-2 bg-background-light">
<span id="fnameErr" class="text-red-500 text-xs"></span>
</div>

<!-- Last Name -->

<div>
<label class="text-sm font-semibold">Last Name</label>
<input id="lname" type="text"
class="w-full mt-2 border rounded-xl px-4 py-2 bg-background-light">
<span id="lnameErr" class="text-red-500 text-xs"></span>
</div>

<!-- Email -->

<div class="md:col-span-2">
<label class="text-sm font-semibold">Email</label>
<input id="email" type="email"
class="w-full mt-2 border rounded-xl px-4 py-2 bg-background-light">
<span id="emailErr" class="text-red-500 text-xs"></span>
</div>

<!-- Role -->

<div>
<label class="text-sm font-semibold">User Role</label>
<select id="role"
class="w-full mt-2 border rounded-xl px-4 py-2 bg-background-light">
<option value="">Select role</option>
<option>Student</option>
<option>Mentor</option>
<option>Admin</option>
</select>
<span id="roleErr" class="text-red-500 text-xs"></span>
</div>

<!-- Career Path -->

<div>
<label class="text-sm font-semibold">Career Path</label>
<select id="path"
class="w-full mt-2 border rounded-xl px-4 py-2 bg-background-light">
<option value="">Select path</option>
<option>Frontend</option>
<option>Backend</option>
<option>Data Science</option>
</select>
<span id="pathErr" class="text-red-500 text-xs"></span>
</div>

</div>

<!-- INFO BOX -->

<div class="bg-blue-50 border border-blue-100 p-4 rounded-xl text-sm text-blue-700">
Invitation email will be sent with temporary password.
</div>

<!-- BUTTONS -->

<div class="flex justify-end gap-3 pt-4">

<!-- ❌ OLD reset removed -->
<a href="<%=request.getContextPath()%>/admin/users" 
   class="px-6 py-2 rounded-xl border border-gray-300 text-gray-700 hover:bg-gray-50 transition flex items-center justify-center">
   Discard
</a>

<button type="submit"
class="px-8 py-2 text-white rounded-xl gradient-btn shadow">
Create User </button>

</div>

</form>

</div>
</div>
</main>
</div>

<!-- ================= JS ================= -->

<script>

/* ===== VALIDATION ===== */

function validateAddUser(){

let valid = true;

let fname = document.getElementById("fname").value.trim();
let lname = document.getElementById("lname").value.trim();
let email = document.getElementById("email").value.trim();
let role  = document.getElementById("role").value;
let path  = document.getElementById("path").value;

clearErrors();

if(fname === ""){
document.getElementById("fnameErr").innerText="First name required";
valid=false;
}

if(lname === ""){
document.getElementById("lnameErr").innerText="Last name required";
valid=false;
}

if(email === ""){
document.getElementById("emailErr").innerText="Email required";
valid=false;
}
else if(!email.includes("@")){
document.getElementById("emailErr").innerText="Invalid email";
valid=false;
}

if(role === ""){
document.getElementById("roleErr").innerText="Select role";
valid=false;
}

if(path === ""){
document.getElementById("pathErr").innerText="Select career path";
valid=false;
}

if(valid){
alert("✅ User Created Successfully (Dummy)");
document.getElementById("addUserForm").reset();
}

return false; // stop submit (dummy)

}

/* ===== DISCARD BUTTON ===== */

function discardForm(){

document.getElementById("addUserForm").reset();
clearErrors();

}

/* ===== CLEAR ERRORS ===== */

function clearErrors(){

document.getElementById("fnameErr").innerText="";
document.getElementById("lnameErr").innerText="";
document.getElementById("emailErr").innerText="";
document.getElementById("roleErr").innerText="";
document.getElementById("pathErr").innerText="";

}

</script>

</body>
</html>
