<?php
// เริ่มต้นเซสชั่น
session_start();

// ลบข้อมูลเซสชั่นทั้งหมด
session_unset();
session_destroy();

// เปลี่ยนเส้นทางไปยังหน้า login
header('Location: login.php');
exit();
?>
