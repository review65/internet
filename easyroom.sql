SET NAMES 'utf8mb4' COLLATE 'utf8mb4_unicode_ci';
-- ใช้งานฐานข้อมูล
USE easyroom;

-- ตารางสำหรับเก็บข้อมูลผู้ใช้
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_number VARCHAR(20) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'user', 'teacher') DEFAULT 'user',  -- เพิ่ม teacher
    full_name VARCHAR(100) NOT NULL,
    year INT DEFAULT 1,
    student_id VARCHAR(20) UNIQUE,
    major VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- เพิ่มข้อมูลผู้ใช้ใหม่
INSERT INTO users (id_number, password, role, full_name, year, student_id, major)
VALUES 
('65310000', SHA2('123', 256), 'user', 'นาย ปัญญากร ทีมจันทึก', 3, '65310000', 'วิทยาการคอมพิวเตอร์'),
('123456', SHA2('123', 256), 'admin', 'นาย สมชาย ใจดี', 2, '123456', 'เจ้าหน้าที่ดูแล'),
('12345', SHA2('123', 256), 'teacher', 'นางสาว นันธกร บุญมี', 2, '012345', 'อาจารย์สาขาวิทยาการคอมพิวเตอร์');

-- ตารางสำหรับเก็บห้อง
CREATE TABLE rooms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    room_name VARCHAR(50) NOT NULL,
    capacity INT NOT NULL CHECK (capacity >= 0),
    description TEXT
);

-- ตัวอย่างข้อมูลห้อง
INSERT INTO rooms (room_name, capacity, description) VALUES
('SC2-211', 150, 'ห้องเรียนบรรยาย (ความจุ 150 คน)'),
('SC2-212', 192, 'ห้องเรียนบรรยาย (ความจุ 192 คน)'),
('SC2-307', 80, 'ห้องปฏิบัติการคอมพิวเตอร์ (ความจุ 80 คน)'),
('SC2-308', 60, 'ห้องปฏิบัติการคอมพิวเตอร์ (Cisco) (ความจุ 60 คน)'),
('SC2-311', 20, 'ห้องค้นคว้าป.ตรี (ความจุ 20 คน)'),
('SC2-313', 0, 'ห้องมัลติมีเดีย (ความจุ 0 คน)'),
('SC2-313-1', 10, 'ห้องเรียนบรรยาย (ความจุ 10 คน)'),
('SC2-314', 10, 'ห้องเรียนบรรยาย (ความจุ 10 คน)'),
('SC2-407', 0, 'ห้องประชุมภาควิชา'),
('SC2-411', 0, 'ห้องสตูดิโอ'),
('SC2-414', 70, 'ห้องปฏิบัติการคอมพิวเตอร์ (ความจุ 70 คน)');

-- ตารางสำหรับเก็บข้อมูลการจองห้อง
CREATE TABLE reservations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    room_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    purpose TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_time CHECK (start_time < end_time)
);

-- ตารางสำหรับการจอง
INSERT INTO `reservations` (`id`, `user_id`, `room_id`, `start_time`, `end_time`, `purpose`, `created_at`) VALUES
(1, 1, 3, '2024-12-26 14:00:11', '2024-12-26 17:00:00', 'ขอใช้ห้อง', '2024-12-26 02:30:37'),
(65310001, 1, 4, '2024-12-25 19:30:36', '2024-12-25 20:30:36', 'ประชุมทีม', '2024-12-26 02:30:37');

-- สร้างตาราง room_schedule
CREATE TABLE room_schedule (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL,
    `08-09` VARCHAR(255) DEFAULT NULL,
    `09-10` VARCHAR(255) DEFAULT NULL,
    `10-11` VARCHAR(255) DEFAULT NULL,
    `11-12` VARCHAR(255) DEFAULT NULL,
    `12-13` VARCHAR(255) DEFAULT NULL,
    `13-14` VARCHAR(255) DEFAULT NULL,
    `14-15` VARCHAR(255) DEFAULT NULL,
    `15-16` VARCHAR(255) DEFAULT NULL,
    `16-17` VARCHAR(255) DEFAULT NULL,
    `17-18` VARCHAR(255) DEFAULT NULL,
    `18-19` VARCHAR(255) DEFAULT NULL,
    `19-20` VARCHAR(255) DEFAULT NULL,
    `20-21` VARCHAR(255) DEFAULT NULL
);

-- ตารางสำหรับการยืมอุปกรณ์
CREATE TABLE borrow_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    console INT,
    cat5 INT,
    crossover INT,
    hub INT,
    router INT,
    switch INT,
    pointer INT,
    microphone INT
);

-- ตารางสำหรับสถานะของโต๊ะ
CREATE TABLE desk_status (
    desk_id INT PRIMARY KEY,
    status ENUM('ว่าง', 'ไม่ว่าง') DEFAULT 'ว่าง'
);

-- ตารางสำหรับบันทึกการกระทำของผู้ใช้
CREATE TABLE logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action VARCHAR(255),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- สร้างตารางสำหรับการเรียนการสอน
CREATE TABLE lectures (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,  -- อาจารย์
    room_id INT NOT NULL,  -- ห้องที่ใช้ในการเรียนการสอน
    start_time DATETIME NOT NULL,  -- เวลาที่เริ่มการเรียนการสอน
    end_time DATETIME NOT NULL,  -- เวลาที่เรียนการสอนจบ
    subject VARCHAR(100) NOT NULL,  -- วิชาที่สอน
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_lecture_time CHECK (start_time < end_time)
);

INSERT INTO lectures (user_id, room_id, start_time, end_time, subject)
VALUES 
-- วันอาทิตย์ (2024-12-22)
(3, 4, '2024-12-22 08:00:00', '2024-12-22 10:00:00', 'วิชาเทคโนโลยีคอมพิวเตอร์'),
(3, 4, '2024-12-22 10:00:00', '2024-12-22 12:00:00', 'วิชาการออกแบบซอฟต์แวร์'),

-- วันจันทร์ (2024-12-23)
(3, 4, '2024-12-23 08:00:00', '2024-12-23 10:00:00', 'วิชาคณิตศาสตร์เบื้องต้น'),
(3, 4, '2024-12-23 10:00:00', '2024-12-23 12:00:00', 'วิชาภาษาอังกฤษธุรกิจ'),
(3, 4, '2024-12-23 13:00:00', '2024-12-23 15:00:00', 'วิชาการออกแบบฐานข้อมูล'),

-- วันอังคาร (2024-12-24)
(3, 4, '2024-12-24 08:00:00', '2024-12-24 10:00:00', 'วิชาเทคโนโลยีคอมพิวเตอร์'),
(3, 4, '2024-12-24 10:00:00', '2024-12-24 12:00:00', 'วิชาการออกแบบซอฟต์แวร์'),
(3, 4, '2024-12-24 13:00:00', '2024-12-24 15:00:00', 'วิชาภาษาอังกฤษธุรกิจ'),

-- วันพุธ (2024-12-25)
(3, 4, '2024-12-25 08:00:00', '2024-12-25 10:00:00', 'วิชาคณิตศาสตร์เบื้องต้น'),
(3, 4, '2024-12-25 10:00:00', '2024-12-25 12:00:00', 'วิชาการออกแบบฐานข้อมูล'),
(3, 4, '2024-12-25 13:00:00', '2024-12-25 15:00:00', 'วิชาภาษาไทย'),

-- วันพฤหัสบดี (2024-12-26)
(3, 4, '2024-12-26 08:00:00', '2024-12-26 10:00:00', 'วิชาเทคโนโลยีคอมพิวเตอร์'),
(3, 4, '2024-12-26 10:00:00', '2024-12-26 12:00:00', 'วิชาการออกแบบซอฟต์แวร์'),
(3, 4, '2024-12-26 13:00:00', '2024-12-26 15:00:00', 'วิชาการออกแบบฐานข้อมูล'),

-- วันศุกร์ (2024-12-27)
(3, 4, '2024-12-27 08:00:00', '2024-12-27 10:00:00', 'วิชาคณิตศาสตร์เบื้องต้น'),
(3, 4, '2024-12-27 10:00:00', '2024-12-27 12:00:00', 'วิชาภาษาอังกฤษธุรกิจ'),
(3, 4, '2024-12-27 13:00:00', '2024-12-27 15:00:00', 'วิชาภาษาไทย'),

-- วันเสาร์ (2024-12-28)
(3, 4, '2024-12-28 08:00:00', '2024-12-28 10:00:00', 'วิชาการออกแบบซอฟต์แวร์'),
(3, 4, '2024-12-28 10:00:00', '2024-12-28 12:00:00', 'วิชาคณิตศาสตร์เบื้องต้น'),
(3, 4, '2024-12-28 13:00:00', '2024-12-28 15:00:00', 'วิชาภาษาอังกฤษธุรกิจ');

SELECT * FROM lectures 
WHERE room_id = 4 
AND DATE(start_time) = '2024-12-22' 
AND start_time < '09:00:00' 
AND end_time > '08:00:00';
