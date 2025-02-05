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
    'Schedule_time', 'Student_information', 'Teacher_information'
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

// 📌 Start Server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`🚀 Server running at http://localhost:${PORT}`);
});