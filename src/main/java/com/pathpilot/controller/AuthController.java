package com.pathpilot.controller;

import com.pathpilot.dao.UserDAO;
import com.pathpilot.service.EmailService;
import com.pathpilot.model.User;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.util.UUID;

@Controller
public class AuthController {

    @Autowired
    private EmailService emailService;

    @Autowired
    private UserDAO userDAO;

    // ==========================================
    // 1. ENTRY POINTS & SESSION GUARD
    // ==========================================
    @GetMapping("/login")
    public String showLoginPage(HttpSession session) {
        if (session != null && session.getAttribute("role") != null) {
            String role = session.getAttribute("role").toString().trim().toUpperCase();
            if ("ADMIN".equals(role)) return "redirect:/admin/dashboard";
            if ("USER".equals(role)) return "redirect:/user/UserHome";
            if ("STUDENT".equals(role)) return "redirect:/student/home";
            session.invalidate();
        }
        return "auth/login";
    }

    @GetMapping("/register")
    public String showRegisterPage() {
        return "auth/register";
    }

    @GetMapping("/verify-register")
    public String showRegisterOtpPage(HttpSession session) {
        if (session.getAttribute("verifyEmail") == null) {
            return "redirect:/register";
        }
        return "auth/verify_register_otp";
    }

    // ==========================================
    // 2. REGISTRATION PROCESS (AJAX)
    // ==========================================
    @PostMapping(value = "/register", produces = "text/plain")
    @ResponseBody
    public String processRegistration(
            @RequestParam("name") String name,
            @RequestParam("email") String email,
            @RequestParam("password") String password,
            HttpServletRequest request,
            HttpSession session) {

        try {
            if (userDAO.emailExists(email)) {
                return "Email already registered";
            }

            String token = UUID.randomUUID().toString();
            userDAO.selfRegister(name, email, password, token);

            // 🔥 Existing email (keep same)
            try {
                emailService.sendVerificationLink(email, token);
            } catch (Exception e) {
                e.printStackTrace();
            }

            // 🔥 ADDITION: OTP ALSO GENERATE
            String otp = String.valueOf((int)((Math.random() * 900000) + 100000));
            userDAO.saveResetToken(email, otp); // reuse same method

            try {
                emailService.sendRegistrationOtpEmail(email, otp);
            } catch (Exception e) {
                e.printStackTrace();
            }

            session.setAttribute("verifyEmail", email);

            return "OTP_SENT";

        } catch (Exception e) {
            e.printStackTrace();
            return "ERROR: " + e.getMessage();
        }
    }

    // ==========================================
    // 🔥 NEW: REGISTER OTP VERIFY
    // ==========================================
    @PostMapping("/verify-register-otp")
    @ResponseBody
    public String verifyRegisterOtp(
            @RequestParam("otp") String otp,
            HttpSession session) {

        try {
            String email = (String) session.getAttribute("verifyEmail");
            System.out.println("DEBUG: Email from session: " + email);
            System.out.println("DEBUG: OTP entered: " + otp);
            
            if (email == null) {
                System.out.println("DEBUG: Session email is null");
                return "SESSION_EXPIRED";
            }

            // Verify OTP matches the one stored in database
            boolean isValidOtp = userDAO.verifyRegistrationOtp(email, otp);
            System.out.println("DEBUG: OTP valid: " + isValidOtp);

            if (isValidOtp) {
                // Mark user as verified and clear token
                boolean marked = userDAO.markUserVerified(email);
                System.out.println("DEBUG: User marked verified: " + marked);
                
                if (marked) {
                    session.removeAttribute("verifyEmail");
                    System.out.println("DEBUG: Verification SUCCESS");
                    return "SUCCESS";
                } else {
                    System.out.println("DEBUG: markUserVerified returned false");
                    return "ERROR";
                }
            } else {
                System.out.println("DEBUG: INVALID_OTP");
                return "INVALID_OTP";
            }

        } catch (Exception e) {
            System.out.println("ERROR in verifyRegisterOtp: " + e.getMessage());
            e.printStackTrace();
            return "ERROR: " + e.getMessage();
        }
    }

    // ==========================================
    // 3. LOGIN PROCESS (UNCHANGED)
    // ==========================================
    @PostMapping(value = "/login", produces = "text/plain")
    @ResponseBody
    public String processLogin(
            @RequestParam("email") String email,
            @RequestParam("password") String password,
            HttpSession session) {

        try {
            User user = userDAO.login(email, password);
            if (user == null) {
                return "INVALID";
            }

            session.setAttribute("userId", user.getId());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("userName", user.getName());
            
            // Set profile picture in session
            session.setAttribute("profilePic", user.getProfilePic());
            
            // Fix role potential formatting issues
            String role = (user.getRole() != null) ? user.getRole().trim().toUpperCase() : "USER";
            session.setAttribute("role", role);

            if ("ADMIN".equals(role)) return "/admin/dashboard";
            if ("USER".equals(role)) return "/user/UserHome";
            return "/student/home";
        } catch (Exception e) {
            return "ERROR";
        }
    }

    // ==========================================
    // 4. EMAIL VERIFICATION (UNCHANGED)
    // ==========================================
    @GetMapping("/user/verify")
    public String verifyUser(@RequestParam("token") String token, Model model) {
        int result = userDAO.verifyUser(token);
        if (result > 0) {
            model.addAttribute("msg", "Account verified successfully! Please login.");
        } else {
            model.addAttribute("error", "Invalid or expired verification link.");
        }
        return "auth/login";
    }

    // ==========================================
    // 5. FORGET PASSWORD (UNCHANGED)
    // ==========================================
    @GetMapping("/forget-password")
    public String showForgetPasswordPage() {
        return "auth/forgetpassword";
    }

    @PostMapping("/forget-password")
    @ResponseBody
    public String processForgetPassword(@RequestParam("email") String email, HttpSession session) {
        try {
            if (!userDAO.emailExists(email)) {
                return "NOT_FOUND";
            }

            String otp = String.valueOf((int)((Math.random() * 900000) + 100000));
            userDAO.saveResetToken(email, otp);
            emailService.sendOtpEmail(email, otp);

            session.setAttribute("resetEmail", email);
            
            return "SUCCESS";
        } catch (Exception e) {
            return "ERROR";
        }
    }

    // ==========================================
    // 6. OTP VERIFY (UNCHANGED)
    // ==========================================
    @GetMapping("/otp")
    public String showOTPPage(HttpSession session) {
        if (session.getAttribute("resetEmail") == null) {
            return "redirect:/forget-password";
        }
        return "auth/verify_otp";
    }

    @PostMapping("/verify-otp")
    @ResponseBody
    public String verifyOtpAndReset(
            @RequestParam("otp") String otp,
            @RequestParam("password") String newPassword,
            HttpSession session) {
        
        try {
            // Verify OTP and get email
            String email = userDAO.verifyOtpAndGetEmail(otp);
            
            if (email == null) {
                return "INVALID_OTP";
            }

            // Update password and clear token
            boolean updated = userDAO.updatePasswordByToken(otp, newPassword);

            if (updated) {
                session.invalidate();
                return "SUCCESS";
            } else {
                return "INVALID_OTP";
            }
        } catch (Exception e) {
            return "ERROR";
        }
    }

    // ==========================================
    // 7. ADMIN (UNCHANGED)
    // ==========================================
    @PostMapping("/admin/add-user")
    @ResponseBody
    public String adminAddUser(
            @RequestParam("name") String name,
            @RequestParam("email") String email,
            @RequestParam("phone") String phone,
            @RequestParam("password") String password,
            @RequestParam("role") String role,
            HttpSession session) {

        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            return "UNAUTHORIZED";
        }

        try {
            if (userDAO.emailExists(email)) {
                return "EMAIL_EXISTS";
            }

            boolean success = userDAO.adminCreateUser(name, email, phone, password, role);
            return success ? "SUCCESS" : "ERROR";
        } catch (Exception e) {
            e.printStackTrace();
            return "ERROR";
        }
    }

    @PostMapping("/admin/update-user")
    @ResponseBody
    public String adminUpdateUser(
            @RequestParam("email") String email,
            @RequestParam("name") String name,
            @RequestParam(value = "password", required = false) String password,
            @RequestParam("phone") String phone,
            @RequestParam("role") String role,
            @RequestParam("status") String status,
            HttpSession session) {

        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            return "UNAUTHORIZED";
        }

        try {
            boolean success = userDAO.adminOverrideUser(email, name, password, phone, role, status);
            return success ? "SUCCESS" : "ERROR";
        } catch (Exception e) {
            e.printStackTrace();
            return "ERROR";
        }
    }

    // ==========================================
    // 8. LOGOUT
    // ==========================================
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        if (session != null) session.invalidate();
        return "redirect:/login?logout=true";
    }
}