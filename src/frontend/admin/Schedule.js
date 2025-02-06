async function fetchSchedule() {
    try {
        const response = await fetch(`http://localhost:3000/data/Schedule_time`);
        const scheduleData = await response.json();

        const dayMapping = {
            'จันทร์': 1,
            'อังคาร': 2,
            'พุธ': 3,
            'พฤหัสบดี': 4,
            'ศุกร์': 5,
            'เสาร์': 6,
            'อาทิตย์': 7
        };

        // ตั้งค่าตาราง
        for (let i = 1; i <= 7; i++) {
            for (let j = 2; j <= 14; j++) {  // คอลัมน์เริ่มต้นที่ 2 (08:00 น.)
                const cell = document.querySelector(`tbody tr:nth-child(${i}) td:nth-child(${j})`);
                if (cell) {
                    cell.classList.add('status-cell');
                    cell.setAttribute('data-status', 'ว่าง');  // ตั้งค่าเริ่มต้นเป็นว่าง
                    updateCellAppearance(cell);

                    // เพิ่ม event สำหรับคลิกเพื่อเปลี่ยนสถานะ
                    cell.addEventListener('click', () => changeStatus(cell));
                }
            }
        }

        // เติมข้อมูลจากฐานข้อมูล
        let roomsFilter = '';

        if (window.location.pathname.includes('Schedule307.html')) {
            roomsFilter = '307';
        } else if (window.location.pathname.includes('Schedule308.html')) {
            roomsFilter = '308';
        } else if(window.location.pathname.includes('Schedule414.html')){
            roomsFilter = '414';
        } else if(window.location.pathname.includes('Schedule407.html')){
            roomsFilter = '407';
        } else if(window.location.pathname.includes('Schedule411.html')){
            roomsFilter = '411';
        } else if(window.location.pathname.includes('Schedule415.html')){
            roomsFilter = '415';
        } else if(window.location.pathname.includes('Schedule314.html')){
            roomsFilter = '314';
        } else if(window.location.pathname.includes('Schedule313-1.html')){
            roomsFilter = '313-1';
        } else if(window.location.pathname.includes('Schedule313.html')){
            roomsFilter = '313';
        } else if(window.location.pathname.includes('Schedule211.html')){
            roomsFilter = '211';
        } else if(window.location.pathname.includes('Schedule212.html')){
            roomsFilter = '212';
        } else if(window.location.pathname.includes('Schedule311.html')){
            roomsFilter = '311';
        }

        // เติมข้อมูลจากฐานข้อมูล
        scheduleData
            .filter(item => item.Rooms_ID === roomsFilter)
            .forEach(item => {
                const dayIndex = dayMapping[item.Week_days];
                const startHour = parseInt(item.Start_time.split(':')[0], 10);
                const endHour = parseInt(item.End_time.split(':')[0], 10);

                for (let hour = startHour; hour < endHour; hour++) {
                    const cell = document.querySelector(`tbody tr:nth-child(${dayIndex}) td:nth-child(${hour - 8 + 2})`);
                    if (cell) {
                        cell.setAttribute('data-status', item.Rooms_status);
                        cell.setAttribute('data-id', item.Schedule_ID); // ใส่ Schedule_ID สำหรับอัปเดต
                        updateCellAppearance(cell);
                    }
                }
            });
    } catch (error) {
        console.error('❌ Error fetching schedule:', error);
    }
}

// 🛠️ ฟังก์ชันเปลี่ยนสถานะ
async function changeStatus(cell) {
    const statuses = ['ว่าง', 'มีเรียน', 'ไม่ว่าง', 'กำลังปรับปรุง'];
    let currentStatus = cell.getAttribute('data-status');
    let nextStatus = statuses[(statuses.indexOf(currentStatus) + 1) % statuses.length]; // วนลูปสถานะ

    cell.setAttribute('data-status', nextStatus);
    updateCellAppearance(cell); // อัปเดต UI

    try {
        const scheduleId = cell.getAttribute('data-id');
        if (scheduleId) {
            // อัปเดตสถานะในฐานข้อมูลเฉพาะเซลล์ที่มี Schedule_ID
            const response = await fetch('http://localhost:3000/updateScheduleStatus', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    scheduleId: scheduleId,
                    status: nextStatus
                }),
            });

            if (response.ok) {
                console.log(`✅ อัปเดตสถานะเป็น "${nextStatus}" สำเร็จ!`);
            } else {
                console.error('❌ Error updating status');
                alert('เกิดข้อผิดพลาดในการอัปเดตสถานะ');
            }
        } else {
            console.log('📝 เซลล์ว่าง ยังไม่มีข้อมูลในฐานข้อมูล');
        }
    } catch (error) {
        console.error('❌ Error:', error);
        alert('ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้');
    }
}

// 🎨 ฟังก์ชันอัปเดต UI ของเซลล์ตามสถานะ
function updateCellAppearance(cell) {
    const status = cell.getAttribute('data-status');
    cell.className = 'status-cell'; // ล้าง class เดิมก่อน
    switch (status) {
        case 'มีเรียน':
            cell.classList.add('status-occupied');
            cell.textContent = '📚 มีเรียน';
            break;
        case 'ไม่ว่าง':
            cell.classList.add('status-unavailable');
            cell.textContent = '🚫 ไม่ว่าง';
            break;
        case 'กำลังปรับปรุง':
            cell.classList.add('status-maintenance');
            cell.textContent = '🔧 กำลังปรับปรุง';
            break;
        case 'ว่าง':
            cell.classList.add('status-available');
            cell.textContent = '';
            break;
        default:
            cell.textContent = '-';
    }
}

document.addEventListener('DOMContentLoaded', fetchSchedule);