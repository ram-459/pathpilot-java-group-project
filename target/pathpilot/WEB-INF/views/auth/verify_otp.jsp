<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if(session.getAttribute("resetEmail") == null){
        response.sendRedirect(request.getContextPath() + "/forget-password");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>Reset Password | PathPilot</title>

<script src="https://cdn.tailwindcss.com?plugins=forms"></script>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet"/>

<script>
tailwind.config = {
    theme: {
        extend: {
            colors: { 'primary': '#4913ec', 'primary-dark': '#3a0fb5' }
        }
    }
}
</script>

<style>
body { font-family: 'Plus Jakarta Sans', sans-serif; background-color: #f8f9fc; }

.is-valid { border:2px solid #10b981 !important; background:#f0fdf4; }
.is-invalid { border:2px solid #ef4444 !important; background:#fef2f2; }

.invalid-feedback { display:none; font-size:10px; font-weight:bold; margin-top:4px; color:#ef4444; }
.is-invalid ~ .invalid-feedback { display:block; }

.shake { animation:shake .4s; }
@keyframes shake {25%{transform:translateX(-5px);}75%{transform:translateX(5px);} }

.spinner {
    border:2px solid rgba(73, 19, 236, 0.2);
    border-top:2px solid #4913ec;
    border-radius:50%;
    width:18px;
    height:18px;
    animation:spin .8s linear infinite;
    display:none;
}
@keyframes spin {100%{transform:rotate(360deg)}}
</style>
</head>

<body class="flex items-center justify-center min-h-screen p-6">

<div id="verifyContainer" class="w-full max-w-md bg-white p-12 rounded-[2.5rem] shadow-xl">

<h2 class="text-3xl text-center mb-2 font-bold text-gray-900">Reset Password</h2>
<p class="text-center text-sm text-gray-400 mb-8">Enter the 6-digit code and your new password</p>

<!-- Form Error Alert -->
<div id="responseAlert" class="hidden mb-6 p-4 rounded-xl text-xs font-bold uppercase tracking-widest flex items-center justify-center gap-2 border border-red-100 bg-red-50 text-red-600">
    <span class="material-icons-round text-sm">error</span>
    <span>Invalid OTP. Please try again.</span>
</div>

<form id="otpForm" class="space-y-6" novalidate>
    <div class="space-y-2">
        <label class="text-xs font-bold text-gray-400 uppercase tracking-widest ml-1">Recovery Code</label>
        <input id="otp" name="otp" type="text" maxlength="6" inputmode="numeric" placeholder="000000" required
            class="w-full p-4 bg-gray-50 rounded-xl text-center text-3xl font-bold tracking-widest border-2 border-gray-200 focus:border-primary focus:outline-none transition">
        <span class="invalid-feedback block text-sm text-red-500">Please enter a valid 6-digit OTP</span>
    </div>

    <div class="space-y-2">
        <label class="text-xs font-bold text-gray-400 uppercase tracking-widest ml-1">New Password</label>
        <input id="password" name="password" type="password" placeholder="Enter new password" required
            class="w-full p-4 bg-gray-50 rounded-xl border-2 border-gray-200 focus:border-primary focus:outline-none transition">
        <span class="invalid-feedback block text-sm text-red-500">Password is required</span>
    </div>

    <button type="submit" id="submitBtn"
        class="w-full bg-primary hover:bg-primary-dark text-white font-bold py-4 rounded-xl flex justify-center items-center gap-3 transition active:scale-[0.98]">
        <span id="btnText">Reset Password</span>
        <div id="btnSpinner" class="spinner"></div>
    </button>
</form>

</div>

<script>
const otpForm = document.getElementById('otpForm');
const otpInput = document.getElementById('otp');
const passwordInput = document.getElementById('password');
const submitBtn = document.getElementById('submitBtn');
const spinner = document.getElementById('btnSpinner');
const container = document.getElementById('verifyContainer');
const responseAlert = document.getElementById('responseAlert');

const endpoint = '<%=request.getContextPath()%>/verify-otp';

otpForm.addEventListener('submit', function(e) {
    e.preventDefault();
    
    responseAlert.classList.add('hidden');
    otpInput.classList.remove('is-invalid');
    passwordInput.classList.remove('is-invalid');
    
    const otp = otpInput.value.trim();
    const password = passwordInput.value.trim();
    let isValid = true;
    
    if(otp.length !== 6 || isNaN(otp)) {
        otpInput.classList.add('is-invalid');
        isValid = false;
    }
    
    if(!password) {
        passwordInput.classList.add('is-invalid');
        isValid = false;
    }
    
    if(!isValid) {
        container.classList.add('shake');
        setTimeout(() => container.classList.remove('shake'), 400);
        return;
    }

    btnText.innerText = 'VERIFYING...';
    submitBtn.disabled = true;
    spinner.style.display = 'block';

    fetch(endpoint, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams(new FormData(this))
    })
    .then(res => res.text())
    .then(data => {
        if(data === "SUCCESS") {
            // Replace form with success message
            container.innerHTML = `
                <div class="text-center animate-fade-in py-8">
                    <div class="w-24 h-24 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-6">
                        <span class="material-icons-round text-6xl text-green-500">check_circle</span>
                    </div>
                    <h2 class="text-3xl font-bold text-gray-900 mb-2">Password Reset!</h2>
                    <p class="text-gray-500 mb-8">You can now login with your new password.</p>
                    <p class="text-sm font-bold text-primary animate-pulse">Redirecting to login...</p>
                </div>
            `;
            setTimeout(() => {
                window.location.href = '<%=request.getContextPath()%>/login';
            }, 2500);
        } else if(data === "INVALID_OTP") {
            responseAlert.classList.remove('hidden');
            otpInput.classList.add('is-invalid');
            container.classList.add('shake');
            setTimeout(() => container.classList.remove('shake'), 400);
            resetBtnState();
        } else {
            alert('An error occurred. Please try again.');
            resetBtnState();
        }
    })
    .catch(err => {
        console.error("Fetch error:", err);
        alert('Connection error. Please try again.');
        resetBtnState();
    });
});

function resetBtnState() {
    btnText.innerText = 'Reset Password';
    submitBtn.disabled = false;
    spinner.style.display = 'none';
}
</script>

</body>
</html>