<?php
// เริ่มต้นเซสชั่น
session_start();

// ตั้งค่าการเชื่อมต่อฐานข้อมูล
include('db_connect.php')
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EasyRoom Reservation System - Login</title>
    <style>
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
    <div class="title">EasyRoom Reservation System</div>
    <div class="container">
        <?php
        $error = '';

        // ตรวจสอบการส่งข้อมูลจากฟอร์ม
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $idNumber = $conn->real_escape_string($_POST['idNumber'] ?? '');
            $password = $conn->real_escape_string($_POST['password'] ?? '');

            // เข้ารหัสรหัสผ่านด้วย SHA2
            $hashedPassword = hash('sha256', $password);

            // Query ตรวจสอบผู้ใช้
            $query = "SELECT * FROM users WHERE id_number = '$idNumber' AND password = '$hashedPassword'";
            $result = $conn->query($query);

            if ($result->num_rows > 0) {
                // กำหนดค่าเซสชั่น
                $user = $result->fetch_assoc();
                $_SESSION['user_id'] = $user['id'];
                $_SESSION['user_role'] = $user['role'];

                // ตรวจสอบบทบาทของผู้ใช้
                if ($user['role'] == 'admin') {
                    // เปลี่ยนเส้นทางไปยังหน้า admin.php
                    header('Location: homeA.php');
                    exit();
                } elseif ($user['role'] == 'teacher') {
                    // เปลี่ยนเส้นทางไปยังหน้า teacher.php
                    header('Location: homeT.php');
                    exit();
                } else {
                    // เปลี่ยนเส้นทางไปยังหน้า user.php
                    header('Location: home.php');
                    exit();
                }
            } else {
                $error = 'รหัสประจำตัวหรือรหัสผ่านไม่ถูกต้อง';
            }
        }
        ?>

        <form method="POST" action="home.php">
            <div class="form-group">
                <label for="idNumber">รหัสประจำตัว</label>
                <input type="text" name="idNumber" id="idNumber" placeholder="รหัสประจำตัว" required>
            </div>
            <div class="form-group">
                <label for="password">รหัสผ่าน</label>
                <input type="password" name="password" id="password" placeholder="******" required>
            </div>
            <?php if ($error): ?>
                <div class="error"><?= $error ?></div>
            <?php endif; ?>
            <button type="submit" class="btn">ยืนยัน</button>
        </form>
    </div>
</body>

</html>