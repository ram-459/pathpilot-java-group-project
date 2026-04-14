version: '1.0'
-- ============================================================
-- PathPilot Database Schema
-- Database: pathpilots_db
-- ============================================================

CREATE DATABASE IF NOT EXISTS pathpilots_db;
USE pathpilots_db;

-- ============================================================
-- 1. USERS TABLE
-- ============================================================
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20) DEFAULT NULL,
    role VARCHAR(50) DEFAULT 'student',
    status VARCHAR(50) DEFAULT 'INACTIVE',
    token VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_verified TINYINT(1) DEFAULT 0
);

-- ============================================================
-- 2. CAREER PATH TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS career_paths (
    path_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(100) NOT NULL,
    level ENUM('Beginner', 'Intermediate', 'Advanced') NOT NULL,
    status ENUM('DRAFT', 'PUBLISHED') DEFAULT 'DRAFT',
    created_by INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    published_at TIMESTAMP NULL,
    total_phases INT DEFAULT 0,
    INDEX idx_status (status),
    INDEX idx_level (level),
    INDEX idx_category (category),
    INDEX idx_created_by (created_by),
    INDEX idx_created_at (created_at),
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 3. PHASE TABLE (Learning phases within a path)
-- ============================================================
CREATE TABLE IF NOT EXISTS phases (
    phase_id INT PRIMARY KEY AUTO_INCREMENT,
    path_id INT NOT NULL,
    phase_number INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    content LONGTEXT NOT NULL,
    is_completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_path_phase (path_id, phase_number),
    INDEX idx_path_id (path_id),
    FOREIGN KEY (path_id) REFERENCES career_paths(path_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 4. QUIZ QUESTIONS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS quiz_questions (
    question_id INT PRIMARY KEY AUTO_INCREMENT,
    phase_id INT NOT NULL,
    question_number INT NOT NULL,
    question_text TEXT NOT NULL,
    correct_answer ENUM('A', 'B', 'C', 'D') NOT NULL,
    difficulty_level VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_phase_question (phase_id, question_number),
    INDEX idx_phase_id (phase_id),
    FOREIGN KEY (phase_id) REFERENCES phases(phase_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 5. QUIZ OPTIONS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS quiz_options (
    option_id INT PRIMARY KEY AUTO_INCREMENT,
    question_id INT NOT NULL,
    option_label ENUM('A', 'B', 'C', 'D') NOT NULL,
    option_text TEXT NOT NULL,
    is_correct BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_question_option (question_id, option_label),
    INDEX idx_question_id (question_id),
    FOREIGN KEY (question_id) REFERENCES quiz_questions(question_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 6. PHASE RESOURCES TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS phase_resources (
    resource_id INT PRIMARY KEY AUTO_INCREMENT,
    phase_id INT NOT NULL,
    resource_type ENUM('PDF', 'VIDEO', 'DOCUMENT') NOT NULL,
    resource_name VARCHAR(255) NOT NULL,
    resource_url TEXT,
    file_path VARCHAR(500),
    file_size BIGINT,
    mime_type VARCHAR(100),
    uploaded_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_phase_id (phase_id),
    INDEX idx_resource_type (resource_type),
    FOREIGN KEY (phase_id) REFERENCES phases(phase_id) ON DELETE CASCADE,
    FOREIGN KEY (uploaded_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 7. ENROLLMENTS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    path_id INT NOT NULL,
    enrolled_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completion_date TIMESTAMP NULL,
    progress_percentage DECIMAL(5, 2) DEFAULT 0,
    is_completed BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    UNIQUE KEY unique_user_path (user_id, path_id),
    INDEX idx_user_id (user_id),
    INDEX idx_path_id (path_id),
    INDEX idx_enrolled_date (enrolled_date),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (path_id) REFERENCES career_paths(path_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 8. PHASE PROGRESS TABLE (Track user progress per phase)
-- ============================================================
CREATE TABLE IF NOT EXISTS phase_progress (
    progress_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT NOT NULL,
    phase_id INT NOT NULL,
    started_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_date TIMESTAMP NULL,
    is_completed BOOLEAN DEFAULT FALSE,
    attempts INT DEFAULT 0,
    best_score DECIMAL(5, 2),
    UNIQUE KEY unique_enrollment_phase (enrollment_id, phase_id),
    INDEX idx_enrollment_id (enrollment_id),
    INDEX idx_phase_id (phase_id),
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id) ON DELETE CASCADE,
    FOREIGN KEY (phase_id) REFERENCES phases(phase_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 9. QUIZ RESPONSES TABLE (Track user answers to quiz questions)
-- ============================================================
CREATE TABLE IF NOT EXISTS quiz_responses (
    response_id INT PRIMARY KEY AUTO_INCREMENT,
    phase_progress_id INT NOT NULL,
    question_id INT NOT NULL,
    selected_answer ENUM('A', 'B', 'C', 'D'),
    is_correct BOOLEAN,
    attempted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_phase_progress_id (phase_progress_id),
    INDEX idx_question_id (question_id),
    UNIQUE KEY unique_response (phase_progress_id, question_id),
    FOREIGN KEY (phase_progress_id) REFERENCES phase_progress(progress_id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES quiz_questions(question_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 10. NOTIFICATIONS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    notification_type VARCHAR(50),
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id),
    INDEX idx_is_read (is_read),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 11. ADMIN SETTINGS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS admin_settings (
    setting_id INT PRIMARY KEY AUTO_INCREMENT,
    setting_key VARCHAR(100) UNIQUE NOT NULL,
    setting_value LONGTEXT,
    description TEXT,
    updated_by INT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_setting_key (setting_key),
    FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 12. STUDY SESSIONS TABLE (Track learning activity sessions)
-- ============================================================
CREATE TABLE IF NOT EXISTS study_sessions (
    session_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT NOT NULL,
    user_id INT NOT NULL,
    phase_id INT NOT NULL,
    session_start TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    session_end TIMESTAMP NULL,
    duration_minutes INT DEFAULT 0,
    content_studied VARCHAR(255),
    is_completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_ss_user_id (user_id),
    INDEX idx_ss_enrollment_id (enrollment_id),
    INDEX idx_ss_phase_id (phase_id),
    INDEX idx_ss_session_start (session_start),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id) ON DELETE CASCADE,
    FOREIGN KEY (phase_id) REFERENCES phases(phase_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 13. USER STREAKS TABLE (Track daily learning streaks)
-- ============================================================
CREATE TABLE IF NOT EXISTS user_streaks (
    user_id INT PRIMARY KEY,
    current_streak INT DEFAULT 0,
    longest_streak INT DEFAULT 0,
    last_activity_date DATE,
    streak_started_date DATE,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 14. USER ACTIVITY LOG TABLE (Daily activity aggregates)
-- ============================================================
CREATE TABLE IF NOT EXISTS user_activity_log (
    activity_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    activity_date DATE NOT NULL,
    session_count INT DEFAULT 0,
    total_learning_minutes INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uniq_user_activity_date (user_id, activity_date),
    INDEX idx_ual_user_id (user_id),
    INDEX idx_ual_activity_date (activity_date),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- INDEXES FOR PERFORMANCE OPTIMIZATION
-- ============================================================
CREATE INDEX idx_enrollment_path ON enrollments(path_id);
CREATE INDEX idx_quiz_response_question ON quiz_responses(question_id);
CREATE INDEX idx_phase_resource_upload ON phase_resources(uploaded_by);

-- ============================================================
-- UPLOAD PATH MIGRATION (OLD /uploads -> /assets/uploads)
-- Run safely on existing databases after deployment.
-- ============================================================

-- Ensure users profile picture column exists for profile uploads.
ALTER TABLE users
        ADD COLUMN IF NOT EXISTS profile_pic VARCHAR(500) DEFAULT NULL;

-- Normalize old file paths in phase resources.
UPDATE phase_resources
SET file_path = REPLACE(file_path, '/uploads/', '/assets/uploads/')
WHERE file_path IS NOT NULL
    AND file_path LIKE '/uploads/%';

-- Normalize old profile picture paths.
UPDATE users
SET profile_pic = REPLACE(profile_pic, '/uploads/', '/assets/uploads/')
WHERE profile_pic IS NOT NULL
    AND profile_pic LIKE '/uploads/%';

-- ============================================================
-- SAMPLE DATA (Optional - Comment out if not needed)
-- ============================================================
-- INSERT INTO users (full_name, email, password_hash, role) 
-- VALUES ('Admin User', 'admin@pathpilot.com', SHA2('admin123', 256), 'ADMIN');
============================
-- SAMPLE DATA (Optional - Comment out if not needed)
-- ============================================================
-- INSERT INTO users (full_name, email, password_hash, role) 
-- VALUES ('Admin User', 'admin@pathpilot.com', SHA2('admin123', 256), 'ADMIN');
