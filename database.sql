-- ============================================================
-- SMART VIT - Student Complaint Management System
-- Database Schema and Seed Data
-- ============================================================

CREATE DATABASE IF NOT EXISTS smart_vit_complaints CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE smart_vit_complaints;

-- 1. ROLES
CREATE TABLE IF NOT EXISTS roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255)
) ENGINE=InnoDB;

-- 2. USERS
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    reg_emp_no VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role_id INT NOT NULL,
    school_dept VARCHAR(100),
    hostel_block VARCHAR(50),
    room_no VARCHAR(30),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE RESTRICT,
    INDEX idx_user_email (email),
    INDEX idx_user_reg (reg_emp_no),
    INDEX idx_user_role (role_id)
) ENGINE=InnoDB;

-- 3. CAMPUSES
CREATE TABLE IF NOT EXISTS campuses (
    campus_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(30) NOT NULL UNIQUE,
    location VARCHAR(200)
) ENGINE=InnoDB;

-- 4. BUILDINGS
CREATE TABLE IF NOT EXISTS buildings (
    building_id INT AUTO_INCREMENT PRIMARY KEY,
    campus_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(30) NOT NULL UNIQUE,
    type VARCHAR(50) NOT NULL DEFAULT 'ACADEMIC', -- ACADEMIC, HOSTEL, FACILITY, MESS, OTHER
    total_floors INT DEFAULT 1,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (campus_id) REFERENCES campuses(campus_id) ON DELETE RESTRICT,
    INDEX idx_bldg_code (code)
) ENGINE=InnoDB;

-- 5. LOCATIONS
CREATE TABLE IF NOT EXISTS locations (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    building_id INT NOT NULL,
    block VARCHAR(50),
    floor INT NOT NULL DEFAULT 0,
    room_number VARCHAR(50) NOT NULL,
    location_name VARCHAR(120),
    description VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (building_id) REFERENCES buildings(building_id) ON DELETE RESTRICT,
    INDEX idx_loc_bldg (building_id),
    INDEX idx_loc_room (room_number)
) ENGINE=InnoDB;

-- 6. DEPARTMENTS
CREATE TABLE IF NOT EXISTS departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    code VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    contact_email VARCHAR(120),
    contact_phone VARCHAR(30),
    office_location VARCHAR(150),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 7. DEPARTMENT STAFF / TECHNICIANS
CREATE TABLE IF NOT EXISTS department_staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    department_id INT NOT NULL,
    designation VARCHAR(100) NOT NULL,
    specialization VARCHAR(150),
    phone VARCHAR(30),
    email VARCHAR(120),
    office_location VARCHAR(150),
    availability_status VARCHAR(30) DEFAULT 'AVAILABLE', -- AVAILABLE, ON_LEAVE, BUSY
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE RESTRICT,
    INDEX idx_staff_dept (department_id)
) ENGINE=InnoDB;

-- 8. COMPLAINT CATEGORIES
CREATE TABLE IF NOT EXISTS categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    code VARCHAR(50) NOT NULL UNIQUE,
    icon VARCHAR(50) DEFAULT 'bi-folder',
    description VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 9. COMPLAINT SUBCATEGORIES
CREATE TABLE IF NOT EXISTS subcategories (
    subcategory_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    name VARCHAR(120) NOT NULL,
    description VARCHAR(255),
    default_priority VARCHAR(20) DEFAULT 'MEDIUM', -- LOW, MEDIUM, HIGH, URGENT
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE,
    INDEX idx_subcat_cat (category_id)
) ENGINE=InnoDB;

-- 10. CATEGORY DEPARTMENT MAPPING (DYNAMIC AUTOMATIC ALLOCATION)
CREATE TABLE IF NOT EXISTS category_department_mapping (
    mapping_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    subcategory_id INT DEFAULT NULL,
    department_id INT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE,
    FOREIGN KEY (subcategory_id) REFERENCES subcategories(subcategory_id) ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE CASCADE,
    INDEX idx_map_cat_sub (category_id, subcategory_id)
) ENGINE=InnoDB;

-- 11. SLA RULES
CREATE TABLE IF NOT EXISTS sla_rules (
    sla_id INT AUTO_INCREMENT PRIMARY KEY,
    priority VARCHAR(20) NOT NULL UNIQUE, -- LOW, MEDIUM, HIGH, URGENT
    max_resolution_hours INT NOT NULL,
    escalation_hours INT NOT NULL,
    description VARCHAR(255)
) ENGINE=InnoDB;

-- 12. COMPLAINTS
CREATE TABLE IF NOT EXISTS complaints (
    complaint_id INT AUTO_INCREMENT PRIMARY KEY,
    complaint_code VARCHAR(30) NOT NULL UNIQUE,
    complainant_id INT NOT NULL,
    category_id INT NOT NULL,
    subcategory_id INT NOT NULL,
    location_id INT NOT NULL,
    department_id INT NOT NULL,
    assigned_staff_id INT DEFAULT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    priority VARCHAR(20) NOT NULL DEFAULT 'MEDIUM',
    status VARCHAR(30) NOT NULL DEFAULT 'SUBMITTED',
    resolution_text TEXT DEFAULT NULL,
    resolved_by INT DEFAULT NULL,
    resolved_at TIMESTAMP NULL DEFAULT NULL,
    closed_at TIMESTAMP NULL DEFAULT NULL,
    reopened_at TIMESTAMP NULL DEFAULT NULL,
    due_date TIMESTAMP NULL DEFAULT NULL,
    is_overdue BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (complainant_id) REFERENCES users(user_id) ON DELETE RESTRICT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE RESTRICT,
    FOREIGN KEY (subcategory_id) REFERENCES subcategories(subcategory_id) ON DELETE RESTRICT,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE RESTRICT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE RESTRICT,
    FOREIGN KEY (assigned_staff_id) REFERENCES department_staff(staff_id) ON DELETE SET NULL,
    FOREIGN KEY (resolved_by) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_cmp_code (complaint_code),
    INDEX idx_cmp_user (complainant_id),
    INDEX idx_cmp_dept (department_id),
    INDEX idx_cmp_status (status),
    INDEX idx_cmp_priority (priority),
    INDEX idx_cmp_created (created_at)
) ENGINE=InnoDB;

-- 13. COMPLAINT ASSIGNMENTS
CREATE TABLE IF NOT EXISTS complaint_assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    complaint_id INT NOT NULL,
    department_id INT NOT NULL,
    staff_id INT DEFAULT NULL,
    assigned_by INT NOT NULL,
    notes TEXT,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (complaint_id) REFERENCES complaints(complaint_id) ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE RESTRICT,
    FOREIGN KEY (staff_id) REFERENCES department_staff(staff_id) ON DELETE SET NULL,
    FOREIGN KEY (assigned_by) REFERENCES users(user_id) ON DELETE RESTRICT,
    INDEX idx_asgn_cmp (complaint_id)
) ENGINE=InnoDB;

-- 14. COMPLAINT UPDATES (TIMELINE AUDIT HISTORY)
CREATE TABLE IF NOT EXISTS complaint_updates (
    update_id INT AUTO_INCREMENT PRIMARY KEY,
    complaint_id INT NOT NULL,
    updated_by INT NOT NULL,
    old_status VARCHAR(30) NOT NULL,
    new_status VARCHAR(30) NOT NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (complaint_id) REFERENCES complaints(complaint_id) ON DELETE CASCADE,
    FOREIGN KEY (updated_by) REFERENCES users(user_id) ON DELETE RESTRICT,
    INDEX idx_upd_cmp (complaint_id)
) ENGINE=InnoDB;

-- 15. COMPLAINT ATTACHMENTS
CREATE TABLE IF NOT EXISTS complaint_attachments (
    attachment_id INT AUTO_INCREMENT PRIMARY KEY,
    complaint_id INT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_type VARCHAR(100),
    file_size BIGINT,
    attachment_type VARCHAR(30) DEFAULT 'INITIAL', -- INITIAL, RESOLUTION_PROOF
    uploaded_by INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (complaint_id) REFERENCES complaints(complaint_id) ON DELETE CASCADE,
    FOREIGN KEY (uploaded_by) REFERENCES users(user_id) ON DELETE RESTRICT,
    INDEX idx_att_cmp (complaint_id)
) ENGINE=InnoDB;

-- 16. NOTIFICATIONS
CREATE TABLE IF NOT EXISTS notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    complaint_id INT DEFAULT NULL,
    title VARCHAR(150) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(30) DEFAULT 'INFO',
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (complaint_id) REFERENCES complaints(complaint_id) ON DELETE SET NULL,
    INDEX idx_notif_user (user_id),
    INDEX idx_notif_read (is_read)
) ENGINE=InnoDB;

-- 17. COMPLAINT FEEDBACK
CREATE TABLE IF NOT EXISTS complaint_feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    complaint_id INT NOT NULL UNIQUE,
    user_id INT NOT NULL,
    problem_solved BOOLEAN NOT NULL DEFAULT TRUE,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (complaint_id) REFERENCES complaints(complaint_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 18. QR CODES
CREATE TABLE IF NOT EXISTS qr_codes (
    qr_id INT AUTO_INCREMENT PRIMARY KEY,
    location_id INT NOT NULL UNIQUE,
    qr_code_identifier VARCHAR(64) NOT NULL UNIQUE,
    qr_image_path VARCHAR(255),
    target_url VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE CASCADE,
    INDEX idx_qr_ident (qr_code_identifier)
) ENGINE=InnoDB;

-- 19. AUDIT LOGS
CREATE TABLE IF NOT EXISTS audit_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT DEFAULT NULL,
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(50),
    entity_id INT,
    ip_address VARCHAR(60),
    details TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_audit_user (user_id),
    INDEX idx_audit_action (action)
) ENGINE=InnoDB;

-- ============================================================
-- SEED DATA
-- ============================================================

-- Roles
INSERT INTO roles (role_id, role_name, description) VALUES
(1, 'ADMIN', 'System Administrator with full management privileges'),
(2, 'STUDENT', 'Enrolled Student who can raise, track, and close complaints'),
(3, 'STAFF', 'University Teaching and Administrative Staff'),
(4, 'DEPARTMENT_STAFF', 'Maintenance and Department Staff managing assignments and resolution');

-- Demo Users
-- Passwords:
-- Admin: Admin@123
-- Student: Student@123
-- Staff: Staff@123
-- Dept: Dept@123
INSERT INTO users (user_id, full_name, email, reg_emp_no, password_hash, phone, role_id, school_dept, hostel_block, room_no) VALUES
(1, 'Campus Admin', 'admin@vit.ac.in', 'ADM0001', '$2a$10$p27wgNVFDU4btrSqVn3Q2u9fZGOzgOvlwdm1sXzJCnx5F8YbM6Ire', '9876543210', 1, 'Administrative Office', NULL, NULL),
(2, 'Rohit Sharma (Student)', 'student@vit.ac.in', '23BCE0000', '$2a$10$QB/wbNdDXQWl8RiKV/HW5uLVVPhXphGdQFexlguM1T/wuI9W1wpt6', '9876543211', 2, 'SCOPE - Computer Science', 'Hostel Block A', 'A-204'),
(3, 'Dr. Arunkumar (Faculty)', 'staff@vit.ac.in', 'EMP1001', '$2a$10$Lsi.2jLMACm/KnHCztD64eV.nb7I7pgn9Q5UhPuQiyEG4k3chU5Re', '9876543212', 3, 'SENSE - Electronics Engineering', NULL, NULL),
(4, 'Senthil Kumar (Electrical)', 'electrical@vit.ac.in', 'EMP2001', '$2a$10$SNdDIeZZaF6JHLFcvqek1uY0md.r6n/IA7maSoDniHi.ye6keLlRu', '9876543213', 4, 'Electrical Maintenance', NULL, NULL),
(5, 'Murugan P (Hostel)', 'hostel@vit.ac.in', 'EMP2002', '$2a$10$SNdDIeZZaF6JHLFcvqek1uY0md.r6n/IA7maSoDniHi.ye6keLlRu', '9876543214', 4, 'Hostel Maintenance', NULL, NULL),
(6, 'Ramesh Nair (Mess)', 'mess@vit.ac.in', 'EMP2003', '$2a$10$SNdDIeZZaF6JHLFcvqek1uY0md.r6n/IA7maSoDniHi.ye6keLlRu', '9876543215', 4, 'Mess Management', NULL, NULL),
(7, 'Praveen Raj (IT/Network)', 'it@vit.ac.in', 'EMP2004', '$2a$10$SNdDIeZZaF6JHLFcvqek1uY0md.r6n/IA7maSoDniHi.ye6keLlRu', '9876543216', 4, 'IT / Network', NULL, NULL),
(8, 'Karthik V (Plumbing)', 'plumbing@vit.ac.in', 'EMP2005', '$2a$10$SNdDIeZZaF6JHLFcvqek1uY0md.r6n/IA7maSoDniHi.ye6keLlRu', '9876543217', 4, 'Plumbing', NULL, NULL),
(9, 'Anand S (Housekeeping)', 'housekeeping@vit.ac.in', 'EMP2006', '$2a$10$SNdDIeZZaF6JHLFcvqek1uY0md.r6n/IA7maSoDniHi.ye6keLlRu', '9876543218', 4, 'Housekeeping', NULL, NULL);

-- Campuses
INSERT INTO campuses (campus_id, name, code, location) VALUES
(1, 'VIT Vellore Main Campus', 'VIT_VEL', 'Katpadi, Vellore, Tamil Nadu 632014');

-- Buildings
INSERT INTO buildings (building_id, campus_id, name, code, type, total_floors) VALUES
(1, 1, 'Academic Block 1', 'AB1', 'ACADEMIC', 6),
(2, 1, 'Academic Block 2', 'AB2', 'ACADEMIC', 7),
(3, 1, 'Main Building', 'MB', 'ACADEMIC', 4),
(4, 1, 'Silver Jubilee Tower', 'SJT', 'ACADEMIC', 8),
(5, 1, 'Hostel Block A (Men)', 'HBA', 'HOSTEL', 5),
(6, 1, 'Hostel Block B (Women)', 'HBB', 'HOSTEL', 6),
(7, 1, 'Central Library', 'LIB', 'FACILITY', 4),
(8, 1, 'Food Park Mess Complex', 'MESS_FP', 'MESS', 2),
(9, 1, 'Sports Complex & Gymnasium', 'SPORTS', 'FACILITY', 2);

-- Locations
INSERT INTO locations (location_id, building_id, block, floor, room_number, location_name, description) VALUES
(1, 1, 'A-Wing', 2, '204', 'AB1 Room 204', 'Smart Classroom with Projector and 60 capacity'),
(2, 1, 'B-Wing', 3, '305', 'AB1 Room 305', 'Lecture Hall with AC and audio system'),
(3, 5, 'Block A', 2, 'A-204', 'Hostel Block A Room A-204', 'Double Occupancy Student Room'),
(4, 5, 'Block A', 1, 'A-105', 'Hostel Block A Room A-105', 'Single Occupancy Student Room'),
(5, 2, 'East-Wing', 3, '301', 'AB2 Room 301', 'Interactive Computing Lab'),
(6, 6, 'Block B', 3, 'B-310', 'Hostel Block B Room B-310', 'Triple Occupancy Student Room'),
(7, 7, 'North-Wing', 1, 'Reading Hall 1', 'Library First Floor', 'Silent Study and Reference Area'),
(8, 8, 'South-Wing', 1, 'Main Dining Hall', 'Mess Dining Hall', 'Catering capacity 500 students'),
(9, 4, 'Central', 4, '401', 'SJT Room 401', 'High Performance AI Laboratory'),
(10, 9, 'Court 1', 0, 'Badminton Court 1', 'Indoor Sports Complex', 'Standard Wooden Badminton Court');

-- Departments
INSERT INTO departments (department_id, name, code, description, contact_email, contact_phone, office_location) VALUES
(1, 'Electrical Maintenance', 'DEPT_ELEC', 'Handles campus electrical fixtures, wiring, lights, fans, and power backup', 'electrical.dept@vit.ac.in', '0416-2202001', 'Substation Building Ground Floor'),
(2, 'Hostel Maintenance', 'DEPT_HOSTEL', 'Manages hostel room amenities, furniture, windows, and residential upkeep', 'hostel.dept@vit.ac.in', '0416-2202002', 'Hostel Office, Block A Ground Floor'),
(3, 'Mess Management', 'DEPT_MESS', 'Oversees food preparation, caterer hygiene, dining facilities, and food quality', 'mess.dept@vit.ac.in', '0416-2202003', 'Food Park Office, 1st Floor'),
(4, 'IT / Network', 'DEPT_IT', 'Maintains campus Wi-Fi, LAN, Internet gateways, and IT lab infrastructure', 'it.network@vit.ac.in', '0416-2202004', 'Data Center, SJT 2nd Floor'),
(5, 'Plumbing', 'DEPT_PLUMB', 'Maintains water supply pipes, restrooms, drainage, taps, and water purifiers', 'plumbing.dept@vit.ac.in', '0416-2202005', 'Maintenance Yard Room 12'),
(6, 'Housekeeping', 'DEPT_HK', 'Cleanliness of classrooms, hostels, corridors, garbage disposal, and sanitation', 'housekeeping.dept@vit.ac.in', '0416-2202006', 'Main Building Basement Room 04'),
(7, 'Transport', 'DEPT_TRANS', 'University buses, shuttles, fleet operations, routes, and timings', 'transport.dept@vit.ac.in', '0416-2202007', 'Campus Transport Depot'),
(8, 'Library', 'DEPT_LIB', 'Library resources, digital subscriptions, RFID systems, and reading rooms', 'library.dept@vit.ac.in', '0416-2202008', 'Central Library Reception'),
(9, 'Laboratory', 'DEPT_LAB', 'Academic labs, analytical instruments, lab equipment, and consumables', 'laboratory.dept@vit.ac.in', '0416-2202009', 'SJT Lab Technical Office'),
(10, 'Security', 'DEPT_SEC', 'Campus security gates, surveillance, access control, and lost/found', 'security.dept@vit.ac.in', '0416-2202010', 'Main Gate Security Office'),
(11, 'Campus Infrastructure', 'DEPT_ESTATE', 'Civil works, road maintenance, horticulture, classrooms furniture, and signage', 'estate.dept@vit.ac.in', '0416-2202011', 'Estate Office MB Ground Floor');

-- Department Staff / Technicians
INSERT INTO department_staff (staff_id, user_id, department_id, designation, specialization, phone, email, office_location, availability_status) VALUES
(1, 4, 1, 'Senior Electrical Engineer', 'Power systems & AC maintenance', '9876543213', 'electrical@vit.ac.in', 'Substation Block G02', 'AVAILABLE'),
(2, 5, 2, 'Hostel Maintenance Supervisor', 'Hostel room fixtures & carpentry', '9876543214', 'hostel@vit.ac.in', 'Hostel Block A Office', 'AVAILABLE'),
(3, 6, 3, 'Chief Food Quality Officer', 'Food hygiene & catering standards', '9876543215', 'mess@vit.ac.in', 'Food Park Admin Suite', 'AVAILABLE'),
(4, 7, 4, 'Network Administrator', 'Campus Wi-Fi & Fibre Network', '9876543216', 'it@vit.ac.in', 'SJT 201 Network NOC', 'AVAILABLE'),
(5, 8, 5, 'Senior Plumbing Technician', 'Pipeline hydraulics & water purifiers', '9876543217', 'plumbing@vit.ac.in', 'Maintenance Yard 14', 'AVAILABLE'),
(6, 9, 6, 'Sanitation Supervisor', 'Waste management & chemical sanitation', '9876543218', 'housekeeping@vit.ac.in', 'MB Basement 08', 'AVAILABLE');

-- 16 Complaint Categories
INSERT INTO categories (category_id, name, code, icon, description) VALUES
(1, 'Classroom', 'CLASSROOM', 'bi-easel', 'Issues related to classrooms, lecture halls, smart boards, and desks'),
(2, 'Hostel', 'HOSTEL', 'bi-building', 'Issues related to hostel rooms, residential amenities, and common spaces'),
(3, 'Mess', 'MESS', 'bi-cup-hot', 'Issues with dining facilities, food quality, timing, hygiene, and drinking water'),
(4, 'Electrical', 'ELECTRICAL', 'bi-lightning-charge', 'Electrical power, wiring, lights, switches, sockets, and fans'),
(5, 'Plumbing', 'PLUMBING', 'bi-droplet', 'Water leakage, broken taps, flush valves, pipelines, and washroom fittings'),
(6, 'Internet / Wi-Fi', 'INTERNET', 'bi-wifi', 'Campus Wi-Fi connectivity, speed issues, captive portal, and LAN sockets'),
(7, 'Transport', 'TRANSPORT', 'bi-bus-front', 'University bus service, schedule delays, routes, and shuttle issues'),
(8, 'Library', 'LIBRARY', 'bi-book', 'Book checkouts, RFID kiosks, digital workstations, and reading environment'),
(9, 'Laboratory', 'LABORATORY', 'bi-cpu', 'Lab workstations, instruments, chemicals, and laboratory safety equipment'),
(10, 'Housekeeping', 'HOUSEKEEPING', 'bi-trash', 'Room cleaning, corridor sanitation, washroom cleanliness, and waste disposal'),
(11, 'Security', 'SECURITY', 'bi-shield-check', 'Campus safety, entry gate issues, parking, and lost/found property'),
(12, 'Sports Facilities', 'SPORTS', 'bi-trophy', 'Gymnasium equipment, sports courts, floodlights, and swimming pool'),
(13, 'Medical Facilities', 'MEDICAL', 'bi-heart-pulse', 'Campus health centre, ambulance response, first aid, and consultations'),
(14, 'Water Supply', 'WATER', 'bi-water', 'Drinking water coolers, RO filters, and running water supply in blocks'),
(15, 'Campus Infrastructure', 'INFRASTRUCTURE', 'bi-hammer', 'Road conditions, footpaths, building structural maintenance, and lighting'),
(16, 'Other', 'OTHER', 'bi-question-circle', 'General inquiries and campus concerns not classified above');

-- Subcategories
INSERT INTO subcategories (subcategory_id, category_id, name, description, default_priority) VALUES
-- Classroom
(1, 1, 'Light not working', 'Classroom ceiling light or tube fixture faulty', 'MEDIUM'),
(2, 1, 'Fan not working', 'Ceiling or wall fan not spinning or regulator failure', 'MEDIUM'),
(3, 1, 'AC problem', 'Air conditioning unit not cooling or making heavy noise', 'HIGH'),
(4, 1, 'Projector problem', 'Digital projector no display or lamp issue', 'HIGH'),
(5, 1, 'Desk problem', 'Student bench or desk broken or unstable', 'LOW'),
(6, 1, 'Chair problem', 'Classroom chair damaged or backrest broken', 'LOW'),
(7, 1, 'Electrical socket', 'Wall power socket not supplying power', 'MEDIUM'),
-- Hostel
(8, 2, 'Fan problem', 'Ceiling fan regulator or motor failure in hostel room', 'MEDIUM'),
(9, 2, 'Light problem', 'Hostel room study lamp or tube light damaged', 'MEDIUM'),
(10, 2, 'Water problem', 'No water supply in hostel bathroom or sink', 'URGENT'),
(11, 2, 'Bathroom problem', 'Geyser, shower, or flush malfunction', 'HIGH'),
(12, 2, 'Furniture', 'Cot, study table, or cupboard door damaged', 'LOW'),
(13, 2, 'Internet', 'Hostel LAN port or Wi-Fi coverage dead spot', 'MEDIUM'),
(14, 2, 'Room maintenance', 'Window latch, mosquito net, or door lock problem', 'MEDIUM'),
-- Mess
(15, 3, 'Food quality', 'Undercooked or improper taste/quality in meal served', 'HIGH'),
(16, 3, 'Food quantity', 'Shortage of food items during mess operational hours', 'MEDIUM'),
(17, 3, 'Hygiene', 'Unclean dining tables, flies, or improper food handling', 'HIGH'),
(18, 3, 'Drinking water', 'Mess drinking water dispenser smell or temperature issue', 'HIGH'),
(19, 3, 'Dining hall', 'Mess chairs, washbasins, or cooling fans in dining hall', 'MEDIUM'),
(20, 3, 'Food timing', 'Delay in serving breakfast, lunch, snacks, or dinner', 'MEDIUM'),
-- Electrical
(21, 4, 'Power failure', 'Complete power outage in wing or floor', 'URGENT'),
(22, 4, 'Light', 'Corridor, stairwell, or hallway lights not functioning', 'MEDIUM'),
(23, 4, 'Switch', 'Broken or burnt electrical switch', 'HIGH'),
(24, 4, 'Wiring', 'Exposed electrical wiring or sparking hazard', 'URGENT'),
(25, 4, 'Electrical socket', 'Burnt or loose 3-pin wall socket', 'HIGH'),
-- Plumbing
(26, 5, 'Water leakage', 'Continuous pipe leakage causing water accumulation', 'HIGH'),
(27, 5, 'Tap', 'Broken or loose tap leaking water', 'MEDIUM'),
(28, 5, 'Drainage', 'Clogged washbasin or floor drain overflow', 'HIGH'),
(29, 5, 'Bathroom', 'Flush tank leakage or broken health faucet', 'MEDIUM'),
-- Internet / Wi-Fi
(30, 6, 'No internet', 'Wi-Fi shows connected but no internet access', 'HIGH'),
(31, 6, 'Slow internet', 'Extremely low bandwidth or packet drop', 'MEDIUM'),
(32, 6, 'Wi-Fi not connecting', 'Authentication error or AP rejecting credentials', 'HIGH'),
(33, 6, 'Network problem', 'Hostel room ethernet wall jack damaged or non-functional', 'MEDIUM'),
-- Transport
(34, 7, 'Bus issue', 'Bus breakdown or mechanical fault during commute', 'HIGH'),
(35, 7, 'Bus timing', 'Campus bus departure or arrival delay', 'MEDIUM'),
(36, 7, 'Route issue', 'Designated stop skipped or route deviation', 'MEDIUM'),
(37, 7, 'Driver issue', 'Rash driving or inappropriate behaviour', 'URGENT'),
-- Library
(38, 8, 'Book unavailability', 'Required syllabus textbook missing or not in rack', 'LOW'),
(39, 8, 'RFID gate error', 'Self checkout kiosk or entry security gate malfunction', 'MEDIUM'),
(40, 8, 'Digital library workstation', 'OPAC terminal or research workstation system error', 'MEDIUM'),
-- Laboratory
(41, 9, 'Equipment failure', 'Lab oscilloscope, multimeter, or trainer kit broken', 'HIGH'),
(42, 9, 'Computer lab system crash', 'Workstation OS boot failure or software license error', 'HIGH'),
(43, 9, 'Chemicals stockout', 'Essential analytical reagents depleted in chemistry lab', 'MEDIUM'),
-- Housekeeping
(44, 10, 'Room cleaning', 'Dusty room or requested cleaning not attended', 'LOW'),
(45, 10, 'Corridor cleaning', 'Spilled liquid or litter in hallway', 'LOW'),
(46, 10, 'Restroom cleaning', 'Washroom uncleaned or lacking liquid soap', 'HIGH'),
-- Security
(47, 11, 'Lost and found', 'Lost student ID card, wallet, or electronic device', 'MEDIUM'),
(48, 11, 'Parking issue', 'Two-wheeler parked blocking pathway or car lane', 'LOW'),
-- Sports
(49, 12, 'Gym equipment broken', 'Treadmill, cable crossover, or weight bench broken', 'MEDIUM'),
(50, 12, 'Badminton court lighting', 'High-bay floodlight failure on court', 'MEDIUM'),
-- Water Supply
(51, 14, 'RO purifier not working', 'Purifier filtration alarm or cold water dispenser off', 'HIGH'),
(52, 14, 'No running water', 'Overhead tank dry or pump failure', 'URGENT'),
-- Other
(53, 16, 'General campus query', 'General inquiry or campus improvement feedback', 'LOW');

-- Category Department Mapping (Dynamic Allocation)
INSERT INTO category_department_mapping (mapping_id, category_id, subcategory_id, department_id) VALUES
-- Classroom Category
(1, 1, 1, 1),  -- Classroom + Light -> Electrical Maintenance
(2, 1, 2, 1),  -- Classroom + Fan -> Electrical Maintenance
(3, 1, 3, 1),  -- Classroom + AC -> Electrical Maintenance
(4, 1, 4, 4),  -- Classroom + Projector -> IT / Network
(5, 1, 5, 11), -- Classroom + Desk -> Campus Infrastructure
(6, 1, 6, 11), -- Classroom + Chair -> Campus Infrastructure
(7, 1, 7, 1),  -- Classroom + Socket -> Electrical Maintenance
-- Hostel Category
(8, 2, 8, 2),   -- Hostel + Fan -> Hostel Maintenance
(9, 2, 9, 2),   -- Hostel + Light -> Hostel Maintenance
(10, 2, 10, 5), -- Hostel + Water -> Plumbing
(11, 2, 11, 2), -- Hostel + Bathroom -> Hostel Maintenance
(12, 2, 12, 2), -- Hostel + Furniture -> Hostel Maintenance
(13, 2, 13, 4), -- Hostel + Internet -> IT / Network
(14, 2, 14, 2), -- Hostel + Room Maint -> Hostel Maintenance
-- Mess Category
(15, 3, NULL, 3), -- All Mess complaints -> Mess Management
-- Electrical Category
(16, 4, NULL, 1), -- All Electrical complaints -> Electrical Maintenance
-- Plumbing Category
(17, 5, NULL, 5), -- All Plumbing complaints -> Plumbing
-- Internet Category
(18, 6, NULL, 4), -- All Internet complaints -> IT / Network
-- Transport Category
(19, 7, NULL, 7), -- All Transport complaints -> Transport
-- Library Category
(20, 8, NULL, 8), -- All Library complaints -> Library
-- Laboratory Category
(21, 9, NULL, 9), -- All Laboratory complaints -> Laboratory
-- Housekeeping Category
(22, 10, NULL, 6), -- All Housekeeping complaints -> Housekeeping
-- Security Category
(23, 11, NULL, 10), -- All Security complaints -> Security
-- Sports Category
(24, 12, NULL, 11), -- Sports -> Campus Infrastructure
-- Water Supply
(25, 14, NULL, 5), -- Water Supply -> Plumbing
-- Campus Infrastructure
(26, 15, NULL, 11), -- Infrastructure -> Campus Infrastructure
-- Other
(27, 16, NULL, 11); -- Other -> Campus Infrastructure

-- SLA Rules (Priority Escalation)
INSERT INTO sla_rules (sla_id, priority, max_resolution_hours, escalation_hours, description) VALUES
(1, 'URGENT', 4, 2, 'Critical safety or infrastructure failure requiring immediate resolution within 4 hours'),
(2, 'HIGH', 24, 12, 'Significant service disruption requiring resolution within 24 hours'),
(3, 'MEDIUM', 48, 24, 'Standard operational issues requiring resolution within 48 hours'),
(4, 'LOW', 72, 36, 'Minor aesthetic or non-urgent maintenance requiring resolution within 72 hours');

-- QR Codes for key locations
-- Target URLs point to /student/raise-complaint?locationId=...
INSERT INTO qr_codes (qr_id, location_id, qr_code_identifier, qr_image_path, target_url) VALUES
(1, 1, 'QR-LOC-0001-AB1-204', 'uploads/qr/qr_loc_1.png', '/student/raise-complaint?locationId=1'),
(2, 3, 'QR-LOC-0003-HBA-A204', 'uploads/qr/qr_loc_3.png', '/student/raise-complaint?locationId=3'),
(3, 5, 'QR-LOC-0005-AB2-301', 'uploads/qr/qr_loc_5.png', '/student/raise-complaint?locationId=5'),
(4, 7, 'QR-LOC-0007-LIB-101', 'uploads/qr/qr_loc_7.png', '/student/raise-complaint?locationId=7'),
(5, 8, 'QR-LOC-0008-MESS-01', 'uploads/qr/qr_loc_8.png', '/student/raise-complaint?locationId=8');
