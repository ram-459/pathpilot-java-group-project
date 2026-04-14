<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<nav class="sticky top-0 z-50 w-full bg-white/90 backdrop-blur-md shadow-sm border-b border-gray-100">
    <div class="max-w-7xl mx-auto px-6 md:px-12 py-4 flex items-center justify-between">
        
        <div class="flex items-center gap-2">
            <div class="bg-indigo-600 p-2 rounded-lg text-white shadow-md shadow-indigo-200">
                <i class="fas fa-compass text-lg"></i>
            </div>
            <span class="text-xl font-bold text-gray-800 tracking-tight">PathPilot</span>
        </div>

        <div class="hidden lg:flex gap-8 text-gray-600 font-medium items-center">
            <a href="<%=request.getContextPath()%>/guest/home" class="nav-link hover:text-indigo-600 transition-all duration-300">Home</a>
            <a href="<%=request.getContextPath()%>/guest/features" class="nav-link hover:text-indigo-600 transition-all duration-300">Features</a>
            <a href="<%=request.getContextPath()%>/guest/resources" class="nav-link hover:text-indigo-600 transition-all duration-300">Resources</a>
            <a href="<%=request.getContextPath()%>/guest/about" class="nav-link hover:text-indigo-600 transition-all duration-300">About</a>
            <a href="<%=request.getContextPath()%>/guest/contact" class="nav-link hover:text-indigo-600 transition-all duration-300">Contact</a>
        </div>

        <div class="flex items-center gap-3 md:gap-4">
            <div class="hidden sm:flex items-center gap-3">
                <a href="<%=request.getContextPath()%>/login" 
                   class="px-5 py-2 rounded-lg font-semibold text-indigo-600 border border-indigo-600 hover:bg-indigo-50 transition-all duration-300 text-sm md:text-base">
                    Login
                </a>
                <a href="<%=request.getContextPath()%>/register" 
                   class="px-6 py-2.5 rounded-lg font-bold text-white bg-indigo-600 hover:bg-indigo-700 shadow-md shadow-indigo-200 transition-all duration-300 text-sm md:text-base">
                    Get Started
                </a>
            </div>

            <button id="mobile-menu-button" class="lg:hidden text-gray-600 hover:text-indigo-600 focus:outline-none p-2">
                <i class="fas fa-bars text-2xl" id="menu-icon"></i>
            </button>
        </div>
    </div>

    <div id="mobile-menu" class="hidden lg:hidden bg-white border-t border-gray-100 shadow-xl animate-in slide-in-from-top duration-300">
        <div class="flex flex-col p-6 gap-4 font-medium text-gray-600">
            <a href="<%=request.getContextPath()%>/guest/home" class="nav-link hover:text-indigo-600 py-2 border-b border-gray-50">Home</a>
            <a href="<%=request.getContextPath()%>/guest/features" class="nav-link hover:text-indigo-600 py-2 border-b border-gray-50">Features</a>
            <a href="<%=request.getContextPath()%>/guest/resources" class="nav-link hover:text-indigo-600 py-2 border-b border-gray-50">Resources</a>
            <a href="<%=request.getContextPath()%>/guest/about" class="nav-link hover:text-indigo-600 py-2 border-b border-gray-50">About</a>
            <a href="<%=request.getContextPath()%>/guest/contact" class="nav-link hover:text-indigo-600 py-2 border-b border-gray-50">Contact</a>
            
            <div class="flex flex-col gap-3 mt-4 sm:hidden">
                <a href="<%=request.getContextPath()%>/login" class="text-center px-5 py-3 rounded-xl font-semibold text-indigo-600 border border-indigo-600">Login</a>
                <a href="<%=request.getContextPath()%>/register" class="text-center px-6 py-3 rounded-xl font-bold text-white bg-indigo-600">Get Started</a>
            </div>
        </div>
    </div>
</nav>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        // --- Mobile Menu Logic (Same as your original) ---
        const menuButton = document.getElementById('mobile-menu-button');
        const mobileMenu = document.getElementById('mobile-menu');
        const menuIcon = document.getElementById('menu-icon');

        menuButton.addEventListener('click', () => {
            const isHidden = mobileMenu.classList.contains('hidden');
            if (isHidden) {
                mobileMenu.classList.remove('hidden');
                menuIcon.classList.remove('fa-bars');
                menuIcon.classList.add('fa-times');
            } else {
                mobileMenu.classList.add('hidden');
                menuIcon.classList.remove('fa-times');
                menuIcon.classList.add('fa-bars');
            }
        });

        // --- NEW: Active Link Color Logic ---
        const currentPath = window.location.pathname;
        const navLinks = document.querySelectorAll('.nav-link');

        navLinks.forEach(link => {
            // If the current browser URL ends with the link's href
            if (link.getAttribute('href').includes(currentPath)) {
                link.classList.remove('text-gray-600');
                link.classList.add('text-indigo-600', 'font-bold');
            }
        });
    });
</script>