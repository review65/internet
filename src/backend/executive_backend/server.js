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

app.get('/Rooms_list_requests', (req, res) => {
    connection.query('SELECT * FROM Rooms_list_requests', (err, results) => {
        if (err) {
            console.error('❌ Error:', err);
            res.status(500).send(err);
            return;
        }
        console.log('✅ ดึงข้อมูลสำเร็จจาก Rooms_list_requests:', results);
        res.json(results);
    });
});


app.get('/data/Student_information', (req, res) => {
    connection.query('SELECT * FROM Student_information', (err, results) => {
        if (err) {
            console.error('❌ Error:', err);
            res.status(500).send(err);
            return;
        }
        console.log('✅ ดึงข้อมูลสำเร็จจาก Student_information:', results);
        res.json(results);
    });
});

app.get('/data/Teacher_information', (req, res) => {
    connection.query('SELECT * FROM Teacher_information', (err, results) => {
        if (err) {
            console.error('❌ Error:', err);
            res.status(500).send(err);
            return;
        }
        console.log('✅ ดึงข้อมูลสำเร็จจาก Teacher_information:', results);
        res.json(results);
    });
});



// 📌 เริ่มเซิร์ฟเวอร์
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`🚀 Server running at http://localhost:${PORT}`);
});