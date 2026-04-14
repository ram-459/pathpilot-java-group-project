package com.pathpilot.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import com.pathpilot.model.PhaseResource;
import java.util.List;

/**
 * PhaseResourceDAO - CRUD operations for Learning Resources
 * Manages PDFs, videos, and study materials for phases
 */
@Repository
public class PhaseResourceDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    /**
     * CREATE - Add a new resource
     */
    public int addResource(PhaseResource resource) {
        String sql = "INSERT INTO phase_resources (phase_id, resource_type, resource_name, resource_url, file_path, " +
                     "file_size, mime_type, uploaded_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql, resource.getPhaseId(), resource.getResourceType(), 
                                   resource.getResourceName(), resource.getResourceUrl(), 
                                   resource.getFilePath(), resource.getFileSize(), 
                                   resource.getMimeType(), resource.getUploadedBy());
    }

    /**
     * READ - Get resource by ID
     */
    public PhaseResource getResourceById(int resourceId) {
        String sql = "SELECT * FROM phase_resources WHERE resource_id = ?";
        try {
            return jdbcTemplate.queryForObject(sql, new BeanPropertyRowMapper<>(PhaseResource.class), resourceId);
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * READ - Get all resources for a specific phase
     */
    public List<PhaseResource> getResourcesByPhaseId(int phaseId) {
        String sql = "SELECT * FROM phase_resources WHERE phase_id = ? ORDER BY created_at DESC";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(PhaseResource.class), phaseId);
    }

    /**
     * READ - Get resources by type (PDF, VIDEO, DOCUMENT)
     */
    public List<PhaseResource> getResourcesByType(String resourceType) {
        String sql = "SELECT * FROM phase_resources WHERE resource_type = ? ORDER BY created_at DESC";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(PhaseResource.class), resourceType);
    }

    /**
     * READ - Get all resources
     */
    public List<PhaseResource> getAllResources() {
        String sql = "SELECT * FROM phase_resources ORDER BY phase_id ASC, created_at DESC";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(PhaseResource.class));
    }

    /**
     * UPDATE - Update resource details
     */
    public int updateResource(PhaseResource resource) {
        String sql = "UPDATE phase_resources SET resource_name = ?, resource_url = ?, file_path = ?, " +
                     "file_size = ?, mime_type = ? WHERE resource_id = ?";
        return jdbcTemplate.update(sql, resource.getResourceName(), resource.getResourceUrl(), 
                                   resource.getFilePath(), resource.getFileSize(), 
                                   resource.getMimeType(), resource.getResourceId());
    }

    /**
     * DELETE - Delete a resource by ID
     */
    public int deleteResource(int resourceId) {
        String sql = "DELETE FROM phase_resources WHERE resource_id = ?";
        return jdbcTemplate.update(sql, resourceId);
    }

    /**
     * DELETE - Delete all resources for a phase
     */
    public int deleteResourcesByPhaseId(int phaseId) {
        String sql = "DELETE FROM phase_resources WHERE phase_id = ?";
        return jdbcTemplate.update(sql, phaseId);
    }

    public int deleteResourcesByPhaseAndType(int phaseId, String resourceType) {
        String sql = "DELETE FROM phase_resources WHERE phase_id = ? AND resource_type = ?";
        return jdbcTemplate.update(sql, phaseId, resourceType);
    }

    public int saveOrUpdateDocumentResource(int phaseId,
                                            String resourceType,
                                            String resourceName,
                                            String filePath,
                                            long fileSize,
                                            String mimeType,
                                            int uploadedBy) {
        Integer existingResourceId = null;
        try {
            String findSql = "SELECT resource_id FROM phase_resources " +
                    "WHERE phase_id = ? AND resource_type IN ('PDF', 'DOCUMENT') " +
                    "ORDER BY resource_id DESC LIMIT 1";
            existingResourceId = jdbcTemplate.queryForObject(findSql, Integer.class, phaseId);
        } catch (Exception ignored) {
        }

        if (existingResourceId != null) {
            String updateSql = "UPDATE phase_resources SET resource_type = ?, resource_name = ?, resource_url = ?, " +
                    "file_path = ?, file_size = ?, mime_type = ?, uploaded_by = ? WHERE resource_id = ?";
            return jdbcTemplate.update(updateSql,
                    resourceType,
                    resourceName,
                filePath,
                    filePath,
                    fileSize,
                    mimeType,
                    uploadedBy,
                    existingResourceId);
        }

        String insertSql = "INSERT INTO phase_resources (phase_id, resource_type, resource_name, resource_url, file_path, " +
            "file_size, mime_type, uploaded_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(insertSql,
                phaseId,
                resourceType,
                resourceName,
            filePath,
                filePath,
                fileSize,
                mimeType,
                uploadedBy);
    }

    public PhaseResource getLatestDocumentResourceByPhaseId(int phaseId) {
        String sql = "SELECT * FROM phase_resources WHERE phase_id = ? " +
                "AND resource_type IN ('PDF', 'DOCUMENT') ORDER BY resource_id DESC LIMIT 1";
        try {
            return jdbcTemplate.queryForObject(sql, new BeanPropertyRowMapper<>(PhaseResource.class), phaseId);
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Get count of resources for a phase
     */
    public int getResourceCountByPhaseId(int phaseId) {
        String sql = "SELECT COUNT(*) FROM phase_resources WHERE phase_id = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, phaseId);
        return count != null ? count : 0;
    }

    /**
     * Get total file size for a phase
     */
    public long getTotalFileSizeByPhaseId(int phaseId) {
        String sql = "SELECT COALESCE(SUM(file_size), 0) FROM phase_resources WHERE phase_id = ?";
        Long size = jdbcTemplate.queryForObject(sql, Long.class, phaseId);
        return size != null ? size : 0;
    }
}
