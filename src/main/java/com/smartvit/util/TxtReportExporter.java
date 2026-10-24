package com.smartvit.util;

import com.smartvit.exception.SmartVitException;
import com.smartvit.model.Complaint;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * Text Summary Implementation of ReportGenerator.
 * Demonstrates Polymorphism and File Handling (BufferedWriter, File creation, writing).
 */
public class TxtReportExporter implements ReportGenerator {

    @Override
    public File generateReport(List<Complaint> complaints, File outputDirectory) throws IOException, SmartVitException {
        if (!outputDirectory.exists()) {
            outputDirectory.mkdirs();
        }

        String timestamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        String fileName = "SmartVIT_Summary_" + timestamp + getFileExtension();
        File reportFile = new File(outputDirectory, fileName);

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(reportFile))) {
            writer.write("=====================================================");
            writer.newLine();
            writer.write(" SMART VIT STUDENT COMPLAINT SYSTEM - SUMMARY REPORT");
            writer.newLine();
            writer.write(" Generated on: " + new Date().toString());
            writer.newLine();
            writer.write(" Total Complaints Exported: " + (complaints != null ? complaints.size() : 0));
            writer.newLine();
            writer.write("=====================================================");
            writer.newLine();
            writer.newLine();

            if (complaints != null) {
                int count = 1;
                for (Complaint c : complaints) {
                    writer.write(String.format("%d. Code: %s | Title: %s", count++, c.getComplaintCode(), c.getTitle()));
                    writer.newLine();
                    writer.write(String.format("   Priority: %s | Status: %s | Overdue: %s", 
                            c.getPriority(), c.getStatus(), c.isOverdue() ? "YES" : "NO"));
                    writer.newLine();
                    writer.write("-----------------------------------------------------");
                    writer.newLine();
                }
            }
            writer.flush();
        }

        return reportFile;
    }

    @Override
    public String getContentType() {
        return "text/plain";
    }

    @Override
    public String getFileExtension() {
        return ".txt";
    }
}
