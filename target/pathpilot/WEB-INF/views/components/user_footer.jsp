<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 
    Note: Page directive is at the top. 
    Links synchronized with UserController mappings and SRS v1.0.
--%>
<footer class="bg-white dark:bg-background-dark border-t border-neutral-100 dark:border-neutral-800 pt-16 pb-8 font-['Plus_Jakarta_Sans']">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-5 gap-8 mb-12">
            
            <div class="col-span-2 lg:col-span-2">
                <div class="flex items-center gap-2 mb-4">
                    <div class="w-7 h-7 rounded bg-[#4913ec] flex items-center justify-center text-white shadow-md">
                        <span class="material-icons-round text-sm">rocket_launch</span>
                    </div>
                    <span class="font-['Poppins'] font-bold text-lg text-neutral-800 dark:text-white">PathPilot</span>
                </div>
                <p class="text-neutral-500 dark:text-neutral-400 text-sm max-w-xs mb-6">
                    Guiding the next generation of tech talent with clarity, structure, and purpose.
                </p>
                <div class="flex gap-4">
                    <a href="https://www.instagram.com/iamrpk___?igsh=MWx0MjgzOXUxeTgzMw==" 
   target="_blank" 
   rel="noopener noreferrer" 
   class="text-neutral-400 hover:text-primary transition-colors">
    <i class="fab fa-instagram text-lg"></i>
</a>
                    <a href="https://github.com/ram-459" 
   target="_blank" 
   rel="noopener noreferrer" 
   class="text-neutral-400 hover:text-primary transition-colors">
    <i class="fab fa-github text-lg"></i>
</a>
                </div>
            </div>

            <div>
                <h4 class="font-['Poppins'] font-semibold text-neutral-800 dark:text-white mb-4">Platform</h4>
                <ul class="space-y-2 text-sm text-neutral-500 dark:text-neutral-400">
                    <%-- ✅ FIXED: Points to /user/career --%>
                    <li><a class="hover:text-primary transition-colors" href="<%=request.getContextPath()%>/user/resources">Career Paths</a></li>
                    <%-- ✅ FIXED: Points to /user/resources --%>
                    <li><a class="hover:text-primary transition-colors" href="<%=request.getContextPath()%>/user/resources">Resources</a></li>
                    <%-- ✅ FIXED: Points to /user/features --%>
                    <li><a class="hover:text-primary transition-colors" href="<%=request.getContextPath()%>/user/features">Features</a></li>
                    <%-- ✅ FIXED: Updated Dashboard link to /user/profile --%>
                    <li><a class="hover:text-primary transition-colors" href="<%=request.getContextPath()%>/user/profile">Dashboard</a></li>
                </ul>
            </div>

            <div>
                <h4 class="font-['Poppins'] font-semibold text-neutral-800 dark:text-white mb-4">Company</h4>
                <ul class="space-y-2 text-sm text-neutral-500 dark:text-neutral-400">
                    <%-- ✅ FIXED: Points to /user/about --%>
                    <li><a class="hover:text-primary transition-colors" href="<%=request.getContextPath()%>/user/about">About Us</a></li>
                    <li><a class="hover:text-primary transition-colors" href="#">Careers</a></li>
                    <li><a class="hover:text-primary transition-colors" href="#">Blog</a></li>
                    <%-- ✅ FIXED: Points to /user/contact --%>
                    <li><a class="hover:text-primary transition-colors" href="<%=request.getContextPath()%>/user/contact">Contact</a></li>
                </ul>
            </div>

            <div>
                <h4 class="font-['Poppins'] font-semibold text-neutral-800 dark:text-white mb-4">Support</h4>
                <ul class="space-y-2 text-sm text-neutral-500 dark:text-neutral-400">
                    <%-- ✅ FIXED: Points to /user/contact for Help Center --%>
                    <li><a class="hover:text-primary transition-colors" href="<%=request.getContextPath()%>/user/contact">Help Center</a></li>
                    <li><a class="hover:text-primary transition-colors" href="#">Terms of Service</a></li>
                    <li><a class="hover:text-primary transition-colors" href="#">Privacy Policy</a></li>
                </ul>
            </div>
        </div>

        <div class="border-t border-neutral-100 dark:border-neutral-800 pt-8 flex flex-col md:flex-row justify-between items-center gap-4">
            <p class="text-neutral-400 text-sm">© 2026 PathPilot. All rights reserved.</p>
            <div class="flex items-center gap-2">
                <span class="w-2 h-2 rounded-full bg-green-500"></span>
                <span class="text-neutral-400 text-xs">Systems Operational</span>
            </div>
        </div>
    </div>
</footer>