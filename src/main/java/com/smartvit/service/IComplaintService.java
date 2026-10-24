package com.smartvit.service;

import com.smartvit.exception.ComplaintNotFoundException;
import com.smartvit.exception.InvalidStatusTransitionException;
import com.smartvit.exception.SmartVitException;
import com.smartvit.model.Complaint;

import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Service Interface for Complaint Management operating contracts.
 * Demonstrates Abstraction and Interface definition in Java.
 */
public interface IComplaintService {

    Complaint submitComplaint(Complaint complaint, String ipAddress) throws SmartVitException;

    boolean updateStatus(int complaintId, String newStatus, String comment, Integer updatedByUserId, String ipAddress) 
            throws ComplaintNotFoundException, InvalidStatusTransitionException, SmartVitException;

    Complaint getComplaintDetails(int complaintId) throws ComplaintNotFoundException, SmartVitException;

    List<Complaint> getComplaintsByStudent(int studentId) throws SmartVitException;

    List<Complaint> getComplaintsByDepartment(int departmentId) throws SmartVitException;

    List<Complaint> getOverdueComplaints() throws SmartVitException;

    Map<String, Integer> getComplaintStatusMetrics() throws SmartVitException;

    Set<String> getUniqueComplaintPriorities() throws SmartVitException;
}
