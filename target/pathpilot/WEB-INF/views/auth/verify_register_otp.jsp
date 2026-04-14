<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if(session.getAttribute("verifyEmail") == null){
        response.sendRedirect(request.getContextPath() + "/register");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>Verify Registration | PathPilot</title>

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

<h2 class="text-3xl text-center mb-2 font-bold text-gray-900">Verify Registration</h2>
<p class="text-center text-sm text-gray-400 mb-8">Enter the OTP sent to your email</p>

<form id="otpForm" class="space-y-6" novalidate>
    <div class="space-y-2">
        <input id="otp" name="otp" type="text" maxlength="6" inputmode="numeric" placeholder="000000" required
            class="w-full p-4 bg-gray-50 rounded-xl text-center text-3xl font-bold tracking-widest border-2 border-gray-200 focus:border-primary focus:outline-none transition">
        <span class="invalid-feedback block text-sm text-red-500">Please enter a valid 6-digit OTP</span>
    </div>

    <button type="submit" id="submitBtn"
        class="w-full bg-primary hover:bg-primary-dark text-white font-bold py-4 rounded-xl flex justify-center items-center gap-3 transition active:scale-[0.98]">
        <span id="btnText">Verify & Continue</span>
        <div id="btnSpinner" class="spinner"></div>
    </button>
</form>

</div>

<script>
// Get form elements
const otpForm = document.getElementById('otpForm');
const otpInput = document.getElementById('otp');
const submitBtn = document.getElementById('submitBtn');
const spinner = document.getElementById('btnSpinner');
const container = document.getElementById('verifyContainer');

const endpoint = '<%=request.getContextPath()%>/verify-register-otp';

console.log('OTP Form found:', !!otpForm);
console.log('OTP Input found:', !!otpInput);
console.log('Container found:', !!container);
console.log('Endpoint:', endpoint);

if(!otpForm || !otpInput || !submitBtn || !container) {
    console.error('Required form elements not found!');
    alert('Form elements missing. Please refresh the page.');
} else {
    otpForm.addEventListener('submit', function(e) {
        e.preventDefault();
        
        const otp = otpInput.value.trim();
        
        console.log('OTP submitted:', otp);
        
        // Validation
        if(otp.length !== 6 || isNaN(otp)) {
            otpInput.classList.add('is-invalid');
            container.classList.add('shake');
            setTimeout(() => container.classList.remove('shake'), 400);
            return;
        }
        
        otpInput.classList.remove('is-invalid');
        submitBtn.disabled = true;
        spinner.style.display = 'block';
        
        const formData = new URLSearchParams();
        formData.append('otp', otp);
        
        console.log('Sending to:', endpoint);
        
        fetch(endpoint, {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: formData
        })
        .then(res => res.text())
        .then(data => {
            console.log('Response received:', data);
            data = data.trim();
            
            if(data === "SUCCESS") {
                console.log('✅ Verification successful!');
                container.innerHTML = '<div style="text-align:center;padding:40px"><span class="material-icons-round" style="font-size:80px;color:#10b981;display:block;margin-bottom:20px">check_circle</span><h2 style="font-size:28px;font-weight:bold;color:#0f172a;margin-bottom:10px">Registration Verified!</h2><p style="color:#666;margin-bottom:30px;font-size:14px">Your account is ready. Redirecting to login...</p></div>';
                setTimeout(() => {
                    window.location.href = '<%=request.getContextPath()%>/login';
                }, 2000);
            } else {
                console.log('❌ Verification failed. Response:', data);
                otpInput.classList.add('is-invalid');
                container.classList.add('shake');
                setTimeout(() => container.classList.remove('shake'), 400);
                submitBtn.disabled = false;
                spinner.style.display = 'none';
            }
        })
        .catch(err => {
            console.error('Fetch error:', err);
            submitBtn.disabled = false;
            spinner.style.display = 'none';
            otpInput.classList.add('is-invalid');
        });
    });
}
</script>

</body>
</html>