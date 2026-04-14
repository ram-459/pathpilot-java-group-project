<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // 🔐 CACHE CONTROL
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // 🔐 ADMIN SESSION CHECK
    if(session == null || session.getAttribute("role") == null || 
       !"ADMIN".equals(session.getAttribute("role"))){
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - PathPilot</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet"/>
    
    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: "#4913ec",
                        "primary-dark": "#3a0fb5",
                        "bg-light": "#f8f9fc"
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
        
        .action-btn { @apply p-2.5 rounded-xl transition-all duration-200 shadow-sm active:scale-95; }
        .modal-input { @apply w-full bg-gray-50 border border-transparent rounded-2xl px-5 py-4 focus:ring-2 focus:ring-primary/20 transition-all outline-none font-medium text-sm; }
        .section-label { @apply text-[10px] font-black uppercase text-gray-400 tracking-widest block mb-1 ml-1; }
        
        /* Validation Styles */
        .input-error { @apply border-red-500 bg-red-50/50 focus:ring-red-200 !important; }
        .error-msg { @apply text-[9px] font-bold text-red-500 uppercase tracking-tight ml-2 mt-1.5 hidden; }
    </style>
</head>

<body class="bg-bg-light antialiased overflow-hidden">
    <div class="flex h-screen">
        <!-- ✅ SIDEBAR -->
        <jsp:include page="/WEB-INF/views/components/admin_sidebar.jsp" />

        <div class="flex-1 flex flex-col overflow-hidden">
            <!-- ✅ HEADER -->
            <header class="h-20 bg-white/80 backdrop-blur-md border-b border-gray-100 flex items-center justify-between px-12 sticky top-0 z-10">
                <div>
                    <nav class="text-[10px] font-black uppercase tracking-widest text-gray-400 mb-1 flex items-center">
                        <span>Admin</span>
                        <span class="material-icons-round text-xs mx-2">chevron_right</span>
                        <span class="text-primary font-bold">Manage Users</span>
                    </nav>
                    <h1 class="text-xl font-800 text-gray-900 tracking-tight">Identity Management</h1>
                </div>
            </header>

            <main class="flex-1 overflow-y-auto p-12">
                <div class="flex justify-between items-center mb-10">
                    <h1 class="text-2xl font-800 text-gray-900 tracking-tight">System Users</h1>
                    <button onclick="openAddModal()"
                       class="px-8 py-4 bg-primary text-white rounded-2xl font-bold text-sm shadow-xl shadow-primary/20 hover:bg-primary-dark transition-all active:scale-95 flex items-center gap-2">
                        <span class="material-icons-round text-base">person_add</span> Add New User
                    </button>
                </div>

                <!-- ✅ USER TABLE -->
                <div class="bg-white rounded-[2.5rem] border border-gray-100 shadow-sm overflow-hidden">
                    <table class="w-full text-sm">
                        <thead class="bg-gray-50/50 text-gray-400 border-b border-gray-50">
                            <tr>
                                <th class="px-8 py-6 text-left text-[10px] font-black uppercase tracking-widest">User Details</th>
                                <th class="px-8 py-6 text-left text-[10px] font-black uppercase tracking-widest">Role</th>
                                <th class="px-8 py-6 text-left text-[10px] font-black uppercase tracking-widest">Status</th>
                                <th class="px-8 py-6 text-center text-[10px] font-black uppercase tracking-widest">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-50">
                            <tr class="hover:bg-gray-50/50 transition-colors">
                                <td class="px-8 py-6 flex items-center gap-4">
                                    <div class="w-12 h-12 rounded-2xl bg-indigo-100 text-primary flex items-center justify-center font-bold">RS</div>
                                    <div>
                                        <p class="font-800 text-gray-900">Rahul Sharma</p>
                                        <p class="text-[10px] text-primary font-black uppercase tracking-widest">PP101 • rahul@gmail.com</p>
                                    </div>
                                </td>
                                <td class="px-8 py-6">
                                    <span class="px-3 py-1 bg-indigo-50 text-primary rounded-lg text-[9px] font-black uppercase tracking-widest w-fit">student</span>
                                </td>
                                <td class="px-8 py-6">
                                    <div class="flex items-center gap-2">
                                        <span class="w-2 h-2 bg-green-500 rounded-full animate-pulse"></span>
                                        <span class="text-[10px] font-black uppercase tracking-widest text-green-600">Active</span>
                                    </div>
                                </td>
                                <td class="px-8 py-6">
                                    <div class="flex justify-center gap-3">
                                        <button onclick="openView('Rahul Sharma','rahul@gmail.com','student','Active','PP101', 'MERN Stack', '+91 9876543210')" 
                                                class="action-btn bg-blue-50 text-blue-600 hover:bg-blue-100">
                                            <span class="material-icons-round text-lg">visibility</span>
                                        </button>
                                        <button onclick="openEdit('Rahul Sharma','rahul@gmail.com','student','Active','+91 9876543210')" 
                                                class="action-btn bg-indigo-50 text-primary hover:bg-indigo-100">
                                            <span class="material-icons-round text-lg">edit</span>
                                        </button>
                                        <button class="action-btn bg-red-50 text-red-600 hover:bg-red-100">
                                            <span class="material-icons-round text-lg">delete</span>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>
    </div>

    <!-- ✅ ADD USER MODAL -->
    <div id="addModal" class="fixed inset-0 bg-gray-900/40 backdrop-blur-sm hidden items-center justify-center z-50 p-4">
        <div class="bg-white w-full max-w-2xl rounded-[3rem] p-12 shadow-2xl border border-gray-100 animate-in zoom-in duration-300 max-h-[95vh] overflow-y-auto">
            <h2 class="text-2xl font-800 text-gray-900 mb-2 tracking-tight">Create New User</h2>
            <p class="text-gray-400 text-xs font-medium mb-10">Assign credentials and contact details directly.</p>
            
            <form id="addForm" novalidate>
                <div class="grid grid-cols-2 gap-x-6 gap-y-4">
                    <div class="col-span-2">
                        <label class="section-label">Full Name</label>
                        <input id="aName" type="text" placeholder="e.g. Rahul Sharma" class="modal-input" oninput="clearError('aName', 'aNameError')">
                        <span id="aNameError" class="error-msg">Please enter full name (min 3 chars)</span>
                    </div>
                    <div class="col-span-1">
                        <label class="section-label">Email Address</label>
                        <input id="aEmail" type="email" placeholder="email@example.com" class="modal-input" oninput="clearError('aEmail', 'aEmailError')">
                        <span id="aEmailError" class="error-msg">Valid email is required</span>
                    </div>
                    <div class="col-span-1">
                        <label class="section-label">Contact Number</label>
                        <input id="aPhone" type="text" placeholder="+91 00000 00000" class="modal-input" oninput="clearError('aPhone', 'aPhoneError')">
                        <span id="aPhoneError" class="error-msg">Enter 10-digit mobile number</span>
                    </div>
                    <div class="col-span-1">
                        <label class="section-label">Initial Password</label>
                        <input id="aPass" type="password" placeholder="••••••••" class="modal-input" oninput="clearError('aPass', 'aPassError')">
                        <span id="aPassError" class="error-msg">Password required (min 6 chars)</span>
                    </div>
                    <div class="col-span-1">
                        <label class="section-label">Assign Role</label>
                        <select id="aRole" class="modal-input cursor-pointer">
                            <option value="student">Student</option>
                            <option value="User">User</option>
                            <option value="Admin">Admin</option>
                        </select>
                    </div>
                </div>
                <div class="flex justify-end gap-4 mt-12">
                    <button type="button" onclick="closeAddModal()" class="px-8 py-3 rounded-2xl font-bold text-xs text-gray-400 uppercase tracking-widest">Cancel</button>
                    <button type="button" onclick="handleAddUser()" class="px-10 py-4 bg-primary text-white rounded-2xl font-bold text-sm shadow-xl shadow-primary/20 hover:bg-primary-dark transition-all">
                        Create Account
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- ✅ EDIT MODAL -->
    <div id="editModal" class="fixed inset-0 bg-gray-900/40 backdrop-blur-sm hidden items-center justify-center z-50 p-4">
        <div class="bg-white w-full max-w-2xl rounded-[3rem] p-12 shadow-2xl border border-gray-100 animate-in zoom-in duration-200 max-h-[95vh] overflow-y-auto">
            <h2 class="text-2xl font-800 text-gray-900 mb-2 tracking-tight text-primary">Override User Account</h2>
            <p class="text-gray-400 text-xs font-medium mb-10">Administrative direct access to change passwords and contact numbers.</p>
            
            <form id="editForm" novalidate>
                <div class="grid grid-cols-2 gap-x-6 gap-y-4">
                    <div class="col-span-2 bg-indigo-50/50 p-6 rounded-3xl border border-indigo-100 mb-2">
                        <div class="grid grid-cols-2 gap-4">
                            <div>
                                <label class="section-label">Full Name</label>
                                <input id="eName" type="text" class="modal-input border-white shadow-sm" oninput="clearError('eName', 'eNameError')">
                                <span id="eNameError" class="error-msg">Name is required</span>
                            </div>
                            <div>
                                <label class="section-label">Email (Read Only)</label>
                                <input id="eEmail" type="email" class="modal-input border-white shadow-sm opacity-60" readonly>
                            </div>
                        </div>
                    </div>

                    <div>
                        <label class="section-label text-red-500 font-black">Security Reset (New Password)</label>
                        <input id="ePass" type="password" placeholder="Leave blank to keep current" class="modal-input border-red-100 focus:ring-red-100" oninput="clearError('ePass', 'ePassError')">
                        <span id="ePassError" class="error-msg">Minimum 6 characters required</span>
                    </div>
                    <div>
                        <label class="section-label">Direct Contact Number</label>
                        <input id="ePhone" type="text" class="modal-input" oninput="clearError('ePhone', 'ePhoneError')">
                        <span id="ePhoneError" class="error-msg">Enter valid contact number</span>
                    </div>
                    <div>
                        <label class="section-label">System Role</label>
                        <select id="eRole" class="modal-input cursor-pointer">
                            <option value="student">student</option>
                            <option value="Learner">Learner</option>
                            <option value="Admin">Admin</option>
                        </select>
                    </div>
                    <div>
                        <label class="section-label">Account Status</label>
                        <select id="eStatus" class="modal-input cursor-pointer">
                            <option value="Active">Active</option>
                            <option value="Inactive">Inactive</option>
                            <option value="Banned">Banned</option>
                        </select>
                    </div>
                </div>
                <div class="flex justify-end gap-4 mt-12">
                    <button type="button" onclick="closeEdit()" class="px-8 py-3 rounded-2xl font-bold text-xs text-gray-400 uppercase tracking-widest">Cancel</button>
                    <button type="button" onclick="handleUpdate()" class="px-10 py-4 bg-primary text-white rounded-2xl font-bold text-sm shadow-xl shadow-primary/20 hover:bg-primary-dark transition-all">
                        Update Identity
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- ✅ VIEW MODAL (Logic Unchanged) -->
    <div id="viewModal" class="fixed inset-0 bg-gray-900/60 backdrop-blur-md hidden items-center justify-center z-50 p-4">
        <div class="bg-white w-full max-w-md rounded-[3rem] shadow-2xl overflow-hidden border border-gray-100 animate-in zoom-in duration-200">
            <div class="bg-primary p-10 text-white text-center">
                <div class="w-16 h-16 bg-white/20 rounded-2xl mx-auto mb-4 flex items-center justify-center backdrop-blur-md">
                    <span class="material-icons-round text-3xl text-white">person</span>
                </div>
                <h2 class="text-2xl font-800 tracking-tight">User Profile</h2>
                <p class="text-white/60 text-[10px] font-black uppercase tracking-widest mt-2" id="vNameHeader"></p>
            </div>
            <div class="p-10 space-y-6">
                <div class="grid grid-cols-1 gap-6">
                    <div>
                        <span class="section-label">Full Name & System ID</span>
                        <p class="font-800 text-gray-900"><span id="vName"></span> • <span id="vID" class="text-primary font-black"></span></p>
                    </div>
                    <div class="p-5 bg-gray-50 rounded-2xl border border-gray-100">
                        <span class="section-label">Confidential Contact Info</span>
                        <div class="space-y-2 mt-2">
                            <div class="flex items-center gap-3">
                                <span class="material-icons-round text-primary text-sm">alternate_email</span>
                                <span id="vEmail" class="font-700 text-gray-700 text-sm"></span>
                            </div>
                            <div class="flex items-center gap-3">
                                <span class="material-icons-round text-green-500 text-sm">call</span>
                                <span id="vPhoneView" class="font-900 text-gray-900 text-sm"></span>
                            </div>
                        </div>
                    </div>
                    <div>
                        <span class="section-label">Academic Path</span>
                        <span id="vCourse" class="text-[10px] font-black text-primary px-3 py-1 bg-indigo-50 rounded-lg uppercase inline-block mt-1"></span>
                    </div>
                </div>
                <button onclick="closeView()" class="w-full py-4 bg-gray-50 text-gray-400 rounded-2xl font-black text-[10px] uppercase tracking-widest hover:bg-gray-100 transition">Close Overlay</button>
            </div>
        </div>
    </div>

    <script>
        // ✅ UTILITY FUNCTIONS
        function showError(inputId, spanId) {
            document.getElementById(inputId).classList.add('input-error');
            document.getElementById(spanId).style.display = 'block';
        }

        function clearError(inputId, spanId) {
            document.getElementById(inputId).classList.remove('input-error');
            document.getElementById(spanId).style.display = 'none';
        }

        function resetFormErrors(formId) {
            const form = document.getElementById(formId);
            form.querySelectorAll('.modal-input').forEach(input => input.classList.remove('input-error'));
            form.querySelectorAll('.error-msg').forEach(span => span.style.display = 'none');
            form.reset();
        }

        // ✅ MODAL CONTROLS
        function openAddModal() {
            resetFormErrors('addForm');
            document.getElementById("addModal").classList.replace("hidden", "flex");
        }
        function closeAddModal() {
            document.getElementById("addModal").classList.replace("flex", "hidden");
        }

        function openEdit(name, email, role, status, phone) {
            resetFormErrors('editForm');
            document.getElementById("eName").value = name;
            document.getElementById("eEmail").value = email;
            document.getElementById("eRole").value = role;
            document.getElementById("eStatus").value = status;
            document.getElementById("ePhone").value = phone;
            document.getElementById("editModal").classList.replace("hidden", "flex");
        }
        function closeEdit() {
            document.getElementById("editModal").classList.replace("flex", "hidden");
        }

        function openView(name, email, role, status, id, course, phone) {
            document.getElementById("vNameHeader").innerText = "Displaying Record for " + id;
            document.getElementById("vName").innerText = name;
            document.getElementById("vEmail").innerText = email;
            document.getElementById("vID").innerText = id;
            document.getElementById("vCourse").innerText = course;
            document.getElementById("vPhoneView").innerText = phone;
            document.getElementById("viewModal").classList.replace("hidden", "flex");
        }
        function closeView() { document.getElementById("viewModal").classList.replace("flex", "hidden"); }

        // ✅ FORM VALIDATION LOGIC
        function handleAddUser() {
            const name = document.getElementById("aName").value.trim();
            const email = document.getElementById("aEmail").value.trim();
            const phone = document.getElementById("aPhone").value.trim();
            const pass = document.getElementById("aPass").value.trim();
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            
            let isValid = true;

            if (name.length < 3) { showError("aName", "aNameError"); isValid = false; }
            if (!emailRegex.test(email)) { showError("aEmail", "aEmailError"); isValid = false; }
            if (phone.length < 10) { showError("aPhone", "aPhoneError"); isValid = false; }
            if (pass.length < 6) { showError("aPass", "aPassError"); isValid = false; }

            if (isValid) {
                alert("Identity generated successfully.");
                closeAddModal();
            }
        }

        function handleUpdate() {
            const name = document.getElementById("eName").value.trim();
            const phone = document.getElementById("ePhone").value.trim();
            const pass = document.getElementById("ePass").value.trim();
            
            let isValid = true;

            if (name.length < 3) { showError("eName", "eNameError"); isValid = false; }
            if (phone.length < 10) { showError("ePhone", "ePhoneError"); isValid = false; }
            // Password in edit is only validated if the user types something (reset mode)
            if (pass.length > 0 && pass.length < 6) { showError("ePass", "ePassError"); isValid = false; }

            if (isValid) {
                alert("Administrative identity override successful.");
                closeEdit();
            }
        }
    </script>
</body>
</html>