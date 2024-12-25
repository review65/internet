<?php
// ตั้งค่าการเชื่อมต่อฐานข้อมูล
include('db_connect.php');

// รับวันที่ที่เลือก
$selected_date = $_GET['search_date'] ?? date('Y-m-d'); // วันที่ที่เลือกหรือวันที่ปัจจุบัน

// คำนวณวันในสัปดาห์ (เริ่มที่วันจันทร์)
$day_of_week = (date('w', strtotime($selected_date)) + 6) % 7; // แปลงให้จันทร์ = 0
$start_of_week = date('Y-m-d', strtotime($selected_date . ' -' . $day_of_week . ' days'));
$end_of_week = date('Y-m-d', strtotime($start_of_week . ' +6 days'));

// สร้างวันที่ในสัปดาห์
$dates_in_week = [];
for ($i = 0; $i < 7; $i++) {
    $dates_in_week[] = date('Y-m-d', strtotime($start_of_week . " +$i days"));
}

// ดึงข้อมูลการเรียนการสอนจากฐานข้อมูล
$room_id = 4; // ห้อง SC2-308 (สามารถเปลี่ยนแปลงได้ตามต้องการ)
$query = "SELECT * FROM lectures WHERE room_id = ? AND start_time BETWEEN ? AND ?";
$stmt = $conn->prepare($query);
$stmt->bind_param("iss", $room_id, $start_of_week, $end_of_week);
$stmt->execute();
$result = $stmt->get_result();

// สร้างอาเรย์สำหรับข้อมูลตาราง
$schedules = [];
while ($row = $result->fetch_assoc()) {
    // เก็บข้อมูลเวลาเรียนในแต่ละวัน
    $day = date('Y-m-d', strtotime($row['start_time']));
    $start_time = date('H:i', strtotime($row['start_time']));
    $end_time = date('H:i', strtotime($row['end_time']));
    $schedules[$day][$start_time] = 'มีการเรียนการสอน';
}

// คำสั่งตรวจสอบการเรียนการสอนในช่วงเวลาที่เลือก
function checkLecture($room_id, $date, $start_time, $end_time, $schedules)
{
    // ตรวจสอบว่าในวันที่นั้นๆ ในช่วงเวลาที่กำหนดมีการเรียนการสอนหรือไม่
    if (isset($schedules[$date][$start_time])) {
        return 'มีการเรียนการสอน';
    } else {
        return ''; // หรือ 'ไม่มีการเรียนการสอน'
    }
}


// ฟังก์ชันดึงชื่อวันภาษาไทย
function getThaiDayName($date)
{
    $days = [
        'Sunday' => 'อาทิตย์',
        'Monday' => 'จันทร์',
        'Tuesday' => 'อังคาร',
        'Wednesday' => 'พุธ',
        'Thursday' => 'พฤหัสบดี',
        'Friday' => 'ศุกร์',
        'Saturday' => 'เสาร์'
    ];
    $englishDay = date('l', strtotime($date)); // ดึงชื่อวันภาษาอังกฤษ
    return $days[$englishDay] ?? $englishDay; // แปลงเป็นชื่อวันภาษาไทย
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ตารางการใช้ห้อง</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        .header {
            background-color: #ff5722;
            color: white;
            padding: 10px 20px;
            display: flex;
            justify-content: flex-start;
            align-items: center;
        }

        .header h1 {
            font-size: 1.5em;
            margin: 0;
        }

        .container {
            padding: 20px;
        }

        .filters {
            margin-bottom: 20px;
            display: flex;
            gap: 20px;
            align-items: center;
        }

        .filters input,
        .filters button {
            padding: 5px;
            font-size: 1em;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        table th,
        table td {
            border: 1px solid #ddd;
            text-align: center;
            padding: 10px;
        }

        table th {
            background-color: #673ab7;
            color: white;
        }

        table tr.highlight {
            background-color: #ffeb3b;
        }

        .btn-confirm {
            display: block;
            margin: 20px auto;
            background-color: #ff5722;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 1em;
            cursor: pointer;
            border-radius: 5px;
        }

        .btn-confirm:hover {
            background-color: #e64a19;
        }

        table tr.highlight {
            background-color: rgb(233, 212, 253);
        }

        table td.checked {
            background-color: #c8e6c9;
            color: black;
            font-weight: bold;
        }
    </style>
</head>

<body>
    <div class="header">
        <a href="booking.php" style="text-decoration: none; color: white;">&#8592;</a>
        <h1>ตารางการใช้ห้อง</h1>
    </div>

    <div class="container">
        <form method="GET" action="">
            <div class="filters">
                <label for="room">ห้อง:</label>
                <div class="room-option">
                    SC2-308 - ห้องปฏิบัติการคอมพิวเตอร์ (ความจุ 80 คน)
                </div>

                <label for="date-range">ระหว่างวันที่-วันที่:</label>
                <input type="date" name="start_date" value="<?= $_GET['start_date'] ?? '2024-12-22' ?>">
                <input type="date" name="end_date" value="<?= $_GET['end_date'] ?? '2024-12-28' ?>">

                <label for="search-date">เลือกวันที่:</label>
                <input type="date" name="search_date" value="<?= $_GET['search_date'] ?? '' ?>">
                <button type="submit">ค้นหา</button>
            </div>
        </form>

        <table>
            <thead>
                <tr>
                    <th>วัน</th>
                    <th>08.00-09.00</th>
                    <th>09.00-10.00</th>
                    <th>10.00-11.00</th>
                    <th>11.00-12.00</th>
                    <th>12.00-13.00</th>
                    <th>13.00-14.00</th>
                    <th>14.00-15.00</th>
                    <th>15.00-16.00</th>
                    <th>16.00-17.00</th>
                    <th>17.00-18.00</th>
                    <th>18.00-19.00</th>
                    <th>19.00-20.00</th>
                    <th>20.00-21.00</th>
                </tr>
            </thead>
            <?php foreach ($dates_in_week as $date): ?>
                <tr class="<?= ($date == $selected_date) ? 'highlight' : '' ?>">
                    <td><?= getThaiDayName($date) . ' (' . date("d/m/Y", strtotime($date)) . ')' ?></td>
                    <?php
                    // ตรวจสอบการจองในแต่ละช่วงเวลา
                    for ($hour = 8; $hour <= 20; $hour++) {
                        $start_time = sprintf('%02d:00', $hour);
                        $end_time = sprintf('%02d:00', $hour + 1);
                        // เรียกฟังก์ชัน checkLecture เพื่อรับสถานะ
                        $status = checkLecture($room_id, $date, $start_time, $end_time, $schedules);

                        if ($status === 'มีการเรียนการสอน') {
                            // หากมีการเรียนการสอน ให้เพิ่มคลาส disabled
                            echo "<td class='disabled'>$status</td>";
                        } else {
                            echo "<td>$status</td>";
                        }
                    }

                    ?>
                </tr>
            <?php endforeach; ?>
        </table>

        <button class="btn-confirm" type="button" onclick="window.location.href='deskSC2-308.php'">ยืนยัน</button>
    </div>

    <script>
        // เพิ่มฟังก์ชันการคลิกเลือกเซลล์
        document.querySelectorAll('table td').forEach(cell => {
            if (cell.cellIndex > 0) { // ถ้าไม่ใช่ช่องแรก
                if (cell.textContent === 'มีการเรียนการสอน') {
                    // ถ้าเซลล์มีการเรียนการสอน ให้ใส่คลาส disabled และไม่สามารถคลิกได้
                    cell.classList.add('disabled');
                } else {
                    cell.addEventListener('click', () => {
                        // สามารถคลิกได้ถ้าไม่ใช่ "มีการเรียนการสอน"
                        cell.classList.toggle('checked');
                        cell.textContent = cell.classList.contains('checked') ? '\u2713' : '';
                    });
                }
            }
        });
    </script>

</body>

</html>

<?php
// ปิดการเชื่อมต่อหลังจากการใช้งานทั้งหมดเสร็จสิ้น
$conn->close();
?>