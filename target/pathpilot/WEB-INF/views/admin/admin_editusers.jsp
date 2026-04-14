<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

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

<html class="light" lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Edit User Details - PathPilot Admin</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
 <script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "primary": "#4913ec",
                        "background-light": "#f6f6f8",
                        "background-dark": "#f6f6f8",
                    },
                    fontFamily: {
                        "display": ["Inter"]
                    },
                    borderRadius: {
                        "DEFAULT": "0.25rem",
                        "lg": "0.5rem",
                        "xl": "0.75rem",
                        "full": "9999px"
                    },
                },
            },
        }
    </script>
<style>
        body {
            font-family: 'Inter', sans-serif;
        }
        .custom-scrollbar::-webkit-scrollbar {
            width: 6px;
        }
        .custom-scrollbar::-webkit-scrollbar-track {
            background: transparent;
        }
        .custom-scrollbar::-webkit-scrollbar-thumb {
            background: #e2e8f0;
            border-radius: 10px;
        }
    </style>
</head>
<body class="bg-background-light dark:bg-background-dark font-display min-h-screen flex items-center justify-center p-4">
<!-- Modal Backdrop -->
<div class="fixed inset-0 bg-background-dark/60 backdrop-blur-sm z-0"></div>
<!-- Manage Users Page Mock Background (Dimmed) -->
<div class="fixed inset-0 z-0 opacity-20 pointer-events-none p-8">
<div class="max-w-7xl mx-auto">
<div class="h-8 w-48 bg-gray-300 dark:bg-gray-700 rounded mb-8"></div>
<div class="grid grid-cols-4 gap-4 mb-8">
<div class="h-24 bg-white dark:bg-gray-800 rounded-lg"></div>
<div class="h-24 bg-white dark:bg-gray-800 rounded-lg"></div>
<div class="h-24 bg-white dark:bg-gray-800 rounded-lg"></div>
<div class="h-24 bg-white dark:bg-gray-800 rounded-lg"></div>
</div>
<div class="h-96 bg-white dark:bg-gray-800 rounded-lg"></div>
</div>
</div>
<!-- Main Modal Container -->
<div class="relative z-10 w-full max-w-2xl bg-white dark:bg-gray-900 shadow-2xl rounded-xl overflow-hidden border border-gray-200 dark:border-gray-800">
<!-- Modal Header -->
<div class="px-6 py-4 border-b border-gray-100 dark:border-gray-800 flex items-center justify-between">
<div>
<h2 class="text-xl font-bold text-gray-900 dark:text-white">Edit User Details</h2>
<p class="text-xs text-gray-500 dark:text-gray-400 mt-0.5">User ID: PP-9420-XM</p>
</div>
<button class="p-2 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-full transition-colors">
<span class="material-icons text-gray-400">close</span>
</button>
</div>
<!-- Modal Content (Scrollable) -->
<form class="p-6 space-y-8 max-h-[75vh] overflow-y-auto custom-scrollbar">
<!-- Profile Section -->
<div class="flex items-center gap-6 pb-6 border-b border-gray-50 dark:border-gray-800">
<div class="relative group">
<img alt="Profile Preview" class="w-24 h-24 rounded-full object-cover ring-4 ring-primary/10" data-alt="Professional profile portrait of a male user" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCt3x-_3K6SYonoaiXHA1apjZNgKvptpihHChbb3rRg0HulidhNWU-L5Y8GpF3F-YyWkJRn3ADtVXhNVmcoJ0yusEgOAWclyONlt4N_AgwaK5qoiurea5Y-_JGojjH0_k3bTCNHeFgyqtiQLxwvrQJ_OcX7dCdME_lQhCH8uMGYlZED2Umtn4kGh6fGD4xg8ZDUK1NBMkzkr6HvJjIucQclzKn5mVadc0aRO5x9GZJKZVP-IBQL853W1UflMXyCmph4YW7w64p7fmmK"/>
<div class="absolute inset-0 bg-black/20 rounded-full opacity-0 group-hover:opacity-100 flex items-center justify-center transition-opacity cursor-pointer">
<span class="material-icons text-white text-sm">camera_alt</span>
</div>
</div>
<div>
<h3 class="text-sm font-semibold text-gray-900 dark:text-white mb-2">Profile Picture</h3>
<div class="flex gap-2">
<button class="px-3 py-1.5 text-xs font-medium bg-primary text-white rounded hover:bg-primary/90 transition-colors" type="button">Update Photo</button>
<button class="px-3 py-1.5 text-xs font-medium bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-300 rounded hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors" type="button">Remove</button>
</div>
<p class="text-[11px] text-gray-400 mt-2">Recommended: Square JPG or PNG, min. 400x400px</p>
</div>
</div>
<!-- Basic Info Section -->
<div class="space-y-4">
<div class="flex items-center gap-2 mb-2">
<span class="material-icons text-primary text-sm">person</span>
<h3 class="text-sm font-bold uppercase tracking-wider text-gray-400">Basic Info</h3>
</div>
<div class="grid grid-cols-1 md:grid-cols-2 gap-4">
<div class="space-y-1.5">
<label class="text-xs font-medium text-gray-700 dark:text-gray-300 ml-1">Full Name</label>
<input class="w-full px-4 py-2.5 bg-gray-50 dark:bg-gray-800/50 border border-gray-200 dark:border-gray-700 rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all dark:text-white" type="text" value="Alex Thompson"/>
</div>
<div class="space-y-1.5">
<label class="text-xs font-medium text-gray-700 dark:text-gray-300 ml-1">Email Address</label>
<input class="w-full px-4 py-2.5 bg-gray-50 dark:bg-gray-800/50 border border-gray-200 dark:border-gray-700 rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all dark:text-white" type="email" value="alex.thompson@pathpilot.io"/>
</div>
<div class="space-y-1.5 md:col-span-2">
<label class="text-xs font-medium text-gray-700 dark:text-gray-300 ml-1">User Role</label>
<select class="w-full px-4 py-2.5 bg-gray-50 dark:bg-gray-800/50 border border-gray-200 dark:border-gray-700 rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all dark:text-white appearance-none">
<option value="student">Student</option>
<option value="mentor">Professional Mentor</option>
<option selected="" value="admin">Administrator</option>
<option value="recruiter">Recruiter</option>
</select>
</div>
</div>
</div>
<!-- Career Details Section -->
<div class="space-y-4">
<div class="flex items-center gap-2 mb-2">
<span class="material-icons text-primary text-sm">explore</span>
<h3 class="text-sm font-bold uppercase tracking-wider text-gray-400">Career Details</h3>
</div>
<div class="grid grid-cols-1 md:grid-cols-2 gap-4">
<div class="space-y-1.5">
<label class="text-xs font-medium text-gray-700 dark:text-gray-300 ml-1">Selected Path</label>
<select class="w-full px-4 py-2.5 bg-gray-50 dark:bg-gray-800/50 border border-gray-200 dark:border-gray-700 rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all dark:text-white appearance-none">
<option value="se">Software Engineering</option>
<option selected="" value="ux">UX/UI Design</option>
<option value="ds">Data Science</option>
<option value="pm">Product Management</option>
</select>
</div>
<div class="space-y-1.5">
<label class="text-xs font-medium text-gray-700 dark:text-gray-300 ml-1">Progress %</label>
<div class="relative">
<input class="w-full px-4 py-2.5 bg-gray-50 dark:bg-gray-800/50 border border-gray-200 dark:border-gray-700 rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary outline-none transition-all dark:text-white" max="100" min="0" type="number" value="68"/>
<span class="absolute right-4 top-1/2 -translate-y-1/2 text-gray-400 font-medium">%</span>
</div>
</div>
</div>
</div>
<!-- Account Status Section -->
<div class="space-y-4">
<div class="flex items-center gap-2 mb-2">
<span class="material-icons text-primary text-sm">verified_user</span>
<h3 class="text-sm font-bold uppercase tracking-wider text-gray-400">Account Status</h3>
</div>
<div class="grid grid-cols-1 sm:grid-cols-3 gap-3">
<label class="relative flex items-center p-4 border border-gray-200 dark:border-gray-700 rounded-lg cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-800/30 transition-all has-[:checked]:border-primary has-[:checked]:bg-primary/5">
<input checked="" class="w-4 h-4 text-primary border-gray-300 focus:ring-primary" name="status" type="radio" value="active"/>
<div class="ml-3">
<span class="block text-sm font-semibold text-gray-900 dark:text-white">Active</span>
</div>
</label>
<label class="relative flex items-center p-4 border border-gray-200 dark:border-gray-700 rounded-lg cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-800/30 transition-all has-[:checked]:border-primary has-[:checked]:bg-primary/5">
<input class="w-4 h-4 text-primary border-gray-300 focus:ring-primary" name="status" type="radio" value="restricted"/>
<div class="ml-3">
<span class="block text-sm font-semibold text-gray-900 dark:text-white">Restricted</span>
</div>
</label>
<label class="relative flex items-center p-4 border border-gray-200 dark:border-gray-700 rounded-lg cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-800/30 transition-all has-[:checked]:border-primary has-[:checked]:bg-primary/5">
<input class="w-4 h-4 text-primary border-gray-300 focus:ring-primary" name="status" type="radio" value="banned"/>
<div class="ml-3">
<span class="block text-sm font-semibold text-gray-900 dark:text-white">Banned</span>
</div>
</label>
</div>
</div>
</form>
<!-- Modal Footer -->
<div class="px-6 py-4 bg-gray-50 dark:bg-gray-800/50 border-t border-gray-100 dark:border-gray-800 flex items-center justify-end gap-3">
<button class="px-5 py-2.5 text-sm font-semibold text-gray-600 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-gray-700 rounded-lg transition-all" type="button">
                Cancel
            </button>
<button class="px-6 py-2.5 text-sm font-semibold text-white bg-gradient-to-r from-primary to-indigo-600 hover:from-indigo-600 hover:to-primary rounded-lg shadow-lg shadow-primary/20 transition-all transform active:scale-95" type="submit">
                Save Changes
            </button>
</div>
</div>
</body></html>