<?php
// เปิดการรายงานข้อผิดพลาด (สำหรับการดีบัก, ควรปิดในโปรดักชัน)
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// เริ่มต้นเซสชั่น
session_start();

// รวมไฟล์เชื่อมต่อฐานข้อมูล
include('db_connect.php');

$error = '';

// ตรวจสอบการส่งข้อมูลจากฟอร์ม
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // รับและทำความสะอาดข้อมูล
    $idNumber = $conn->real_escape_string($_POST['idNumber'] ?? '');
    $password = $_POST['password'] ?? '';

    // เข้ารหัสรหัสผ่านด้วย SHA-256
    $hashedPassword = hash('sha256', $password);

    // เตรียมคำสั่ง SQL ป้องกันการโจมตีแบบ SQL Injection
    $stmt = $conn->prepare("SELECT * FROM users WHERE id_number = ? AND password = ?");
    $stmt->bind_param("ss", $idNumber, $hashedPassword);
    $stmt->execute();
    $result = $stmt->get_result();

    // ตรวจสอบว่ามีผู้ใช้หรือไม่
    if ($result->num_rows > 0) {
        // ดึงข้อมูลผู้ใช้
        $user = $result->fetch_assoc();
        $_SESSION['user_id'] = $user['id'];
        $_SESSION['user_role'] = $user['role'];

        // เปลี่ยนเส้นทางตามบทบาทของผู้ใช้
        if ($user['role'] === 'admin') {
            header('Location: homeA.php');
            exit();
        } elseif ($user['role'] === 'teacher') {
            header('Location: homeT.php');
            exit();
        } else {
            header('Location: home.php');
            exit();
        }
    } else {
        $error = 'รหัสประจำตัวหรือรหัสผ่านไม่ถูกต้อง';
    }

    $stmt->close();
}

$conn->close();
?>
<!DOCTYPE html>
<html lang="th">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ระบบจองห้อง EasyRoom - เข้าสู่ระบบ</title>
    <style>
        /* [CSS เดิมของคุณ] */
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            flex-direction: column;
        }

        .title {
            color: #e67e22;
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .container {
            background-color: #ffffff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            max-width: 400px;
            width: 100%;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            font-size: 14px;
            margin-bottom: 8px;
        }

        input {
            width: 100%;
            padding: 10px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }

        .btn {
            background-color: #6c3483;
            color: white;
            padding: 10px 20px;
            font-size: 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
        }

        .btn:hover {
            background-color: #512e5f;
        }

        .error {
            color: red;
            font-size: 14px;
            margin-top: -10px;
            margin-bottom: 20px;
        }
    </style>
</head>

<body>
    <div class="title">ระบบจองห้อง EasyRoom</div>
    <div class="container">
        <form method="POST" action="">
            <div class="form-group">
                <label for="idNumber">รหัสประจำตัว</label>
                <input type="text" name="idNumber" id="idNumber" placeholder="รหัสประจำตัว" required>
            </div>
            <div class="form-group">
                <label for="password">รหัสผ่าน</label>
                <input type="password" name="password" id="password" placeholder="******" required>
            </div>
            <?php if ($error): ?>
                <div class="error"><?= htmlspecialchars($error) ?></div>
            <?php endif; ?>
            <button type="submit" class="btn">ยืนยัน</button>
        </form>
    </div>
</body>

</html>