package com.pathpilot.controller;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.pathpilot.dao.UserDAO;
import com.pathpilot.dao.PathDAO;
import com.pathpilot.dao.PhaseDAO;
import com.pathpilot.dao.EnrollmentDAO;
import com.pathpilot.dao.PhaseProgressDAO;
import com.pathpilot.dao.PhaseResourceDAO;
import com.pathpilot.dao.QuizQuestionDAO;
import com.pathpilot.dao.QuizOptionDAO;
import com.pathpilot.dao.QuizResponseDAO;
import com.pathpilot.dao.UserStatisticsDAO;
import com.pathpilot.model.CareerPath;
import com.pathpilot.model.Enrollment;
import com.pathpilot.model.Phase;
import com.pathpilot.model.PhaseProgress;
import com.pathpilot.model.PhaseResource;
import com.pathpilot.model.QuizQuestion;
import com.pathpilot.model.QuizOption;
import com.pathpilot.model.User;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserDAO userDAO;

    @Autowired
    private PathDAO pathDAO;

    @Autowired
    private PhaseDAO phaseDAO;

    @Autowired
    private EnrollmentDAO enrollmentDAO;

    @Autowired
    private PhaseProgressDAO phaseProgressDAO;

    @Autowired
    private QuizQuestionDAO quizQuestionDAO;

    @Autowired
    private QuizOptionDAO quizOptionDAO;

    @Autowired
    private QuizResponseDAO quizResponseDAO;

    @Autowired
    private PhaseResourceDAO phaseResourceDAO;

    @Autowired
    private UserStatisticsDAO userStatisticsDAO;

    // ==========================================
    // 🔐 CENTRALIZED SESSION + ROLE CHECK
    // ==========================================
    private String checkAccess(HttpSession session) {
        if (session == null || session.getAttribute("role") == null) {
            return "redirect:/login";
        }

        String role = session.getAttribute("role").toString().trim().toUpperCase();
        // Supporting both 'USER' and 'STUDENT' if applicable, 
        // but strictly matching your "USER" logic here.
        if (!"USER".equals(role)) {
            return "redirect:/login";
        }

        return null; // Access granted
    }

    // ==========================================
    // 🏠 DASHBOARD / NAVIGATION
    // ==========================================

    @GetMapping("/UserHome")
    public String home(HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;
        return "user/user_home";
    }

    @GetMapping("/profile")
    public String profile(HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;
        return "user/user_profile";
    }

    @GetMapping("/settings")
    public String settings(HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;
        return "user/user_setting";
    }

    // ==========================================
    // ✍️ CREATOR FEATURES (Roadmap Management)
    // ==========================================

    @GetMapping("/career-mgmt")
    public String careerMgmt(org.springframework.ui.Model model, HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;
        
        try {
            int userId = (Integer) session.getAttribute("userId");
            
            // Fetch user's roadmaps from database
            java.util.List<CareerPath> myPaths = pathDAO.getPathsByUserId(userId);
            
            System.out.println("Loading career paths for User ID: " + userId);
            System.out.println("Found " + (myPaths != null ? myPaths.size() : 0) + " roadmaps");
            
            // Add roadmaps to model for JSP
            model.addAttribute("myPaths", myPaths != null ? myPaths : new java.util.ArrayList<>());
            
        } catch (Exception e) {
            System.err.println("Error loading roadmaps: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("myPaths", new java.util.ArrayList<>());
        }
        
        return "user/user-career-path-mgmt";
    }
    
    @GetMapping("/features")
    public String features(HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;
        return "user/user_features";
    }
    
    @GetMapping("/learner-mgmt")
    public String learner(HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;
        return "user/user-learner-mgmt";
    }


    @GetMapping("/create-path")
    public String createPathPage(HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;
        return "user/user_create_path";
    }

    @PostMapping("/create-path")
    @ResponseBody
    public ResponseEntity<String> createPathSubmit(
            @RequestParam("roadmapTitle") String title,
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "roadmapDesc", required = false) String description,
            @RequestParam(value = "level", required = false, defaultValue = "Beginner") String level,
            @RequestParam(value = "phaseTitles[]", required = false) String[] phaseTitles,
            @RequestParam(value = "phaseContents[]", required = false) String[] phaseContents,
            @RequestParam(value = "phaseLinks[]", required = false) String[] phaseLinks,
            @RequestParam(value = "status", required = false, defaultValue = "DRAFT") String status,
            HttpServletRequest request,
            HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("UNAUTHORIZED");
        
        try {
            int userId = (Integer) session.getAttribute("userId");
            
            System.out.println("\n" + "=".repeat(80));
            System.out.println("CREATE PATH SUBMISSION START - User ID: " + userId);
            System.out.println("Roadmap: " + title + " | Category: " + category + " | Level: " + level);
            System.out.println("=".repeat(80));
            
            // 1. Create CareerPath object and save to database
            CareerPath careerPath = new CareerPath();
            careerPath.setTitle(title);
            careerPath.setDescription(description != null ? description.trim() : "");
            careerPath.setCategory(category != null ? category.trim() : "");
            careerPath.setLevel(level);
            careerPath.setStatus(normalizeStatus(status));
            careerPath.setCreatedBy(userId);
            
            // Set total phases count BEFORE saving
            int totalPhases = (phaseTitles != null) ? phaseTitles.length : 0;
            careerPath.setTotalPhases(totalPhases);
            
            int pathId = pathDAO.addPath(careerPath);
            System.out.println("✅ Career Path Created: ID=" + pathId + " | Total Phases: " + totalPhases);
            
            // 2. Create Phases and their Quiz Questions
            savePhasesAndQuiz(pathId, phaseTitles, phaseContents, phaseLinks, request, userId);
            
            System.out.println("\n" + "=".repeat(80));
            System.out.println("✅ SUCCESS: Roadmap fully created with all phases and quiz questions!");
            System.out.println("=".repeat(80) + "\n");
            
            return ResponseEntity.ok("PATH_CREATED:" + pathId);
            
        } catch (Exception e) {
            System.err.println("\n❌ ERROR Creating Career Path:");
            e.printStackTrace();
            System.err.println("\n");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("ERROR: Failed to create career path");
        }
    }

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
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            boolean isOldPasswordCorrect = userDAO.verifyCurrentPassword(userId, oldPassword);
            if (!isOldPasswordCorrect) {
                return "redirect:/user/profile?error=wrong_password";
            }
        }

        // 2. 📂 FILE UPLOAD (D:\ drive storage)
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
        boolean updated = userDAO.updateProfile(userId, name, newPassword, currentProfilePic);

        if (updated) {
            session.setAttribute("userName", name);
            session.setAttribute("profilePic", currentProfilePic);
            return "redirect:/user/profile?success=true";
        }

        return "redirect:/user/profile?error=server_error";
    }

    @GetMapping("/edit-path")
    public String editPathPage(
            @RequestParam("id") int pathId,
            org.springframework.ui.Model model,
            HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;

        try {
            System.out.println("\nLoading roadmap for editing - Path ID: " + pathId);
            
            // Load career path from database
            CareerPath careerPath = pathDAO.getPathById(pathId);
            if (careerPath == null) {
                System.err.println("❌ Roadmap not found: " + pathId);
                return "redirect:/user/career-mgmt?error=notfound";
            }
            
            System.out.println("✅ Loaded Career Path: " + careerPath.getTitle());
            
            // Load all phases for this path
            java.util.List<Phase> phases = phaseDAO.getPhasesByPathId(pathId);
            System.out.println("✅ Loaded " + phases.size() + " phases");
            
            // For each phase, load quiz questions and options
            for (Phase phase : phases) {
                java.util.List<QuizQuestion> questions = quizQuestionDAO.getQuestionsByPhaseId(phase.getPhaseId());
                System.out.println("  Phase " + phase.getPhaseNumber() + ": " + questions.size() + " questions");
                
                // For each question, load options
                for (QuizQuestion question : questions) {
                    java.util.List<QuizOption> options = quizOptionDAO.getOptionsByQuestionId(question.getQuestionId());
                    question.setOptions(options);  // Store options in question
                    System.out.println("    Q" + question.getQuestionNumber() + ": " + options.size() + " options");
                }
                
                phase.setQuestions(questions);  // Store questions in phase

                java.util.List<PhaseResource> resources = phaseResourceDAO.getResourcesByPhaseId(phase.getPhaseId());
                for (PhaseResource resource : resources) {
                    if ("VIDEO".equalsIgnoreCase(resource.getResourceType()) && resource.getResourceUrl() != null) {
                        phase.setVideoResourceUrl(normalizeVideoEmbedUrl(resource.getResourceUrl()));
                    }
                    if (("PDF".equalsIgnoreCase(resource.getResourceType()) || "DOCUMENT".equalsIgnoreCase(resource.getResourceType()))
                            && resource.getFilePath() != null) {
                        phase.setFileResourcePath(resource.getFilePath());
                        phase.setFileResourceName(resource.getResourceName());
                    }
                }
            }
            
            // Pass data to JSP
            model.addAttribute("roadmap", careerPath);
            model.addAttribute("phases", phases);
            
            System.out.println("✅ Data loaded successfully for editing\n");
            return "user/user_edit_path";
            
        } catch (Exception e) {
            System.err.println("❌ Error loading roadmap: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/user/career-mgmt?error=loaderror";
        }
    }

    @PostMapping("/edit-path")
    @ResponseBody
    public ResponseEntity<String> editPathSubmit(
            @RequestParam("pathId") int pathId,
            @RequestParam("roadmapTitle") String title,
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "roadmapDesc", required = false) String description,
            @RequestParam(value = "level", required = false, defaultValue = "Beginner") String level,
            @RequestParam(value = "phaseIds[]", required = false) String[] phaseIds,
            @RequestParam(value = "phaseTitles[]", required = false) String[] phaseTitles,
            @RequestParam(value = "phaseContents[]", required = false) String[] phaseContents,
            @RequestParam(value = "phaseLinks[]", required = false) String[] phaseLinks,
            @RequestParam(value = "status", required = false, defaultValue = "DRAFT") String status,
            HttpServletRequest request,
            HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("UNAUTHORIZED");

        try {
            int userId = (Integer) session.getAttribute("userId");

            CareerPath existing = pathDAO.getPathById(pathId);
            if (existing == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("ERROR: Path not found");
            }
            if (existing.getCreatedBy() != userId) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("ERROR: Unauthorized update attempt");
            }

            CareerPath careerPath = new CareerPath();
            careerPath.setPathId(pathId);
            careerPath.setTitle(title);
            careerPath.setDescription(description != null ? description.trim() : "");
            careerPath.setCategory(category != null ? category.trim() : "");
            careerPath.setLevel(level);
            careerPath.setStatus(normalizeStatus(status));
            careerPath.setTotalPhases(phaseTitles != null ? phaseTitles.length : 0);

            int updated = pathDAO.updatePath(careerPath);
            if (updated <= 0) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                        .body("ERROR: Failed to update path header");
            }

            // Non-destructive update: update existing phases, insert new ones,
            // delete only phases intentionally removed from UI.
            upsertPhasesAndQuiz(pathId, phaseIds, phaseTitles, phaseContents, phaseLinks, request, userId);

            return ResponseEntity.ok("PATH_UPDATED:" + pathId);
        } catch (Exception e) {
            System.err.println("❌ Error updating roadmap: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("ERROR: Failed to update roadmap");
        }
    }

    private void savePhasesAndQuiz(int pathId, String[] phaseTitles, String[] phaseContents, String[] phaseLinks,
                                   HttpServletRequest request, int userId) {
        if (phaseTitles == null || phaseTitles.length == 0) {
            return;
        }

        System.out.println("\n📚 Processing " + phaseTitles.length + " phases...\n");

        for (int phaseIdx = 0; phaseIdx < phaseTitles.length; phaseIdx++) {
            String phaseTitle = phaseTitles[phaseIdx] != null ? phaseTitles[phaseIdx].trim() : "";
            if (phaseTitle.isEmpty()) {
                continue;
            }

            String phaseContent = (phaseContents != null && phaseIdx < phaseContents.length && phaseContents[phaseIdx] != null)
                    ? phaseContents[phaseIdx].trim()
                    : "";

            Phase phase = new Phase();
            phase.setPathId(pathId);
            phase.setPhaseNumber(phaseIdx + 1);
            phase.setTitle(phaseTitle);
            phase.setContent(phaseContent);
            phase.setCompleted(false);

            int phaseId = phaseDAO.addPhase(phase);
            int phaseNum = phaseIdx + 1;
            int questionCount = 0;

                String videoLink = (phaseLinks != null && phaseIdx < phaseLinks.length && phaseLinks[phaseIdx] != null)
                    ? phaseLinks[phaseIdx].trim()
                    : "";
                saveVideoResourceForPhase(phaseId, videoLink, userId);

            for (int qNum = 1; qNum <= 5; qNum++) {
                String questionText = resolveQuestionText(request, phaseNum, qNum, false);
                if (questionText.isEmpty()) {
                    continue;
                }

                String correctAnswer = normalizeAnswer(resolveCorrectAnswer(request, phaseNum, qNum, false));

                QuizQuestion quizQuestion = new QuizQuestion();
                quizQuestion.setPhaseId(phaseId);
                quizQuestion.setQuestionNumber(qNum);
                quizQuestion.setQuestionText(questionText);
                quizQuestion.setCorrectAnswer(correctAnswer);
                quizQuestion.setDifficultyLevel("Medium");

                int questionId = quizQuestionDAO.addQuestion(quizQuestion);
                questionCount++;

                saveOption(questionId, "A", resolveOptionText(request, phaseNum, qNum, "A", false), correctAnswer);
                saveOption(questionId, "B", resolveOptionText(request, phaseNum, qNum, "B", false), correctAnswer);
                saveOption(questionId, "C", resolveOptionText(request, phaseNum, qNum, "C", false), correctAnswer);
                saveOption(questionId, "D", resolveOptionText(request, phaseNum, qNum, "D", false), correctAnswer);
            }

            System.out.println("  [Phase " + phaseNum + "] ✅ Created ID=" + phaseId + " | Title: " + phaseTitle + " | Questions: " + questionCount);
        }
    }

    private void upsertPhasesAndQuiz(int pathId, String[] phaseIds, String[] phaseTitles, String[] phaseContents,
                                     String[] phaseLinks, HttpServletRequest request, int userId) {
        List<Phase> existingPhases = phaseDAO.getPhasesByPathId(pathId);
        Set<Integer> submittedExistingPhaseIds = new HashSet<>();

        if (phaseIds != null) {
            for (String phaseIdValue : phaseIds) {
                if (phaseIdValue == null || phaseIdValue.trim().isEmpty()) {
                    continue;
                }
                try {
                    int parsed = Integer.parseInt(phaseIdValue.trim());
                    if (parsed > 0) {
                        submittedExistingPhaseIds.add(parsed);
                    }
                } catch (Exception ignored) {
                }
            }
        }

        // IMPORTANT: delete removed phases first, before renumbering existing ones,
        // to avoid UNIQUE(path_id, phase_number) conflicts during updates.
        for (Phase existing : existingPhases) {
            if (!submittedExistingPhaseIds.contains(existing.getPhaseId())) {
                phaseDAO.deletePhase(existing.getPhaseId());
            }
        }

        if (phaseTitles == null) {
            phaseTitles = new String[0];
        }

        for (int phaseIdx = 0; phaseIdx < phaseTitles.length; phaseIdx++) {
            String phaseTitle = phaseTitles[phaseIdx] != null ? phaseTitles[phaseIdx].trim() : "";
            if (phaseTitle.isEmpty()) {
                continue;
            }

            String phaseContent = (phaseContents != null && phaseIdx < phaseContents.length && phaseContents[phaseIdx] != null)
                    ? phaseContents[phaseIdx].trim()
                    : "";
            String videoLink = (phaseLinks != null && phaseIdx < phaseLinks.length && phaseLinks[phaseIdx] != null)
                    ? phaseLinks[phaseIdx].trim()
                    : "";

            int parsedPhaseId = parsePositiveInt(phaseIds, phaseIdx);
            int phaseId;

            if (parsedPhaseId > 0) {
                Phase existing = phaseDAO.getPhaseById(parsedPhaseId);
                if (existing != null && existing.getPathId() == pathId) {
                    existing.setTitle(phaseTitle);
                    existing.setContent(phaseContent);
                    existing.setPhaseNumber(phaseIdx + 1);
                    phaseDAO.updatePhase(existing);
                    phaseId = existing.getPhaseId();
                } else {
                    phaseId = createPhase(pathId, phaseIdx + 1, phaseTitle, phaseContent);
                }
            } else {
                phaseId = createPhase(pathId, phaseIdx + 1, phaseTitle, phaseContent);
            }

            saveVideoResourceForPhase(phaseId, videoLink, userId);

            boolean isExistingPhase = parsedPhaseId > 0;
            boolean hasPhaseScopedQuizPayload = hasPhaseScopedQuizPayload(request, phaseIdx + 1);
            System.out.println("[EDIT DEBUG] Phase " + (phaseIdx + 1) + " | phaseId=" + phaseId + " | existing=" + isExistingPhase + " | hasScopedPayload=" + hasPhaseScopedQuizPayload);
            if (hasPhaseScopedQuizPayload || !isExistingPhase) {
                quizQuestionDAO.deleteQuestionsByPhaseId(phaseId);
                int inserted = saveQuizForPhase(phaseId, phaseIdx + 1, request, !isExistingPhase);
                System.out.println("[EDIT DEBUG] Phase " + (phaseIdx + 1) + " | insertedQuestions=" + inserted);
                if (isExistingPhase && inserted == 0) {
                    // Safety: keep old data if parsing unexpectedly produced nothing
                    // (existing phase questions were deleted above only when payload detected)
                    System.out.println("⚠️ No quiz rows parsed for existing phase " + phaseId + " (phase " + (phaseIdx + 1) + ")");
                }
            }
        }

    }

    private int createPhase(int pathId, int phaseNumber, String title, String content) {
        Phase phase = new Phase();
        phase.setPathId(pathId);
        phase.setPhaseNumber(phaseNumber);
        phase.setTitle(title);
        phase.setContent(content);
        phase.setCompleted(false);
        return phaseDAO.addPhase(phase);
    }

    private int saveQuizForPhase(int phaseId, int phaseNum, HttpServletRequest request, boolean allowGenericFallback) {
        int insertedCount = 0;
        for (int qNum = 1; qNum <= 5; qNum++) {
            String questionText = resolveQuestionText(request, phaseNum, qNum, allowGenericFallback);
            if (questionText.isEmpty()) {
                continue;
            }

            String correctAnswer = normalizeAnswer(resolveCorrectAnswer(request, phaseNum, qNum, allowGenericFallback));

            QuizQuestion quizQuestion = new QuizQuestion();
            quizQuestion.setPhaseId(phaseId);
            quizQuestion.setQuestionNumber(qNum);
            quizQuestion.setQuestionText(questionText);
            quizQuestion.setCorrectAnswer(correctAnswer);
            quizQuestion.setDifficultyLevel("Medium");

            int questionId = quizQuestionDAO.addQuestion(quizQuestion);
            insertedCount++;

            saveOption(questionId, "A", resolveOptionText(request, phaseNum, qNum, "A", allowGenericFallback), correctAnswer);
            saveOption(questionId, "B", resolveOptionText(request, phaseNum, qNum, "B", allowGenericFallback), correctAnswer);
            saveOption(questionId, "C", resolveOptionText(request, phaseNum, qNum, "C", allowGenericFallback), correctAnswer);
            saveOption(questionId, "D", resolveOptionText(request, phaseNum, qNum, "D", allowGenericFallback), correctAnswer);
        }
        return insertedCount;
    }

    private void saveVideoResourceForPhase(int phaseId, String videoLink, int userId) {
        if (videoLink == null || videoLink.trim().isEmpty()) {
            return;
        }
        phaseResourceDAO.deleteResourcesByPhaseAndType(phaseId, "VIDEO");
        PhaseResource videoResource = new PhaseResource();
        videoResource.setPhaseId(phaseId);
        videoResource.setResourceType("VIDEO");
        videoResource.setResourceName("Video Resource");
        videoResource.setResourceUrl(videoLink.trim());
        videoResource.setUploadedBy(userId);
        phaseResourceDAO.addResource(videoResource);
    }

    private boolean hasPhaseScopedQuizPayload(HttpServletRequest request, int phaseNum) {
        String phasePrefix = "phaseQuiz_P" + phaseNum + "_";
        for (String key : request.getParameterMap().keySet()) {
            if (key != null && key.startsWith(phasePrefix)) {
                return true;
            }
        }
        return false;
    }

    private int parsePositiveInt(String[] values, int index) {
        if (values == null || index < 0 || index >= values.length || values[index] == null) {
            return -1;
        }
        try {
            int parsed = Integer.parseInt(values[index].trim());
            return parsed > 0 ? parsed : -1;
        } catch (Exception ex) {
            return -1;
        }
    }

    private void saveOption(int questionId, String label, String text, String correctAnswer) {
        QuizOption option = new QuizOption();
        option.setQuestionId(questionId);
        option.setOptionLabel(label);
        option.setOptionText(text);
        option.setCorrect(label.equals(correctAnswer));
        quizOptionDAO.addOption(option);
    }

    private String firstParamValue(HttpServletRequest request, String paramName) {
        String[] values = request.getParameterValues(paramName);
        if ((values == null || values.length == 0 || values[0] == null) && paramName.endsWith("[]")) {
            String withoutBrackets = paramName.substring(0, paramName.length() - 2);
            values = request.getParameterValues(withoutBrackets);
        }
        if (values == null || values.length == 0) {
            return "";
        }
        for (String value : values) {
            if (value != null && !value.trim().isEmpty()) {
                return value.trim();
            }
        }
        return "";
    }

    private String resolveQuestionText(HttpServletRequest request, int phaseNum, int qNum, boolean allowGenericFallback) {
        String value = firstParamValue(request, "phaseQuiz_P" + phaseNum + "_Q" + qNum + "[]");
        if (!value.isEmpty()) return value;
        value = firstParamByRegex(request, "^phaseQuiz_P" + phaseNum + "_Q" + qNum + "(?:\\[\\])?$");
        if (!value.isEmpty()) return value;

        if (allowGenericFallback) {
            value = firstParamValue(request, "phaseQuiz_Q" + qNum + "[]");
            if (!value.isEmpty()) return value;
            return firstParamByRegex(request, "^phaseQuiz_Q" + qNum + "(?:\\[\\])?$");
        }
        return "";
    }

    private String resolveOptionText(HttpServletRequest request, int phaseNum, int qNum, String label, boolean allowGenericFallback) {
        String value = firstParamValue(request, "phaseQuiz_P" + phaseNum + "_" + label + "_Q" + qNum + "[]");
        if (!value.isEmpty()) return value;
        value = firstParamByRegex(request, "^phaseQuiz_P" + phaseNum + "_" + label + "_Q" + qNum + "(?:\\[\\])?$");
        if (!value.isEmpty()) return value;

        if (allowGenericFallback) {
            value = firstParamValue(request, "phaseQuiz_" + label + "_Q" + qNum + "[]");
            if (!value.isEmpty()) return value;
            return firstParamByRegex(request, "^phaseQuiz_" + label + "_Q" + qNum + "(?:\\[\\])?$");
        }
        return "";
    }

    private String resolveCorrectAnswer(HttpServletRequest request, int phaseNum, int qNum, boolean allowGenericFallback) {
        String value = request.getParameter("phaseQuiz_Correct_P" + phaseNum + "_Q" + qNum);
        if (value != null && !value.trim().isEmpty()) {
            return value.trim();
        }
        value = firstParamByRegex(request, "^phaseQuiz_Correct_P" + phaseNum + "_Q" + qNum + "$");
        if (!value.isEmpty()) return value;

        if (allowGenericFallback) {
            value = request.getParameter("phaseQuiz_Correct_Q" + qNum + "_temp");
            if (value != null && !value.trim().isEmpty()) {
                return value.trim();
            }
            return firstParamByRegex(request, "^phaseQuiz_Correct_Q" + qNum + "_temp$");
        }
        return "";
    }

    private String firstParamByRegex(HttpServletRequest request, String regex) {
        for (Map.Entry<String, String[]> entry : request.getParameterMap().entrySet()) {
            if (entry.getKey().matches(regex)) {
                String[] values = entry.getValue();
                if (values == null || values.length == 0) {
                    continue;
                }
                for (String value : values) {
                    if (value != null && !value.trim().isEmpty()) {
                        return value.trim();
                    }
                }
            }
        }
        return "";
    }

    private String normalizeStatus(String status) {
        if (status == null) {
            return "DRAFT";
        }
        String normalized = status.trim().toUpperCase(Locale.ROOT);
        return "PUBLISHED".equals(normalized) ? "PUBLISHED" : "DRAFT";
    }

    private String normalizeAnswer(String answer) {
        if (answer == null) {
            return "A";
        }
        String normalized = answer.trim().toUpperCase(Locale.ROOT);
        return ("A".equals(normalized) || "B".equals(normalized) || "C".equals(normalized) || "D".equals(normalized))
                ? normalized
                : "A";
    }

    private String normalizeVideoEmbedUrl(String rawUrl) {
        if (rawUrl == null || rawUrl.trim().isEmpty()) {
            return "";
        }

        String url = rawUrl.trim();
        if (url.contains("youtube.com/embed/")) {
            return url;
        }

        String videoId = null;

        Matcher watchMatcher = Pattern.compile("[?&]v=([A-Za-z0-9_-]{6,})").matcher(url);
        if (watchMatcher.find()) {
            videoId = watchMatcher.group(1);
        }

        if (videoId == null) {
            Matcher shortMatcher = Pattern.compile("youtu\\.be/([A-Za-z0-9_-]{6,})").matcher(url);
            if (shortMatcher.find()) {
                videoId = shortMatcher.group(1);
            }
        }

        if (videoId == null) {
            Matcher shortsMatcher = Pattern.compile("youtube\\.com/shorts/([A-Za-z0-9_-]{6,})").matcher(url);
            if (shortsMatcher.find()) {
                videoId = shortsMatcher.group(1);
            }
        }

        if (videoId == null) {
            Matcher liveMatcher = Pattern.compile("youtube\\.com/live/([A-Za-z0-9_-]{6,})").matcher(url);
            if (liveMatcher.find()) {
                videoId = liveMatcher.group(1);
            }
        }

        return videoId != null ? "https://www.youtube.com/embed/" + videoId : url;
    }

    @PostMapping("/create-path/upload-phase-file")
    @ResponseBody
    public ResponseEntity<String> uploadPhaseFile(
            @RequestParam("pathId") int pathId,
            @RequestParam("phaseNumber") int phaseNumber,
            @RequestParam("attachment") MultipartFile attachment,
            HttpSession session) {
        String access = checkAccess(session);
        if (access != null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("ERROR: Unauthorized");
        }

        try {
            if (attachment == null || attachment.isEmpty()) {
                return ResponseEntity.badRequest().body("ERROR: No file provided");
            }

            CareerPath path = pathDAO.getPathById(pathId);
            if (path == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("ERROR: Path not found");
            }

            int userId = (Integer) session.getAttribute("userId");
            if (path.getCreatedBy() != userId) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("ERROR: Unauthorized");
            }

            Phase phase = phaseDAO.getPhaseByPathIdAndNumber(pathId, phaseNumber);
            if (phase == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("ERROR: Phase not found");
            }

            String originalName = attachment.getOriginalFilename() != null ? attachment.getOriginalFilename() : "resource";
            String safeName = originalName.replaceAll("[^a-zA-Z0-9._-]", "_");
            String fileName = "path_" + pathId + "_phase_" + phaseNumber + "_" + System.currentTimeMillis() + "_" + safeName;

            Path uploadRoot = Paths.get("D:/pathpilot/uploads");
            Files.createDirectories(uploadRoot);
            Path target = uploadRoot.resolve(fileName);
            Files.copy(attachment.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);

            String mime = attachment.getContentType() != null ? attachment.getContentType() : "application/octet-stream";
            String resourceType = mime.contains("pdf") ? "PDF" : "DOCUMENT";

            phaseResourceDAO.deleteResourcesByPhaseAndType(phase.getPhaseId(), "PDF");
            phaseResourceDAO.deleteResourcesByPhaseAndType(phase.getPhaseId(), "DOCUMENT");

            PhaseResource resource = new PhaseResource();
            resource.setPhaseId(phase.getPhaseId());
            resource.setResourceType(resourceType);
            resource.setResourceName(originalName);
            resource.setFilePath("/uploads/" + fileName);
            resource.setFileSize(attachment.getSize());
            resource.setMimeType(mime);
            resource.setUploadedBy(userId);
            phaseResourceDAO.addResource(resource);

            return ResponseEntity.ok("RESOURCE_SAVED|" + resource.getFilePath() + "|" + originalName);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("ERROR: Upload failed");
        }
    }

    @PostMapping("/delete-path")
    public String deletePath(
            @RequestParam("pathId") int pathId,
            HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;

        try {
            int userId = (Integer) session.getAttribute("userId");
            
            // Verify user owns this roadmap before deleting
            CareerPath path = pathDAO.getPathById(pathId);
            if (path == null) {
                System.err.println("❌ Roadmap not found: " + pathId);
                return "redirect:/user/career-mgmt?error=notfound";
            }
            
            if (path.getCreatedBy() != userId) {
                System.err.println("❌ Unauthorized delete attempt - User " + userId + " tried to delete path by " + path.getCreatedBy());
                return "redirect:/user/career-mgmt?error=unauthorized";
            }

            // Explicit cleanup: remove resources under each phase before path delete
            // (keeps behavior safe even if FK cascade is missing/inconsistent)
            java.util.List<Phase> phases = phaseDAO.getPhasesByPathId(pathId);
            for (Phase phase : phases) {
                java.util.List<QuizQuestion> questions = quizQuestionDAO.getQuestionsByPhaseId(phase.getPhaseId());
                for (QuizQuestion question : questions) {
                    quizOptionDAO.deleteOptionsByQuestionId(question.getQuestionId());
                }
                quizQuestionDAO.deleteQuestionsByPhaseId(phase.getPhaseId());
                phaseResourceDAO.deleteResourcesByPhaseId(phase.getPhaseId());
            }
            
            // Delete the career path (cascades to phases, questions, options)
            int result = pathDAO.deletePath(pathId);
            
            if (result > 0) {
                System.out.println("✅ Roadmap deleted successfully - Path ID: " + pathId);
                System.out.println("   Title: " + path.getTitle());
            } else {
                System.err.println("❌ Failed to delete roadmap: " + pathId);
                return "redirect:/user/career-mgmt?error=deletefailed";
            }
            
            return "redirect:/user/career-mgmt?status=deleted";
            
        } catch (Exception e) {
            System.err.println("❌ Error deleting roadmap: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/user/career-mgmt?error=deleteerror";
        }
    }

    // ==========================================
    // 🎓 LEARNER SECTION (Learning & Progress)
    // ==========================================

    @GetMapping("/career")
    public String career(Model model, HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;

        Integer userId = (Integer) session.getAttribute("userId");

        List<CareerPath> careerPaths = pathDAO.getAllPaths();
        List<Map<String, Object>> pathsWithStatus = new ArrayList<>();

        if (careerPaths != null) {
            for (CareerPath path : careerPaths) {
                if (!"PUBLISHED".equalsIgnoreCase(path.getStatus())) {
                    continue;
                }

                Map<String, Object> pathInfo = new HashMap<>();
                pathInfo.put("path", path);

                List<Phase> phases = phaseDAO.getPhasesByPathId(path.getPathId());
                pathInfo.put("phases", phases != null ? phases : new ArrayList<>());

                boolean isCreator = userId != null && path.getCreatedBy() == userId;
                pathInfo.put("isCreator", isCreator);

                if (isCreator) {
                    pathInfo.put("isEnrolled", true);
                    pathInfo.put("canCertify", false);
                    pathInfo.put("enrollmentStatus", "Creator Access");
                } else {
                    boolean isEnrolled = userId != null && enrollmentDAO.isEnrolled(userId, path.getPathId());
                    pathInfo.put("isEnrolled", isEnrolled);
                    pathInfo.put("enrollmentStatus", isEnrolled ? "Already Enrolled" : "Enroll Now");

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

        model.addAttribute("careerPaths", pathsWithStatus);
        return "user/user_career_path";
    }

    @GetMapping("/enroll")
    public String enrollPage(@RequestParam(value = "id", required = false) Integer pathId,
                             Model model,
                             HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;

        if (pathId == null) {
            return "redirect:/user/career";
        }

        try {
            CareerPath careerPath = pathDAO.getPathById(pathId);
            if (careerPath == null || !"PUBLISHED".equalsIgnoreCase(careerPath.getStatus())) {
                return "redirect:/user/career";
            }

            List<Phase> phases = phaseDAO.getPhasesByPathId(pathId);
            model.addAttribute("careerPath", careerPath);
            model.addAttribute("phases", phases != null ? phases : new ArrayList<>());
        } catch (Exception e) {
            System.err.println("Error loading enroll page data: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/user/career";
        }

        return "user/user_enroll";
    }

    @PostMapping("/enroll")
    public String submitEnrollment(@RequestParam("pathId") int pathId,
                                   @RequestParam(value = "phone", required = false) String phone,
                                   HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;

        try {
            int userId = (Integer) session.getAttribute("userId");

            CareerPath path = pathDAO.getPathById(pathId);
            if (path == null || !"PUBLISHED".equalsIgnoreCase(path.getStatus())) {
                return "redirect:/user/career?error=path_not_found";
            }

            User currentUser = userDAO.getUserById(userId);
            String submittedPhone = phone != null ? phone.trim() : "";
            if (currentUser != null && !submittedPhone.isEmpty()) {
                String existingPhone = currentUser.getPhone() != null ? currentUser.getPhone().trim() : "";
                if (!submittedPhone.equals(existingPhone)) {
                    userDAO.updatePhone(userId, submittedPhone);
                }
            }

            if (enrollmentDAO.isEnrolled(userId, pathId)) {
                return "redirect:/user/view-path?id=" + pathId;
            }

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
                return "redirect:/user/view-path?id=" + pathId;
            }

            return "redirect:/user/enroll?id=" + pathId + "&error=enrollment_failed";
        } catch (Exception e) {
            System.err.println("❌ Error processing user enrollment: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/user/enroll?id=" + pathId + "&error=enrollment_error";
        }
    }

    @GetMapping("/view-path")
    public String viewPath(@RequestParam("id") int pathId,
                           HttpSession session,
                           RedirectAttributes redirectAttributes) {
        String r = checkAccess(session);
        if (r != null) return r;

        Integer userId = (Integer) session.getAttribute("userId");
        CareerPath path = pathDAO.getPathById(pathId);

        if (path == null || !"PUBLISHED".equalsIgnoreCase(path.getStatus())) {
            redirectAttributes.addFlashAttribute("error", "Path not found");
            return "redirect:/user/career";
        }

        if (userId != null && path.getCreatedBy() == userId) {
            return "redirect:/user/edit-path?id=" + pathId;
        }

        boolean isEnrolled = userId != null && enrollmentDAO.isEnrolled(userId, pathId);
        if (isEnrolled && userId != null) {
            List<Map<String, Object>> enrollments = enrollmentDAO.getAllEnrollmentDetailsForUser(userId);
            for (Map<String, Object> enrollment : enrollments) {
                if (((Number) enrollment.get("path_id")).intValue() == pathId) {
                    int enrollmentId = ((Number) enrollment.get("enrollment_id")).intValue();
                    return "redirect:/user/progress?enrollmentId=" + enrollmentId;
                }
            }
        }

        return "redirect:/user/enroll?id=" + pathId;
    }

    @GetMapping("/course_detail")
    public String courseDetail(HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;
        return "user/user_course_details";
    }

    @GetMapping("/module")
    public String moduleContent(
            @RequestParam(value = "phaseId", required = false) Integer phaseId,
            @RequestParam(value = "phase", required = false) String phase,
            @RequestParam(value = "title", required = false) String title,
            Model model,
            HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;

        if (phaseId == null && phase != null) {
            try {
                phaseId = Integer.parseInt(phase.trim());
            } catch (Exception ignored) {
            }
        }

        if (phaseId == null || phaseId <= 0) {
            return "redirect:/user/progress?error=phase_not_found";
        }

        int userId = (Integer) session.getAttribute("userId");
        Phase phaseObj = phaseDAO.getPhaseById(phaseId);
        if (phaseObj == null) {
            return "redirect:/user/progress?error=phase_not_found";
        }

        Enrollment enrollment = enrollmentDAO.getEnrollmentByUserAndPath(userId, phaseObj.getPathId());
        if (enrollment == null) {
            return "redirect:/user/enroll?id=" + phaseObj.getPathId();
        }

        String resolvedTitle = (title != null && !title.trim().isEmpty()) ? title : phaseObj.getTitle();
        String videoUrl = "";
        String pdfPath = "";
        String pdfName = "";

        List<PhaseResource> resources = phaseResourceDAO.getResourcesByPhaseId(phaseId);
        for (PhaseResource resource : resources) {
            if (videoUrl.isEmpty() && "VIDEO".equalsIgnoreCase(resource.getResourceType()) && resource.getResourceUrl() != null) {
                videoUrl = normalizeVideoEmbedUrl(resource.getResourceUrl());
            }
            if (pdfPath.isEmpty() && ("PDF".equalsIgnoreCase(resource.getResourceType()) || "DOCUMENT".equalsIgnoreCase(resource.getResourceType()))
                    && resource.getFilePath() != null) {
                pdfPath = resource.getFilePath();
                pdfName = resource.getResourceName() != null ? resource.getResourceName() : "Study Material";
            }
        }

        model.addAttribute("phaseObj", phaseObj);
        model.addAttribute("title", resolvedTitle);
        model.addAttribute("videoUrl", videoUrl);
        model.addAttribute("pdfPath", pdfPath);
        model.addAttribute("pdfName", pdfName);
        return "user/user_module";
    }

    @GetMapping("/quiz")
    public String showQuiz(
            @RequestParam(value = "phaseId", required = false) Integer phaseId,
            @RequestParam(value = "phase", required = false) String phase,
            HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;

        if (phaseId == null && phase != null) {
            try {
                phaseId = Integer.parseInt(phase.trim());
            } catch (Exception ignored) {
            }
        }

        if (phaseId == null || phaseId <= 0) {
            return "redirect:/user/progress?error=phase_not_found";
        }

        return "redirect:/student/quiz/" + phaseId;
    }

    @GetMapping("/progress")
    public String progress(@RequestParam(value = "enrollmentId", required = false) Integer enrollmentId,
                           Model model,
                           HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;

        try {
            int userId = (Integer) session.getAttribute("userId");

            if (enrollmentId == null) {
                List<Enrollment> enrollments = enrollmentDAO.getEnrollmentsByUserId(userId);
                if (enrollments == null || enrollments.isEmpty()) {
                    model.addAttribute("careerPath", new CareerPath());
                    model.addAttribute("phasesList", new ArrayList<>());
                    model.addAttribute("phaseProgressList", new ArrayList<>());
                    model.addAttribute("userStats", new HashMap<String, Object>());
                    return "user/user_progress";
                }
                enrollmentId = enrollments.get(0).getEnrollmentId();
            }

            Enrollment enrollment = enrollmentDAO.getEnrollmentById(enrollmentId);
            if (enrollment == null || enrollment.getUserId() != userId) {
                return "redirect:/user/career";
            }

            CareerPath careerPath = pathDAO.getPathById(enrollment.getPathId());
            List<Map<String, Object>> rawPhaseRows = phaseProgressDAO.getPhaseProgressByPathId(enrollment.getPathId(), enrollmentId);
            List<Map<String, Object>> phasesList = new ArrayList<>();

            for (Map<String, Object> row : rawPhaseRows) {
                Map<String, Object> normalized = new HashMap<>(row);
                normalized.put("phaseId", row.get("phase_id"));
                normalized.put("title", row.get("phase_title"));
                normalized.put("content", row.get("phase_content"));
                phasesList.add(normalized);
            }

            Map<String, Object> userStats = userStatisticsDAO.getUserStatistics(userId, enrollmentId);

            model.addAttribute("careerPath", careerPath != null ? careerPath : new CareerPath());
            model.addAttribute("phasesList", phasesList);
            model.addAttribute("phaseProgressList", phasesList);
            model.addAttribute("userStats", userStats != null ? userStats : new HashMap<String, Object>());
            model.addAttribute("enrollmentId", enrollmentId);
        } catch (Exception e) {
            System.err.println("Error loading user progress: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("careerPath", new CareerPath());
            model.addAttribute("phasesList", new ArrayList<>());
            model.addAttribute("phaseProgressList", new ArrayList<>());
            model.addAttribute("userStats", new HashMap<String, Object>());
        }

        return "user/user_progress";
    }

    @PostMapping("/progress")
    public String updateProgress(@RequestParam("title") String title, HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;

        return "redirect:/user/progress?title=" + title;
    }

    @GetMapping("/certificates")
    public String certificates(HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;
        return "user/user_certificates";
    }

    // ==========================================
    // ℹ️ INFORMATION & SHARED PAGES
    // ==========================================

    @GetMapping("/resources")
    public String resources(HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;
        return "user/user_resources";
    }

    @GetMapping("/about")
    public String about(HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;
        return "user/user_about";
    }

    @GetMapping("/contact")
    public String contact(HttpSession session) {
        String r = checkAccess(session);
        if (r != null) return r;
        return "user/user_contact";
    }
}