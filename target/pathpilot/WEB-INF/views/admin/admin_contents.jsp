<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
<title>Content Management - PathPilot Admin</title>

<script src="https://cdn.tailwindcss.com?plugins=forms"></script>

<link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>

<script>
tailwind.config = {
theme:{
extend:{
colors:{
primary:"#4913ec",
"primary-dark":"#3a0fb5",
"background-light":"#f6f6f8",
"neutral-border":"#e5e7eb",
"neutral-text-subtle":"#6b7280"
},
fontFamily:{display:["Inter","sans-serif"]}
}
}
}
</script>

</head>

<body class="bg-background-light font-display overflow-hidden">

<div class="flex h-screen">

<!-- Sidebar -->

<%@ include file="/WEB-INF/views/components/admin_sidebar.jsp" %>


<div class="flex-1 flex flex-col overflow-hidden">

<!-- Header -->

<header class="h-16 bg-white/80 backdrop-blur-md border-b flex items-center justify-between px-6">

<nav class="text-sm text-neutral-text-subtle flex items-center">
Admin
<span class="material-icons-round mx-1 text-gray-400">chevron_right</span>
<span class="text-primary font-semibold">Content Management</span>
</nav>

</header>

<!-- Main -->

<main class="flex-1 overflow-y-auto p-6">

<div class="max-w-7xl mx-auto">

<!-- Top -->

<div class="flex justify-between items-center mb-8">

<h1 class="text-2xl font-bold">
Module Management
</h1>

<button onclick="openAddModal()"
class="bg-primary text-white px-4 py-2 rounded-lg flex items-center gap-2">

<span class="material-icons-round">add</span>
Add New Module

</button>

</div>

<!-- TABLE -->

<div class="bg-white rounded-2xl border shadow-sm overflow-hidden">

<table class="w-full text-sm">

<thead class="bg-gray-50 text-neutral-text-subtle">

<tr>
<th class="px-6 py-4 text-left">Module</th>
<th class="px-6 py-4">Career Path</th>
<th class="px-6 py-4">Lessons</th>
<th class="px-6 py-4">Status</th>
<th class="px-6 py-4 text-center">Actions</th>
</tr>

</thead>

<tbody class="divide-y">

<tr>

<td class="px-6 py-4">
<p class="font-semibold">HTML Basics</p>
<p class="text-xs text-gray-400">ID: MOD101</p>
</td>

<td class="px-6 py-4">Frontend</td>

<td class="px-6 py-4">12</td>

<td class="px-6 py-4">
<span class="px-2 py-1 bg-green-100 text-green-700 text-xs rounded-full">
Live
</span>
</td>

<td class="px-6 py-4">

<div class="flex justify-center gap-3">

<!-- VIEW -->

<button onclick="openViewModal()"
class="p-2 bg-blue-50 text-blue-600 rounded-lg"> <span class="material-icons-round text-sm">visibility</span> </button>

<!-- EDIT -->

<button onclick="openEditModal(
'HTML Basics',
'Frontend',
12,
'Live'
)"
class="p-2 bg-indigo-50 text-primary rounded-lg"> <span class="material-icons-round text-sm">edit</span> </button>

<!-- DELETE -->

<button class="p-2 bg-red-50 text-red-600 rounded-lg">
<span class="material-icons-round text-sm">delete</span>
</button>

</div>

</td>

</tr>

</tbody>

</table>

</div>

</div>
</main>
</div>
</div>

<!-- ================= VIEW MODAL ================= -->

<div id="viewModal"
class="fixed inset-0 bg-black/40 hidden items-center justify-center z-50">

<div class="bg-white w-full max-w-md rounded-2xl p-6">

<h2 class="text-xl font-bold mb-4">Module Details</h2>

<div class="space-y-2 text-sm">
<p><b>Name:</b> HTML Basics</p>
<p><b>Career Path:</b> Frontend</p>
<p><b>Total Lessons:</b> 12</p>
<p><b>Status:</b> Live</p>
</div>

<button onclick="closeViewModal()"
class="mt-6 px-4 py-2 bg-primary text-white rounded-lg">
Close </button>

</div>
</div>

<!-- ================= ADD MODAL ================= -->

<div id="addModal"
class="fixed inset-0 bg-black/40 hidden items-center justify-center z-50">

<div class="bg-white w-full max-w-lg rounded-2xl p-6">

<h2 class="text-xl font-bold mb-6">
Add Module
</h2>

<form onsubmit="return validateAdd()">

<div class="space-y-4">

<div>
<label class="text-sm font-semibold">Module Name</label>
<input id="addName" type="text"
class="w-full border rounded-lg px-3 py-2 mt-1">
<span id="addNameErr" class="text-red-500 text-xs"></span>
</div>

<div>
<label class="text-sm font-semibold">Career Path</label>
<select id="addPath"
class="w-full border rounded-lg px-3 py-2 mt-1">
<option value="">Select</option>
<option>Frontend</option>
<option>Backend</option>
<option>Data Science</option>
</select>
<span id="addPathErr" class="text-red-500 text-xs"></span>
</div>

<div>
<label class="text-sm font-semibold">Lessons</label>
<input id="addLessons" type="number"
class="w-full border rounded-lg px-3 py-2 mt-1">
<span id="addLessonsErr" class="text-red-500 text-xs"></span>
</div>

<div>
<label class="text-sm font-semibold">Status</label>
<select id="addStatus"
class="w-full border rounded-lg px-3 py-2 mt-1">
<option value="">Select</option>
<option>Live</option>
<option>Draft</option>
</select>
<span id="addStatusErr" class="text-red-500 text-xs"></span>
</div>

</div>

<div class="flex justify-end gap-3 mt-6">

<button type="button"
onclick="closeAddModal()"
class="px-4 py-2 border rounded-lg">
Cancel </button>

<button type="submit"
class="px-6 py-2 bg-primary text-white rounded-lg">
Create </button>

</div>

</form>
</div>
</div>

<!-- ================= EDIT MODAL ================= -->

<div id="editModal"
class="fixed inset-0 bg-black/40 hidden items-center justify-center z-50">

<div class="bg-white w-full max-w-lg rounded-2xl p-6">

<h2 class="text-xl font-bold mb-6">
Edit Module
</h2>

<form onsubmit="return validateEdit()">

<div class="space-y-4">

<div>
<label class="text-sm font-semibold">Module Name</label>
<input id="editName" type="text"
class="w-full border rounded-lg px-3 py-2 mt-1">
<span id="editNameErr" class="text-red-500 text-xs"></span>
</div>

<div>
<label class="text-sm font-semibold">Career Path</label>
<input id="editPath" type="text"
class="w-full border rounded-lg px-3 py-2 mt-1">
</div>

<div>
<label class="text-sm font-semibold">Lessons</label>
<input id="editLessons" type="number"
class="w-full border rounded-lg px-3 py-2 mt-1">
</div>

<div>
<label class="text-sm font-semibold">Status</label>
<select id="editStatus"
class="w-full border rounded-lg px-3 py-2 mt-1">
<option>Live</option>
<option>Draft</option>
</select>
</div>

</div>

<div class="flex justify-end gap-3 mt-6">

<button type="button"
onclick="closeEditModal()"
class="px-4 py-2 border rounded-lg">
Cancel </button>

<button type="submit"
class="px-6 py-2 bg-primary text-white rounded-lg">
Update </button>

</div>

</form>
</div>
</div>

<!-- ================= JS ================= -->

<script>

/* VIEW */
function openViewModal(){
document.getElementById("viewModal").classList.remove("hidden");
document.getElementById("viewModal").classList.add("flex");
}
function closeViewModal(){
document.getElementById("viewModal").classList.add("hidden");
}

/* ADD */
function openAddModal(){
document.getElementById("addModal").classList.remove("hidden");
document.getElementById("addModal").classList.add("flex");
}
function closeAddModal(){
document.getElementById("addModal").classList.add("hidden");
}

/* EDIT */
function openEditModal(name,path,lessons,status){

document.getElementById("editName").value=name;
document.getElementById("editPath").value=path;
document.getElementById("editLessons").value=lessons;
document.getElementById("editStatus").value=status;

document.getElementById("editModal").classList.remove("hidden");
document.getElementById("editModal").classList.add("flex");
}
function closeEditModal(){
document.getElementById("editModal").classList.add("hidden");
}

/* VALIDATIONS */

function validateAdd(){

let valid=true;

if(addName.value===""){
addNameErr.innerText="Module name required";
valid=false;
}

if(addPath.value===""){
addPathErr.innerText="Select path";
valid=false;
}

if(addLessons.value===""){
addLessonsErr.innerText="Enter lessons";
valid=false;
}

if(addStatus.value===""){
addStatusErr.innerText="Select status";
valid=false;
}

if(valid) alert("✅ Module Added");

return false;
}

function validateEdit(){

if(editName.value===""){
editNameErr.innerText="Module name required";
return false;
}

alert("✅ Module Updated");
return false;
}

</script>

</body>
</html>
