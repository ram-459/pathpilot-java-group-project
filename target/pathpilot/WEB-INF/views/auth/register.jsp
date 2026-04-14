<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if(session != null && session.getAttribute("role") != null){
        String role = (String) session.getAttribute("role");
        if("ADMIN".equals(role)){
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/student/home");
        }
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Join PathPilot | Create Account</title>

    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet"/>

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: { 
                        'primary': '#4913ec',
                        'primary-dark': '#3a0fb5'
                    },
                    fontFamily: { 
                        'sans': ["'Plus Jakarta Sans'", 'sans-serif'], 
                        'heading': ['Poppins', 'sans-serif'] 
                    }
                }
            }
        }
    </script>

    <style>
        body { font-family: 'Plus Jakarta Sans', sans-serif; background-color: #f8f9fc; }
        .hero-indigo { background: linear-gradient(135deg, #4913ec 0%, #6366f1 100%); }
        
        /* 🚨 Validation Styles */
        .is-invalid { border: 2px solid #ef4444 !important; background-color: #fef2f2 !important; }
        .is-valid { border: 2px solid #10b981 !important; background-color: #f0fdf4 !important; }
        
        .validation-msg { font-size: 10px; font-weight: 700; text-transform: uppercase; margin-top: 4px; margin-left: 4px; display: none; }
        .invalid-feedback { color: #ef4444; }
        .valid-feedback { color: #10b981; }

        .spinner {
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            border-top: 2px solid #fff;
            width: 18px;
            height: 18px;
            animation: spin 0.8s linear infinite;
            display: none;
        }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
    </style>
</head>

<body class="antialiased overflow-hidden">

    <a href="<%=request.getContextPath()%>/guest/home"
       class="absolute top-8 left-8 z-50 flex items-center space-x-2 bg-white border border-gray-100 px-5 py-2.5 rounded-2xl shadow-sm hover:shadow-md transition-all active:scale-95 group">
        <span class="material-icons-round text-gray-400 group-hover:text-primary transition-colors">arrow_back</span>
        <span class="text-[10px] font-black uppercase tracking-widest text-gray-700">Back to Portal</span>
    </a>

    <div class="flex h-screen overflow-hidden">
        
        <div class="hidden lg:flex lg:w-[45%] hero-indigo p-16 flex-col justify-between text-white relative overflow-hidden">
            <div class="absolute -top-20 -left-20 w-64 h-64 bg-white/10 rounded-full blur-3xl"></div>
            <div class="absolute -bottom-20 -right-20 w-80 h-80 bg-indigo-400/20 rounded-full blur-3xl"></div>

            <div class="relative z-10">
                <div class="flex items-center space-x-3 mb-16">
                    <div class="w-12 h-12 bg-white/20 rounded-2xl flex items-center justify-center backdrop-blur-xl border border-white/30">
                        <span class="material-icons-round text-2xl text-white">rocket_launch</span>
                    </div>
                    <span class="text-xl font-800 tracking-[0.2em] text-white uppercase">PathPilot</span>
                </div>
                <h1 class="text-6xl font-800 leading-tight mb-6 tracking-tighter font-heading">
                    Master Your <br/><span class="text-white/60">Career</span> Path.
                </h1>
                <p class="text-lg font-medium opacity-80 max-w-sm leading-relaxed">
                    Join 20k+ students and get access to structured roadmaps, certificates, and expert guidance.
                </p>
            </div>
            
            <div class="relative z-10">
                <div class="bg-white/10 backdrop-blur-md border border-white/20 p-6 rounded-3xl inline-block">
                    <div class="flex items-center gap-4">
                        <div class="flex -space-x-3">
                            <div class="w-10 h-10 rounded-full border-2 border-white bg-indigo-200"></div>
                            <div class="w-10 h-10 rounded-full border-2 border-white bg-indigo-300"></div>
                            <div class="w-10 h-10 rounded-full border-2 border-white bg-indigo-400"></div>
                        </div>
                        <p class="text-xs font-bold uppercase tracking-widest text-white/90">Enrolling now for 2026 Batch</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="w-full lg:w-[55%] flex items-center justify-center p-8 bg-[#f8f9fc] overflow-y-auto">
            <div class="w-full max-w-md bg-white p-10 rounded-[2.5rem] shadow-xl shadow-indigo-100/50 border border-gray-50 my-10">
                <div class="mb-8 text-center">
                    <h2 class="text-3xl font-800 text-gray-900 mb-2 tracking-tight font-heading">Create Account</h2>
                    <p class="text-[10px] font-black text-gray-400 uppercase tracking-[0.2em]">Start your professional journey today</p>
                </div>

                <div id="responseAlert" class="hidden mb-6 p-4 rounded-2xl text-[10px] font-bold uppercase tracking-widest flex items-center gap-3 border">
                    <span id="alertIcon" class="material-icons-round text-sm"></span>
                    <span id="alertMessage"></span>
                </div>

                <form id="registerForm" class="space-y-5" novalidate>
                    <div class="space-y-1.5">
                        <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest ml-1">Full Name</label>
                        <div class="relative group">
                            <span class="material-icons-round absolute left-5 top-1/2 -translate-y-1/2 text-gray-300 group-focus-within:text-primary transition-colors">person</span>
                            <input type="text" id="name" name="name" placeholder="Name" required
                                class="w-full pl-14 pr-5 py-4 bg-gray-50 border-none rounded-2xl focus:ring-4 focus:ring-primary/5 transition-all outline-none font-medium text-gray-700">
                            <span id="nameError" class="validation-msg invalid-feedback">Please enter your full name</span>
                        </div>
                    </div>

                    <div class="space-y-1.5">
                        <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest ml-1">Work Email</label>
                        <div class="relative group">
                            <span class="material-icons-round absolute left-5 top-1/2 -translate-y-1/2 text-gray-300 group-focus-within:text-primary transition-colors">alternate_email</span>
                            <input type="email" name="email" id="email" placeholder="Email" required
                                class="w-full pl-14 pr-5 py-4 bg-gray-50 border-none rounded-2xl focus:ring-4 focus:ring-primary/5 transition-all outline-none font-medium text-gray-700">
                            <span id="emailError" class="validation-msg invalid-feedback">Enter a valid work email address</span>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div class="space-y-1.5">
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest ml-1">Set Password</label>
                            <input id="password" type="password" name="password" placeholder="••••••••" required
                                class="w-full px-5 py-4 bg-gray-50 border-none rounded-2xl focus:ring-4 focus:ring-primary/5 transition-all outline-none font-medium text-gray-700">
                            <span id="passError" class="validation-msg invalid-feedback">Min. 6 characters</span>
                        </div>
                        <div class="space-y-1.5">
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest ml-1">Confirm</label>
                            <input id="confirmPassword" type="password" placeholder="••••••••" required
                                class="w-full px-5 py-4 bg-gray-50 border-none rounded-2xl focus:ring-4 focus:ring-primary/5 transition-all outline-none font-medium text-gray-700">
                            <span id="cnfPassError" class="validation-msg invalid-feedback">Passwords mismatch</span>
                        </div>
                    </div>

                    <button type="submit" id="submitBtn"
                        class="w-full bg-primary hover:bg-primary-dark text-white font-bold py-5 rounded-2xl shadow-xl shadow-indigo-200 transition-all active:scale-[0.98] flex justify-center items-center gap-3 mt-4">
                        <span id="btnText" class="uppercase tracking-[0.2em] text-xs">Create Account</span>
                        <div id="btnSpinner" class="spinner"></div>
                    </button>
                </form>

                <div class="mt-8 pt-6 border-t border-gray-50 text-center">
                    <p class="text-gray-400 text-[11px] font-bold uppercase tracking-widest">
                        Already part of PathPilot? 
                        <a href="<%=request.getContextPath()%>/login" class="text-primary hover:underline ml-1">Log in here</a>
                    </p>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Input elements
            const nameEl = document.getElementById('name');
            const emailEl = document.getElementById('email');
            const passEl = document.getElementById('password');
            const cnfPassEl = document.getElementById('confirmPassword');

            // Reset validation states
            [nameEl, emailEl, passEl, cnfPassEl].forEach(el => {
                el.classList.remove('is-invalid');
                const errorSpan = document.getElementById(el.id + 'Error');
                if(errorSpan) errorSpan.style.display = 'none';
            });

            let isValid = true;

            // Name Validation
            if (nameEl.value.trim().length < 2) {
                showFieldError(nameEl, 'nameError');
                isValid = false;
            }

            // Email Validation
            if (!emailEl.value.includes('@') || emailEl.value.length < 5) {
                showFieldError(emailEl, 'emailError');
                isValid = false;
            }

            // Password length check
            if (passEl.value.length < 6) {
                showFieldError(passEl, 'passError');
                isValid = false;
            }

            // Confirm Password Check
            if (passEl.value !== cnfPassEl.value) {
                showFieldError(cnfPassEl, 'cnfPassError');
                isValid = false;
            }

            if (!isValid) return;

            // Logic Part (AJAX)
            const btn = document.getElementById('submitBtn');
            const spinner = document.getElementById('btnSpinner');
            const btnText = document.getElementById('btnText');
            const alertBox = document.getElementById('responseAlert');

            btn.disabled = true;
            spinner.style.display = 'block';
            btnText.innerText = 'PROCESSING';
            alertBox.classList.add('hidden');

            const formData = new URLSearchParams(new FormData(this));

            fetch('<%=request.getContextPath()%>/register', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData
            })
            .then(response => response.text())
            .then(text => {
                if (text === "OTP_SENT") {
                    showAlert("Welcome aboard! OTP sent to your email.", "success");
                    setTimeout(() => window.location.href = '<%=request.getContextPath()%>/verify-register', 3000);
                } else if (text === "SUCCESS") {
                    showAlert("Verification email sent. Please login.", "success");
                    setTimeout(() => window.location.href = '<%=request.getContextPath()%>/login', 3000);
                } else {
                    throw new Error(text || "REGISTRATION FAILED");
                }
            })
            .catch(error => {
                btn.disabled = false;
                spinner.style.display = 'none';
                btnText.innerText = 'INITIALIZE ACCOUNT';
                showAlert(error.message, "error");
            });
        });

        function showFieldError(input, spanId) {
            input.classList.add('is-invalid');
            document.getElementById(spanId).style.display = 'block';
        }

        function showAlert(message, type) {
            const alertBox = document.getElementById('responseAlert');
            const alertMsg = document.getElementById('alertMessage');
            const alertIcon = document.getElementById('alertIcon');

            alertBox.classList.remove('hidden', 'bg-red-50', 'text-red-600', 'border-red-100', 'bg-green-50', 'text-green-600', 'border-green-100');
            
            if (type === "error") {
                alertBox.classList.add('bg-red-50', 'text-red-600', 'border-red-100');
                alertIcon.innerText = "gpp_bad";
            } else {
                alertBox.classList.add('bg-green-50', 'text-green-600', 'border-green-100');
                alertIcon.innerText = "verified_user";
            }
            
            alertMsg.innerText = message;
            alertBox.classList.remove('hidden');
        }
    </script>
</body>
</html>