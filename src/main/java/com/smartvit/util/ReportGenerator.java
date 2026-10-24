package com.smartvit.util;

import com.smartvit.exception.SmartVitException;
import com.smartvit.model.Complaint;

import java.io.File;
import java.io.IOException;
import java.util.List;

/**
 * Interface defining contract for complaint report generation.
 * Demonstrates Abstraction, Polymorphism, and File I/O contracts.
 */
public interface ReportGenerator {

    /**
     * Generates a report file from a list of complaints.
     *
     * @param complaints List of complaints to include
     * @param outputDirectory Target directory where file will be created
     * @return Generated File object
     * @throws IOException If file creation or writing fails
     * @throws SmartVitException If business rules fail
     */
    File generateReport(List<Complaint> complaints, File outputDirectory) throws IOException, SmartVitException;

    /**
     * Returns the content type (MIME type) of the generated report.
     */
    String getContentType();

    /**
     * Returns the default file extension including dot (e.g. ".csv", ".txt").
     */
    String getFileExtension();
}
