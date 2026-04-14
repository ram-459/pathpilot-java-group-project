<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    String currentPath = request.getRequestURI();
    String role = session != null && session.getAttribute("role") != null
            ? String.valueOf(session.getAttribute("role")).toUpperCase()
            : "STUDENT";
    boolean isMentor = "USER".equals(role);

    String basePath = isMentor ? "/user" : "/student";
    String homePath = isMentor ? "/user/UserHome" : "/student/home";
    String featuresPath = basePath + "/features";
    String resourcesPath = basePath + (isMentor ? "/resources" : "/resources");
    String aboutPath = basePath + "/about";
    String helpPath = basePath + "/contact";
    String profilePath = basePath + "/profile";
%>

<nav class="sticky top-0 z-50 w-full bg-white/90 backdrop-blur-md shadow-sm border-b border-gray-100 font-['Plus_Jakarta_Sans']">
    <div class="max-w-7xl mx-auto px-6 lg:px-12 py-4 flex items-center justify-between">
        
        <div class="flex items-center gap-2">
                <a href="<%=request.getContextPath()%><%=homePath%>" class="flex items-center gap-2">
                <div class="bg-indigo-600 p-2 rounded-lg text-white shadow-md shadow-indigo-200">
                    <span class="material-icons-round text-lg">rocket_launch</span>
                </div>
                <span class="text-xl font-bold text-gray-800 tracking-tight">PathPilot</span>
            </a>
        </div>

        <div class="hidden lg:flex gap-8 text-gray-600 font-medium items-center">
                <a href="<%=request.getContextPath()%><%=homePath%>" 
                    class="transition-all duration-300 border-b-2 pb-1 <%= (isMentor ? currentPath.contains("UserHome") : currentPath.contains("/home")) ? "text-indigo-600 border-indigo-600 font-bold" : "border-transparent hover:text-indigo-600 hover:border-indigo-600" %>">
                    <%= isMentor ? "Home" : "Dashboard" %>
            </a>
                <a href="<%=request.getContextPath()%><%=featuresPath%>" 
               class="transition-all duration-300 border-b-2 pb-1 <%= currentPath.contains("features") ? "text-indigo-600 border-indigo-600 font-bold" : "border-transparent hover:text-indigo-600 hover:border-indigo-600" %>">
               Features
            </a>
                <a href="<%=request.getContextPath()%><%=resourcesPath%>" 
               class="transition-all duration-300 border-b-2 pb-1 <%= currentPath.contains("resources") ? "text-indigo-600 border-indigo-600 font-bold" : "border-transparent hover:text-indigo-600 hover:border-indigo-600" %>">
                    <%= isMentor ? "Resources" : "Library" %>
            </a>
                <a href="<%=request.getContextPath()%><%=aboutPath%>" 
               class="transition-all duration-300 border-b-2 pb-1 <%= currentPath.contains("about") ? "text-indigo-600 border-indigo-600 font-bold" : "border-transparent hover:text-indigo-600 hover:border-indigo-600" %>">
               About
            </a>
                <a href="<%=request.getContextPath()%><%=helpPath%>" 
               class="transition-all duration-300 border-b-2 pb-1 <%= currentPath.contains("contact") ? "text-indigo-600 border-indigo-600 font-bold" : "border-transparent hover:text-indigo-600 hover:border-indigo-600" %>">
                    <%= isMentor ? "Contact" : "Help" %>
            </a>
        </div>

        <div class="flex items-center gap-2 md:gap-5 relative">
            <div class="relative">
                <button id="notifBtn" class="relative text-gray-400 hover:text-indigo-600 transition-colors p-2 focus:outline-none">
                    <span class="material-icons-round text-2xl">notifications</span>
                    <span id="notifDot" class="absolute top-2 right-2 flex h-2.5 w-2.5">
                        <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-indigo-400 opacity-75"></span>
                        <span class="relative inline-flex rounded-full h-2.5 w-2.5 bg-indigo-500"></span>
                    </span>
                </button>

                <div id="notifDropdown" class="hidden absolute right-0 mt-4 w-72 md:w-80 bg-white rounded-2xl shadow-2xl border border-gray-100 z-[100] overflow-hidden">
                    <div class="p-4 border-b border-gray-50 flex justify-between items-center bg-gray-50/50">
                        <span class="text-[10px] font-black uppercase tracking-widest text-gray-400"><%= isMentor ? "Mentor Alerts" : "Student Alerts" %></span>
                        <button onclick="clearNotifs()" class="text-[10px] font-bold text-indigo-600 hover:underline uppercase">Clear</button>
                    </div>
                    <div id="notifList" class="max-h-[300px] overflow-y-auto">
                        <div class="flex items-start gap-4 p-4 hover:bg-gray-50 transition-colors border-b border-gray-50">
                            <div class="w-8 h-8 rounded-full bg-green-100 flex items-center justify-center text-green-600 shrink-0">
                                <span class="material-icons-round text-sm"><%= isMentor ? "verified_user" : "assignment_turned_in" %></span>
                            </div>
                            <div>
                                <p class="text-xs font-bold text-gray-800"><%= isMentor ? "Verified Access" : "Module Completed" %></p>
                                <p class="text-[10px] text-gray-500 mt-1"><%= isMentor ? "PathPilot account ready." : "Great job! Keep learning momentum." %></p>
                            </div>
                        </div>
                    </div>
                    <a href="<%=request.getContextPath()%><%= isMentor ? "/user/profile" : "/student/progress" %>" class="block py-3 text-center text-[10px] font-black uppercase tracking-widest text-gray-400 hover:text-indigo-600 bg-gray-50/50">
                         <%= isMentor ? "View Dashboard" : "View My Progress" %>
                    </a>
                </div>
            </div>

            <div class="flex items-center gap-3 pl-2 md:pl-4 border-l border-gray-200">
               <a href="<%=request.getContextPath()%><%=profilePath%>" title="<%= isMentor ? "Dashboard" : "My Profile" %>">
                    <div class="w-9 h-9 bg-indigo-50 rounded-full flex items-center justify-center text-xs font-bold text-indigo-600 cursor-pointer border-2 <%= currentPath.contains("profile") ? "border-indigo-500" : "border-transparent" %> hover:border-indigo-400 transition-all duration-300 uppercase">
                        <c:choose>
                            <c:when test="${not empty sessionScope.userName}">
                                ${fn:toUpperCase(fn:substring(sessionScope.userName, 0, 2))}
                            </c:when>
                            <c:otherwise>PP</c:otherwise>
                        </c:choose>
                    </div>
               </a>
            </div>

            <a href="<%=request.getContextPath()%>/logout" class="hidden md:block text-gray-400 hover:text-red-500 p-1" title="Sign Out">
                <span class="material-icons-round text-xl">logout</span>
            </a>

            <button id="mobile-menu-btn" class="lg:hidden text-gray-600 hover:text-indigo-600 p-2 focus:outline-none">
                <span class="material-icons-round transition-transform duration-300" id="menu-icon">menu</span>
            </button>
        </div>
    </div>

    <div id="mobile-menu" class="hidden lg:hidden bg-white border-t border-gray-50 overflow-hidden transition-all duration-300">
        <div class="px-6 py-4 flex flex-col gap-4">
                <a href="<%=request.getContextPath()%><%=homePath%>" 
                    class="text-sm font-semibold p-3 rounded-xl <%= (isMentor ? currentPath.contains("UserHome") : currentPath.contains("/home")) ? "bg-indigo-50 text-indigo-600" : "text-gray-600" %>">
                    <%= isMentor ? "Home" : "Dashboard" %>
            </a>
                <a href="<%=request.getContextPath()%><%=featuresPath%>" 
               class="text-sm font-semibold p-3 rounded-xl <%= currentPath.contains("features") ? "bg-indigo-50 text-indigo-600" : "text-gray-600" %>">
               Features
            </a>
                <a href="<%=request.getContextPath()%><%=resourcesPath%>" 
               class="text-sm font-semibold p-3 rounded-xl <%= currentPath.contains("resources") ? "bg-indigo-50 text-indigo-600" : "text-gray-600" %>">
                    <%= isMentor ? "Resources" : "Library" %>
            </a>
                <a href="<%=request.getContextPath()%><%=aboutPath%>" 
               class="text-sm font-semibold p-3 rounded-xl <%= currentPath.contains("about") ? "bg-indigo-50 text-indigo-600" : "text-gray-600" %>">
               About
            </a>
                <a href="<%=request.getContextPath()%><%=helpPath%>" 
               class="text-sm font-semibold p-3 rounded-xl <%= currentPath.contains("contact") ? "bg-indigo-50 text-indigo-600" : "text-gray-600" %>">
                    <%= isMentor ? "Contact" : "Help" %>
            </a>
            <hr class="border-gray-50">
            <a href="<%=request.getContextPath()%>/logout" class="text-sm font-semibold p-3 rounded-xl text-red-500 flex items-center gap-2">
                <span class="material-icons-round text-sm">logout</span> Sign Out
            </a>
        </div>
    </div>
</nav>

<script>
    (function() {
        const btn = document.getElementById('notifBtn');
        const dropdown = document.getElementById('notifDropdown');
        const dot = document.getElementById('notifDot');
        const mobileBtn = document.getElementById('mobile-menu-btn');
        const mobileMenu = document.getElementById('mobile-menu');
        const menuIcon = document.getElementById('menu-icon');

        // Check if essential elements exist before adding listeners
        if (btn && dropdown) {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                dropdown.classList.toggle('hidden');
                if (dot) dot.classList.add('hidden');
                // Close mobile menu if notifications are opened
                if (mobileMenu) {
                    mobileMenu.classList.add('hidden');
                    if (menuIcon) menuIcon.innerText = 'menu';
                }
            });
        }

        if (mobileBtn && mobileMenu) {
            mobileBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                const isHidden = mobileMenu.classList.contains('hidden');
                if (isHidden) {
                    mobileMenu.classList.remove('hidden');
                    if (menuIcon) menuIcon.innerText = 'close';
                    // Close notifications if mobile menu is opened
                    if (dropdown) dropdown.classList.add('hidden');
                } else {
                    mobileMenu.classList.add('hidden');
                    if (menuIcon) menuIcon.innerText = 'menu';
                }
            });
        }

        // Global click to close dropdowns
        window.addEventListener('click', (e) => {
            if (dropdown && !dropdown.contains(e.target) && e.target !== btn) {
                dropdown.classList.add('hidden');
            }
            if (mobileMenu && !mobileMenu.contains(e.target) && !mobileBtn?.contains(e.target)) {
                mobileMenu.classList.add('hidden');
                if (menuIcon) menuIcon.innerText = 'menu';
            }
        });
    })();

    function clearNotifs() {
        const list = document.getElementById('notifList');
        if (list) {
            list.innerHTML = `
                <div class="p-10 text-center">
                    <span class="material-icons-round text-gray-200 text-4xl">notifications_none</span>
                    <p class="text-gray-400 text-[10px] font-black uppercase mt-2 tracking-widest">Inbox Zero</p>
                </div>
            `;
        }
    }
</script>