package com.pathpilot.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.MediaType;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Arrays;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.io.File;
import java.io.IOException;
import org.springframework.web.multipart.MultipartFile;
import com.pathpilot.dao.UserDAO;
import com.pathpilot.dao.EnrollmentDAO;
import com.pathpilot.model.User;
import com.pathpilot.service.EmailService;
import org.springframework.jdbc.core.JdbcTemplate;

/**
 * AdminController handles UI navigation for secure management routes.
 * CRUD logic for Identity/Passwords is handled by AuthController via AJAX.
 */
@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private UserDAO userDAO;

    @Autowired
    private EmailService emailService;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private EnrollmentDAO enrollmentDAO;

    /**
     * Helper to verify admin session status.
     */
    private boolean isNotAdmin(HttpSession session) {
        return session == null || !"ADMIN".equals(session.getAttribute("role"));
    }

    // ==========================================
    // 1. DASHBOARD & USER MANAGEMENT (UI)
    // ==========================================

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session) {
        if (isNotAdmin(session)) return "redirect:/login";
        return "admin/admin_dashboard"; 
    }

    @GetMapping("/users")
    public String users(HttpSession session) {
        if (isNotAdmin(session)) return "redirect:/login";
        return "admin/admin_users";
    }

    // ==========================================
    // AJAX ENDPOINTS FOR USER MANAGEMENT
    // ==========================================

    /**
     * Health check endpoint
     */
    @GetMapping("/api/health")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> health() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "ok");
        response.put("message", "Admin API is working");
        return ResponseEntity.ok(response);
    }

    /**
     * Get Dashboard Statistics
     * Returns total counts for users, career paths, and enrollments
     */
    @GetMapping("/api/dashboard-stats")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getDashboardStats(HttpSession session) {
        if (isNotAdmin(session)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }

        try {
            System.out.println("📊 Fetching dashboard statistics...");
            
            int totalUsers = userDAO.getTotalUsersCount();
            int totalPaths = userDAO.getTotalCareerPathsCount();
            int totalEnrollments = userDAO.getTotalEnrollmentsCount();
            
            System.out.println("✅ Total Users: " + totalUsers);
            System.out.println("✅ Total Career Paths: " + totalPaths);
            System.out.println("✅ Total Enrollments: " + totalEnrollments);

            Map<String, Object> stats = new HashMap<>();
            stats.put("totalUsers", totalUsers);
            stats.put("totalCareerPaths", totalPaths);
            stats.put("totalEnrollments", totalEnrollments);
            stats.put("platformPlan", "Free");

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", stats);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            System.err.println("❌ Error fetching dashboard stats: " + e.getMessage());
            e.printStackTrace();
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * Get all users (for table display)
     */
    @GetMapping("/api/users")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getAllUsers(HttpSession session) {
        if (isNotAdmin(session)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }

        try {
            System.out.println("🔍 Fetching all users...");
            
            List<User> users = userDAO.getUsersByRole("student");
            System.out.println("✅ Students: " + (users != null ? users.size() : 0));
            
            List<User> mentors = userDAO.getUsersByRole("USER");
            System.out.println("✅ Mentors: " + (mentors != null ? mentors.size() : 0));
            
            List<User> admins = userDAO.getUsersByRole("ADMIN");
            System.out.println("✅ Admins: " + (admins != null ? admins.size() : 0));
            
            // Add all users to list
            java.util.ArrayList<User> allUsers = new java.util.ArrayList<>();
            if (users != null) allUsers.addAll(users);
            if (mentors != null) allUsers.addAll(mentors);
            if (admins != null) allUsers.addAll(admins);
            
            System.out.println("✅ Total users collected: " + allUsers.size());

            // Convert to DTOs without passwords (security & encoding fix)
            java.util.List<Map<String, Object>> safeUsers = new java.util.ArrayList<>();
            for (User user : allUsers) {
                Map<String, Object> userMap = new HashMap<>();
                userMap.put("id", user.getId());
                userMap.put("name", user.getName());
                userMap.put("email", user.getEmail());
                userMap.put("phone", user.getPhone());
                userMap.put("role", user.getRole());
                userMap.put("verified", user.isVerified());
                safeUsers.add(userMap);
            }
            
            System.out.println("✅ Converted to safe users: " + safeUsers.size());

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", safeUsers);
            response.put("count", safeUsers.size());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            System.err.println("❌ Error fetching users: " + e.getMessage());
            e.printStackTrace();
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * Create new user
     */
    @PostMapping("/api/users")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> createUser(
            @RequestParam String name,
            @RequestParam String email,
            @RequestParam String phone,
            @RequestParam String password,
            @RequestParam(defaultValue = "student") String role,
            HttpSession session) {
        if (isNotAdmin(session)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }

        try {
            if (userDAO.emailExists(email)) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("message", "Email already exists");
                return ResponseEntity.ok(response);
            }

            boolean created = userDAO.adminCreateUser(name, email, phone, password, role);
            Map<String, Object> response = new HashMap<>();
            response.put("success", created);
            response.put("message", created ? "User created successfully" : "Failed to create user");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * Update user
     */
    @GetMapping("/api/users/{userId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getUserById(
            @PathVariable int userId,
            HttpSession session) {
        if (isNotAdmin(session)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }

        try {
            User user = userDAO.getUserById(userId);
            Map<String, Object> response = new HashMap<>();

            if (user == null) {
                response.put("success", false);
                response.put("message", "User not found");
                return ResponseEntity.ok(response);
            }

            Map<String, Object> safeUser = new HashMap<>();
            safeUser.put("id", user.getId());
            safeUser.put("name", user.getName());
            safeUser.put("email", user.getEmail());
            safeUser.put("phone", user.getPhone());
            safeUser.put("role", user.getRole());
            safeUser.put("verified", user.isVerified());

            response.put("success", true);
            response.put("data", safeUser);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    @PutMapping("/api/users/{userId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateUser(
            @PathVariable int userId,
            @RequestParam String name,
            @RequestParam String phone,
            @RequestParam(required = false) String password,
            @RequestParam String role,
            @RequestParam String status,
            HttpSession session) {
        if (isNotAdmin(session)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }

        try {
            User user = userDAO.getUserById(userId);
            if (user == null) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("message", "User not found");
                return ResponseEntity.ok(response);
            }
            
            boolean updated = userDAO.adminOverrideUser(user.getEmail(), name, password, phone, role, status);
            Map<String, Object> response = new HashMap<>();
            response.put("success", updated);
            response.put("message", updated ? "User updated successfully" : "Failed to update user");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * Delete user
     */
    @DeleteMapping("/api/users/{userId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteUser(
            @PathVariable int userId,
            HttpSession session) {
        if (isNotAdmin(session)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }

        try {
            int result = userDAO.deleteUser(userId);
            Map<String, Object> response = new HashMap<>();
            response.put("success", result > 0);
            response.put("message", result > 0 ? "User deleted successfully" : "Failed to delete user");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * Get enrolled career path names for a specific user.
     * Used by Admin Users modal (view details) for STUDENT/USER roles.
     */
    @GetMapping("/api/users/{userId}/careerpaths")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getUserCareerPaths(
            @PathVariable int userId,
            HttpSession session) {
        if (isNotAdmin(session)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }

        try {
            List<Map<String, Object>> enrollments = enrollmentDAO.getAllEnrollmentDetailsForUser(userId);
            java.util.LinkedHashSet<String> uniqueTitles = new java.util.LinkedHashSet<>();

            for (Map<String, Object> enrollment : enrollments) {
                Object titleObj = enrollment.get("path_title");
                if (titleObj != null) {
                    String title = String.valueOf(titleObj).trim();
                    if (!title.isEmpty()) {
                        uniqueTitles.add(title);
                    }
                }
            }

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", new java.util.ArrayList<>(uniqueTitles));
            response.put("count", uniqueTitles.size());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * Get Admin Settings (for profile section)
     */
    @GetMapping("/api/admin-settings")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getAdminSettings(HttpSession session) {
        if (isNotAdmin(session)) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("error", "Unauthorized");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        try {
            System.out.println("🔍 Fetching admin settings...");
            
            User admin = userDAO.getFirstAdminUser();
            if (admin == null) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("message", "Admin user not found");
                return ResponseEntity.ok(response);
            }
            
            System.out.println("✅ Admin settings retrieved: " + admin.getName());

            Map<String, Object> adminData = new HashMap<>();
            adminData.put("id", admin.getId());
            adminData.put("name", admin.getName());
            adminData.put("email", admin.getEmail());
            adminData.put("phone", admin.getPhone() != null ? admin.getPhone() : "");
            adminData.put("profilePic", admin.getProfilePic() != null ? admin.getProfilePic() : "/assets/images/rpk.jpg");

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", adminData);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            System.err.println("❌ Error fetching admin settings: " + e.getMessage());
            e.printStackTrace();
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * Update Admin Settings
     */
    @PutMapping("/api/admin-settings")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateAdminSettings(
            HttpSession session,
            @RequestBody Map<String, Object> request) {
        if (isNotAdmin(session)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }

        try {
            System.out.println("🔄 Updating admin settings...");
            
            User admin = userDAO.getFirstAdminUser();
            if (admin == null) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("message", "Admin user not found");
                return ResponseEntity.ok(response);
            }

            String name = (String) request.get("name");
            String email = (String) request.get("email");
            String phone = (String) request.get("phone");
            String password = (String) request.get("password");

            if (name == null || name.trim().isEmpty()) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("message", "Name cannot be empty");
                return ResponseEntity.ok(response);
            }

            boolean updated = userDAO.updateAdminSettings(admin.getId(), name, email, phone, password);
            
            if (updated) {
                System.out.println("✅ Admin settings updated successfully");
                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("message", "Settings updated successfully");
                return ResponseEntity.ok(response);
            } else {
                System.err.println("❌ Failed to update admin settings");
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("message", "Failed to update settings");
                return ResponseEntity.ok(response);
            }
        } catch (Exception e) {
            System.err.println("❌ Error updating admin settings: " + e.getMessage());
            e.printStackTrace();
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * Serve Admin Files (images, pdfs, etc)
     * Same pattern as StudentController.serveFile() for consistency
     * Allows access to files stored in /assets/uploads/ directory
     */
    @GetMapping("/file/**")
    public ResponseEntity<byte[]> serveAdminFile(jakarta.servlet.http.HttpServletRequest request) throws IOException {
        String pathInfo = request.getRequestURI();
        // Extract filename after /admin/file/
        String filename = pathInfo.substring(pathInfo.lastIndexOf("/") + 1);
        
        try {
            if (filename == null || filename.isEmpty() || filename.contains("..")) {
                System.out.println("🚫 Invalid filename: " + filename);
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
            }

            System.out.println("🖼️ Serving admin file: " + filename);
            
            Path uploadRoot = resolveUploadRoot();
            Path filePath = uploadRoot.resolve(filename).normalize();
            
            // Security check: ensure the resolved path is still within the upload directory
            if (!filePath.startsWith(uploadRoot)) {
                System.out.println("🚫 Path traversal attempt detected: " + filePath);
                return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
            }
            
            if (!Files.exists(filePath)) {
                System.out.println("❌ File not found: " + filePath.toAbsolutePath());
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            }

            byte[] fileContent = Files.readAllBytes(filePath);
            String contentType = "application/octet-stream";
            
            // Determine content type based on file extension
            if (filename.endsWith(".png")) {
                contentType = "image/png";
            } else if (filename.endsWith(".jpg") || filename.endsWith(".jpeg")) {
                contentType = "image/jpeg";
            } else if (filename.endsWith(".pdf")) {
                contentType = "application/pdf";
            } else if (filename.endsWith(".gif")) {
                contentType = "image/gif";
            } else if (filename.endsWith(".webp")) {
                contentType = "image/webp";
            } else if (filename.endsWith(".doc") || filename.endsWith(".docx")) {
                contentType = "application/msword";
            }
            
            System.out.println("✅ Serving file: " + filename + " (" + fileContent.length + " bytes) as " + contentType);
            
            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(contentType))
                    .body(fileContent);
        } catch (Exception e) {
            System.err.println("❌ [ADMIN_FILE_SERVE] Error: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Upload Admin Profile Picture
     * Similar to UserController's profile picture upload
     */
    @PostMapping("/api/admin-settings/upload-photo")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> uploadAdminProfilePicture(
            HttpSession session,
            @RequestParam(value = "file", required = false) MultipartFile file,
            jakarta.servlet.http.HttpServletRequest request) {
        if (isNotAdmin(session)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }

        try {
            if (file == null || file.isEmpty()) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("message", "No file selected");
                return ResponseEntity.ok(response);
            }

            System.out.println("📸 Uploading admin profile picture...");
            
            // Get first admin user
            User admin = userDAO.getFirstAdminUser();
            if (admin == null) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("message", "Admin user not found");
                return ResponseEntity.ok(response);
            }

            // Save file to uploads directory
            Path uploadRoot = resolveUploadRoot();
            String originalName = file.getOriginalFilename() != null ? file.getOriginalFilename() : "profile.jpg";
            String safeName = originalName.replaceAll("[^a-zA-Z0-9._-]", "_");
            String fileName = "profile_" + admin.getId() + "_" + System.currentTimeMillis() + "_" + safeName;
            Path target = uploadRoot.resolve(fileName);

            Files.copy(file.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);
            String profilePicPath = "/assets/uploads/" + fileName;
            
            System.out.println("✅ File saved: " + target.toAbsolutePath());
            System.out.println("✅ File exists: " + Files.exists(target) + " Size: " + Files.size(target) + " bytes");

            // Update database with new profile picture path
            boolean updated = userDAO.updateAdminProfilePic(admin.getId(), profilePicPath);
            
            if (updated) {
                System.out.println("✅ Admin profile picture path saved to database");
                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("message", "Profile picture uploaded successfully");
                Map<String, Object> data = new HashMap<>();
                data.put("profilePic", profilePicPath);
                data.put("url", request.getContextPath() + "/admin/file/" + fileName);
                response.put("data", data);
                return ResponseEntity.ok(response);
            } else {
                System.err.println("❌ Failed to update admin profile picture in database");
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("message", "Failed to save profile picture path to database");
                return ResponseEntity.ok(response);
            }
        } catch (IOException e) {
            System.err.println("❌ IO Error uploading admin profile picture: " + e.getMessage());
            e.printStackTrace();
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "File upload failed: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        } catch (Exception e) {
            System.err.println("❌ Error uploading admin profile picture: " + e.getMessage());
            e.printStackTrace();
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * Helper method to resolve the uploads directory
     * Identical to StudentController.resolveUploadRoot() for consistency
     */
    private Path resolveUploadRoot() throws IOException {
        List<Path> candidates = List.of(
                Paths.get("D:/RGM/pathpilot/src/main/webapp/assets/uploads"),
                Paths.get(System.getProperty("user.dir"), "src", "main", "webapp", "assets", "uploads").toAbsolutePath().normalize()
        );

        IOException last = null;
        for (Path candidate : candidates) {
            try {
                Files.createDirectories(candidate);
                if (Files.isDirectory(candidate) && Files.isWritable(candidate)) {
                    System.out.println("✅ Using uploads directory: " + candidate.toAbsolutePath());
                    return candidate;
                }
            } catch (IOException ex) {
                last = ex;
            }
        }

        if (last != null) {
            throw last;
        }
        throw new IOException("No writable upload directory available at project assets/uploads");
    }

    @GetMapping("/settings")
    public String settings(HttpSession session) {
        if (isNotAdmin(session)) return "redirect:/login";
        return "admin/admin_settings";
    }

    @GetMapping("/manage-home")
    public String manageHome(HttpSession session) {
        if (isNotAdmin(session)) return "redirect:/login";
        return "admin/admin_manage_home";
    }

    @GetMapping("/manage-features")
    public String manageFeatures(HttpSession session) {
        if (isNotAdmin(session)) return "redirect:/login";
        return "admin/admin_manage_features";
    }

    @GetMapping("/manage-about")
    public String manageAbout(HttpSession session) {
        if (isNotAdmin(session)) return "redirect:/login";
        return "admin/admin_manage_about";
    }

    @GetMapping("/manage-contact")
    public String manageContact(HttpSession session) {
        if (isNotAdmin(session)) return "redirect:/login";
        return "admin/admin_manage_contact";
    }

    @GetMapping("/manage-footer")
    public String manageFooter(HttpSession session) {
        if (isNotAdmin(session)) return "redirect:/login";
        return "admin/admin_manage_footer";
    }

    @GetMapping("/notify")
    public String notifyPage(HttpSession session) {
        if (isNotAdmin(session)) return "redirect:/login";
        return "admin/admin_notify";
    }

    // ==========================================
    // 4. CONTENT UPDATES (POST Mappings)
    // ==========================================

    /**
     * Handles general platform content saving.
     * Note: User registration/overrides are now handled in AuthController.
     */
    @PostMapping({"/update-content", "/manage-home", "/manage-features", "/manage-about", "/manage-contact", "/manage-footer"})
    public String updatePlatformContent(HttpSession session) {
        if (isNotAdmin(session)) return "redirect:/login";
        
        System.out.println("Platform content updated via AdminController.");
        return "redirect:/admin/settings?status=saved";
    }

    // ==========================================
    // 5. CONTACT MESSAGES API
    // ==========================================

    /**
     * Fetch all contact messages from database
     * Returns JSON array with message details
     */
    @GetMapping("/api/contact-messages")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getContactMessages(HttpSession session) {
        if (isNotAdmin(session)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }

        try {
            System.out.println("📬 Fetching contact messages from database...");
            
            List<Map<String, Object>> messages = userDAO.getContactMessages();
            
            System.out.println("✅ Found " + messages.size() + " contact messages");

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", messages);
            response.put("count", messages.size());
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            System.err.println("❌ Error fetching contact messages: " + e.getMessage());
            e.printStackTrace();
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("error", e.getMessage());
            
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * Send reply to contact message - Form-based endpoint (like contact form)
     * Receives: messageId, replyMessage as form data (not JSON)
     */
    @PostMapping("/api/reply")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> replyToContactMessage(
            @RequestParam("messageId") Integer messageId,
            @RequestParam("replyMessage") String replyMessage,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            // ========== AUTHORIZATION CHECK ==========
            if (isNotAdmin(session)) {
                response.put("success", false);
                response.put("error", "Unauthorized access");
                System.err.println("❌ Unauthorized reply attempt - not admin");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }
            
            String adminName = (String) session.getAttribute("userName");
            if (adminName == null) adminName = "Support Team";
            
            System.out.println("\n========== ADMIN REPLY PROCESS ==========");
            System.out.println("✅ Message ID: " + messageId);
            System.out.println("✅ Admin: " + adminName);
            System.out.println("✅ Reply length: " + (replyMessage != null ? replyMessage.length() : 0));
            
            // ========== VALIDATE INPUT ==========
            if (replyMessage == null || replyMessage.trim().isEmpty()) {
                response.put("success", false);
                response.put("error", "Reply message cannot be empty");
                System.err.println("❌ Empty reply text");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
            }
            
            // ========== FETCH MESSAGE FROM DATABASE ==========
            String querySql = "SELECT id, sender_name, sender_email, subject, message FROM contact_messages WHERE id = ?";
            java.util.List<Map<String, Object>> msgList = jdbcTemplate.queryForList(querySql, messageId);
            
            if (msgList.isEmpty()) {
                response.put("success", false);
                response.put("error", "Message not found");
                System.err.println("❌ Message not found with ID: " + messageId);
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
            }
            
            Map<String, Object> msgData = msgList.get(0);
            String studentEmail = (String) msgData.get("sender_email");
            String originalSubject = (String) msgData.get("subject");
            
            if (studentEmail == null || studentEmail.trim().isEmpty()) {
                response.put("success", false);
                response.put("error", "Cannot find student email");
                System.err.println("❌ Student email is null or empty");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
            }
            
            System.out.println("✅ Student Email: " + studentEmail);
            System.out.println("✅ Subject: " + originalSubject);
            
            // ========== PREPARE EMAIL BODY (like contact form pattern) ==========
            String htmlBody = "<div style='font-family: Segoe UI, Tahoma, sans-serif; max-width: 600px; margin: auto; border: 1px solid #eef2f6; padding: 40px; border-radius: 20px; color: #1e293b;'>" +
                    "  <h2 style='color: #4913ec; margin-top: 0;'>Response to Your Message</h2>" +
                    "  <div style='background-color: #f8fafc; padding: 20px; border-radius: 12px; margin: 20px 0;'>" +
                    "    <p><strong>Subject:</strong> " + originalSubject.replace("<", "&lt;").replace(">", "&gt;") + "</p>" +
                    "    <p><strong>From:</strong> PathPilot Support Team</p>" +
                    "  </div>" +
                    "  <div style='background-color: #f1f5f9; padding: 20px; border-radius: 12px; border-left: 4px solid #4913ec;'>" +
                    "    <h3 style='margin-top: 0; color: #0f172a;'>Our Response:</h3>" +
                    "    <p style='line-height: 1.6; color: #475569;'>" + replyMessage.replace("\n", "<br>").replace("<", "&lt;").replace(">", "&gt;") + "</p>" +
                    "  </div>" +
                    "  <p style='font-size: 12px; color: #94a3b8; border-top: 1px solid #f1f5f9; padding-top: 20px; text-align: center;'>&copy; 2026 PathPilot Support Team.</p>" +
                    "</div>";
            
            // ========== SEND EMAIL (Best-Effort Pattern) ==========
            try {
                emailService.sendEmailWithAttachment(
                        studentEmail,
                        "Re: " + originalSubject,
                        htmlBody,
                        null);
                System.out.println("✅ Email sent successfully to: " + studentEmail);
            } catch (Exception emailErr) {
                System.err.println("⚠️  Email sending failed (continuing): " + emailErr.getMessage());
                emailErr.printStackTrace();
                // Don't fail - email is optional, DB update is what matters
            }
            
            // ========== UPDATE DATABASE ==========
            String adminId = String.valueOf(session.getAttribute("userId"));
            String updateSql = "UPDATE contact_messages SET status = 'REPLIED', reply_message = ?, reply_date = NOW(), replied_by = ?, replied_by_id = ? WHERE id = ?";
            int rowsUpdated = jdbcTemplate.update(updateSql, replyMessage, adminName, adminId, messageId);
            
            if (rowsUpdated > 0) {
                System.out.println("✅ Database updated: Message marked as REPLIED");
                System.out.println("========== REPLY SUCCESSFUL ==========\n");
                
                response.put("success", true);
                response.put("message", "Reply sent successfully");
                return ResponseEntity.ok(response);
            } else {
                System.err.println("❌ No rows updated in database");
                response.put("success", false);
                response.put("error", "Failed to update message");
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
            }
            
        } catch (Exception e) {
            System.err.println("❌ EXCEPTION: " + e.getClass().getSimpleName());
            System.err.println("❌ Message: " + e.getMessage());
            e.printStackTrace();
            
            response.put("success", false);
            response.put("error", e.getMessage());
            
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
    @ResponseBody
    public ResponseEntity<Map<String, Object>> sendMessageReply(
            @PathVariable Integer messageId,
            @RequestBody Map<String, String> payload,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            // ========== AUTHORIZATION CHECK ==========
            if (isNotAdmin(session)) {
                response.put("success", false);
                response.put("error", "Unauthorized");
                System.err.println("❌ Unauthorized reply attempt");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }
            
            String replyText = payload.get("replyMessage");
            String adminName = (String) session.getAttribute("userName");
            if (adminName == null) adminName = "Support Team";
            
            System.out.println("\n========== ADMIN REPLY PROCESS ==========");
            System.out.println("Message ID: " + messageId);
            System.out.println("Admin: " + adminName);
            System.out.println("Reply Length: " + (replyText != null ? replyText.length() : 0));
            
            // ========== VALIDATE INPUT ==========
            if (replyText == null || replyText.trim().isEmpty()) {
                response.put("success", false);
                response.put("error", "Reply message cannot be empty");
                System.err.println("❌ Empty reply text");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
            }
            
            // ========== FETCH MESSAGE FROM DATABASE ==========
            String querySql = "SELECT id, sender_name, sender_email, subject, message FROM contact_messages WHERE id = ?";
            java.util.List<Map<String, Object>> msgList = jdbcTemplate.queryForList(querySql, messageId);
            
            if (msgList.isEmpty()) {
                response.put("success", false);
                response.put("error", "Message not found with ID: " + messageId);
                System.err.println("❌ Message not found with ID: " + messageId);
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
            }
            
            Map<String, Object> msgData = msgList.get(0);
            String studentEmail = (String) msgData.get("sender_email");
            String originalSubject = (String) msgData.get("subject");
            
            if (studentEmail == null || studentEmail.trim().isEmpty()) {
                response.put("success", false);
                response.put("error", "Student email is invalid");
                System.err.println("❌ Student email is null or empty");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
            }
            
            System.out.println("✅ Message found for ID: " + messageId);
            System.out.println("✅ Student Email: " + studentEmail);
            System.out.println("✅ Original Subject: " + originalSubject);
            
            // ========== PREPARE EMAIL BODY (like contact form pattern) ==========
            String htmlBody = "<div style='font-family: Segoe UI, Tahoma, sans-serif; max-width: 600px; margin: auto; border: 1px solid #eef2f6; padding: 40px; border-radius: 20px; color: #1e293b;'>" +
                    "  <h2 style='color: #4913ec; margin-top: 0;'>Response to Your Message</h2>" +
                    "  <div style='background-color: #f8fafc; padding: 20px; border-radius: 12px; margin: 20px 0;'>" +
                    "    <p><strong>Subject:</strong> " + originalSubject.replaceAll("<", "&lt;").replaceAll(">", "&gt;") + "</p>" +
                    "    <p><strong>From:</strong> PathPilot Support Team</p>" +
                    "  </div>" +
                    "  <div style='background-color: #f1f5f9; padding: 20px; border-radius: 12px; border-left: 4px solid #4913ec;'>" +
                    "    <h3 style='margin-top: 0; color: #0f172a;'>Our Response:</h3>" +
                    "    <p style='line-height: 1.6; color: #475569;'>" + replyText.replace("\n", "<br>").replaceAll("<", "&lt;").replaceAll(">", "&gt;") + "</p>" +
                    "  </div>" +
                    "  <p style='font-size: 12px; color: #94a3b8; border-top: 1px solid #f1f5f9; padding-top: 20px; text-align: center;'>&copy; 2026 PathPilot Support Team.</p>" +
                    "</div>";
            
            // ========== SEND EMAIL (Best-Effort Pattern - doesn't block on failure) ==========
            try {
                emailService.sendEmailWithAttachment(
                        studentEmail,
                        "Re: " + originalSubject,
                        htmlBody,
                        null);
                System.out.println("✅ Email sent successfully to: " + studentEmail);
            } catch (Exception emailErr) {
                System.err.println("⚠️  Email sending failed (continuing anyway): " + emailErr.getMessage());
                emailErr.printStackTrace();
                // Don't fail - just log and continue
            }
            
            // ========== UPDATE DATABASE ==========
            String updateSql = "UPDATE contact_messages SET status = 'REPLIED', reply_message = ?, reply_date = NOW(), replied_by = ? WHERE id = ?";
            int rowsUpdated = jdbcTemplate.update(updateSql, replyText, adminName, messageId);
            
            if (rowsUpdated > 0) {
                System.out.println("✅ Database updated: Message marked as REPLIED");
                System.out.println("========== REPLY SUCCESSFUL ==========\n");
                
                response.put("success", true);
                response.put("message", "Reply sent successfully");
                return ResponseEntity.ok(response);
            } else {
                System.err.println("❌ No rows updated in database");
                response.put("success", false);
                response.put("error", "Failed to update message in database");
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
            }
            
        } catch (Exception e) {
            System.err.println("❌ EXCEPTION in sendMessageReply: " + e.getClass().getSimpleName());
            System.err.println("❌ Error message: " + e.getMessage());
            e.printStackTrace();
            
            response.put("success", false);
            response.put("error", "Server error: " + e.getClass().getSimpleName() + " - " + e.getMessage());
            
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * Update message status to UNREAD when viewing
     */
    @PutMapping("/api/messages/{messageId}/view")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> markMessageAsViewed(
            @PathVariable Integer messageId,
            HttpSession session) {
        
        if (isNotAdmin(session)) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("error", "Unauthorized");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        try {
            String sql = "UPDATE contact_messages SET status = 'UNREAD', updated_at = NOW() WHERE id = ?";
            jdbcTemplate.update(sql, messageId);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            System.err.println("❌ Error updating message status: " + e.getMessage());
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("error", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
}