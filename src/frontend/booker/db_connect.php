<?php
$host = "easyroomhost";
$username = "root";
$password = "1234";
$dbname = "easyroom"; // ชื่อฐานข้อมูล

$conn = new mysqli($host, $username, $password, $dbname);
if ($conn->connect_error) {
    die("เกิดข้อผิดพลาด: " . $conn->connect_error);
} else {
    // echo "เชื่อมต่อฐานข้อมูลสำเร็จ";
}

$conn->set_charset("utf8");
