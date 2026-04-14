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
    <title>Notifications - PathPilot Admin</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>
     <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet"/>
</head>
<body class="bg-background-light antialiased overflow-hidden">
<div class="flex h-screen">
<%@ include file="/WEB-INF/views/components/admin_sidebar.jsp" %>
    <div class="flex-1 flex flex-col h-screen overflow-hidden">
        <header class="h-16 bg-white border-b border-neutral-border flex items-center justify-between px-6">
            <nav class="text-sm text-neutral-text-subtle flex items-center">
                <span>Admin</span><span class="material-icons-round text-base mx-1">chevron_right</span><span class="text-primary font-semibold">Notifications</span>
            </nav>
        </header>
        <main class="flex-1 overflow-y-auto p-6 lg:p-10">
            <div class="max-w-4xl mx-auto">
                <h1 class="text-2xl font-bold mb-8">Notifications</h1>
                </div>
        </main>
    </div>
</div>
</body>
</html>