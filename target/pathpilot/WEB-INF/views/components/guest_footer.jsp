<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 
    Note: Page directive is only at the top to prevent 'Internal Server Error 500' in Tomcat 11.
--%>
<footer class="bg-white border-t border-neutral-100 pt-16 pb-8">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-5 gap-8 mb-12">
            
            <div class="col-span-2 lg:col-span-2">
                <div class="flex items-center gap-2 mb-4">
                    <a href="<%=request.getContextPath()%>/guest/home" class="flex items-center gap-2">
                        <div class="w-8 h-8 rounded-lg bg-[#1313ec] flex items-center justify-center text-white shadow-md">
                            <span class="material-icons-round text-sm">rocket_launch</span>
                        </div>
                        <span class="font-['Plus_Jakarta_Sans'] font-extrabold text-xl tracking-tight text-neutral-800">PathPilot</span>
                    </a>
                </div>
                <p class="text-neutral-500 text-sm max-w-xs mb-6 font-medium">
                    Guiding BTech & BCA students from confusion to a focused IT career with industry-standard roadmaps.
                </p>
                <div class="flex gap-4">
                    <a href="#" class="w-10 h-10 rounded-full bg-gray-50 flex items-center justify-center text-neutral-400 hover:text-[#1313ec] transition-all">
                        <i class="fab fa-twitter text-lg"></i>
                    </a>
                    <a href="#" class="w-10 h-10 rounded-full bg-gray-50 flex items-center justify-center text-neutral-400 hover:text-[#1313ec] transition-all">
                        <i class="fab fa-github text-lg"></i>
                    </a>
                </div>
            </div>

            <div>
                <h4 class="font-['Plus_Jakarta_Sans'] font-bold text-neutral-800 text-xs uppercase tracking-widest mb-6">Platform</h4>
                <ul class="space-y-3 text-sm text-neutral-500 font-medium">
                    <li><a class="hover:text-[#1313ec] transition-colors" href="<%=request.getContextPath()%>/guest/careerpath">Career Paths</a></li>
                    <li><a class="hover:text-[#1313ec] transition-colors" href="<%=request.getContextPath()%>/guest/resources">Resources</a></li>
                    <li><a class="hover:text-[#1313ec] transition-colors" href="<%=request.getContextPath()%>/guest/features">Features</a></li>
                    <li><a class="hover:text-[#1313ec] transition-colors" href="#">Pricing</a></li>
                </ul>
            </div>

            <div>
                <h4 class="font-['Plus_Jakarta_Sans'] font-bold text-neutral-800 text-xs uppercase tracking-widest mb-6">Company</h4>
                <ul class="space-y-3 text-sm text-neutral-500 font-medium">
                    <li><a class="hover:text-[#1313ec] transition-colors" href="<%=request.getContextPath()%>/guest/about">About Us</a></li>
                    <li><a class="hover:text-[#1313ec] transition-colors" href="#">Careers</a></li>
                    <li><a class="hover:text-[#1313ec] transition-colors" href="#">Blog</a></li>
                    <li><a class="hover:text-[#1313ec] transition-colors" href="<%=request.getContextPath()%>/guest/contact">Contact</a></li>
                </ul>
            </div>

            <div>
                <h4 class="font-['Plus_Jakarta_Sans'] font-bold text-neutral-800 text-xs uppercase tracking-widest mb-6">Support</h4>
                <ul class="space-y-3 text-sm text-neutral-500 font-medium">
                    <li><a class="hover:text-[#1313ec] transition-colors" href="#">Help Center</a></li>
                    <li><a class="hover:text-[#1313ec] transition-colors" href="#">Terms of Service</a></li>
                    <li><a class="hover:text-[#1313ec] transition-colors" href="#">Privacy Policy</a></li>
                </ul>
            </div>
        </div>

        <div class="border-t border-neutral-100 pt-8 flex flex-col md:flex-row justify-between items-center gap-4">
            <p class="text-neutral-400 text-xs font-bold uppercase tracking-tighter">© 2026 PathPilot. Crafted for future engineers.</p>
            <div class="flex items-center gap-2 bg-green-50 px-3 py-1 rounded-full border border-green-100">
                <span class="w-1.5 h-1.5 rounded-full bg-green-500 animate-pulse"></span>
                <span class="text-green-600 text-[10px] font-black uppercase tracking-widest">Global Systems Online</span>
            </div>
        </div>
    </div>
</footer>