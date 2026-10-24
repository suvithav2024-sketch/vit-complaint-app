package com.smartvit.util;

import com.smartvit.exception.SmartVitException;
import com.smartvit.model.Complaint;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * CSV Implementation of ReportGenerator.
 * Demonstrates Polymorphism and File Handling (Writing files to disk).
 */
public class CsvReportExporter implements ReportGenerator {

    @Override
    public File generateReport(List<Complaint> complaints, File outputDirectory) throws IOException, SmartVitException {
        if (!outputDirectory.exists()) {
            outputDirectory.mkdirs();
        }

        String timestamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        String fileName = "SmartVIT_Complaints_" + timestamp + getFileExtension();
        File reportFile = new File(outputDirectory, fileName);

        try (PrintWriter writer = new PrintWriter(new FileWriter(reportFile))) {
            // Write CSV Header
            writer.println("Complaint Code,Title,Category,Priority,Status,Overdue,Created At");

            // Write Data Rows
            if (complaints != null) {
                for (Complaint c : complaints) {
                    StringBuilder sb = new StringBuilder();
                    sb.append(escapeCsv(c.getComplaintCode())).append(",");
                    sb.append(escapeCsv(c.getTitle())).append(",");
                    sb.append(escapeCsv(c.getCategoryName() != null ? c.getCategoryName() : "General")).append(",");
                    sb.append(escapeCsv(c.getPriority())).append(",");
                    sb.append(escapeCsv(c.getStatus())).append(",");
                    sb.append(c.isOverdue() ? "YES" : "NO").append(",");
                    sb.append(c.getCreatedAt() != null ? c.getCreatedAt().toString() : "");
                    writer.println(sb.toString());
                }
            }
            writer.flush();
        }

        return reportFile;
    }

    private String escapeCsv(String value) {
        if (value == null) return "\"\"";
        String escaped = value.replace("\"", "\"\"");
        return "\"" + escaped + "\"";
    }

    @Override
    public String getContentType() {
        return "text/csv";
    }

    @Override
    public String getFileExtension() {
        return ".csv";
    }
}
