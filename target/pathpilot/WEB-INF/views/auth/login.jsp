<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Sign In | PathPilot</title>

    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet"/>

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: { 'primary': '#4913ec', 'primary-dark': '#3a0fb5' },
                    fontFamily: { 'sans': ["'Plus Jakarta Sans'", 'sans-serif'], 'heading': ['Poppins', 'sans-serif'] }
                }
            }
        }
    </script>

    <style>
        body { font-family: 'Plus Jakarta Sans', sans-serif; background-color: #f8f9fc; }
        .hero-indigo { background: linear-gradient(135deg, #4913ec 0%, #6366f1 100%); }
        
        /* ✅ Autocomplete Background Fix (Prevents yellow/blue autofill color) */
        input:-webkit-autofill,
        input:-webkit-autofill:hover, 
        input:-webkit-autofill:focus {
            -webkit-box-shadow: 0 0 0px 1000px #f9fafb inset !important;
            -webkit-text-fill-color: #111827 !important;
            transition: background-color 5000s ease-in-out 0s;
        }

        .is-valid { border: 2px solid #10b981 !important; background-color: #f0fdf4 !important; }
        .is-invalid { border: 2px solid #ef4444 !important; background-color: #fef2f2 !important; }
        
        .valid-feedback, .invalid-feedback { display: none; font-size: 10px; font-weight: 700; text-transform: uppercase; margin-top: 4px; margin-left: 4px; }
        .valid-feedback { color: #10b981; }
        .invalid-feedback { color: #ef4444; }

        .is-valid ~ .valid-feedback { display: block; }
        .is-invalid ~ .invalid-feedback { display: block; }

        @keyframes shake { 0%, 100% { transform: translateX(0); } 25% { transform: translateX(-5px); } 75% { transform: translateX(5px); } }
        .shake { animation: shake 0.4s ease-in-out; }
        .spinner { border: 2px solid rgba(255, 255, 255, 0.3); border-radius: 50%; border-top: 2px solid #fff; width: 18px; height: 18px; animation: spin 0.8s linear infinite; display: none; }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
    </style>
</head>

<body class="antialiased overflow-hidden text-gray-900">

    <a href="<%=request.getContextPath()%>/guest/home"
       class="absolute top-8 left-8 z-50 flex items-center space-x-2 bg-white border border-gray-100 px-5 py-2.5 rounded-2xl shadow-sm hover:shadow-md transition-all active:scale-95 group">
        <span class="material-icons-round text-gray-400 group-hover:text-primary transition-colors">arrow_back</span>
        <span class="text-[10px] font-black uppercase tracking-widest text-gray-700">Back to Home</span>
    </a>

    <div class="flex h-screen overflow-hidden">
        <div class="hidden lg:flex lg:w-[45%] hero-indigo p-20 flex-col justify-between text-white relative overflow-hidden">
            <div class="absolute -top-20 -left-20 w-64 h-64 bg-white/10 rounded-full blur-3xl"></div>
            <div class="absolute -bottom-20 -right-20 w-80 h-80 bg-indigo-400/20 rounded-full blur-3xl"></div>
            <div class="relative z-10">
                <div class="flex items-center space-x-3 mb-16">
                    <div class="w-12 h-12 bg-white/20 rounded-2xl flex items-center justify-center backdrop-blur-xl border border-white/30"><span class="material-icons-round text-2xl text-white">rocket_launch</span></div>
                    <span class="text-xl font-800 tracking-[0.2em] text-white uppercase">PathPilot</span>
                </div>
                <h1 class="text-6xl font-800 leading-tight mb-6 tracking-tighter font-heading">Design Your <br/><span class="text-white/60">Future</span> Career.</h1>
            </div>
        </div>

        <div class="w-full lg:w-[55%] flex items-center justify-center p-8 bg-[#f8f9fc] relative">
            <div id="loginContainer" class="w-full max-w-md bg-white p-12 rounded-[2.5rem] shadow-xl shadow-indigo-100/50 border border-gray-50 relative z-10 transition-all duration-300">
                <div class="mb-10 text-center">
                    <h2 class="text-3xl font-800 text-gray-900 mb-2 tracking-tight font-heading">Identity Verification</h2>
                    <p class="text-[10px] font-black text-gray-400 uppercase tracking-[0.2em]">Enter Credentials to Access</p>
                </div>

                <div id="responseAlert" class="hidden mb-8 p-5 rounded-2xl text-[10px] font-bold uppercase tracking-widest flex items-center gap-4 border border-red-100 bg-red-50 text-red-600 animate-bounce">
                    <span class="material-icons-round text-sm">gpp_bad</span>
                    <span>Invalid email or password. Please try again.</span>
                </div>

                <form id="loginForm" class="space-y-6" autocomplete="on" novalidate>
                    <div>
                        <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest ml-1">Email Address</label>
                        <div class="relative group mt-1">
                            <span class="material-icons-round absolute left-5 top-1/2 -translate-y-1/2 text-gray-300 group-focus-within:text-primary transition-colors">alternate_email</span>
                            <input id="email" type="email" name="email" placeholder="Enter Your E-mail" autocomplete="email"
                                class="w-full pl-14 pr-5 py-4.5 bg-gray-50 border-none rounded-2xl focus:ring-4 focus:ring-primary/5 transition-all outline-none font-medium">
                            <span class="valid-feedback">Format accepted!</span>
                            <span class="invalid-feedback">Please enter a valid work email.</span>
                        </div>
                    </div>

                    <div>
                        <div class="flex justify-between items-center ml-1">
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest">Access Key</label>
                            <a href="<%=request.getContextPath()%>/forget-password" class="text-[10px] font-black text-primary tracking-widest hover:underline uppercase">Forgot?</a>
                        </div>
                        <div class="relative group mt-1">
                            <span class="material-icons-round absolute left-5 top-1/2 -translate-y-1/2 text-gray-300 group-focus-within:text-primary transition-colors">lock_open</span>
                            <input id="password" type="password" name="password" placeholder="••••••••••••" autocomplete="current-password"
                                class="w-full pl-14 pr-14 py-4.5 bg-gray-50 border-none rounded-2xl focus:ring-4 focus:ring-primary/5 transition-all outline-none font-medium">
                            <button type="button" onclick="togglePassword()" class="absolute right-5 top-1/2 -translate-y-1/2 text-gray-300 hover:text-primary transition-colors">
                                <span id="eyeIcon" class="material-icons-round text-xl">visibility</span>
                            </button>
                            <span class="valid-feedback">Key format accepted!</span>
                            <span class="invalid-feedback">Security key is required.</span>
                        </div>
                    </div>

                    <button type="submit" id="submitBtn"
                        class="w-full bg-primary hover:bg-primary-dark text-white font-bold py-5 rounded-2xl shadow-xl shadow-indigo-200 transition-all active:scale-[0.98] flex justify-center items-center gap-3">
                        <span id="btnText" class="uppercase tracking-[0.2em] text-xs">Verify & Login</span>
                        <div id="btnSpinner" class="spinner"></div>
                    </button>
                </form>

                <div class="mt-10 pt-8 border-t border-gray-50 text-center font-bold text-[11px] uppercase tracking-widest text-gray-400">
                    New to PathPilot? <a href="<%=request.getContextPath()%>/register" class="text-primary hover:underline ml-1">Create Account</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        window.addEventListener("load", function () {
            if (sessionStorage.getItem("loginError") === "true") {
                document.getElementById('responseAlert').classList.remove('hidden');
                const container = document.getElementById('loginContainer');
                container.classList.add('shake');
                setTimeout(() => container.classList.remove('shake'), 400);
                sessionStorage.removeItem("loginError");
            }
        });

        document.getElementById('loginForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const email = document.getElementById('email');
            const password = document.getElementById('password');
            const container = document.getElementById('loginContainer');
            const btn = document.getElementById('submitBtn');
            const spinner = document.getElementById('btnSpinner');

            email.classList.remove('is-valid', 'is-invalid');
            password.classList.remove('is-valid', 'is-invalid');

            let isValid = true;
            if(!email.value.trim() || !email.value.includes('@')) {
                email.classList.add('is-invalid');
                isValid = false;
            }
            if(!password.value.trim()) {
                password.classList.add('is-invalid');
                isValid = false;
            }

            if(!isValid) {
                container.classList.add('shake');
                setTimeout(() => container.classList.remove('shake'), 400);
                return;
            }

            btn.disabled = true;
            spinner.style.display = 'block';
            document.getElementById('btnText').innerText = 'VERIFYING';

            fetch('<%=request.getContextPath()%>/login', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams(new FormData(this))
            })
            .then(res => res.text())
            .then(data => {
                console.log("📡 Raw login response:", JSON.stringify(data));
                console.log("📡 Response length:", data.length);
                
                // Trim whitespace and remove quotes
                let response = (data || "").trim();
                console.log("✅ Trimmed (before quote removal):", response);
                
                // Remove surrounding quotes if present
                if (response.startsWith('"') && response.endsWith('"')) {
                    response = response.slice(1, -1);
                    console.log("✅ Removed quotes, now:", response);
                }
                
                if (response === "INVALID") {
                    console.log("❌ Invalid credentials");
                    sessionStorage.setItem("loginError", "true");
                    location.reload();
                } else if (response === "ERROR") {
                    console.log("❌ System error");
                    alert("System error. Please try again.");
                    btn.disabled = false;
                    spinner.style.display = 'none';
                    document.getElementById('btnText').innerText = 'VERIFY & LOGIN';
                } else if (response.startsWith("/")) {
                    // Successful login - redirect to role-based page
                    console.log("✅ Login successful, redirecting to:", response);
                    const redirectUrl = '<%=request.getContextPath()%>' + response;
                    console.log("🔄 Final redirect URL:", redirectUrl);
                    window.location.href = redirectUrl;
                } else {
                    console.error("⚠️ Unexpected response:", response);
                    console.error("Response starts with:", response.charAt(0), " (code:", response.charCodeAt(0), ")");
                    btn.disabled = false;
                    spinner.style.display = 'none';
                    document.getElementById('btnText').innerText = 'VERIFY & LOGIN';
                }
            })
            .catch(error => {
                console.error("❌ Fetch error:", error);
                btn.disabled = false;
                spinner.style.display = 'none';
                document.getElementById('btnText').innerText = 'VERIFY & LOGIN';
                container.classList.add('shake');
                setTimeout(() => container.classList.remove('shake'), 400);
            });
        });

        function togglePassword() {
            const p = document.getElementById("password");
            const e = document.getElementById("eyeIcon");
            p.type = (p.type === "password") ? "text" : "password";
            e.innerText = (p.type === "password") ? "visibility" : "visibility_off";
        }
    </script>
</body>
</html>