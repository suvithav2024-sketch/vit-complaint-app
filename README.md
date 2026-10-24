# SMART VIT — Student Complaint Management System

Smart VIT is a enterprise Java Web & Desktop Application designed for managing student complaints, tracking SLA resolutions, sending notifications, and displaying real-time system metrics.

---

## 📚 Java Syllabus Concepts Mapping

This application strictly implements required academic Java concepts meaningfully:

| Java Syllabus Concept | Implementation Location in Project | Description / Purpose |
| :--- | :--- | :--- |
| **OOP: Encapsulation** | `com.smartvit.model.*` | Private fields with public getters/setters in `User`, `Complaint`, `Department`, etc. |
| **OOP: Inheritance** | `com.smartvit.dao.BaseDAO<T>`, `com.smartvit.exception.SmartVitException` | Generic BaseDAO hierarchy and domain custom exception class hierarchy. |
| **OOP: Polymorphism** | `com.smartvit.util.ReportGenerator`, `CsvReportExporter`, `TxtReportExporter` | Dynamic method dispatch exporting complaint data into different file formats (CSV / TXT). |
| **OOP: Abstraction** | `com.smartvit.service.IComplaintService`, `INotificationService`, `BaseDAO` | Pure interface contracts and abstract classes decoupling business logic from implementation. |
| **Packages** | `com.smartvit.{model, dao, service, controller, util, exception, thread, javafx}` | Clean modular package organization. |
| **User-Defined Exceptions** | `com.smartvit.exception.*` | Custom domain exceptions (`DatabaseException`, `ComplaintNotFoundException`, `InvalidStatusTransitionException`, `UnauthorizedAccessException`). |
| **File Handling** | `CsvReportExporter.java`, `TxtReportExporter.java`, `AdminReportsServlet.java` | File creation, buffered writing to disk, file streaming downloads, and attachment storage. |
| **Collection Framework** | `ComplaintService.java`, `SmartVitAdminApp.java` | Meaningful usage of `List<Complaint>`, `Set<String>` (unique priority filters), and `Map<String, Integer>` (dashboard status metrics). |
| **JDBC Connectivity** | `DBConnection.java`, `com.smartvit.dao.*` | JDBC Connection management, `PreparedStatement`, `ResultSet`, and parameterized CRUD queries. |
| **JavaFX Components** | `com.smartvit.javafx.SmartVitAdminApp` | Standalone JavaFX Desktop GUI application with `TableView`, `ObservableList`, `VBox`, `HBox`, `Button`, `Label`, and `Alert`. |
| **JSP** | `src/main/webapp/**/*.jsp` | Web presentation layer using JSP, JSTL tags (`c:forEach`, `c:if`), and dynamic attributes. |
| **Jakarta Servlets** | `com.smartvit.controller.*` | Jakarta Servlets (`jakarta.servlet.*`) handling HTTP GET/POST controllers. |
| **Multithreading** | `SlaMonitoringThread`, `NotificationProcessorTask`, `SlaContextListener` | Background daemon thread scanning SLA deadlines every 60s, async worker tasks, and Tomcat ServletContext lifecycle integration. |

---

## 🛠️ Prerequisites & System Requirements

1. **Java Development Kit (JDK)**: JDK 17 or higher (e.g., Eclipse Temurin 17 or Oracle OpenJDK 17).
2. **Build Tool**: Apache Maven 3.8+ (or Maven wrapper).
3. **Database**: MySQL Server 8.0+ or MariaDB 10.5+.
4. **Web Server**: Apache Tomcat 10.1+ (Supports Jakarta Servlet 6.0).
5. **IDE**: Visual Studio Code (VS Code).

---

## 🚀 VS Code Setup Instructions

### 1. Install VS Code Extensions
Open VS Code and install the following recommended extension pack:
- **Extension Pack for Java** (by Microsoft)
- **Community Server Connectors** or **Tomcat for Java** (for deploying directly from VS Code)
- **Maven for Java** (by Microsoft)

### 2. Configure JDK in VS Code
Ensure your VS Code uses JDK 17:
1. Open `Settings` (`Ctrl + ,`).
2. Search for `java.configuration.runtimes`.
3. Set JDK 17 as the default Java runtime path.

---

## 🗄️ Database Setup (MySQL / MariaDB)

### 1. Start MySQL Server
Ensure your MySQL service is running on `localhost:3306`.

### 2. Import Database Schema & Seed Data
Open terminal / MySQL Workbench / Command Prompt and execute:
```bash
mysql -u root -p < database.sql
```
*(If `root` user has no password, press Enter when prompted).*

This will automatically create the database `smart_vit_complaints` along with tables and demo records.

### 3. Portable Database Configuration
Database connection parameters are loaded from `src/main/resources/db.properties`.
You can modify `db.properties` or override via Environment Variables:
```properties
db.driver=com.mysql.cj.jdbc.Driver
db.host=localhost
db.port=3306
db.name=smart_vit_complaints
db.user=root
db.password=
```

**Environment Variables Override (Optional)**:
- `DB_HOST`
- `DB_PORT`
- `DB_NAME`
- `DB_USER`
- `DB_PASSWORD`

---

## 📦 Building the Application (Maven)

Open terminal in the project root directory (`Smartvit/`) and run:
```bash
mvn clean package
```

This will compile all Java sources, execute validation checks, and generate the WAR deployment package:
```text
target/Smartvit.war
```

---

## 🌐 Deploying to Apache Tomcat 10.1+

1. Copy `target/Smartvit.war` to your Tomcat `webapps/` folder:
   - **Windows**: `C:\apache-tomcat-10.1.x\webapps\`
2. Start Apache Tomcat:
   - **Windows**: `C:\apache-tomcat-10.1.x\bin\startup.bat`
3. Open your browser and navigate to:
   ```text
   http://localhost:8080/Smartvit
   ```

---

## 🔑 Demo Login Credentials

| Role | Registration / Email | Password | Access / Permissions |
| :--- | :--- | :--- | :--- |
| **System Admin** | `admin@vit.ac.in` | `Admin@123` | Full Admin Dashboard, SLA Rules, Category, Staff & Audit logs |
| **Student** | `21BCE0001` / `student1@vit.ac.in` | `Student@123` | Submit complaints, view status, upload attachments, confirm/reopen |
| **Department Staff** | `staff.hostel@vit.ac.in` | `Staff@123` | Department complaints dashboard, update resolution status |

---

## 🖥️ Running the JavaFX Desktop Admin Application

The project includes a standalone JavaFX Desktop Monitoring GUI (`SmartVitAdminApp`).

### Run via Maven:
```bash
mvn exec:java -Dexec.mainClass="com.smartvit.javafx.SmartVitAdminApp"
```

### Features of JavaFX Application:
- Real-time **JDBC Connection Test**.
- Live **SLA Breach Overdue Complaints Table**.
- Manual **Trigger SLA Audit** button executing `SlaMonitoringThread`.

---

## ❓ Common Errors & Troubleshooting

### 1. `ClassNotFoundException: jakarta.servlet.ServletException`
- **Cause**: Mixing Tomcat 9 (javax.servlet) with Tomcat 10 (jakarta.servlet).
- **Solution**: Use Apache Tomcat 10.1+ which natively supports Jakarta Servlet API 6.0.

### 2. `Access denied for user 'root'@'localhost'`
- **Cause**: Incorrect MySQL credentials in `db.properties`.
- **Solution**: Update `src/main/resources/db.properties` with your local MySQL password.

### 3. `JavaFX runtime components are missing`
- **Cause**: JavaFX modules not linked when executing `java -jar`.
- **Solution**: Run via Maven `mvn exec:java -Dexec.mainClass="com.smartvit.javafx.SmartVitAdminApp"`.
