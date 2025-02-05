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
    const query ="SELECT rlr.Rooms_ID AS room,rlr.Identify_ID AS id,SUM(CASE WHEN si.Department = 'วิทยาการคอมพิวเตอร์' THEN 1 ELSE 0 END) AS cs,SUM(CASE WHEN si.Department = 'เทคโนโลยีสารสนเทศ' THEN 1 ELSE 0 END) AS it, COUNT(*) AS count FROM Rooms_list_requests rlr LEFT JOIN Student_information si ON rlr.Identify_ID = si.Student_ID GROUP BY rlr.Rooms_ID, rlr.Identify_ID;"
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
    const query ="SELECT rlr.Rooms_ID AS room,rlr.Identify_ID AS id,SUM(CASE WHEN si.Department = 'วิทยาการคอมพิวเตอร์' THEN 1 ELSE 0 END) AS cs,SUM(CASE WHEN si.Department = 'เทคโนโลยีสารสนเทศ' THEN 1 ELSE 0 END) AS it,COUNT(*) AS count,CASE WHEN DAYOFWEEK(rlr.Used_Date) = 1 THEN 'อาทิตย์'WHEN DAYOFWEEK(rlr.Used_Date) = 2 THEN 'จันทร์'WHEN DAYOFWEEK(rlr.Used_Date) = 3 THEN 'อังคาร'WHEN DAYOFWEEK(rlr.Used_Date) = 4 THEN 'พุธ'WHEN DAYOFWEEK(rlr.Used_Date) = 5 THEN 'พฤหัสบดี'WHEN DAYOFWEEK(rlr.Used_Date) = 6 THEN 'ศุกร์'WHEN DAYOFWEEK(rlr.Used_Date) = 7 THEN 'เสาร์' END AS day_of_week FROM Rooms_list_requests rlr LEFT JOIN Student_information si ON rlr.Identify_ID = si.Student_ID GROUP BY   rlr.Rooms_ID, rlr.Identify_ID, day_of_week;"
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
    const query ="SELECT rli.Rooms_name AS Name,rli.Floors, rli.Rooms_ID, SUM(CASE WHEN rlr.Requests_status = 'อนุมัติ' THEN 1 ELSE 0 END) AS Approved_Count FROM Rooms_list_information rli LEFT JOIN Rooms_list_requests rlr ON rli.Rooms_ID = rlr.Rooms_ID GROUP BY rli.Rooms_ID, rli.Rooms_name, rli.Floors ORDER BY Approved_Count DESC;"
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
