const express = require('express');
const connection = require('./db'); // นำเข้าการเชื่อมต่อฐานข้อมูล
const mysql = require('mysql2');
const cors = require('cors');  // เพิ่ม cors


const app = express();
app.use(express.json()); // รองรับ JSON request body
app.use(cors());
// 📌 ดึงข้อมูลจากตาราง (เปลี่ยน `rooms` เป็นชื่อตารางของคุณ)
app.get('/rooms', (req, res) => {
    connection.query('SELECT * FROM Equipments_list_brokened', (err, results) => {
        if (err) {
            console.error('❌ เกิดข้อผิดพลาด:', err);
            res.status(500).send(err);
            return;
        }
        console.log('✅ ดึงข้อมูลสำเร็จ:', results);
        res.json(results);
    });
});
app.get('/brokendEquipment', (req, res) => {
    connection.query('SELECT b.Equipments_ID, (SELECT Equipments_name FROM Equipments_list_information WHERE Equipments_ID = b.Equipments_ID) AS Equipments_name, COUNT(*) AS count FROM Equipments_list_brokened b GROUP BY b.Equipments_ID ORDER BY count DESC LIMIT 3;', (err, results) => {
        if (err) {
            console.error('❌ เกิดข้อผิดพลาด:', err);
            res.status(500).send(err);
            return;
        }
        console.log('✅ ดึงข้อมูลสำเร็จ:', results);
        res.json(results);
    });
});
app.get('/borrowEquipment', (req, res) => {
    connection.query('SELECT b.Equipments_ID, (SELECT Equipments_name FROM Equipments_list_information WHERE Equipments_ID = b.Equipments_ID) AS Equipments_name, COUNT(*) AS count FROM Equipments_list_requests b GROUP BY Equipments_ID ORDER BY count DESC LIMIT 3;', (err, results) => {
        if (err) {
            console.error('❌ เกิดข้อผิดพลาด:', err);
            res.status(500).send(err);
            return;
        }
        console.log('✅ ดึงข้อมูลสำเร็จ:', results);
        res.json(results);
    });
});
app.get('/mostroomalldata', (req, res) => {
    const query ="WITH RoomUsage AS (SELECT rr.Rooms_ID, s.Department, COUNT(*) AS UsageCount FROM Rooms_list_requests rr JOIN Student_information s ON rr.Identify_ID = s.Student_ID WHERE s.Department IN ('วิทยาการคอมพิวเตอร์', 'เทคโนโลยีสารสนเทศ') GROUP BY rr.Rooms_ID, s.Department) SELECT ru.Rooms_ID AS Room, COALESCE(SUM(CASE WHEN ru.Department = 'วิทยาการคอมพิวเตอร์' THEN ru.UsageCount END), 0) AS cs, COALESCE(SUM(CASE WHEN ru.Department = 'เทคโนโลยีสารสนเทศ' THEN ru.UsageCount END), 0) AS it, SUM(ru.UsageCount) AS total FROM RoomUsage ru GROUP BY ru.Rooms_ID ORDER BY total DESC;"
    connection.query( query,(err, results) => {
        if (err) {
            console.error('❌ เกิดข้อผิดพลาด:', err);
            res.status(500).send(err);
            return;
        }
        console.log('✅ ดึงข้อมูลสำเร็จ:', results);
        res.json(results);
    });
});
app.get('/daysroom', (req, res) => {
    const query ="WITH DailyBookings AS (SELECT DAYOFWEEK(rr.Used_date) AS DayOfWeek,SUM(CASE WHEN s.Department = 'วิทยาการคอมพิวเตอร์' THEN 1 ELSE 0 END) AS CS_Count,SUM(CASE WHEN s.Department = 'เทคโนโลยีสารสนเทศ' THEN 1 ELSE 0 END) AS IT_Count FROM Rooms_list_requests rr JOIN Student_information s ON rr.Identify_ID = s.Student_ID WHERE s.Department IN ('วิทยาการคอมพิวเตอร์', 'เทคโนโลยีสารสนเทศ') GROUP BY DAYOFWEEK(rr.Used_date))SELECT CASE WHEN db.DayOfWeek = 1 THEN 'อาทิตย์' WHEN db.DayOfWeek = 2 THEN 'จันทร์' WHEN db.DayOfWeek = 3 THEN 'อังคาร' WHEN db.DayOfWeek = 4 THEN 'พุธ' WHEN db.DayOfWeek = 5 THEN 'พฤหัสบดี' WHEN db.DayOfWeek = 6 THEN 'ศุกร์' WHEN db.DayOfWeek = 7 THEN 'เสาร์' END AS DayName,db.CS_Count AS Cs,db.IT_Count AS It,(db.CS_Count + db.IT_Count) AS TotalCount FROM DailyBookings db ORDER BY db.DayOfWeek;"
    connection.query( query,(err, results) => {
        if (err) {
            console.error('❌ เกิดข้อผิดพลาด:', err);
            res.status(500).send(err);
            return;
        }
        console.log('✅ ดึงข้อมูลสำเร็จ:', results);
        res.json(results);
    });
});
app.get('/detailsdaysroom', (req, res) => {
    const query ="SELECT 'รวมทั้งหมด' AS DayName, SUM(db.CS_Count) AS Cs, SUM(db.IT_Count) AS It, SUM(db.CS_Count + db.IT_Count) AS TotalCount FROM (SELECT DAYOFWEEK(rr.Used_date) AS DayOfWeek, SUM(CASE WHEN s.Department = 'วิทยาการคอมพิวเตอร์' THEN 1 ELSE 0 END) AS CS_Count, SUM(CASE WHEN s.Department = 'เทคโนโลยีสารสนเทศ' THEN 1 ELSE 0 END) AS IT_Count FROM Rooms_list_requests rr JOIN Student_information s ON rr.Identify_ID = s.Student_ID WHERE s.Department IN ('วิทยาการคอมพิวเตอร์', 'เทคโนโลยีสารสนเทศ') GROUP BY DAYOFWEEK(rr.Used_date)) db;"
    connection.query( query,(err, results) => {
        if (err) {
            console.error('❌ เกิดข้อผิดพลาด:', err);
            res.status(500).send(err);
            return;
        }
        console.log('✅ ดึงข้อมูลสำเร็จ:', results);
        res.json(results);
    });
});
app.get('/useralldata', (req, res) => {
    const query ="SELECT si.Name, si.Student_ID,si.Phone_number,si.email, COUNT(rlr.Identify_ID) AS Status FROM Rooms_list_requests rlr JOIN Student_information si ON rlr.Identify_ID = si.Student_ID GROUP BY si.Student_ID ORDER BY Status DESC LIMIT 3;"
    connection.query( query,(err, results) => {
        if (err) {
            console.error('❌ เกิดข้อผิดพลาด:', err);
            res.status(500).send(err);
            return;
        }
        console.log('✅ ดึงข้อมูลสำเร็จ:', results);
        res.json(results);
    });
});

app.get('/user', (req, res) => {
    const query ="SELECT si.Name, si.Student_ID,si.Phone_number,si.email, COUNT(rlr.Identify_ID) AS Status FROM Rooms_list_requests rlr JOIN Student_information si ON rlr.Identify_ID = si.Student_ID GROUP BY si.Student_ID ORDER BY Status DESC ;"
    connection.query( query,(err, results) => {
        if (err) {
            console.error('❌ เกิดข้อผิดพลาด:', err);
            res.status(500).send(err);
            return;
        }
        console.log('✅ ดึงข้อมูลสำเร็จ:', results);
        res.json(results);
    });
});
app.get('/roomdetail', (req, res) => {
    const query ="SELECT rli.Rooms_name AS Name,rli.Floors, rli.Rooms_ID, SUM(CASE WHEN rlr.Requests_status = 'อนุมัติ' THEN 1 ELSE 0 END) AS Approved_Count FROM Rooms_list_information rli LEFT JOIN Rooms_list_requests rlr ON rli.Rooms_ID = rlr.Rooms_ID GROUP BY rli.Rooms_ID, rli.Rooms_name, rli.Floors ORDER BY Approved_Count;"
    connection.query( query,(err, results) => {
        if (err) {
            console.error('❌ เกิดข้อผิดพลาด:', err);
            res.status(500).send(err);
            return;
        }
        console.log('✅ ดึงข้อมูลสำเร็จ:', results);
        res.json(results);
    });
});
// 📌 เริ่มเซิร์ฟเวอร์
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`🚀 Server running at http://localhost:${PORT}`);
});
