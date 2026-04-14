<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- Logic: Automatic collapse on mobile/small screens for Admin Panel --%>
<% String currentUri = request.getServletPath(); %>

<aside class="flex flex-col justify-between h-screen sticky top-0 bg-white border-r border-gray-100 p-4 transition-all duration-300 font-['Plus_Jakarta_Sans']
             w-20 lg:w-64"> 
             
    <div>
        <div class="flex items-center gap-3 mb-10 px-2">
            <div class="w-10 h-10 rounded-xl bg-indigo-600 flex-shrink-0 flex items-center justify-center text-white shadow-md">
                <span class="material-icons-round text-lg">rocket_launch</span>
            </div>
            <span class="text-xl font-bold tracking-tight text-gray-800 hidden lg:block">
                PathPilot <span class="text-[10px] bg-indigo-50 text-indigo-600 px-1.5 py-0.5 rounded ml-1 uppercase">Admin</span>
            </span>
        </div>

        <nav class="space-y-2">

            <a href="<%=request.getContextPath()%>/admin/dashboard" title="Admin Dashboard"
               class="flex items-center gap-4 px-3 py-3 rounded-2xl font-semibold transition
               <%= currentUri.contains("dashboard") ? "bg-indigo-50 text-indigo-600" : "text-gray-500 hover:bg-gray-50 hover:text-indigo-600" %>">
                <span class="material-icons-round text-2xl flex-shrink-0">dashboard</span>
                <span class="hidden lg:block whitespace-nowrap">Dashboard</span>
            </a>

            <a href="<%=request.getContextPath()%>/admin/users" title="Manage Users"
               class="flex items-center gap-4 px-3 py-3 rounded-2xl font-semibold transition
               <%= currentUri.contains("users") ? "bg-indigo-50 text-indigo-600" : "text-gray-500 hover:bg-gray-50 hover:text-indigo-600" %>">
                <span class="material-icons-round text-2xl flex-shrink-0">people</span>
                <span class="hidden lg:block whitespace-nowrap">Manage Users</span>
            </a>

            <a href="<%=request.getContextPath()%>/admin/career-path" title="Career Paths"
               class="flex items-center gap-4 px-3 py-3 rounded-2xl font-semibold transition
               <%= currentUri.contains("career") ? "bg-indigo-50 text-indigo-600" : "text-gray-500 hover:bg-gray-50 hover:text-indigo-600" %>">
                <span class="material-icons-round text-2xl flex-shrink-0">alt_route</span>
                <span class="hidden lg:block whitespace-nowrap">Career Paths</span>
            </a>

            <a href="<%=request.getContextPath()%>/admin/settings" title="System Settings"
               class="flex items-center gap-4 px-3 py-3 rounded-2xl font-semibold transition
               <%= currentUri.contains("settings") ? "bg-indigo-50 text-indigo-600" : "text-gray-500 hover:bg-gray-50 hover:text-indigo-600" %>">
                <span class="material-icons-round text-2xl flex-shrink-0">settings</span>
                <span class="hidden lg:block whitespace-nowrap">Settings</span>
            </a>

        </nav>
    </div>

    <div class="space-y-2 border-t border-gray-100 pt-6">


        <a href="<%=request.getContextPath()%>/logout" title="Logout from Admin"
           class="flex items-center gap-4 px-3 py-3 font-bold text-gray-400 hover:text-red-500 transition">
            <span class="material-icons-round text-2xl flex-shrink-0">logout</span>
            <span class="hidden lg:block text-xs uppercase tracking-widest whitespace-nowrap">Logout</span>
        </a>

    </div>

</aside>