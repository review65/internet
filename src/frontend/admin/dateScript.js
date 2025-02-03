const currentDate = new Date();

function toggleCalendar() {
    const calendar = document.getElementById("dropdown-calendar");
    if (calendar.style.display === "none" || calendar.style.display === "") {
        calendar.style.display = "block";
        initializeCalendar();
    } else {
        calendar.style.display = "none";
    }
}

document.addEventListener("click", function (event) {
    const calendar = document.getElementById("dropdown-calendar");
    const iconElement = document.querySelector("i.bi-caret-down-fill");
    if (!calendar.contains(event.target) && event.target !== iconElement) {
        calendar.style.display = "none";
    }
});

function initializeCalendar() {
    const monthSelect = document.getElementById("month-select");
    const yearSelect = document.getElementById("year-select");

    // Populate months
    monthSelect.innerHTML = "";
    const monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    monthNames.forEach((month, index) => {
        const option = document.createElement("option");
        option.value = index;
        option.text = month;
        if (index === currentDate.getMonth()) option.selected = true;
        monthSelect.appendChild(option);
    });

    // Populate years
    yearSelect.innerHTML = "";
    const startYear = currentDate.getFullYear() - 10;
    const endYear = currentDate.getFullYear() + 50;
    for (let year = startYear; year <= endYear; year++) {
        const option = document.createElement("option");
        option.value = year;
        option.text = year;
        if (year === currentDate.getFullYear()) option.selected = true;
        yearSelect.appendChild(option);
    }

    renderCustomCalendar();
}

function renderCustomCalendar() {
    const calendarDiv = document.getElementById("custom-calendar");
    calendarDiv.innerHTML = ""; // Clear existing calendar

    const selectedMonth = parseInt(document.getElementById("month-select").value);
    const selectedYear = parseInt(document.getElementById("year-select").value);

    const daysInMonth = new Date(selectedYear, selectedMonth + 1, 0).getDate();
    const firstDay = new Date(selectedYear, selectedMonth, 1).getDay();

    const calendarTable = document.createElement("table");
    calendarTable.style.borderCollapse = "collapse";
    calendarTable.style.width = "100%";

    // Header row
    const headerRow = document.createElement("tr");
    ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"].forEach(day => {
        const th = document.createElement("th");
        th.style.textAlign = "center";
        th.innerText = day;
        headerRow.appendChild(th);
    });
    calendarTable.appendChild(headerRow);

    // Dates
    let date = 1;
    for (let i = 0; i < 6; i++) { // Up to 6 rows
        const row = document.createElement("tr");
        for (let j = 0; j < 7; j++) {
            const cell = document.createElement("td");
            cell.style.textAlign = "center";
            cell.style.padding = "5px";
            cell.style.border = "1px solid #ddd";
            if (i === 0 && j < firstDay) {
                cell.innerText = ""; // Empty cell
            } else if (date > daysInMonth) {
                break;
            } else {
                cell.innerText = date;
                cell.style.cursor = "pointer";
                cell.onclick = function () {
                    document.getElementById("dropdown-calendar").style.display = "none";
                };
                date++;
            }
            row.appendChild(cell);
        }
        calendarTable.appendChild(row);
    }

    calendarDiv.appendChild(calendarTable);
}