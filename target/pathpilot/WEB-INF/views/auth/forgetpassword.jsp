<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Forget Password | PathPilot</title>

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
        .is-invalid { border: 2px solid #ef4444 !important; background-color: #fef2f2 !important; }
        .invalid-feedback { font-size:10px; color:#ef4444; font-weight:bold; text-transform:uppercase; margin-top:4px; margin-left:4px; display:none; }
        .is-invalid ~ .invalid-feedback { display:block; }

        @keyframes shake {
            0%,100%{transform:translateX(0);}
            25%{transform:translateX(-5px);}
            75%{transform:translateX(5px);}
        }
        .shake{animation:shake 0.4s ease-in-out;}

        .spinner {
            border:2px solid rgba(255,255,255,0.3);
            border-radius:50%;
            border-top:2px solid #fff;
            width:18px;height:18px;
            animation:spin 0.8s linear infinite;
            display:none;
        }
        @keyframes spin {0%{transform:rotate(0)}100%{transform:rotate(360deg)}}
    </style>
</head>

<body class="antialiased flex items-center justify-center min-h-screen p-6">

<div id="forgetContainer" class="w-full max-w-md bg-white p-12 rounded-[2.5rem] shadow-xl border relative">

<a href="<%=request.getContextPath()%>/login" class="absolute top-8 left-8 text-gray-400 hover:text-primary">
<span class="material-icons-round">arrow_back</span>
</a>

<div class="mb-10 text-center">
<div class="w-16 h-16 bg-indigo-50 text-primary rounded-2xl flex items-center justify-center mx-auto mb-6">
<span class="material-icons-round text-3xl">lock_reset</span>
</div>
<h2 class="text-3xl font-800">Recovery Mode</h2>
</div>

<div id="responseAlert" class="hidden mb-8 p-5 rounded-2xl text-red-600 bg-red-50">
This email is not registered with PathPilot.
</div>

<form id="forgetForm" class="space-y-6" novalidate>

<div>
<input id="email" type="email" name="email" placeholder="ram@pathpilot.io"
class="w-full p-4 bg-gray-50 rounded-xl">

<span class="invalid-feedback">Please enter a valid registered email</span>
</div>

<button type="submit" id="submitBtn"
class="w-full bg-primary text-white py-4 rounded-xl flex justify-center items-center gap-2">
<span id="btnText">Send Recovery Code</span>
<div id="btnSpinner" class="spinner"></div>
</button>

</form>

</div>

<script>
document.getElementById('forgetForm').addEventListener('submit', function(e) {
    e.preventDefault();

    const email = document.getElementById('email');
    const container = document.getElementById('forgetContainer');
    const btn = document.getElementById('submitBtn');
    const spinner = document.getElementById('btnSpinner');

    email.classList.remove('is-invalid');

    // format check
    if(!email.value.trim() || !email.value.includes('@')) {
        email.classList.add('is-invalid');
        container.classList.add('shake');
        setTimeout(() => container.classList.remove('shake'), 400);
        return;
    }

    btn.disabled = true;
    spinner.style.display = 'block';
    document.getElementById('btnText').innerText = 'SENDING';

    fetch('<%=request.getContextPath()%>/forget-password', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams(new FormData(this))
    })
    .then(res => res.text())
    .then(data => {

        if (data === "SUCCESS") {
            window.location.href = '<%=request.getContextPath()%>/otp';
        } 
        else if (data === "NOT_FOUND") {
            // 🔥 MAIN FIX
            email.classList.add('is-invalid');

            container.classList.add('shake');
            setTimeout(() => container.classList.remove('shake'), 400);

            btn.disabled = false;
            spinner.style.display = 'none';
            document.getElementById('btnText').innerText = 'SEND RECOVERY CODE';
        } 
        else {
            alert("System error");
            btn.disabled = false;
            spinner.style.display = 'none';
            document.getElementById('btnText').innerText = 'SEND RECOVERY CODE';
        }

    })
    .catch(() => {
        btn.disabled = false;
        spinner.style.display = 'none';
        document.getElementById('btnText').innerText = 'SEND RECOVERY CODE';
        container.classList.add('shake');
    });
});
</script>

</body>
</html>