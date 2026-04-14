<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if(session == null || session.getAttribute("role") == null){
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enroll - PathPilot</title>

    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Poppins:wght@500;600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet"/>
    
    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: { primary: "#4913ec", "primary-dark": "#3a0fb5" },
                    fontFamily: { sans: ["'Plus Jakarta Sans'", "sans-serif"], heading: ["Poppins", "sans-serif"] }
                }
            }
        }
    </script>

    <style type="text/tailwindcss">
        body { font-family: 'Plus Jakarta Sans', sans-serif; }
        h1, h2, h3 { font-family: 'Poppins', sans-serif; }
        /* ✅ Standardized Error Styling */
        .error-msg { 
            @apply text-red-500 text-[10px] font-bold mt-1.5 block ml-1 transition-all duration-200; 
            min-height: 15px; 
        }
        .input-error { @apply ring-2 ring-red-500/20 border-red-500 !important; }
    </style>

    <script>
        function validateForm() {
            let isValid = true;
            const phone = document.forms["enrollForm"]["phone"].value.trim();
            const phoneError = document.getElementById("phoneError");
            const phoneInput = document.forms["enrollForm"]["phone"];

            // Reset
            phoneError.innerText = "";
            phoneInput.classList.remove("input-error");

            // Phone Validation
            const phonePattern = /^[0-9]{10}$/;
            if (phone === "") {
                phoneError.innerText = "Phone number is required for enrollment";
                phoneInput.classList.add("input-error");
                isValid = false;
            } else if (!phonePattern.test(phone)) {
                phoneError.innerText = "Please enter a valid 10-digit mobile number";
                phoneInput.classList.add("input-error");
                isValid = false;
            }

            return isValid;
        }
    </script>
</head>

<body class="bg-[#f8f9fc] antialiased">

<jsp:include page="/WEB-INF/views/components/user_navbar.jsp"/>

<div class="max-w-4xl mx-auto py-20 px-6">
    <div class="bg-white rounded-[2.5rem] shadow-sm border border-gray-100 p-12">

        <h1 class="text-4xl font-800 text-gray-900 mb-2 tracking-tight">Enroll in Course</h1>
        <p class="text-gray-500 mb-10 font-medium text-sm">Please confirm your details to add this roadmap to your learning journey.</p>

        <div class="bg-indigo-50/50 border border-indigo-100 rounded-[2rem] p-8 mb-10 relative overflow-hidden group">
            <div class="absolute top-0 right-0 p-4 opacity-10 group-hover:scale-110 transition-transform">
                <span class="material-icons-round text-6xl text-primary">auto_awesome</span>
            </div>
            <span class="text-[10px] font-black text-primary uppercase tracking-widest block mb-2 text-center">Selected Career Path</span>
            <h2 class="text-2xl font-800 text-primary text-center">
                ${not empty careerPath.title ? careerPath.title : "Professional Roadmap"}
            </h2>
        </div>

        <%-- All Phases Section (Locked) --%>
        <div class="mb-10">
            <h3 class="text-lg font-800 text-gray-900 mb-6 flex items-center gap-2">
                <span class="material-icons-round text-primary">school</span>
                Learning Path (${not empty phases ? phases.size() : 0} Phases)
            </h3>
            <div class="space-y-3">
                <c:forEach var="phase" items="${phases}">
                    <div class="relative bg-gray-50 border border-gray-200 rounded-2xl p-6 hover:shadow-md transition-all opacity-75">
                        <div class="absolute top-4 right-4 text-gray-300">
                            <span class="material-icons-round text-lg">lock</span>
                        </div>
                        <div class="flex items-start gap-4 pr-12">
                            <div class="flex-shrink-0 w-12 h-12 bg-gradient-to-br from-primary/10 to-primary/5 rounded-xl flex items-center justify-center">
                                <span class="text-primary font-bold text-sm">${phase.phaseNumber}</span>
                            </div>
                            <div class="flex-grow">
                                <h4 class="font-bold text-gray-900 mb-1">${phase.title}</h4>
                                <p class="text-sm text-gray-500">${phase.content}</p>
                            </div>
                        </div>
                        <div class="mt-4 pt-4 border-t border-gray-200 text-[10px] text-gray-400 font-medium">
                            <span class="inline-block bg-gray-200 text-gray-700 px-3 py-1 rounded-full">
                                <span class="material-icons-round" style="font-size: 12px; vertical-align: middle; margin-right: 4px;">lock</span>
                                Unlock after enrollment
                            </span>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <form name="enrollForm"
              action="<%=request.getContextPath()%>/user/enroll"
              method="POST" 
              onsubmit="return validateForm()"
              class="space-y-8">

            <input type="hidden" name="pathId" value="${careerPath.pathId}" />
            <input type="hidden" name="title" value="${careerPath.title}" />

            <div class="grid md:grid-cols-2 gap-8">
                <!-- Name (Read-Only) -->
                <div>
                    <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Student Name</label>
                    <div class="relative">
                        <input type="text" name="name" value="${sessionScope.userName}"
                               class="w-full bg-gray-50 border-gray-100 border rounded-2xl px-5 py-4 font-medium opacity-70 cursor-not-allowed outline-none"
                               readonly>
                        <span class="material-icons-round absolute right-4 top-1/2 -translate-y-1/2 text-gray-300 text-sm">lock</span>
                    </div>
                    <span class="error-msg"></span> <%-- Empty span for alignment --%>
                </div>

                <!-- Phone (Validated) -->
                <div>
                    <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Contact Phone</label>
                    <input type="text" name="phone"
                           class="w-full bg-gray-50 border-gray-100 border rounded-2xl px-5 py-4 focus:ring-2 focus:ring-primary/20 transition-all outline-none font-medium"
                           placeholder="9876543210">
                    <!-- ✅ Phone Error Span -->
                    <span id="phoneError" class="error-msg"></span>
                </div>
            </div>

            <!-- Email (Read-Only) -->
            <div>
                <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Email Address</label>
                <div class="relative">
                    <input type="email" name="email" value="${sessionScope.userEmail}"
                           class="w-full bg-gray-50 border-gray-100 border rounded-2xl px-5 py-4 font-medium opacity-70 cursor-not-allowed outline-none"
                           readonly>
                    <span class="material-icons-round absolute right-4 top-1/2 -translate-y-1/2 text-gray-300 text-sm">lock</span>
                </div>
                <span class="error-msg"></span>
            </div>

            <div class="flex flex-col md:flex-row gap-4 pt-6">
                <button type="submit"
                        class="flex-1 bg-primary hover:bg-primary-dark text-white font-bold py-5 rounded-2xl shadow-xl shadow-primary/20 transition-all active:scale-95 flex items-center justify-center gap-2">
                    <span class="material-icons-round text-sm">check_circle</span>
                    Confirm Enrollment
                </button>

                <a href="<%=request.getContextPath()%>/user/career"
                   class="px-10 py-5 rounded-2xl border border-gray-200 font-bold text-gray-400 hover:bg-gray-50 transition-all text-center">
                    Back to Paths
                </a>
            </div>
        </form>
    </div>
</div>

<jsp:include page="/WEB-INF/views/components/user_footer.jsp"/>

</body>
</html>