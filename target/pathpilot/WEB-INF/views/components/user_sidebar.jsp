<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- Shared Role-Based Sidebar: USER=Mentor, STUDENT=Student --%>
<%
    String currentUri = request.getServletPath();
    String role = session != null && session.getAttribute("role") != null
            ? String.valueOf(session.getAttribute("role")).toUpperCase()
            : "STUDENT";
    boolean isMentor = "USER".equals(role);

    String profileUrl = isMentor ? "/user/profile" : "/student/profile";
    String certificatesUrl = isMentor ? "/user/certificates" : "/student/certificates";
    String settingsUrl = isMentor ? "/user/settings" : "/student/settings";
    String homeUrl = isMentor ? "/user/UserHome" : "/student/home";
%>

<aside class="flex flex-col justify-between h-screen sticky top-0 bg-white border-r border-gray-100 p-4 transition-all duration-300 font-['Plus_Jakarta_Sans']
             w-20 lg:w-64"> <div>
        <div class="flex items-center gap-3 mb-10 px-2">
            <div class="w-10 h-10 rounded-xl bg-indigo-600 flex-shrink-0 flex items-center justify-center text-white shadow-md">
                <span class="material-icons-round text-lg">rocket_launch</span>
            </div>
            <span class="text-xl font-bold tracking-tight text-gray-800 hidden lg:block">PathPilot</span>
        </div>

        <nav class="space-y-2">
            <a href="<%=request.getContextPath()%><%=profileUrl%>" title="<%= isMentor ? "Dashboard" : "My Profile" %>"
               class="flex items-center gap-4 px-3 py-3 transition rounded-2xl font-semibold 
               <%= currentUri.contains("profile") ? "bg-indigo-50 text-indigo-600" : "text-gray-500 hover:bg-gray-50 hover:text-indigo-600" %>">
                <span class="material-icons-round text-2xl flex-shrink-0"><%= isMentor ? "grid_view" : "person_outline" %></span>
                <span class="hidden lg:block whitespace-nowrap"><%= isMentor ? "Dashboard" : "My Profile" %></span>
            </a>

            <% if (isMentor) { %>
                <a href="<%=request.getContextPath()%>/user/career-mgmt" title="My Roadmaps"
                   class="flex items-center gap-4 px-3 py-3 transition rounded-2xl font-semibold 
                   <%= currentUri.contains("mgmt") && currentUri.contains("career") ? "bg-indigo-50 text-indigo-600" : "text-gray-500 hover:bg-gray-50 hover:text-indigo-600" %>">
                    <span class="material-icons-round text-2xl flex-shrink-0">alt_route</span>
                    <span class="hidden lg:block whitespace-nowrap">My Roadmaps</span>
                </a>

                <a href="<%=request.getContextPath()%>/user/learner-mgmt" title="Learners"
                   class="flex items-center gap-4 px-3 py-3 transition rounded-2xl font-semibold 
                   <%= currentUri.contains("learner-mgmt") ? "bg-indigo-50 text-indigo-600" : "text-gray-500 hover:bg-gray-50 hover:text-indigo-600" %>">
                    <span class="material-icons-round text-2xl flex-shrink-0">group</span>
                    <span class="hidden lg:block whitespace-nowrap">Learners</span>
                </a>
            <% } %>

            <a href="<%=request.getContextPath()%><%=certificatesUrl%>" title="Certificates"
               class="flex items-center gap-4 px-3 py-3 transition rounded-2xl font-semibold 
               <%= currentUri.contains("certificates") ? "bg-indigo-50 text-indigo-600" : "text-gray-500 hover:bg-gray-50 hover:text-indigo-600" %>">
                <span class="material-icons-round text-2xl flex-shrink-0"><%= isMentor ? "verified" : "workspace_premium" %></span>
                <span class="hidden lg:block whitespace-nowrap">Certificates</span>
            </a>

            <% if (!isMentor) { %>
                <a href="<%=request.getContextPath()%>/student/quotes" title="Happy Soul Quotes"
                   class="flex items-center gap-4 px-3 py-3 transition rounded-2xl font-semibold 
                   <%= currentUri.contains("quotes") ? "bg-indigo-50 text-indigo-600" : "text-gray-500 hover:bg-gray-50 hover:text-indigo-600" %>">
                    <span class="material-icons-round text-2xl flex-shrink-0">auto_awesome</span>
                    <span class="hidden lg:block whitespace-nowrap">Happy Soul</span>
                </a>
            <% } %>

            <a href="<%=request.getContextPath()%><%=settingsUrl%>" title="Settings"
               class="flex items-center gap-4 px-3 py-3 transition rounded-2xl font-semibold 
               <%= currentUri.contains("setting") ? "bg-indigo-50 text-indigo-600" : "text-gray-500 hover:bg-gray-50 hover:text-indigo-600" %>">
                <span class="material-icons-round text-2xl flex-shrink-0">settings</span>
                <span class="hidden lg:block whitespace-nowrap">Settings</span>
            </a>
        </nav>
    </div>

    <div class="space-y-2 border-t border-gray-100 pt-6">
        <a href="<%=request.getContextPath()%><%=homeUrl%>" title="<%= isMentor ? "Back Home" : "Back to Learning" %>"
           class="flex items-center gap-4 px-3 py-3 transition font-bold text-gray-400 hover:text-indigo-600">
            <span class="material-icons-round text-2xl flex-shrink-0"><%= isMentor ? "arrow_back" : "home" %></span>
            <span class="hidden lg:block text-xs uppercase tracking-widest whitespace-nowrap"><%= isMentor ? "Back Home" : "Portal Home" %></span>
        </a>

        <a href="<%=request.getContextPath()%>/logout" title="Logout"
           class="flex items-center gap-4 px-3 py-3 transition font-bold text-gray-400 hover:text-red-500">
            <span class="material-icons-round text-2xl flex-shrink-0">logout</span>
            <span class="hidden lg:block text-xs uppercase tracking-widest whitespace-nowrap">Logout</span>
        </a>
    </div>
</aside>