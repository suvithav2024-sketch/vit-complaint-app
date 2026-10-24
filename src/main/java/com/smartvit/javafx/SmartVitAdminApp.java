package com.smartvit.javafx;

import com.smartvit.dao.ComplaintDAO;
import com.smartvit.model.Complaint;
import com.smartvit.thread.SlaMonitoringThread;
import com.smartvit.util.DBConnection;

import javafx.application.Application;
import javafx.beans.property.SimpleStringProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.*;
import javafx.scene.paint.Color;
import javafx.scene.text.Font;
import javafx.scene.text.FontWeight;
import javafx.stage.Stage;

import java.sql.Connection;
import java.util.List;

/**
 * Standalone JavaFX Desktop Application for Smart VIT Admin System Diagnostics.
 * Demonstrates GUI components, Event Handling, and System Integration in Java syllabus.
 */
public class SmartVitAdminApp extends Application {

    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final SlaMonitoringThread slaThread = new SlaMonitoringThread(60000);

    private Label statusLabel;
    private Label overdueCountLabel;
    private Label totalComplaintsLabel;
    private TableView<Complaint> overdueTable;
    private ObservableList<Complaint> overdueData;

    @Override
    public void start(Stage primaryStage) {
        primaryStage.setTitle("SMART VIT - Admin System Diagnostics & SLA Monitor");

        // Header Title
        Label headerLabel = new Label("Smart VIT Admin Monitor & SLA Dashboard");
        headerLabel.setFont(Font.font("Segoe UI", FontWeight.BOLD, 18));
        headerLabel.setTextFill(Color.web("#1e293b"));

        // Status Card Area
        HBox cardsBox = createMetricsCards();

        // Overdue Complaints Section Header
        Label tableTitle = new Label("Live Overdue Complaints (SLA Breach List)");
        tableTitle.setFont(Font.font("Segoe UI", FontWeight.SEMI_BOLD, 14));

        // Overdue Complaints TableView
        overdueTable = createOverdueTable();

        // Control Buttons Box
        HBox buttonBox = new HBox(12);
        buttonBox.setAlignment(Pos.CENTER_RIGHT);

        Button btnRefresh = new Button("Refresh Data");
        btnRefresh.setStyle("-fx-background-color: #2563eb; -fx-text-fill: white; -fx-font-weight: bold; -fx-padding: 8 16;");
        btnRefresh.setOnAction(e -> refreshDashboardData());

        Button btnRunSla = new Button("Trigger SLA Audit");
        btnRunSla.setStyle("-fx-background-color: #dc2626; -fx-text-fill: white; -fx-font-weight: bold; -fx-padding: 8 16;");
        btnRunSla.setOnAction(e -> runManualSlaAudit());

        Button btnTestDb = new Button("Test JDBC Connection");
        btnTestDb.setStyle("-fx-background-color: #059669; -fx-text-fill: white; -fx-font-weight: bold; -fx-padding: 8 16;");
        btnTestDb.setOnAction(e -> testJdbcConnection());

        buttonBox.getChildren().addAll(btnTestDb, btnRunSla, btnRefresh);

        // Status Bar
        statusLabel = new Label("System Status: Initializing...");
        statusLabel.setFont(Font.font("Segoe UI", 12));
        statusLabel.setTextFill(Color.web("#64748b"));

        VBox root = new VBox(16);
        root.setPadding(new Insets(20));
        root.setStyle("-fx-background-color: #f8fafc;");
        root.getChildren().addAll(headerLabel, cardsBox, tableTitle, overdueTable, buttonBox, statusLabel);

        Scene scene = new Scene(root, 900, 600);
        primaryStage.setScene(scene);
        primaryStage.show();

        // Initial Data Load & DB Check
        testJdbcConnection();
        refreshDashboardData();
    }

    private HBox createMetricsCards() {
        HBox box = new HBox(20);
        box.setAlignment(Pos.CENTER);

        // DB Status Card
        VBox dbCard = createCard("Database Connectivity", statusLabel = new Label("Unknown"), "#e0f2fe", "#0369a1");
        // Overdue Complaints Card
        VBox overdueCard = createCard("Overdue Complaints", overdueCountLabel = new Label("0"), "#fee2e2", "#991b1b");
        // Total Complaints Card
        VBox totalCard = createCard("Total System Complaints", totalComplaintsLabel = new Label("0"), "#f0fdf4", "#166534");

        box.getChildren().addAll(dbCard, overdueCard, totalCard);
        return box;
    }

    private VBox createCard(String title, Label valLabel, String bgColor, String textColor) {
        VBox card = new VBox(8);
        card.setPadding(new Insets(15));
        card.setPrefWidth(260);
        card.setStyle("-fx-background-color: " + bgColor + "; -fx-background-radius: 8px; -fx-border-color: #cbd5e1; -fx-border-radius: 8px;");

        Label tLabel = new Label(title);
        tLabel.setFont(Font.font("Segoe UI", FontWeight.NORMAL, 12));
        tLabel.setTextFill(Color.web(textColor));

        valLabel.setFont(Font.font("Segoe UI", FontWeight.BOLD, 18));
        valLabel.setTextFill(Color.web(textColor));

        card.getChildren().addAll(tLabel, valLabel);
        return card;
    }

    @SuppressWarnings("unchecked")
    private TableView<Complaint> createOverdueTable() {
        TableView<Complaint> table = new TableView<>();
        table.setPlaceholder(new Label("No overdue complaints found. System in good SLA health."));

        TableColumn<Complaint, String> colCode = new TableColumn<>("Complaint Code");
        colCode.setCellValueFactory(cell -> new SimpleStringProperty(cell.getValue().getComplaintCode()));
        colCode.setPrefWidth(140);

        TableColumn<Complaint, String> colTitle = new TableColumn<>("Title");
        colTitle.setCellValueFactory(cell -> new SimpleStringProperty(cell.getValue().getTitle()));
        colTitle.setPrefWidth(250);

        TableColumn<Complaint, String> colPriority = new TableColumn<>("Priority");
        colPriority.setCellValueFactory(cell -> new SimpleStringProperty(cell.getValue().getPriority()));
        colPriority.setPrefWidth(100);

        TableColumn<Complaint, String> colStatus = new TableColumn<>("Status");
        colStatus.setCellValueFactory(cell -> new SimpleStringProperty(cell.getValue().getStatus()));
        colStatus.setPrefWidth(120);

        TableColumn<Complaint, String> colCreated = new TableColumn<>("Created At");
        colCreated.setCellValueFactory(cell -> new SimpleStringProperty(
                cell.getValue().getCreatedAt() != null ? cell.getValue().getCreatedAt().toString() : "N/A"));
        colCreated.setPrefWidth(180);

        table.getColumns().addAll(colCode, colTitle, colPriority, colStatus, colCreated);
        overdueData = FXCollections.observableArrayList();
        table.setItems(overdueData);

        VBox.setVgrow(table, Priority.ALWAYS);
        return table;
    }

    private void testJdbcConnection() {
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null && !conn.isClosed()) {
                statusLabel.setText("CONNECTED (MySQL)");
                statusLabel.setTextFill(Color.web("#15803d"));
            } else {
                statusLabel.setText("DISCONNECTED");
                statusLabel.setTextFill(Color.web("#b91c1c"));
            }
        } catch (Exception e) {
            statusLabel.setText("DB ERROR: " + e.getMessage());
            statusLabel.setTextFill(Color.web("#b91c1c"));
        }
    }

    private void refreshDashboardData() {
        try {
            List<Complaint> overdueList = complaintDAO.findOverdueComplaints();
            overdueData.setAll(overdueList);
            overdueCountLabel.setText(String.valueOf(overdueList.size()));

            int totalCount = complaintDAO.countComplaints(null, null);
            totalComplaintsLabel.setText(String.valueOf(totalCount));
        } catch (Exception e) {
            showAlert("Data Fetch Error", "Failed to refresh system metrics: " + e.getMessage());
        }
    }

    private void runManualSlaAudit() {
        try {
            slaThread.performSlaCheck();
            refreshDashboardData();
            showAlert("SLA Audit Completed", "Manual SLA check executed successfully against all open complaints.");
        } catch (Exception e) {
            showAlert("SLA Audit Failed", "An error occurred during SLA check: " + e.getMessage());
        }
    }

    private void showAlert(String title, String content) {
        Alert alert = new Alert(Alert.AlertType.INFORMATION);
        alert.setTitle(title);
        alert.setHeaderText(null);
        alert.setContentText(content);
        alert.showAndWait();
    }

    public static void main(String[] args) {
        launch(args);
    }
}
