<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    // 🔐 SESSION + CACHE FIX ONLY
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // 🔐 If not logged in → redirect
    if(session == null || session.getAttribute("role") == null){
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Contact Support | PathPilot</title>

    <%-- Standardized Fonts and Icons --%>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Poppins:wght@500;600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: { 
                        primary: "#4913ec",
                        "primary-dark": "#3a0fb5",
                    },
                    fontFamily: { 
                        sans: ["'Plus Jakarta Sans'", "sans-serif"],
                        heading: ["Poppins", "sans-serif"]
                    }
                }
            }
        }
    </script>

    <style type="text/tailwindcss">
        body { font-family: 'Plus Jakarta Sans', sans-serif; }
        h1, h2, h3, .font-heading { font-family: 'Poppins', sans-serif; }
        
        /* Validation Span Styling */
        .error { 
            @apply text-red-500 text-[10px] font-bold mt-1.5 block ml-1 transition-all duration-300; 
            min-height: 15px; 
        }
    </style>

    <script>
        function validateContact() {
            let isValid = true;
            let name = document.forms["contactForm"]["fullName"].value.trim();
            let email = document.forms["contactForm"]["email"].value.trim();
            let subject = document.forms["contactForm"]["subject"].value.trim();
            let message = document.forms["contactForm"]["message"].value.trim();

            document.getElementById("nameError").innerText = "";
            document.getElementById("emailError").innerText = "";
            document.getElementById("subjectError").innerText = "";
            document.getElementById("messageError").innerText = "";

            if (name === "") {
                document.getElementById("nameError").innerText = "Full name is required";
                isValid = false;
            }

            let emailPattern = /^[^ ]+@[^ ]+\.[a-z]{2,3}$/;
            if (email === "" || !email.match(emailPattern)) {
                document.getElementById("emailError").innerText = "A valid email address is required";
                isValid = false;
            }

            if (subject === "") {
                document.getElementById("subjectError").innerText = "Please provide a subject";
                isValid = false;
            }

            if (message === "") {
                document.getElementById("messageError").innerText = "Message cannot be empty";
                isValid = false;
            }

            return isValid;
        }
    </script>
</head>

<body class="bg-[#f8f9fc] text-gray-900 min-h-screen flex flex-col antialiased">

<jsp:include page="/WEB-INF/views/components/user_navbar.jsp"/>

<section class="bg-gradient-to-br from-indigo-700 via-primary to-purple-800 text-white py-20">
    <div class="max-w-7xl mx-auto px-12 text-center md:text-left">
        <span class="bg-white/10 border border-white/20 px-4 py-1.5 rounded-full text-[10px] font-black uppercase tracking-widest">
            Support Center
        </span>
        <h1 class="text-5xl font-800 mt-6 mb-4 tracking-tight">How can we help?</h1>
        <p class="text-indigo-100 max-w-2xl font-medium leading-relaxed">
            Have questions about your current roadmap or need technical assistance? Our team is dedicated to your engineering success.
        </p>
    </div>
</section>

<main class="flex-grow py-16">
    <div class="max-w-7xl mx-auto px-12">
        <div class="grid lg:grid-cols-3 gap-12">

            <div class="lg:col-span-2 bg-white rounded-[2.5rem] shadow-sm p-12 border border-gray-100">
                <h2 class="text-3xl font-800 mb-8 text-gray-900 tracking-tight">Send us a message</h2>

                <%-- Success Message --%>
                <c:if test="${not empty success}">
                    <div class="mb-8 p-4 bg-green-50 border border-green-200 rounded-2xl flex items-start gap-4">
                        <span class="material-icons-round text-green-600 flex-shrink-0">check_circle</span>
                        <div>
                            <p class="text-green-800 font-bold">${success}</p>
                        </div>
                    </div>
                </c:if>

                <%-- Error Message --%>
                <c:if test="${not empty error}">
                    <div class="mb-8 p-4 bg-red-50 border border-red-200 rounded-2xl flex items-start gap-4">
                        <span class="material-icons-round text-red-600 flex-shrink-0">error</span>
                        <div>
                            <p class="text-red-800 font-bold">${error}</p>
                        </div>
                    </div>
                </c:if>

                <form name="contactForm" action="<%=request.getContextPath()%>/student/contact" method="post" onsubmit="return validateContact()" class="space-y-6">
                    <%-- Hidden fields for admin info --%>
                    <c:if test="${not empty primaryAdmin}">
                        <input type="hidden" name="adminEmail" value="${primaryAdmin.email}">
                        <input type="hidden" name="adminId" value="${primaryAdmin.id}">
                    </c:if>
                    <input type="hidden" name="senderEmail" value="${sessionScope.userEmail}">
                    <input type="hidden" name="senderId" value="${sessionScope.userId}">
                    <div class="grid md:grid-cols-2 gap-8">
                        <div>
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Full Name</label>
                            <input type="text" name="fullName" class="w-full bg-gray-50 border-none rounded-2xl px-5 py-4 focus:ring-2 focus:ring-primary/20 transition-all outline-none font-medium" placeholder="Ram Kurmi">
                            <span id="nameError" class="error"></span>
                        </div>
                        <div>
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Email Address</label>
                            <input type="email" name="email" class="w-full bg-gray-50 border-none rounded-2xl px-5 py-4 focus:ring-2 focus:ring-primary/20 transition-all outline-none font-medium" placeholder="rkurmi101@rku.ac.in">
                            <span id="emailError" class="error"></span>
                        </div>
                    </div>

                    <div>
                        <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Subject</label>
                        <input type="text" name="subject" class="w-full bg-gray-50 border-none rounded-2xl px-5 py-4 focus:ring-2 focus:ring-primary/20 transition-all outline-none font-medium" placeholder="Course Roadmap Inquiry">
                        <span id="subjectError" class="error"></span>
                    </div>

                    <div>
                        <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Message</label>
                        <textarea name="message" rows="5" class="w-full bg-gray-50 border-none rounded-2xl px-5 py-4 focus:ring-2 focus:ring-primary/20 transition-all outline-none resize-none font-medium" placeholder="Describe your issue or question..."></textarea>
                        <span id="messageError" class="error"></span>
                    </div>

                    <button type="submit" class="w-full bg-primary hover:bg-primary-dark text-white font-bold py-5 rounded-2xl shadow-xl shadow-primary/20 transition-all active:scale-95">
                        Send Secure Message
                    </button>
                </form>
            </div>

            <div class="space-y-6">
                <%-- Admin Email --%>
                <div class="p-8 bg-white border border-gray-100 rounded-[2rem] shadow-sm hover:border-primary/20 transition-all group">
                    <div class="bg-indigo-50 w-12 h-12 rounded-xl flex items-center justify-center mb-4 transition-colors group-hover:bg-primary group-hover:text-white">
                        <span class="material-icons-round">mail</span>
                    </div>
                    <h3 class="font-bold text-gray-900">Email Support</h3>
                    <c:if test="${not empty primaryAdmin}">
                        <p class="text-gray-500 text-sm mt-1">${primaryAdmin.email}</p>
                    </c:if>
                    <c:if test="${empty primaryAdmin}">
                        <p class="text-gray-500 text-sm mt-1">rkurmi101@rku.ac.in</p>
                    </c:if>
                </div>

                <%-- Admin Contact --%>
                <div class="p-8 bg-white border border-gray-100 rounded-[2rem] shadow-sm hover:border-primary/20 transition-all group">
                    <div class="bg-indigo-50 w-12 h-12 rounded-xl flex items-center justify-center mb-4 transition-colors group-hover:bg-primary group-hover:text-white">
                        <span class="material-icons-round">phone</span>
                    </div>
                    <h3 class="font-bold text-gray-900">Contact Support</h3>
                    <c:if test="${not empty primaryAdmin}">
                        <p class="text-gray-500 text-sm mt-1">
                            <strong>Name:</strong> ${primaryAdmin.name}<br>
                            <c:if test="${not empty primaryAdmin.phone}">
                                <strong>Phone:</strong> ${primaryAdmin.phone}
                            </c:if>
                        </p>
                    </c:if>
                    <c:if test="${empty primaryAdmin}">
                        <p class="text-gray-500 text-sm mt-1">RK University, Rajkot<br>Gujarat, India</p>
                    </c:if>
                </div>

                <%-- All Admin List --%>
                <c:if test="${not empty adminUsers && adminUsers.size() > 1}">
                    <div class="p-8 bg-gradient-to-br from-primary/10 to-purple-50 border border-primary/20 rounded-[2rem] shadow-sm">
                        <h3 class="font-bold text-gray-900 mb-4 flex items-center gap-2">
                            <span class="material-icons-round text-primary">group</span>
                            Support Team
                        </h3>
                        <div class="space-y-3">
                            <c:forEach var="admin" items="${adminUsers}" varStatus="status">
                                <c:if test="${status.index < 3}">
                                    <div class="flex items-center gap-3 pb-3 border-b border-gray-200 last:border-0">
                                        <div class="w-10 h-10 rounded-full bg-primary text-white flex items-center justify-center text-sm font-bold">
                                            ${admin.name.charAt(0)}
                                        </div>
                                        <div>
                                            <p class="text-sm font-bold text-gray-900">${admin.name}</p>
                                            <p class="text-[10px] text-gray-500">${admin.email}</p>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
            </div>

        </div>
    </div>
</main>



<jsp:include page="/WEB-INF/views/components/student_footer.jsp"/>

</body>
</html>