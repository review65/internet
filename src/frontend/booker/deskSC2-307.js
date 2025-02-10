async function loadDesks() {
    try {
        const response = await fetch("http://localhost:3000/Manage_computers");
        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }

        const desks = await response.json();
        const deskGrid = document.getElementById('deskGrid');
        deskGrid.innerHTML = ""; // ล้างข้อมูลเก่าออกก่อน

        desks.forEach(desk => {
            const deskDiv = document.createElement('div');
            deskDiv.classList.add('desk');

            // กำหนดสถานะของคอมพิวเตอร์
            if (desk.Computer_status === "ใช้งานได้") {
                deskDiv.classList.add('available');
            } else {
                deskDiv.classList.add('damaged'); // ใช้คลาส 'damaged' แทน
            }

            deskDiv.textContent = `ComID ${desk.Computer_ID}`;
            deskDiv.dataset.id = desk.Computer_ID; // เก็บ ID เผื่อใช้งานต่อ

            deskDiv.onclick = () => toggleDesk(deskDiv);
            deskGrid.appendChild(deskDiv);
        });
    } catch (error) {
        console.error("เกิดข้อผิดพลาดในการโหลดข้อมูล:", error);
    }
}

function toggleDesk(desk) {
    if (!desk.classList.contains('damaged')) {
        desk.classList.toggle('checked');
    }
}

async function submitBorrow() {
    const data = {
        console: document.getElementById('console').value,
        cat5: document.getElementById('cat5').value,
        crossover: document.getElementById('crossover').value,
        hub: document.getElementById('hub').value,
        router: document.getElementById('router').value,
        switch: document.getElementById('switch').value,
        pointer: document.getElementById('pointer').value,
    };

    const response = await fetch("booking.js",{
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
    });
    const result = await response.text();
    alert(result);
}

function createDesks(group, count) {
    for (let i = 0; i < count; i++) {
        const desk = document.createElement('div');
        desk.classList.add('desk');

        // Mark some desks as damaged as a fixed setting
        if (i % 10 < 2) { // Example fixed rule
            desk.classList.add('damaged');
        }

        desk.addEventListener('click', () => {
            if (!desk.classList.contains('damaged')) {
                desk.classList.toggle('checked');
                desk.textContent = desk.classList.contains('checked') ? '\u2713' : '';
            }
        });

        group.appendChild(desk);
    }
}
let selectedDesks = new Set(); // เก็บหมายเลขโต๊ะที่ถูกเลือก

function createDesks(group, count, groupName) {
    for (let i = 0; i < count; i++) {
        const desk = document.createElement('div');
        desk.classList.add('desk');
        desk.dataset.id = `${groupName}-${i + 1}`; // เพิ่มหมายเลขให้แต่ละโต๊ะ

        if (i % 10 < 2) { // ตัวอย่างการกำหนดโต๊ะชำรุด
            desk.classList.add('damaged');
        }

        desk.addEventListener('click', () => {
            if (!desk.classList.contains('damaged')) {
                desk.classList.toggle('checked');
                if (desk.classList.contains('checked')) {
                    selectedDesks.add(desk.dataset.id);
                    desk.textContent = '\u2713';
                } else {
                    selectedDesks.delete(desk.dataset.id);
                    desk.textContent = '';
                }
            }
        });

        group.appendChild(desk);
    }
}

function submitSelection() {
    console.log("โต๊ะที่เลือก:", Array.from(selectedDesks));
    alert("ข้อมูลถูกบันทึกแล้ว! ดูใน console");
}

function createDesks(container, count, prefix) {
    container.innerHTML = ""; // ล้างข้อมูลเก่าออกก่อน
    for (let i = 1; i <= count; i++) {
        const desk = document.createElement("div");
        desk.classList.add("desk");
        desk.textContent = `${prefix}-${i}`;
        container.appendChild(desk);
    }
}

// เรียกใช้โค้ดเมื่อหน้าโหลดเสร็จ
document.addEventListener("DOMContentLoaded", () => {
    createDesks(document.getElementById("group-1"), 24, "G1");
    createDesks(document.getElementById("group-2"), 32, "G2");
    createDesks(document.getElementById("group-3"), 24, "G3");

    loadDesks(); // ✅ โหลดข้อมูลหลังจาก DOM โหลดเสร็จ

    const confirmButton = document.querySelector('.confirm-button');
    if (confirmButton) {
        confirmButton.addEventListener("click", submitSelection);
    }
});



loadDesks();