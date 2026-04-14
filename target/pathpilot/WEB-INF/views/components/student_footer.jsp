<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 
    ✅ PathPilot Student Footer
    Synchronized with StudentController mappings.
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
                    <%-- ✅ FIXED: Student specific links --%>
                    
                    <li><a class="hover:text-primary transition-colors" href="<%=request.getContextPath()%>/student/resources">Learning Resources</a></li>
                    <li><a class="hover:text-primary transition-colors" href="<%=request.getContextPath()%>/student/features">Platform Features</a></li>
                    <li><a class="hover:text-primary transition-colors" href="<%=request.getContextPath()%>/student/home">Student Dashboard</a></li>
                </ul>
            </div>

            <div>
                <h4 class="font-['Poppins'] font-semibold text-neutral-800 dark:text-white mb-4">Account</h4>
                <ul class="space-y-2 text-sm text-neutral-500 dark:text-neutral-400">
                    <%-- ✅ FIXED: Directs to Student Profile & Settings --%>
                    <li><a class="hover:text-primary transition-colors" href="<%=request.getContextPath()%>/student/profile">My Profile</a></li>
                    <li><a class="hover:text-primary transition-colors" href="<%=request.getContextPath()%>/student/settings">Account Settings</a></li>
                    <li><a class="hover:text-primary transition-colors" href="<%=request.getContextPath()%>/student/progress">Track Progress</a></li>
                    <li><a class="hover:text-primary transition-colors" href="<%=request.getContextPath()%>/student/certificates">My Certificates</a></li>
                </ul>
            </div>

            <div>
                <h4 class="font-['Poppins'] font-semibold text-neutral-800 dark:text-white mb-4">Help & Support</h4>
                <ul class="space-y-2 text-sm text-neutral-500 dark:text-neutral-400">
                    <%-- ✅ FIXED: Points to Student Support --%>
                    <li><a class="hover:text-primary transition-colors" href="<%=request.getContextPath()%>/student/about">About PathPilot</a></li>
                    <li><a class="hover:text-primary transition-colors" href="<%=request.getContextPath()%>/student/contact">Support Center</a></li>
                    <li><a class="hover:text-primary transition-colors" href="<%=request.getContextPath()%>/student/quotes">Happy Soul (Quotes)</a></li>
                </ul>
            </div>
        </div>

        <div class="border-t border-neutral-100 dark:border-neutral-800 pt-8 flex flex-col md:flex-row justify-between items-center gap-4">
            <p class="text-neutral-400 text-sm">© 2026 PathPilot. Crafted for Students by Ram.</p>
            <div class="flex items-center gap-2">
                <span class="w-2 h-2 rounded-full bg-green-500"></span>
                <span class="text-neutral-400 text-xs">Student Portal Active</span>
            </div>
        </div>
    </div>
</footer>