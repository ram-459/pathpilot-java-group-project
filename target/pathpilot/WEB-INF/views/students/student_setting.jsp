<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    // 🔐 CACHE CONTROL: Purani images ya data ko refresh karne ke liye
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // 🔐 SESSION GUARD: Bina login ke access block
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
    <title>Edit Profile - PathPilot</title>

    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Poppins:wght@600;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet"/>
    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: { 
                        primary: "#4913ec",
                        "primary-dark": "#3a0fb5",
                        "bg-main": "#f8f9fc"
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
        .input-field { 
            @apply w-full bg-gray-50 border border-transparent rounded-2xl px-5 py-4 focus:ring-2 
            focus:ring-primary/20 focus:bg-white transition-all outline-none font-medium text-sm; 
        }
        .error-msg { @apply text-[10px] text-red-500 font-bold mt-1 ml-2 hidden uppercase tracking-wider; }
        .input-error { @apply border-red-500 bg-red-50/30; }
    </style>
</head>

<body class="bg-bg-main min-h-screen flex antialiased overflow-x-hidden">

    <jsp:include page="/WEB-INF/views/components/user_sidebar.jsp"/>

    <main class="flex-grow p-6 lg:p-10 overflow-y-auto">
        
        <%-- Top Identity Card --%>
        <div class="max-w-4xl mx-auto bg-white rounded-[2rem] p-8 border border-gray-100 shadow-sm flex flex-col md:flex-row items-center justify-between mb-8">
            <div class="flex items-center gap-6">
                <%-- Top Identity Card: Image Source Fixed --%>
<%
    String profilePic = (String) session.getAttribute("profilePic");
    String imgSrc = request.getContextPath() + "/assets/images/default-avatar.png";
    if (profilePic != null && !profilePic.isEmpty()) {
        String filename = profilePic.substring(profilePic.lastIndexOf('/') + 1);
        imgSrc = request.getContextPath() + "/student/file/" + filename;
    }
%>
<div class="relative group">
    <img id="profilePreview" 
         src="<%= imgSrc %>"
         class="w-24 h-24 rounded-3xl object-cover border-4 border-indigo-50 shadow-inner transition-transform group-hover:scale-105">
    
    <label for="imageInput" class="absolute -bottom-2 -right-2 bg-primary p-2.5 rounded-xl shadow-xl cursor-pointer hover:bg-primary-dark transition-all border-2 border-white">
        <span class="material-icons-round text-white text-sm">photo_camera</span>
        <input type="file" id="imageInput" name="profileImage" form="profileForm" class="hidden" accept="image/*" onchange="previewImage(this)">
    </label>
</div>    

                <div>
                    <h2 class="text-2xl font-800 text-gray-900 tracking-tight">${sessionScope.userName}</h2>
                    <div class="flex flex-wrap items-center gap-4 mt-2 text-[10px] font-black uppercase tracking-widest text-gray-400">
                        <span class="flex items-center gap-1.5 bg-gray-50 px-3 py-1.5 rounded-lg border border-gray-100">
                            <span class="material-icons-round text-sm text-primary">verified_user</span> 
                            ${sessionScope.role}
                        </span>
                        <span class="flex items-center gap-1.5">
                            <span class="material-icons-round text-sm">alternate_email</span> 
                            ${sessionScope.userEmail}
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <div class="max-w-4xl mx-auto">
            <form id="profileForm" action="<%=request.getContextPath()%>/student/update-profile" method="POST" enctype="multipart/form-data" class="space-y-8">
                
                <%-- Section 1: Personal --%>
                <div class="bg-white p-10 rounded-[2.5rem] shadow-sm border border-gray-100">
                    <h2 class="text-xl font-800 text-gray-900 mb-8 flex items-center gap-3">
                        <span class="w-10 h-10 rounded-2xl bg-indigo-50 text-primary flex items-center justify-center">
                            <span class="material-icons-round text-base">badge</span>
                        </span>
                        Legal Identity
                    </h2>

                    <div class="grid md:grid-cols-2 gap-8">
                        <div class="space-y-2">
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block ml-1">Full Name</label>
                            <input type="text" id="fullName" name="fullName" value="${sessionScope.userName}" class="input-field">
                            <span id="nameError" class="error-msg">Name is too short (min 3 chars)</span>
                        </div>
                        <div class="space-y-2">
                            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block ml-1">Account Email</label>
                            <input type="email" value="${sessionScope.userEmail}" class="input-field bg-gray-100 cursor-not-allowed opacity-70" readonly>
                        </div>
                    </div>
                </div>

                <%-- Section 2: Security --%>
                <%-- Updated Security Section with Current Password Field --%>
<div class="bg-white p-10 rounded-[2.5rem] shadow-sm border border-gray-100">
    <h2 class="text-xl font-800 text-gray-900 mb-8 flex items-center gap-3">
        <span class="w-10 h-10 rounded-2xl bg-red-50 text-red-500 flex items-center justify-center">
            <span class="material-icons-round text-base">lock</span>
        </span>
        Security Protocol
    </h2>
    <div class="grid md:grid-cols-2 gap-8">
        <div class="md:col-span-2 space-y-2">
            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block ml-1">Current Password</label>
            <input type="password" id="oldPass" name="oldPassword" placeholder="Required only if changing password" class="input-field">
            <span id="oldPassError" class="error-msg">Current password is required to make changes</span>
        </div>
        
        <div class="space-y-2">
            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block ml-1">New Password</label>
            <input type="password" id="newPass" name="newPassword" placeholder="Min 6 characters" class="input-field">
            <span id="passError" class="error-msg">Min 6 characters required</span>
        </div>
        <div class="space-y-2">
            <label class="text-[10px] font-black uppercase text-gray-400 tracking-widest block ml-1">Verify New Password</label>
            <input type="password" id="confirmPass" placeholder="Repeat new password" class="input-field">
            <span id="confirmError" class="error-msg">Mismatch detected</span>
        </div>
    </div>
</div>

                <%-- Action Bar --%>
                <div class="flex flex-col sm:flex-row justify-end gap-4 pt-4 pb-20">
                    <button type="button" onclick="confirmDiscard()"
                            class="px-8 py-4 rounded-2xl border border-gray-200 text-gray-400 hover:text-red-500 hover:bg-red-50 font-bold transition-all active:scale-95 uppercase tracking-widest text-[10px]">
                        Discard
                    </button>
                    <button type="submit"
                            class="px-12 py-4 bg-primary hover:bg-primary-dark text-white font-bold rounded-2xl shadow-xl shadow-primary/20 transition-all active:scale-95 uppercase tracking-widest text-[10px] flex items-center gap-2">
                        <span class="material-icons-round text-sm">check_circle</span>
                        Sync Configuration
                    </button>
                </div>
            </form>
        </div>
    </main>


<script>
    // 🖼️ Real-time Profile Image Preview
    function previewImage(input) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = e => {
                document.getElementById('profilePreview').src = e.target.result;
            };
            reader.readAsDataURL(input.files[0]);
        }
    }

    // 🚀 URL se Errors detect karna (Backend Validation)
    window.addEventListener('DOMContentLoaded', () => {
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.has('error') && urlParams.get('error') === 'wrong_password') {
            Swal.fire({
                title: 'Security Breach!',
                text: 'The current password you entered is incorrect. Identity verification failed.',
                icon: 'error',
                confirmButtonColor: '#4913ec'
            });
        }
        if (urlParams.has('success')) {
            Swal.fire({
                title: 'Profile Synced!',
                text: 'Your configuration has been updated successfully.',
                icon: 'success',
                timer: 2000,
                showConfirmButton: false
            });
        }
    });

    // 🛡️ Final Submission & Validation Logic
    const form = document.getElementById('profileForm');
    
    form.addEventListener('submit', function(e) {
        e.preventDefault();
        let valid = true;

        // Elements
        const name = document.getElementById('fullName');
        const oldPass = document.getElementById('oldPass'); // Current Password
        const newPass = document.getElementById('newPass'); // New Password
        const confirmPass = document.getElementById('confirmPass'); // Confirm

        // Reset UI State
        [name, oldPass, newPass, confirmPass].forEach(el => {
            if(el) el.classList.remove('input-error');
        });
        document.querySelectorAll('.error-msg').forEach(el => el.classList.add('hidden'));

        // 1. Full Name Validation
        if(name.value.trim().length < 3) {
            showError('fullName', 'nameError');
            valid = false;
        }

        // 2. Password Change Logic
        // Agar new password field bhari hai, toh validation trigger hoga
        if(newPass.value.length > 0) {
            
            // Check if Current Password is empty
            if(oldPass.value.trim() === "") {
                showError('oldPass', 'oldPassError');
                valid = false;
            }

            // Check New Password Strength
            if(newPass.value.length < 6) {
                showError('newPass', 'passError');
                valid = false;
            }

            // Check Mismatch
            if(newPass.value !== confirmPass.value) {
                showError('confirmPass', 'confirmError');
                valid = false;
            }
        }

        // 3. Final Execution
        if(valid) {
            Swal.fire({
                title: 'Syncing Credentials...',
                text: 'Verifying with PathPilot Database',
                icon: 'info',
                allowOutsideClick: false,
                showConfirmButton: false,
                didOpen: () => Swal.showLoading()
            });
            
            // Submit the form physically
            setTimeout(() => { this.submit(); }, 800);
        }
    });

    // Helper: Show Error
    function showError(inputId, spanId) {
        const input = document.getElementById(inputId);
        const span = document.getElementById(spanId);
        if(input) input.classList.add('input-error');
        if(span) span.classList.remove('hidden');
    }

    // 🗑️ Discard Changes Logic
    function confirmDiscard() {
        Swal.fire({
            title: 'Discard Changes?',
            text: "Modifications will be permanently reverted.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#ef4444',
            cancelButtonColor: '#gray-300',
            confirmButtonText: 'Yes, Discard'
        }).then(res => {
            if(res.isConfirmed) {
                location.reload();
            }
        });
    }
</script>

</body>
</html>