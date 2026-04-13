package com.pathpilot.controller;

import com.pathpilot.dao.UserDAO;
import com.pathpilot.dao.PathDAO;
import com.pathpilot.dao.PhaseDAO;
import com.pathpilot.dao.EnrollmentDAO;
import com.pathpilot.dao.QuizQuestionDAO;
import com.pathpilot.dao.QuizOptionDAO;
import com.pathpilot.dao.PhaseProgressDAO;
import com.pathpilot.dao.PhaseResourceDAO;
import com.pathpilot.dao.QuizResponseDAO;
import com.pathpilot.model.CareerPath;
import com.pathpilot.model.Phase;
import com.pathpilot.model.Enrollment;
import com.pathpilot.model.PhaseProgress;
import com.pathpilot.model.PhaseResource;
import com.pathpilot.model.QuizQuestion;
import com.pathpilot.model.QuizResponse;
import com.pathpilot.model.User;
import com.pathpilot.model.QuizOption;
import com.pathpilot.service.EmailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.multipart.MultipartFile;
import jakarta.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/student")
public class StudentController {

    @Autowired
    private UserDAO userDAO;

    @Autowired
    private PathDAO pathDAO;

    @Autowired
    private PhaseDAO phaseDAO;

    @Autowired
    private EnrollmentDAO enrollmentDAO;

    @Autowired
    private QuizQuestionDAO quizQuestionDAO;

    @Autowired
    private QuizOptionDAO quizOptionDAO;

    @Autowired
    private PhaseProgressDAO phaseProgressDAO;

    @Autowired
    private PhaseResourceDAO phaseResourceDAO;

    @Autowired
    private QuizResponseDAO quizResponseDAO;

    @Autowired
    private EmailService emailService;

    // ==========================================
    // 🔐 CENTRALIZED SESSION + ROLE CHECK
    // ==========================================
    private String checkAccess(HttpSession session) {
        if (session == null || session.getAttribute("role") == null) {
            return "redirect:/login";
        }
        String role = (String) session.getAttribute("role");
        if (!"STUDENT".equals(role) && !"USER".equals(role)) {
            return "redirect:/login";
        }
        return null; 
    }

    // ==========================================
    // 🏠 DASHBOARD & NAVIGATION
    // ==========================================

    @GetMapping("/home")
    public String home(HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;
        return "students/student_home";
    }

    @GetMapping("/profile")
    public String profile(Model model, HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;
        
        try {
            Integer userId = (Integer) session.getAttribute("userId");
            
            // Fetch all enrolled career paths for this student
            List<Map<String, Object>> enrolledPaths = new ArrayList<>();
            List<Enrollment> enrollments = enrollmentDAO.getEnrollmentsByUserId(userId);
            
            if (enrollments != null) {
                for (Enrollment enrollment : enrollments) {
                    CareerPath path = pathDAO.getPathById(enrollment.getPathId());
                    if (path != null) {
                        Map<String, Object> pathInfo = new HashMap<>();
                        pathInfo.put("path", path);
                        pathInfo.put("enrollmentDate", enrollment.getEnrolledDate());
                        
                        // Calculate completion percentage based on best scores
                        List<Phase> phases = phaseDAO.getPhasesByPathId(path.getPathId());
                        int totalPhases = phases != null ? phases.size() : 0;
                        
                        if (totalPhases > 0) {
                            int completedPhases = 0;
                            double totalCompletion = 0;
                            Phase nextPhase = null;
                            
                            for (Phase phase : phases) {
                                PhaseProgress progress = phaseProgressDAO.getProgressByEnrollmentAndPhase(enrollment.getEnrollmentId(), phase.getPhaseId());
                                if (progress != null) {
                                    if (progress.isCompleted()) {
                                        completedPhases++;
                                        totalCompletion += 100;
                                    } else if (progress.getBestScore() != null) {
                                        totalCompletion += progress.getBestScore().doubleValue();
                                    }
                                }
                                if (nextPhase == null && (progress == null || !progress.isCompleted())) {
                                    nextPhase = phase;
                                }
                            }
                            
                            double avgCompletion = totalCompletion / totalPhases;
                            pathInfo.put("completionPercentage", (int) avgCompletion);
                            pathInfo.put("completedPhases", completedPhases);
                            pathInfo.put("totalPhases", totalPhases);
                            pathInfo.put("nextPhase", nextPhase);
                        } else {
                            pathInfo.put("completionPercentage", 0);
                            pathInfo.put("completedPhases", 0);
                            pathInfo.put("totalPhases", 0);
                            pathInfo.put("nextPhase", null);
                        }
                        
                        enrolledPaths.add(pathInfo);
                    }
                }
            }
            
            model.addAttribute("enrolledPaths", enrolledPaths);
            
        } catch (Exception e) {
            System.err.println("Error loading enrolled paths: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("enrolledPaths", new ArrayList<>());
        }
        
        return "students/student_profile";
    }
    
    @GetMapping("/settings")
    public String settings(HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;
        return "students/student_setting";
    }

    // ==========================================
    // 🎓 LEARNING & ENROLLMENT
    // ==========================================

    @GetMapping("/enroll")
    public String enrollPage(
            @RequestParam(value = "id", required = false) Integer pathId,
            Model model,
            HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;
        
        try {
            if (pathId != null) {
                // Fetch career path and phases for enrollment
                CareerPath path = pathDAO.getPathById(pathId);
                List<Phase> phases = phaseDAO.getPhasesByPathId(pathId);
                if (path != null) {
                    model.addAttribute("careerPath", path);
                    model.addAttribute("phases", phases);
                    System.out.println("✅ Loading enrollment for path: " + path.getTitle());
                }
            }
        } catch (Exception e) {
            System.err.println("Error loading path for enrollment: " + e.getMessage());
            e.printStackTrace();
        }
        
        return "students/student_enroll";
    }

    @PostMapping("/enroll")
    public String submitEnrollment(
            @RequestParam("pathId") int pathId,
            @RequestParam(value = "contact", required = false) String contact,
            HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;
        
        try {
            int userId = (Integer) session.getAttribute("userId");

            User currentUser = userDAO.getUserById(userId);
            String submittedContact = contact != null ? contact.trim() : "";
            if (currentUser != null && !submittedContact.isEmpty()) {
                String existingContact = currentUser.getPhone() != null ? currentUser.getPhone().trim() : "";
                if (!submittedContact.equals(existingContact)) {
                    userDAO.updatePhone(userId, submittedContact);
                }
            }

            if (enrollmentDAO.isEnrolled(userId, pathId)) {
                // Already enrolled, redirect to progress
                List<Map<String, Object>> enrollments = enrollmentDAO.getAllEnrollmentDetailsForUser(userId);
                for (Map<String, Object> enrollment : enrollments) {
                    if (((Number) enrollment.get("path_id")).intValue() == pathId) {
                        int enrollmentId = ((Number) enrollment.get("enrollment_id")).intValue();
                        return "redirect:/student/progress?enrollmentId=" + enrollmentId;
                    }
                }
            }
            
            // Create enrollment record
            Enrollment enrollment = new Enrollment();
            enrollment.setPathId(pathId);
            enrollment.setUserId(userId);
            enrollment.setActive(true);
            enrollment.setCompleted(false);
            enrollment.setProgressPercentage(BigDecimal.ZERO);
            
            int enrollmentId = enrollmentDAO.addEnrollment(enrollment);
            
            if (enrollmentId > 0) {
                List<Phase> phases = phaseDAO.getPhasesByPathId(pathId);
                for (Phase phase : phases) {
                    PhaseProgress progress = new PhaseProgress();
                    progress.setEnrollmentId(enrollmentId);
                    progress.setPhaseId(phase.getPhaseId());
                    progress.setCompleted(false);
                    progress.setAttempts(0);
                    progress.setBestScore(BigDecimal.ZERO);
                    phaseProgressDAO.addPhaseProgress(progress);
                }
                System.out.println("✅ Student enrolled successfully - Enrollment ID: " + enrollmentId);
                return "redirect:/student/progress?enrollmentId=" + enrollmentId;
            }
            
            return "redirect:/student/enroll?id=" + pathId + "&error=enrollment_failed";
            
        } catch (Exception e) {
            System.err.println("❌ Error processing enrollment: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/student/enroll?id=" + pathId + "&error=enrollment_error";
        }
    }

    @GetMapping("/view-path")
    public String viewPath(@RequestParam(value = "id") int pathId, HttpSession session, 
                           RedirectAttributes redirectAttributes) {
        String r = checkAccess(session);
        if (r != null) return r;
        
        Integer userId = (Integer) session.getAttribute("userId");
        
        // Check if student is enrolled in this path
        boolean isEnrolled = userId != null && enrollmentDAO.isEnrolled(userId, pathId);
        
        if (isEnrolled) {
            // Get enrollment details including path information
            List<Map<String, Object>> enrollments = enrollmentDAO.getAllEnrollmentDetailsForUser(userId);
            for (Map<String, Object> enrollment : enrollments) {
                if (((Number) enrollment.get("path_id")).intValue() == pathId) {
                    // Redirect to progress page with enrollment ID and path title
                    int enrollmentId = ((Number) enrollment.get("enrollment_id")).intValue();
                    String title = (String) enrollment.get("path_title");
                    return "redirect:/student/progress?enrollmentId=" + enrollmentId + "&title=" + 
                           URLEncoder.encode(title, StandardCharsets.UTF_8);
                }
            }
        }
        
        // If not enrolled, go to enrollment page with locked phases
        return "redirect:/student/enroll?id=" + pathId;
    }

    @GetMapping("/course-details/{id}")
    public String courseDetails(
            @PathVariable("id") Integer pathId,
            Model model,
            HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;
        
        try {
            Integer userId = (Integer) session.getAttribute("userId");
            
            // Fetch career path and phases
            CareerPath path = pathDAO.getPathById(pathId);
            if (path != null) {
                List<Phase> phases = phaseDAO.getPhasesByPathId(pathId);
                model.addAttribute("careerPath", path);
                model.addAttribute("phases", phases != null ? phases : new java.util.ArrayList<>());
                if (phases != null && !phases.isEmpty()) {
                    model.addAttribute("firstPhaseId", phases.get(0).getPhaseId());
                }

                // Check if user is enrolled in this path
                if (userId != null) {
                    User currentUser = userDAO.getUserById(userId);
                    if (currentUser != null) {
                        model.addAttribute("studentUser", currentUser);
                    }

                    Enrollment userEnrollment = enrollmentDAO.getEnrollmentByUserAndPath(userId, pathId);

                    if (userEnrollment != null) {
                        model.addAttribute("isEnrolled", true);
                        model.addAttribute("enrollmentId", userEnrollment.getEnrollmentId());

                        // Fetch phase progress for this enrollment
                        List<com.pathpilot.model.PhaseProgress> progressData = phaseProgressDAO.getProgressByEnrollmentId(userEnrollment.getEnrollmentId());
                        model.addAttribute("phaseProgress", progressData);
                    } else {
                        model.addAttribute("isEnrolled", false);
                    }
                }

                System.out.println("✅ Loading course details: " + path.getTitle());
            }
        } catch (Exception e) {
            System.err.println("Error loading course details: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("phases", new java.util.ArrayList<>());
            model.addAttribute("isEnrolled", false);
        }
        
        return "students/student_course_details";
    }

    @GetMapping("/course-details")
    public String courseDetailsLegacy(
            @RequestParam(value = "id", required = false) Integer pathId,
            HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;

        if (pathId == null) {
            return "redirect:/student/resources";
        }
        return "redirect:/student/course-details/" + pathId;
    }

    @GetMapping("/module")
    public String moduleContent(
            @RequestParam("phase") int phaseId,
            @RequestParam(value = "title", required = false) String title,
            @RequestParam(value = "path", required = false) Integer pathId,
            Model model,
            HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;

        int studentId = (Integer) session.getAttribute("userId");
        
        Phase phase = phaseDAO.getPhaseById(phaseId);
        if (phase == null) {
            return "redirect:/student/progress?error=phase_not_found";
        }

        String resolvedTitle = (title != null && !title.trim().isEmpty()) ? title : phase.getTitle();
        String videoUrl = "";
        String pdfPath = "";
        String pdfName = "";

        // Get resources for this phase
        List<PhaseResource> resources = phaseResourceDAO.getResourcesByPhaseId(phaseId);
        for (PhaseResource resource : resources) {
            if (videoUrl.isEmpty() && "VIDEO".equalsIgnoreCase(resource.getResourceType()) && resource.getResourceUrl() != null) {
                videoUrl = resource.getResourceUrl();
            }
            if (pdfPath.isEmpty() && ("PDF".equalsIgnoreCase(resource.getResourceType()) || "DOCUMENT".equalsIgnoreCase(resource.getResourceType()))
                    && resource.getFilePath() != null) {
                pdfPath = resource.getFilePath();
                pdfName = resource.getResourceName() != null ? resource.getResourceName() : "Study Material";
            }
        }

        model.addAttribute("phaseObj", phase);
        model.addAttribute("title", resolvedTitle);
        model.addAttribute("pathId", pathId);
        model.addAttribute("videoUrl", videoUrl);
        model.addAttribute("pdfPath", pdfPath);
        model.addAttribute("pdfName", pdfName);
        return "students/student_module";
    }
    
    @GetMapping("/quiz")
    public String showQuiz(
            @RequestParam(value = "path", required = false) Integer pathId,
            @RequestParam(value = "phase", required = false) Integer phaseId,
            @RequestParam(value = "title", required = false) String title,
            Model model,
            HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;

        if (phaseId != null && phaseId > 0) {
            return "redirect:/student/quiz/" + phaseId;
        }

        Integer userId = (Integer) session.getAttribute("userId");

        if (phaseId != null && phaseId > 0) {
            Phase selectedPhase = phaseDAO.getPhaseById(phaseId);
            if (selectedPhase == null) {
                return "redirect:/student/resources";
            }
            if (userId == null || enrollmentDAO.getEnrollmentByUserAndPath(userId, selectedPhase.getPathId()) == null) {
                return "redirect:/student/course-details/" + selectedPhase.getPathId() + "?error=enroll_required";
            }
        } else if (pathId != null && pathId > 0) {
            if (userId == null || enrollmentDAO.getEnrollmentByUserAndPath(userId, pathId) == null) {
                return "redirect:/student/course-details/" + pathId + "?error=enroll_required";
            }
        }

        // If phase is selected, fetch quiz questions for that phase
        if (phaseId != null && phaseId > 0) {
            Phase phase = phaseDAO.getPhaseById(phaseId);
            List<QuizQuestion> questions = quizQuestionDAO.getQuestionsByPhaseId(phaseId);
            
            // Load options for each question
            for (QuizQuestion question : questions) {
                List<QuizOption> options = quizOptionDAO.getOptionsByQuestionId(question.getQuestionId());
                question.setOptions(options);
            }
            
            model.addAttribute("questions", questions);
            model.addAttribute("phase", phase);
            model.addAttribute("phaseId", phaseId);
            model.addAttribute("title", phase != null ? phase.getTitle() : (title != null ? title : "Assessment"));
            model.addAttribute("viewMode", "quiz");
        }
        // If path is provided, fetch all phases for selection
        else if (pathId != null && pathId > 0) {
            CareerPath path = pathDAO.getPathById(pathId);
            List<Phase> phases = phaseDAO.getPhasesByPathId(pathId);
            
            model.addAttribute("careerPath", path);
            model.addAttribute("phases", phases);
            model.addAttribute("pathId", pathId);
            model.addAttribute("viewMode", "select");
        }
        
        return "students/student_quiz";
    }

    @GetMapping("/quiz/{phaseId}")
    public String showQuizByPhaseId(
            @PathVariable("phaseId") int phaseId,
            Model model,
            HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;

        Integer userId = (Integer) session.getAttribute("userId");
        Phase phase = phaseDAO.getPhaseById(phaseId);
        if (phase == null) {
            return "redirect:/student/resources";
        }

        if (userId == null || enrollmentDAO.getEnrollmentByUserAndPath(userId, phase.getPathId()) == null) {
            return "redirect:/student/course-details/" + phase.getPathId() + "?error=enroll_required";
        }

        List<QuizQuestion> questions = quizQuestionDAO.getQuestionsByPhaseId(phaseId);
        for (QuizQuestion question : questions) {
            List<QuizOption> options = quizOptionDAO.getOptionsByQuestionId(question.getQuestionId());
            question.setOptions(options);
        }

        model.addAttribute("questions", questions);
        model.addAttribute("phase", phase);
        model.addAttribute("phaseId", phaseId);
        model.addAttribute("title", phase.getTitle());
        model.addAttribute("viewMode", "quiz");
        return "students/student_quiz";
    }


    @GetMapping("/progress")
    public String viewProgress(Model model, HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;
        
        try {
            int userId = (Integer) session.getAttribute("userId");
            
            // Fetch student's enrollments
            List<Enrollment> enrollments = enrollmentDAO.getEnrollmentsByUserId(userId);
            
            // Fetch path details for each enrollment
            java.util.List<java.util.Map<String, Object>> enrolledPaths = new java.util.ArrayList<>();
            if (enrollments != null) {
                for (Enrollment enrollment : enrollments) {
                    CareerPath path = pathDAO.getPathById(enrollment.getPathId());
                    if (path != null) {
                        java.util.Map<String, Object> pathData = new java.util.HashMap<>();
                        pathData.put("enrollment", enrollment);
                        pathData.put("path", path);
                        pathData.put("phases", phaseDAO.getPhasesByPathId(enrollment.getPathId()));
                        enrolledPaths.add(pathData);
                    }
                }
            }
            
            System.out.println("📚 Loaded " + enrolledPaths.size() + " enrolled courses for user " + userId);
            model.addAttribute("enrolledPaths", enrolledPaths);
            
        } catch (Exception e) {
            System.err.println("Error loading progress: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("enrolledPaths", new java.util.ArrayList<>());
        }
        
        return "students/student_progress";
    }

    @GetMapping("/certificates")
    public String certificates(HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;
        return "students/student_certificates";
    }

    @GetMapping("/resources")
    public String resources(org.springframework.ui.Model model, HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;
        
        try {
            int userId = (Integer) session.getAttribute("userId");
            
            // Get all published paths
            List<CareerPath> publishedPaths = pathDAO.getPublishedPaths();
            
            System.out.println("📚 Loaded " + publishedPaths.size() + " published career paths for student");
            model.addAttribute("careerPaths", publishedPaths);
            
        } catch (Exception e) {
            System.err.println("Error loading career paths: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("careerPaths", new java.util.ArrayList<>());
        }
        
        return "students/student_resources";
    }
    
    @GetMapping("/career")
    public String career(Model model, HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;
        
        Integer userId = (Integer) session.getAttribute("userId");
        
        // Fetch all published career paths from database
        List<CareerPath> careerPaths = pathDAO.getAllPaths();
        
        // Filter only published paths with enrollment status and creator check
        List<Map<String, Object>> pathsWithStatus = new ArrayList<>();
        if (careerPaths != null) {
            for (CareerPath path : careerPaths) {
                if ("PUBLISHED".equalsIgnoreCase(path.getStatus())) {
                    Map<String, Object> pathInfo = new HashMap<>();
                    pathInfo.put("path", path);
                    
                    // Check if user is the creator
                    boolean isCreator = userId != null && path.getCreatedBy() == userId;
                    pathInfo.put("isCreator", isCreator);
                    
                    if (isCreator) {
                        // Creator gets direct access, no enrollment needed, no certificate
                        pathInfo.put("isEnrolled", true);
                        pathInfo.put("canCertify", false);
                        pathInfo.put("enrollmentStatus", "Creator Access");
                    } else {
                        // Check if student is enrolled in this path
                        boolean isEnrolled = userId != null && enrollmentDAO.isEnrolled(userId, path.getPathId());
                        pathInfo.put("isEnrolled", isEnrolled);
                        pathInfo.put("enrollmentStatus", isEnrolled ? "Already Enrolled" : "Enroll Now");
                        
                        // Check if user can get certified (completed all phases + avg score >= 60%)
                        if (isEnrolled) {
                            boolean completedAllPhases = quizResponseDAO.hasCompletedAllPhasesInPath(userId, path.getPathId());
                            BigDecimal avgScore = quizResponseDAO.getAverageScoreForCareerPath(userId, path.getPathId());
                            boolean canCertify = completedAllPhases && avgScore.compareTo(new BigDecimal("60")) >= 0;
                            pathInfo.put("canCertify", canCertify);
                            pathInfo.put("avgScore", avgScore);
                        } else {
                            pathInfo.put("canCertify", false);
                        }
                    }
                    
                    pathsWithStatus.add(pathInfo);
                }
            }
        }
        
        model.addAttribute("careerPaths", pathsWithStatus);
        return "students/student_career_path";
    }

    @GetMapping("/quotes")
    public String quotes(HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;
        return "students/student_quotes";
    }

    // ==========================================
    // ℹ️ INFORMATION & SUPPORT
    // ==========================================

    @GetMapping("/about")
    public String about(HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;
        return "students/student_about";
    }

    @GetMapping("/features")
    public String features(HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;
        return "students/student_features";
    }

    @GetMapping("/contact")
    public String contact(Model model, HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;
        
        // Fetch admin users from database (receiver details)
        java.util.List<User> adminUsers = userDAO.getUsersByRole("ADMIN");
        
        if (adminUsers != null && !adminUsers.isEmpty()) {
            // Get first admin as primary contact
            User primaryAdmin = adminUsers.get(0);
            model.addAttribute("primaryAdmin", primaryAdmin);
            model.addAttribute("adminUsers", adminUsers);
        }
        
        return "students/student_contact";
    }

    @PostMapping("/contact")
    public String contactSubmit(
            @RequestParam("fullName") String fullName,
            @RequestParam("email") String email,
            @RequestParam("subject") String subject,
            @RequestParam("message") String message,
            @RequestParam(value = "adminEmail", required = false) String adminEmail,
            HttpSession session,
            org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {
        
        String r = checkAccess(session);
        if (r != null) return r;
        
        try {
            // Get admin email - use provided admin email or fetch from database
            String recipientEmail = adminEmail;
            if (recipientEmail == null || recipientEmail.isEmpty()) {
                java.util.List<User> admins = userDAO.getUsersByRole("ADMIN");
                if (admins != null && !admins.isEmpty()) {
                    recipientEmail = admins.get(0).getEmail();
                }
            }
            
            // If still no admin email, show error
            if (recipientEmail == null || recipientEmail.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Admin contact not available. Please try again later.");
                return "redirect:/student/contact";
            }
            
            // Prepare HTML email body
            String htmlBody = "<div style='font-family: Segoe UI, Tahoma, sans-serif; max-width: 600px; margin: auto; border: 1px solid #eef2f6; padding: 40px; border-radius: 20px; color: #1e293b;'>" +
                    "  <h2 style='color: #4913ec; margin-top: 0;'>New Contact Form Submission</h2>" +
                    "  <div style='background-color: #f8fafc; padding: 20px; border-radius: 12px; margin: 20px 0;'>" +
                    "    <p><strong>From:</strong> " + fullName + "</p>" +
                    "    <p><strong>Email:</strong> <a href='mailto:" + email + "'>" + email + "</a></p>" +
                    "    <p><strong>Subject:</strong> " + subject + "</p>" +
                    "  </div>" +
                    "  <div style='background-color: #f1f5f9; padding: 20px; border-radius: 12px; border-left: 4px solid #4913ec;'>" +
                    "    <h3 style='margin-top: 0; color: #0f172a;'>Message:</h3>" +
                    "    <p style='line-height: 1.6; color: #475569;'>" + message.replace("\n", "<br>") + "</p>" +
                    "  </div>" +
                    "  <p style='font-size: 12px; color: #94a3b8; border-top: 1px solid #f1f5f9; padding-top: 20px; text-align: center;'>&copy; 2026 PathPilot Contact System.</p>" +
                    "</div>";
            
            // Send email to admin
            emailService.sendEmailWithAttachment(recipientEmail, 
                    "New Contact Form: " + subject, 
                    htmlBody, 
                    null);
            
            // Also send confirmation to user
            String userConfirmation = "<div style='font-family: Segoe UI, Tahoma, sans-serif; max-width: 600px; margin: auto; border: 1px solid #eef2f6; padding: 40px; border-radius: 20px; color: #1e293b;'>" +
                    "  <h2 style='color: #4913ec; margin-top: 0;'>Message Received</h2>" +
                    "  <p style='line-height: 1.6;'>Thank you for contacting PathPilot. We have received your message and our support team will respond shortly.</p>" +
                    "  <p style='line-height: 1.6;'><strong>Your Subject:</strong> " + subject + "</p>" +
                    "  <p style='font-size: 12px; color: #94a3b8; border-top: 1px solid #f1f5f9; padding-top: 20px; text-align: center;'>&copy; 2026 PathPilot Support Team.</p>" +
                    "</div>";
            
            emailService.sendEmailWithAttachment(email, 
                    "PathPilot: We received your message", 
                    userConfirmation, 
                    null);
            
            redirectAttributes.addFlashAttribute("success", "✓ Your message has been sent! Our team will respond shortly.");
            return "redirect:/student/contact";
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to send message. Please try again.");
            e.printStackTrace();
            return "redirect:/student/contact";
        }
    }

    // ==========================================
    // ⚙️ ACTIONS (Database Updates)
    // ==========================================

    /**
     * 🔥 SECURE PROFILE UPDATE
     * Includes Old Password matching before allowing new password change.
     */
    @PostMapping("/update-profile")
    public String updateProfile(
            @RequestParam("fullName") String name,
            @RequestParam(value = "oldPassword", required = false) String oldPassword,
            @RequestParam(value = "newPassword", required = false) String newPassword,
            @RequestParam(value = "profileImage", required = false) MultipartFile file,
            HttpSession session) {

        String access = checkAccess(session);
        if (access != null) return access;

        int userId = (int) session.getAttribute("userId");
        String currentProfilePic = (String) session.getAttribute("profilePic");

        // 1. 🛡️ PASSWORD SECURITY CHECK
        // If user wants to change password, verify the old one first
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            boolean isOldPasswordCorrect = userDAO.verifyCurrentPassword(userId, oldPassword);
            if (!isOldPasswordCorrect) {
                // Redirect back with error code for SweetAlert
                return "redirect:/student/profile?error=wrong_password";
            }
        }

        // 2. 📂 FILE UPLOAD (Drive D:\)
        if (file != null && !file.isEmpty()) {
            try {
                String uploadDir = "D:/pathpilot/uploads/";
                File dir = new File(uploadDir);
                if (!dir.exists()) dir.mkdirs(); 

                String fileName = "profile_" + userId + "_" + System.currentTimeMillis() + ".jpg";
                File dest = new File(dir.getAbsolutePath() + File.separator + fileName);
                
                file.transferTo(dest);
                currentProfilePic = "/uploads/" + fileName; 
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        // 3. 💾 DATABASE UPDATE
        // Pass either newPassword (if verified) or null (to keep old one)
        boolean updated = userDAO.updateProfile(userId, name, newPassword, currentProfilePic);

        if (updated) {
            session.setAttribute("userName", name);
            session.setAttribute("profilePic", currentProfilePic);
            return "redirect:/student/profile?success=true";
        }

        return "redirect:/student/profile?error=server_error";
    }

    @PostMapping("/update-progress")
    public String handleProgressUpdate(@RequestParam String roadmapId, HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;
        return "redirect:/student/progress?status=updated";
    }

    @PostMapping("/quiz/submit")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> submitQuizResult(
            @RequestBody Map<String, Object> payload,
            HttpSession session) {
        String access = checkAccess(session);
        if (access != null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(java.util.Map.of("error", "UNAUTHORIZED"));
        }

        try {
            int userId = (Integer) session.getAttribute("userId");
            int phaseId = ((Number) payload.getOrDefault("phaseId", 0)).intValue();

            if (phaseId <= 0) {
                return ResponseEntity.badRequest().body(java.util.Map.of("error", "INVALID_PAYLOAD"));
            }

            Phase phase = phaseDAO.getPhaseById(phaseId);
            if (phase == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(java.util.Map.of("error", "PHASE_NOT_FOUND"));
            }

            Enrollment enrollment = null;
            List<Enrollment> enrollments = enrollmentDAO.getEnrollmentsByUserId(userId);
            for (Enrollment candidate : enrollments) {
                if (candidate.getPathId() == phase.getPathId()) {
                    enrollment = candidate;
                    break;
                }
            }

            if (enrollment == null) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(java.util.Map.of("error", "NOT_ENROLLED"));
            }

            List<QuizQuestion> questions = quizQuestionDAO.getQuestionsByPhaseId(phaseId);
            if (questions == null || questions.isEmpty()) {
                return ResponseEntity.badRequest().body(java.util.Map.of("error", "NO_QUESTIONS"));
            }

            java.util.Map<Integer, Integer> submittedAnswers = new java.util.HashMap<>();
            Object responsesRaw = payload.get("responses");
            if (responsesRaw instanceof List<?>) {
                for (Object item : (List<?>) responsesRaw) {
                    if (item instanceof Map<?, ?>) {
                        Object questionIdObj = ((Map<?, ?>) item).get("questionId");
                        Object selectedIndexObj = ((Map<?, ?>) item).get("selectedIndex");
                        if (questionIdObj instanceof Number && selectedIndexObj instanceof Number) {
                            submittedAnswers.put(((Number) questionIdObj).intValue(), ((Number) selectedIndexObj).intValue());
                        }
                    }
                }
            }

            int score = 0;
            int totalQuestions = questions.size();
            for (QuizQuestion question : questions) {
                Integer selectedIndex = submittedAnswers.get(question.getQuestionId());
                if (selectedIndex == null) {
                    continue;
                }
                String correctAnswer = question.getCorrectAnswer() != null ? question.getCorrectAnswer().trim().toUpperCase() : "";
                int correctIndex;
                switch (correctAnswer) {
                    case "A":
                        correctIndex = 0;
                        break;
                    case "B":
                        correctIndex = 1;
                        break;
                    case "C":
                        correctIndex = 2;
                        break;
                    case "D":
                        correctIndex = 3;
                        break;
                    default:
                        correctIndex = -1;
                }
                if (selectedIndex == correctIndex) {
                    score++;
                }
            }

            BigDecimal percentage = BigDecimal.valueOf(score)
                    .multiply(BigDecimal.valueOf(100))
                    .divide(BigDecimal.valueOf(totalQuestions), 2, java.math.RoundingMode.HALF_UP);
            boolean passed = percentage.compareTo(BigDecimal.valueOf(60)) >= 0;

                PhaseProgress progress = phaseProgressDAO.getProgressByEnrollmentAndPhase(enrollment.getEnrollmentId(), phaseId);
                int attempts = (progress != null ? progress.getAttempts() : 0) + 1;
                BigDecimal currentBest = (progress != null && progress.getBestScore() != null)
                    ? progress.getBestScore()
                    : BigDecimal.ZERO;
                boolean completed = (progress != null && progress.isCompleted()) || passed;
                BigDecimal bestScore = currentBest.max(percentage);

                phaseProgressDAO.upsertProgressByEnrollmentAndPhase(
                    enrollment.getEnrollmentId(),
                    phaseId,
                    completed,
                    attempts,
                    bestScore
                );

            PhaseProgress savedProgress = phaseProgressDAO.getProgressByEnrollmentAndPhase(enrollment.getEnrollmentId(), phaseId);
            if (savedProgress != null) {
                int progressId = savedProgress.getProgressId();
                quizResponseDAO.deleteResponsesByPhaseProgressId(progressId);

                for (QuizQuestion question : questions) {
                    Integer selectedIndex = submittedAnswers.get(question.getQuestionId());
                    String correctAnswer = question.getCorrectAnswer() != null ? question.getCorrectAnswer().trim().toUpperCase() : "";

                    int correctIndex;
                    switch (correctAnswer) {
                        case "A":
                            correctIndex = 0;
                            break;
                        case "B":
                            correctIndex = 1;
                            break;
                        case "C":
                            correctIndex = 2;
                            break;
                        case "D":
                            correctIndex = 3;
                            break;
                        default:
                            correctIndex = -1;
                    }

                    String selectedAnswer = null;
                    if (selectedIndex != null) {
                        switch (selectedIndex) {
                            case 0:
                                selectedAnswer = "A";
                                break;
                            case 1:
                                selectedAnswer = "B";
                                break;
                            case 2:
                                selectedAnswer = "C";
                                break;
                            case 3:
                                selectedAnswer = "D";
                                break;
                            default:
                                selectedAnswer = null;
                        }
                    }

                    boolean isCorrect = selectedIndex != null && selectedIndex == correctIndex;

                    QuizResponse quizResponse = new QuizResponse();
                    quizResponse.setPhaseProgressId(progressId);
                    quizResponse.setQuestionId(question.getQuestionId());
                    quizResponse.setSelectedAnswer(selectedAnswer);
                    quizResponse.setCorrect(isCorrect);
                    quizResponseDAO.addResponse(quizResponse);
                }
            }

            BigDecimal overall = phaseProgressDAO.calculateProgressPercentage(enrollment.getEnrollmentId());
            enrollmentDAO.updateProgress(enrollment.getEnrollmentId(), overall);
            if (overall.compareTo(BigDecimal.valueOf(100)) >= 0) {
                enrollmentDAO.completeEnrollment(enrollment.getEnrollmentId());
            }

            java.util.Map<String, Object> response = new java.util.HashMap<>();
            response.put("status", "QUIZ_SAVED");
            response.put("score", score);
            response.put("totalQuestions", totalQuestions);
            response.put("percentage", percentage);
            response.put("passed", passed);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(java.util.Map.of("error", "ERROR_SAVING_QUIZ"));
        }
    }
}