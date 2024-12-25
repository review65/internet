CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '1234';

-- มอบสิทธิ์ทั้งหมดให้ mod
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

-- รีเฟรชสิทธิ์เพื่อให้การเปลี่ยนแปลงมีผล
FLUSH PRIVILEGES;
