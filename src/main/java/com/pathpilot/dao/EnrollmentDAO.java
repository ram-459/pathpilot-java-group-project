package com.pathpilot.model;

import java.time.LocalDateTime;
import java.math.BigDecimal;

/**
 * Enrollment Model - Represents a user's enrollment in a career path
 */
public class Enrollment {
    private int enrollmentId;
    private int userId;
    private int pathId;
    private LocalDateTime enrolledDate;
    private LocalDateTime completionDate;
    private BigDecimal progressPercentage;
    private boolean isCompleted;
    private boolean isActive;

    // Constructors
    public Enrollment() {}

    public Enrollment(int userId, int pathId) {
        this.userId = userId;
        this.pathId = pathId;
        this.progressPercentage = BigDecimal.ZERO;
        this.isCompleted = false;
        this.isActive = true;
    }

    // Getters and Setters
    public int getEnrollmentId() {
        return enrollmentId;
    }

    public void setEnrollmentId(int enrollmentId) {
        this.enrollmentId = enrollmentId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getPathId() {
        return pathId;
    }

    public void setPathId(int pathId) {
        this.pathId = pathId;
    }

    public LocalDateTime getEnrolledDate() {
        return enrolledDate;
    }

    public void setEnrolledDate(LocalDateTime enrolledDate) {
        this.enrolledDate = enrolledDate;
    }

    public LocalDateTime getCompletionDate() {
        return completionDate;
    }

    public void setCompletionDate(LocalDateTime completionDate) {
        this.completionDate = completionDate;
    }

    public BigDecimal getProgressPercentage() {
        return progressPercentage;
    }

    public void setProgressPercentage(BigDecimal progressPercentage) {
        this.progressPercentage = progressPercentage;
    }

    public boolean isCompleted() {
        return isCompleted;
    }

    public void setCompleted(boolean completed) {
        isCompleted = completed;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    @Override
    public String toString() {
        return "Enrollment{" +
                "enrollmentId=" + enrollmentId +
                ", userId=" + userId +
                ", pathId=" + pathId +
                ", enrolledDate=" + enrolledDate +
                ", completionDate=" + completionDate +
                ", progressPercentage=" + progressPercentage +
                ", isCompleted=" + isCompleted +
                ", isActive=" + isActive +
                '}';
    }
}
