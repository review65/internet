const express = require('express');
const connection = require('./db'); // Import database connection
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors()); // Allow frontend to access API

// 📌 Whitelist allowed tables to prevent SQL injection
const allowedTables = [
    'Rooms_list_requests', 'Equipments_list_brokened', 'Admin_information',
    'Equipments_list_requests', 'Executive_information', 'Manage_computers',
    'Manage_equipments', 'Name_list_requests_rooms', 'Rooms_list_information',
    'Schedule_time', 'Student_information', 'Teacher_information', 'Equipments_list_information'
];

// 📌 Dynamic Route for fetching any table data
app.get('/data/:table', (req, res) => {
    const { table } = req.params;

    // Check if requested table is in allowed list
    if (!allowedTables.includes(table)) {
        return res.status(400).json({ error: 'Invalid table name' });
    }

    const sql = `SELECT * FROM ??`; // `??` prevents SQL injection
    connection.query(sql, [table], (err, results) => {
        if (err) {
            console.error(`❌ Error fetching data from ${table}:`, err);
            return res.status(500).json({ error: 'Database query failed' });
        }
        console.log(`✅ Data retrieved from ${table}:`, results.length, 'rows');
        res.json(results);
    });
});

app.post('/updateStatus', (req, res) => {
    const { requestId, status } = req.body;

    const sql = 'UPDATE Rooms_list_requests SET Requests_status = ? WHERE Rooms_requests_ID = ?';
    
    connection.query(sql, [status, requestId], (err, results) => {
        if (err) {
            console.error('❌ Error updating status:', err);
            return res.status(500).json({ message: 'Failed to update status' });
        }

        if (results.affectedRows === 0) {
            // ถ้าไม่มีแถวไหนถูกอัปเดต แสดงว่า requestId อาจไม่ถูกต้อง
            return res.status(404).json({ message: 'Request ID not found' });
        }

        console.log(`✅ Status updated for Request ID ${requestId}: ${status}`);
        res.status(200).json({ message: 'Status updated successfully' });
    });
});

app.post('/updateScheduleStatus', (req, res) => {
    const { scheduleId, status } = req.body;

    const sql = `UPDATE Schedule_time SET Rooms_status = ? WHERE Schedule_ID = ?`;
    connection.query(sql, [status, scheduleId], (err, result) => {
        if (err) {
            console.error('❌ Error updating schedule status:', err);
            return res.status(500).json({ message: 'Failed to update status' });
        }
        res.status(200).json({ message: 'Status updated successfully' });
    });
});


// 📌 Start Server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`🚀 Server running at http://localhost:${PORT}`);
});