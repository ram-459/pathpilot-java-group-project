<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Contact Support | PathPilot</title>

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
        .error { @apply text-red-500 text-[10px] font-bold mt-1 block ml-1; }
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
                document.getElementById("nameError").innerText = "Full name required";
                isValid = false;
            }

            let emailPattern = /^[^ ]+@[^ ]+\.[a-z]{2,3}$/;
            if (email === "" || !email.match(emailPattern)) {
                document.getElementById("emailError").innerText = "Valid email required";
                isValid = false;
            }

            if (subject === "") {
                document.getElementById("subjectError").innerText = "Subject required";
                isValid = false;
            }

            if (message === "") {
                document.getElementById("messageError").innerText = "Message required";
                isValid = false;
            }

            return isValid;
        }
    </script>
</head>

<body class="bg-[#f8f9fc] text-gray-900 min-h-screen flex flex-col antialiased">

<jsp:include page="/WEB-INF/views/components/gnavbar.jsp"/>

<section class="bg-gradient-to-br from-indigo-700 via-primary to-purple-800 text-white py-16">
    <div class="max-w-7xl mx-auto px-12">
        <span class="bg-white/10 border border-white/20 px-4 py-1.5 rounded-full text-[10px] font-black uppercase tracking-widest">
            Guest Support
        </span>
        <h1 class="text-5xl font-800 mt-6 mb-4 tracking-tight">Get in Touch</h1>
        <p class="text-indigo-100 max-w-2xl font-medium leading-relaxed">
            Have questions about our career roadmaps or how PathPilot works? We're here to help you start your tech journey.
        </p>
    </div>
</section>

<main class="flex-grow py-16">
    <div class="max-w-7xl mx-auto px-12">
        <div class="grid lg:grid-cols-3 gap-12">

            <div class="lg:col-span-2 bg-white rounded-[2.5rem] shadow-sm p-12 border border-gray-100">
                <h2 class="text-3xl font-800 mb-8 text-gray-900 tracking-tight">Send us a message</h2>

                <form name="contactForm" action="#" method="post" onsubmit="return validateContact()" class="space-y-8">
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
                        <input type="text" name="subject" class="w-full bg-gray-50 border-none rounded-2xl px-5 py-4 focus:ring-2 focus:ring-primary/20 transition-all outline-none font-medium" placeholder="Inquiry about Career Roadmaps">
                        <span id="subjectError" class="error"></span>
                    </div>

                    <div>
                        <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-2 ml-1">Message</label>
                        <textarea name="message" rows="5" class="w-full bg-gray-50 border-none rounded-2xl px-5 py-4 focus:ring-2 focus:ring-primary/20 transition-all outline-none resize-none font-medium" placeholder="How can we assist you today?"></textarea>
                        <span id="messageError" class="error"></span>
                    </div>

                    <button type="submit" class="w-full bg-primary hover:bg-primary-dark text-white font-bold py-5 rounded-2xl shadow-xl shadow-primary/20 transition-all active:scale-95">
                        Submit Inquiry
                    </button>
                </form>
            </div>

            <div class="space-y-6">
                <div class="p-8 bg-white border border-gray-100 rounded-[2rem] shadow-sm hover:border-primary/20 transition-all">
                    <div class="bg-indigo-50 w-12 h-12 rounded-xl flex items-center justify-center mb-4">
                        <span class="material-icons-round text-primary">mail</span>
                    </div>
                    <h3 class="font-bold text-gray-900">Email</h3>
                    <p class="text-gray-500 text-sm mt-1">support@pathpilot.io</p>
                </div>

                <div class="p-8 bg-white border border-gray-100 rounded-[2rem] shadow-sm hover:border-primary/20 transition-all">
                    <div class="bg-indigo-50 w-12 h-12 rounded-xl flex items-center justify-center mb-4">
                        <span class="material-icons-round text-primary">location_on</span>
                    </div>
                    <h3 class="font-bold text-gray-900">Campus Office</h3>
                    <p class="text-gray-500 text-sm mt-1">RK University, Rajkot<br>Gujarat, India</p>
                </div>

                <div class="p-8 bg-white border border-gray-100 rounded-[2rem] shadow-sm hover:border-primary/20 transition-all">
                    <div class="bg-purple-50 w-12 h-12 rounded-xl flex items-center justify-center mb-4">
                        <span class="material-icons-round text-purple-600">forum</span>
                    </div>
                    <h3 class="font-bold text-gray-900">Community</h3>
                    <p class="text-gray-500 text-sm mt-1">Join our Discord</p>
                </div>
            </div>

        </div>
    </div>
</main>



<jsp:include page="/WEB-INF/views/components/guest_footer.jsp"/>

</body>
</html>