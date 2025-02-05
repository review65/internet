-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: easyroomhost
-- Generation Time: Feb 02, 2025 at 04:11 AM
-- Server version: 9.1.0
-- PHP Version: 8.2.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";
SET NAMES 'utf8mb4' COLLATE 'utf8mb4_unicode_ci';

-- ใช้งานฐานข้อมูล
USE easyroom;


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `easyroom_pre`
--

-- --------------------------------------------------------

--
-- Table structure for table `Admin_information`
--

CREATE TABLE `Admin_information` (
  `Admin_ID` varchar(8) NOT NULL,
  `Name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `Status` enum('ผู้ดูแลห้อง') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Admin_information`
--

INSERT INTO `Admin_information` (`Admin_ID`, `Name`, `email`, `Status`) VALUES
('1', 'นายธราศักดิ์ ชุนกองฮอง', 'tharasak@nu.ac.th', 'ผู้ดูแลห้อง'),
('2', 'นายยุทธพงษ์ คงถาวร', 'yutthapong@nu.ac.th', 'ผู้ดูแลห้อง');

-- --------------------------------------------------------

--
-- Table structure for table `Equipments_list_brokened`
--

CREATE TABLE `Equipments_list_brokened` (
  `Repair_numbers` varchar(12) NOT NULL,
  `Repair_date` datetime DEFAULT NULL,
  `Identify_ID` varchar(8) DEFAULT NULL,
  `Rooms_ID` varchar(6) DEFAULT NULL,
  `Equipments_ID` int DEFAULT NULL,
  `Repair_person_name` varchar(100) DEFAULT NULL,
  `Repair_status` enum('รอซ่อม','รับเรื่องแล้ว','กำลังจัดซื้อ','กำลังซ่อม','ซ่อมสำเร็จ') DEFAULT NULL,
  `Damaged_details` enum('สายไฟชำรุด','ขาเก้าอี้หัก','หน้าจอไม่ติด') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Equipments_list_brokened`
--

INSERT INTO `Equipments_list_brokened` (`Repair_numbers`, `Repair_date`, `Identify_ID`, `Rooms_ID`, `Equipments_ID`, `Repair_person_name`, `Repair_status`, `Damaged_details`) VALUES
('212-001001', '2025-01-15 10:00:00', '65312994', '212', 1, 'นายยุทธพงษ์ คงถาวรอง', 'รับเรื่องแล้ว', 'สายไฟชำรุด'),
('307-001001', '2025-01-16 14:30:00', '65312997', '307', 1, 'นายธราศักดิ์ ชุนกองฮอง', 'กำลังซ่อม', 'ขาเก้าอี้หัก'),
('308-003001', '2025-01-17 09:45:00', '65313000', '308', 3, 'นางสาวสมฤดี จันทรา', 'รอซ่อม', 'หน้าจอไม่ติด'),
('311-004001', '2025-01-18 13:20:00', '65313005', '311', 4, 'นายยุทธพงษ์ คงถาวร', 'กำลังจัดซื้อ', 'ขาเก้าอี้หัก'),
('311-004002', '2025-01-19 11:10:00', '65312994', '311', 4, 'นายยุทธพงษ์ คงถาวร', 'ซ่อมสำเร็จ', 'สายไฟชำรุด');

-- --------------------------------------------------------

--
-- Table structure for table `Equipments_list_information`
--

CREATE TABLE `Equipments_list_information` (
  `Equipments_ID` int NOT NULL,
  `Equipments_name` varchar(100) DEFAULT NULL,
  `Equipments_amount` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Equipments_list_information`
--

INSERT INTO `Equipments_list_information` (`Equipments_ID`, `Equipments_name`, `Equipments_amount`) VALUES
(1, 'คอมพิวเตอร์', 10),
(2, 'โปรเจคเตอร์', 5),
(3, 'จอคอมพิวเตอร์', 3),
(4, 'เก้าอี้', 8),
(5, 'เม้าส์', 7);

-- --------------------------------------------------------

--
-- Table structure for table `Equipments_list_requests`
--

CREATE TABLE `Equipments_list_requests` (
  `Rooms_requests_ID` int NOT NULL,
  `Equipments_ID` int NOT NULL,
  `Equipments_amount` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Equipments_list_requests`
--

INSERT INTO `Equipments_list_requests` (`Rooms_requests_ID`, `Equipments_ID`, `Equipments_amount`) VALUES
(1, 1, 5),
(1, 2, 3),
(2, 3, 2),
(2, 4, 6),
(3, 1, 2),
(3, 5, 4),
(4, 2, 1),
(4, 3, 3),
(5, 4, 10),
(5, 5, 7),
(6, 1, 8),
(6, 2, 4);

-- --------------------------------------------------------

--
-- Table structure for table `Executive_information`
--

CREATE TABLE `Executive_information` (
  `Executive_ID` varchar(8) NOT NULL,
  `Name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `Status` enum('ผู้บริหาร') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Executive_information`
--

INSERT INTO `Executive_information` (`Executive_ID`, `Name`, `email`, `Status`) VALUES
('CSB25645', 'วุฒิพงศ์ เรือนทอง', 'wuttipong@nu.ac.th', 'ผู้บริหาร');

-- --------------------------------------------------------

--
-- Table structure for table `Manage_computers`
--

CREATE TABLE `Manage_computers` (
  `Computer_ID` int NOT NULL,
  `Rooms_ID` varchar(6) NOT NULL,
  `Computer_status` enum('ใช้งานได้','ใช้งานไม่ได้') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Manage_computers`
--

INSERT INTO `Manage_computers` (`Computer_ID`, `Rooms_ID`, `Computer_status`) VALUES
(1, '212', 'ใช้งานได้'),
(1, '307', 'ใช้งานได้'),
(1, '308', 'ใช้งานได้'),
(1, '311', 'ใช้งานได้'),
(1, '407', 'ใช้งานได้'),
(1, '414', 'ใช้งานได้'),
(2, '212', 'ใช้งานไม่ได้'),
(2, '308', 'ใช้งานไม่ได้'),
(2, '311', 'ใช้งานไม่ได้'),
(2, '407', 'ใช้งานไม่ได้'),
(2, '414', 'ใช้งานไม่ได้'),
(3, '212', 'ใช้งานได้'),
(5, '307', 'ใช้งานไม่ได้'),
(6, '307', 'ใช้งานได้'),
(9, '308', 'ใช้งานได้'),
(12, '311', 'ใช้งานได้'),
(15, '407', 'ใช้งานได้'),
(18, '414', 'ใช้งานได้');

-- --------------------------------------------------------

--
-- Table structure for table `Manage_equipments`
--

CREATE TABLE `Manage_equipments` (
  `Equipments_ID` int NOT NULL,
  `Rooms_ID` varchar(6) NOT NULL,
  `Equipments_amount` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Manage_equipments`
--

INSERT INTO `Manage_equipments` (`Equipments_ID`, `Rooms_ID`, `Equipments_amount`) VALUES
(1, '212', 10),
(1, '307', 15),
(1, '308', 20),
(1, '311', 12),
(1, '407', 18),
(1, '414', 10),
(2, '212', 5),
(2, '307', 3),
(2, '308', 7),
(2, '311', 4),
(2, '407', 6),
(2, '414', 4),
(3, '212', 3),
(3, '307', 2),
(3, '308', 6),
(3, '311', 5),
(3, '407', 4),
(3, '414', 3),
(4, '212', 8),
(4, '307', 10),
(4, '308', 12),
(4, '311', 7),
(4, '407', 9),
(4, '414', 8),
(5, '212', 7),
(5, '307', 5),
(5, '308', 8),
(5, '311', 9),
(5, '407', 6),
(5, '414', 7);

-- --------------------------------------------------------

--
-- Table structure for table `Name_list_requests_rooms`
--

CREATE TABLE `Name_list_requests_rooms` (
  `Rooms_requests_ID` int NOT NULL,
  `Identify_ID` varchar(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Name_list_requests_rooms`
--

INSERT INTO `Name_list_requests_rooms` (`Rooms_requests_ID`, `Identify_ID`) VALUES
(2, '64312995'),
(3, '64313005'),
(2, '64313012'),
(1, '65312994'),
(1, '65312997'),
(4, '65313003'),
(3, '65313006'),
(4, '65313009'),
(5, '65313012'),
(5, '66312993'),
(6, '66312996');

-- --------------------------------------------------------

--
-- Table structure for table `Rooms_list_information`
--

CREATE TABLE `Rooms_list_information` (
  `Rooms_ID` varchar(6) NOT NULL,
  `Rooms_name` varchar(10) DEFAULT NULL,
  `Floors` enum('2','3','4') DEFAULT NULL,
  `Room_types` enum('ห้องเลคเชอร์','ห้องปฏิบัติการ') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Rooms_list_information`
--

INSERT INTO `Rooms_list_information` (`Rooms_ID`, `Rooms_name`, `Floors`, `Room_types`) VALUES
('212', 'SC2-212', '2', 'ห้องเลคเชอร์'),
('307', 'SC2-307', '3', 'ห้องปฏิบัติการ'),
('308', 'SC2-308', '3', 'ห้องปฏิบัติการ'),
('311', 'SC2-311', '3', 'ห้องเลคเชอร์'),
('407', 'SC2-407', '4', 'ห้องเลคเชอร์'),
('414', 'SC2-414', '4', 'ห้องปฏิบัติการ');

-- --------------------------------------------------------

--
-- Table structure for table `Rooms_list_requests`
--

CREATE TABLE `Rooms_list_requests` (
  `Rooms_requests_ID` int NOT NULL,
  `Submitted_time` datetime DEFAULT NULL,
  `Rooms_ID` varchar(6) DEFAULT NULL,
  `Used_date` date DEFAULT NULL,
  `Identify_ID` varchar(8) DEFAULT NULL,
  `Start_time` time DEFAULT NULL,
  `End_time` time DEFAULT NULL,
  `Reason` enum('ขอใช้ห้องเพื่อติวหนังสือ','ขอใช้ห้องเพื่อประชุมงานกลุ่ม','ขอใช้ห้องเพื่อจัดกิจกรรมเสริมความรู้') DEFAULT NULL,
  `Requests_status` enum('รอดำเนินการ', 'รออนุมัติ', 'อนุมัติ','ไม่อนุมัติ') DEFAULT NULL,
  `Requests_types` enum('ในเวลา','นอกเวลา') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Rooms_list_requests`
--

INSERT INTO `Rooms_list_requests` (`Rooms_requests_ID`, `Submitted_time`, `Rooms_ID`, `Used_date`, `Identify_ID`, `Start_time`, `End_time`, `Reason`, `Requests_status`, `Requests_types`) VALUES
(1, '2025-01-20 09:00:00', '212', '2025-01-22', '65312994', '08:00:00', '10:00:00', 'ขอใช้ห้องเพื่อติวหนังสือ', 'อนุมัติ', 'ในเวลา'),
(2, '2025-01-20 09:30:00', '307', '2025-01-23', '65312997', '10:00:00', '12:00:00', 'ขอใช้ห้องเพื่อประชุมงานกลุ่ม', 'ไม่อนุมัติ', 'ในเวลา'),
(3, '2025-01-20 10:00:00', '308', '2025-01-24', '64312995', '13:00:00', '15:00:00', 'ขอใช้ห้องเพื่อจัดกิจกรรมเสริมความรู้', 'อนุมัติ', 'นอกเวลา'),
(4, '2025-01-20 11:00:00', '311', '2025-01-25', '64313012', '09:00:00', '11:00:00', 'ขอใช้ห้องเพื่อติวหนังสือ', 'ไม่อนุมัติ', 'ในเวลา'),
(5, '2025-01-20 12:00:00', '407', '2025-01-26', '64313005', '14:00:00', '16:00:00', 'ขอใช้ห้องเพื่อประชุมงานกลุ่ม', 'อนุมัติ', 'นอกเวลา'),
(6, '2025-01-20 13:00:00', '414', '2025-01-27', '65313006', '08:30:00', '10:30:00', 'ขอใช้ห้องเพื่อจัดกิจกรรมเสริมความรู้', 'อนุมัติ', 'ในเวลา');

-- --------------------------------------------------------

--
-- Table structure for table `Schedule_time`
--

CREATE TABLE `Schedule_time` (
  `Schedule_ID` int NOT NULL,
  `Rooms_ID` varchar(6) DEFAULT NULL,
  `Week_days` enum('จันทร์','อังคาร','พุธ','พฤหัสบดี','ศุกร์','เสาร์','อาทิตย์') DEFAULT NULL,
  `Start_time` time DEFAULT NULL,
  `End_time` time DEFAULT NULL,
  `Rooms_status` enum('ว่าง','ไม่ว่าง','มีเรียน','กำลังปรับปรุง') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Schedule_time`
--

INSERT INTO `Schedule_time` (`Schedule_ID`, `Rooms_ID`, `Week_days`, `Start_time`, `End_time`, `Rooms_status`) VALUES
(1, '212', 'จันทร์', '08:00:00', '10:00:00', 'มีเรียน'),
(2, '212', 'จันทร์', '10:30:00', '12:30:00', 'ไม่ว่าง'),
(3, '212', 'จันทร์', '13:00:00', '15:00:00', 'กำลังปรับปรุง'),
(4, '212', 'จันทร์', '15:30:00', '17:30:00', 'ว่าง'),
(5, '307', 'อังคาร', '08:00:00', '10:00:00', 'มีเรียน'),
(6, '307', 'อังคาร', '10:30:00', '12:30:00', 'ไม่ว่าง'),
(7, '307', 'อังคาร', '13:00:00', '15:00:00', 'กำลังปรับปรุง'),
(8, '307', 'อังคาร', '15:30:00', '17:30:00', 'ว่าง'),
(9, '308', 'พุธ', '08:00:00', '10:00:00', 'มีเรียน'),
(10, '308', 'พุธ', '10:30:00', '12:30:00', 'ไม่ว่าง'),
(11, '308', 'พุธ', '13:00:00', '15:00:00', 'กำลังปรับปรุง'),
(12, '308', 'พุธ', '15:30:00', '17:30:00', 'ว่าง'),
(13, '311', 'พฤหัสบดี', '08:00:00', '10:00:00', 'มีเรียน'),
(14, '311', 'พฤหัสบดี', '10:30:00', '12:30:00', 'ไม่ว่าง'),
(15, '311', 'พฤหัสบดี', '13:00:00', '15:00:00', 'กำลังปรับปรุง'),
(16, '311', 'พฤหัสบดี', '15:30:00', '17:30:00', 'ว่าง'),
(17, '407', 'ศุกร์', '08:00:00', '10:00:00', 'มีเรียน'),
(18, '407', 'ศุกร์', '10:30:00', '12:30:00', 'ไม่ว่าง'),
(19, '407', 'ศุกร์', '13:00:00', '15:00:00', 'กำลังปรับปรุง'),
(20, '407', 'ศุกร์', '15:30:00', '17:30:00', 'ว่าง'),
(21, '414', 'เสาร์', '08:00:00', '10:00:00', 'มีเรียน'),
(22, '414', 'เสาร์', '10:30:00', '12:30:00', 'ไม่ว่าง'),
(23, '414', 'เสาร์', '13:00:00', '15:00:00', 'กำลังปรับปรุง'),
(24, '414', 'เสาร์', '15:30:00', '17:30:00', 'ว่าง');

-- --------------------------------------------------------

--
-- Table structure for table `Student_information`
--

CREATE TABLE `Student_information` (
  `Student_ID` varchar(8) NOT NULL,
  `Name` varchar(100) DEFAULT NULL,
  `Department` varchar(100) DEFAULT NULL,
  `Faculty` varchar(100) DEFAULT NULL,
  `Academic_year` int DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `Phone_number` varchar(10) DEFAULT NULL,
  `Status` enum('นิสิต') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Student_information`
--

INSERT INTO `Student_information` (`Student_ID`, `Name`, `Department`, `Faculty`, `Academic_year`, `email`, `Phone_number`, `Status`) VALUES
('64312995', 'สุกานดา ศรีประเสริฐ', 'เทคโนโลยีสารสนเทศ', 'คณะวิทยาศาสตร์', 2564, 'sukanda.s@example.com', '0814567890', 'นิสิต'),
('64312998', 'เกรียงไกร วิชชุภักดี', 'เทคโนโลยีสารสนเทศ', 'คณะวิทยาศาสตร์', 2564, 'kriengkhai.w@example.com', '0817890123', 'นิสิต'),
('64313001', 'พิมพ์ชนก ลีลาชัย', 'เทคโนโลยีสารสนเทศ', 'คณะวิทยาศาสตร์', 2564, 'phimchanok.l@example.com', '0820123456', 'นิสิต'),
('64313005', 'รติพร บุญส่ง', 'วิทยาการคอมพิวเตอร์', 'คณะวิทยาศาสตร์', 2564, 'ratiporn.b@example.com', '0824567890', 'นิสิต'),
('64313012', 'กิตติพงษ์ กองแก้ว', 'วิทยาการข้อมูล', 'คณะวิทยาศาสตร์', 2564, 'kittipong.k@example.com', '0831234567', 'นิสิต'),
('65312994', 'สมหญิง รุ่งโรจน์', 'วิทยาการข้อมูล', 'คณะวิทยาศาสตร์', 2565, 'somhun.r@example.com', '0813456789', 'นิสิต'),
('65312997', 'นภัสวรรณ บัวทอง', 'วิทยาการข้อมูล', 'คณะวิทยาศาสตร์', 2565, 'napatsawan.b@example.com', '0816789012', 'นิสิต'),
('65313000', 'ธนากร สุดใจ', 'วิทยาการข้อมูล', 'คณะวิทยาศาสตร์', 2565, 'thanakorn.s@example.com', '0819012345', 'นิสิต'),
('65313003', 'ปิยาพร มั่นคง', 'วิทยาการข้อมูล', 'คณะวิทยาศาสตร์', 2565, 'piyaporn.m@example.com', '0822345678', 'นิสิต'),
('65313006', 'ดวงใจ กาญจนารักษ์', 'วิทยาการข้อมูล', 'คณะวิทยาศาสตร์', 2565, 'duangjai.k@example.com', '0825678901', 'นิสิต'),
('65313009', 'ศิริรัตน์ สมบัติ', 'วิทยาการข้อมูล', 'คณะวิทยาศาสตร์', 2565, 'sirirat.s@example.com', '0828901234', 'นิสิต'),
('66312993', 'สมชาย พันธ์ดี', 'วิทยาการคอมพิวเตอร์', 'คณะวิทยาศาสตร์', 2566, 'somchai.p@example.com', '0812345678', 'นิสิต'),
('66312996', 'อภิชาติ สุขสม', 'วิทยาการคอมพิวเตอร์', 'คณะวิทยาศาสตร์', 2566, 'apichat.s@example.com', '0815678901', 'นิสิต'),
('66313004', 'วัชรินทร์ ศรีนวล', 'เทคโนโลยีสารสนเทศ', 'คณะวิทยาศาสตร์', 2566, 'watcharin.s@example.com', '0823456789', 'นิสิต'),
('66313007', 'ธนภัทร พานิช', 'เทคโนโลยีสารสนเทศ', 'คณะวิทยาศาสตร์', 2566, 'thanapat.p@example.com', '0826789012', 'นิสิต'),
('66313010', 'อมรเทพ ไชยวัฒน์', 'เทคโนโลยีสารสนเทศ', 'คณะวิทยาศาสตร์', 2566, 'amorntep.c@example.com', '0829012345', 'นิสิต'),
('67312999', 'เมธาวี จันทรา', 'วิทยาการคอมพิวเตอร์', 'คณะวิทยาศาสตร์', 2567, 'methawi.c@example.com', '0818901234', 'นิสิต'),
('67313002', 'อรพรรณ แสงสุริยะ', 'วิทยาการคอมพิวเตอร์', 'คณะวิทยาศาสตร์', 2567, 'orapan.s@example.com', '0821234567', 'นิสิต'),
('67313008', 'พุฒิพงษ์ เพ็ชรชม', 'วิทยาการคอมพิวเตอร์', 'คณะวิทยาศาสตร์', 2567, 'puttipong.p@example.com', '0827890123', 'นิสิต'),
('67313011', 'บุญช่วย ศรีสวัสดิ์', 'วิทยาการคอมพิวเตอร์', 'คณะวิทยาศาสตร์', 2567, 'bunchuai.s@example.com', '0830123456', 'นิสิต');

-- --------------------------------------------------------

--
-- Table structure for table `Teacher_information`
--

CREATE TABLE `Teacher_information` (
  `Teacher_ID` varchar(8) NOT NULL,
  `Name` varchar(100) DEFAULT NULL,
  `Department` varchar(100) DEFAULT NULL,
  `Faculty` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `Phone_number` varchar(10) DEFAULT NULL,
  `Status` enum('อาจารย์') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Teacher_information`
--

INSERT INTO `Teacher_information` (`Teacher_ID`, `Name`, `Department`, `Faculty`, `email`, `Phone_number`, `Status`) VALUES
('CS653129', 'สมชาย พันธ์ดี', 'วิทยาการคอมพิวเตอร์', 'คณะวิทยาศาสตร์', 'somchai.p.teacher@example.com', '0912345678', 'อาจารย์'),
('CS663129', 'อภิชาติ สุขสม', 'วิทยาการคอมพิวเตอร์', 'คณะวิทยาศาสตร์', 'apichat.s.teacher@example.com', '0915678901', 'อาจารย์'),
('CS673129', 'เมธาวี จันทรา', 'วิทยาการคอมพิวเตอร์', 'คณะวิทยาศาสตร์', 'methawi.c.teacher@example.com', '0918901234', 'อาจารย์'),
('CS673131', 'อรพรรณ แสงสุริยะ', 'วิทยาการคอมพิวเตอร์', 'คณะวิทยาศาสตร์', 'orapan.s.teacher@example.com', '0921234567', 'อาจารย์'),
('DS653129', 'สมหญิง รุ่งโรจน์', 'วิทยาการข้อมูล', 'คณะวิทยาศาสตร์', 'somhun.r.teacher@example.com', '0913456789', 'อาจารย์'),
('DS663129', 'นภัสวรรณ บัวทอง', 'วิทยาการข้อมูล', 'คณะวิทยาศาสตร์', 'napatsawan.b.teacher@example.com', '0916789012', 'อาจารย์'),
('DS673130', 'ธนากร สุดใจ', 'วิทยาการข้อมูล', 'คณะวิทยาศาสตร์', 'thanakorn.s.teacher@example.com', '0919012345', 'อาจารย์'),
('IT653129', 'สุกานดา ศรีประเสริฐ', 'เทคโนโลยีสารสนเทศ', 'คณะวิทยาศาสตร์', 'sukanda.s.teacher@example.com', '0914567890', 'อาจารย์'),
('IT663129', 'เกรียงไกร วิชชุภักดี', 'เทคโนโลยีสารสนเทศ', 'คณะวิทยาศาสตร์', 'kriengkhai.w.teacher@example.com', '0917890123', 'อาจารย์'),
('IT673130', 'พิมพ์ชนก ลีลาชัย', 'เทคโนโลยีสารสนเทศ', 'คณะวิทยาศาสตร์', 'phimchanok.l.teacher@example.com', '0920123456', 'อาจารย์');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Admin_information`
--
ALTER TABLE `Admin_information`
  ADD PRIMARY KEY (`Admin_ID`);

--
-- Indexes for table `Equipments_list_brokened`
--
ALTER TABLE `Equipments_list_brokened`
  ADD PRIMARY KEY (`Repair_numbers`),
  ADD KEY `Rooms_ID` (`Rooms_ID`),
  ADD KEY `Equipments_ID` (`Equipments_ID`),
  ADD KEY `Identify_ID` (`Identify_ID`);

--
-- Indexes for table `Equipments_list_information`
--
ALTER TABLE `Equipments_list_information`
  ADD PRIMARY KEY (`Equipments_ID`);

--
-- Indexes for table `Equipments_list_requests`
--
ALTER TABLE `Equipments_list_requests`
  ADD PRIMARY KEY (`Rooms_requests_ID`,`Equipments_ID`),
  ADD KEY `Equipments_ID` (`Equipments_ID`);

--
-- Indexes for table `Executive_information`
--
ALTER TABLE `Executive_information`
  ADD PRIMARY KEY (`Executive_ID`);

--
-- Indexes for table `Manage_computers`
--
ALTER TABLE `Manage_computers`
  ADD PRIMARY KEY (`Computer_ID`,`Rooms_ID`),
  ADD KEY `Rooms_ID` (`Rooms_ID`);

--
-- Indexes for table `Manage_equipments`
--
ALTER TABLE `Manage_equipments`
  ADD PRIMARY KEY (`Equipments_ID`,`Rooms_ID`),
  ADD KEY `Rooms_ID` (`Rooms_ID`);

--
-- Indexes for table `Name_list_requests_rooms`
--
ALTER TABLE `Name_list_requests_rooms`
  ADD PRIMARY KEY (`Rooms_requests_ID`,`Identify_ID`),
  ADD KEY `Identify_ID` (`Identify_ID`);

--
-- Indexes for table `Rooms_list_information`
--
ALTER TABLE `Rooms_list_information`
  ADD PRIMARY KEY (`Rooms_ID`);

--
-- Indexes for table `Rooms_list_requests`
--
ALTER TABLE `Rooms_list_requests`
  ADD PRIMARY KEY (`Rooms_requests_ID`),
  ADD KEY `Rooms_ID` (`Rooms_ID`),
  ADD KEY `Identify_ID` (`Identify_ID`);

--
-- Indexes for table `Schedule_time`
--
ALTER TABLE `Schedule_time`
  ADD PRIMARY KEY (`Schedule_ID`),
  ADD KEY `Rooms_ID` (`Rooms_ID`);

--
-- Indexes for table `Student_information`
--
ALTER TABLE `Student_information`
  ADD PRIMARY KEY (`Student_ID`);

--
-- Indexes for table `Teacher_information`
--
ALTER TABLE `Teacher_information`
  ADD PRIMARY KEY (`Teacher_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
