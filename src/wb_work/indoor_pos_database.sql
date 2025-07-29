-- =====================================================
-- Indoor Positioning System Database Setup Script
-- Generated based on codebase analysis
-- Database: indoor_pos
-- =====================================================

-- Create database if not exists
CREATE DATABASE IF NOT EXISTS indoor_pos CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE indoor_pos;

-- =====================================================
-- Table: room
-- Purpose: Stores room information and layout images
-- =====================================================
CREATE TABLE room (
    room_id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Room identifier',
    room_name VARCHAR(100) NOT NULL COMMENT 'Room name/description',
    layout_image LONGBLOB COMMENT 'Room layout image binary data',
    pixels_per_m INT COMMENT 'Scale factor: pixels per meter for image coordinates',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Room information and layout images';

-- =====================================================
-- Table: base_station
-- Purpose: Stores iBeacon base station information and coordinates
-- =====================================================
CREATE TABLE base_station (
    base_id VARCHAR(50) PRIMARY KEY COMMENT 'Base station identifier (iBeacon UUID)',
    room_id INT NOT NULL COMMENT 'Room where base station is located',
    x_axis DOUBLE NOT NULL COMMENT 'X coordinate of base station in meters',
    y_axis DOUBLE NOT NULL COMMENT 'Y coordinate of base station in meters',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (room_id) REFERENCES room(room_id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_room_id (room_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='iBeacon base station coordinates and properties';

-- =====================================================
-- Table: employee
-- Purpose: Stores employee information and terminal device mapping
-- =====================================================
CREATE TABLE employee (
    emp_id VARCHAR(50) PRIMARY KEY COMMENT 'Employee identifier',
    name VARCHAR(100) NOT NULL COMMENT 'Employee name',
    sex VARCHAR(10) COMMENT 'Employee gender (男/女)',
    terminal_id VARCHAR(50) UNIQUE COMMENT 'Associated mobile terminal/device ID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_terminal_id (terminal_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Employee information and terminal device mapping';

-- =====================================================
-- Table: env_factor
-- Purpose: Stores environmental factors for RSSI signal propagation calculation
-- =====================================================
CREATE TABLE env_factor (
    room_id INT PRIMARY KEY COMMENT 'Room identifier',
    height DOUBLE NOT NULL COMMENT 'Height compensation value in meters',
    atten_factor DOUBLE NOT NULL COMMENT 'Environmental attenuation factor (n value)',
    p0 DOUBLE NOT NULL COMMENT 'RSSI value received at 1 meter distance (dBm)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (room_id) REFERENCES room(room_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Environmental factors for RSSI signal propagation model';

-- =====================================================
-- Table: login
-- Purpose: Stores user authentication information
-- =====================================================
CREATE TABLE login (
    user_id VARCHAR(50) PRIMARY KEY COMMENT 'User identifier',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT 'Login username',
    password VARCHAR(100) NOT NULL COMMENT 'Login password (should be hashed)',
    role VARCHAR(20) NOT NULL DEFAULT 'user' COMMENT 'User role/permissions (admin, user)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='User authentication information';

-- =====================================================
-- Table: location
-- Purpose: Stores historical positioning results
-- =====================================================
CREATE TABLE location (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Auto-increment primary key',
    emp_id VARCHAR(50) NOT NULL COMMENT 'Employee identifier',
    room_id INT NOT NULL COMMENT 'Room where position was calculated',
    x_axis DOUBLE NOT NULL COMMENT 'X coordinate of calculated position in meters',
    y_axis DOUBLE NOT NULL COMMENT 'Y coordinate of calculated position in meters',
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Time when position was calculated',
    FOREIGN KEY (emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (room_id) REFERENCES room(room_id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_emp_id (emp_id),
    INDEX idx_room_id (room_id),
    INDEX idx_timestamp (timestamp),
    INDEX idx_emp_timestamp (emp_id, timestamp)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Historical positioning results';

-- =====================================================
-- SAMPLE DATA FOR TESTING
-- =====================================================

-- Insert sample rooms
INSERT INTO room (room_name, pixels_per_m) VALUES 
('Conference Room A', 50),
('Office Area B', 45),
('Laboratory C', 60);

-- Insert sample base stations for room 1 (Conference Room A)
INSERT INTO base_station (base_id, room_id, x_axis, y_axis) VALUES
('beacon001', 1, 0.0, 0.0),
('beacon002', 1, 10.0, 0.0),
('beacon003', 1, 10.0, 8.0),
('beacon004', 1, 0.0, 8.0);

-- Insert sample base stations for room 2 (Office Area B)
INSERT INTO base_station (base_id, room_id, x_axis, y_axis) VALUES
('beacon005', 2, 0.0, 0.0),
('beacon006', 2, 15.0, 0.0),
('beacon007', 2, 15.0, 12.0);

-- Insert sample employees
INSERT INTO employee (emp_id, name, sex, terminal_id) VALUES
('emp001', '张三', '男', 'terminal001'),
('emp002', '李四', '女', 'terminal002'),
('emp003', '王五', '男', 'terminal003'),
('emp004', '赵六', '女', 'terminal004');

-- Insert environmental factors for each room
INSERT INTO env_factor (room_id, height, atten_factor, p0) VALUES
(1, 2.5, 2.0, -40.0),  -- Conference Room A
(2, 3.0, 2.2, -38.0),  -- Office Area B  
(3, 2.8, 1.8, -42.0);  -- Laboratory C

-- Insert sample admin user (password should be hashed in production)
INSERT INTO login (user_id, username, password, role) VALUES
('admin001', 'admin', 'admin123', 'admin'),
('user001', 'operator', 'user123', 'user');

-- Insert sample location history
INSERT INTO location (emp_id, room_id, x_axis, y_axis, timestamp) VALUES
('emp001', 1, 5.0, 4.0, '2024-01-15 09:30:00'),
('emp001', 1, 5.2, 4.1, '2024-01-15 09:31:00'),
('emp001', 1, 5.5, 4.3, '2024-01-15 09:32:00'),
('emp002', 2, 7.5, 6.0, '2024-01-15 10:15:00'),
('emp002', 2, 7.8, 6.2, '2024-01-15 10:16:00'),
('emp003', 1, 2.0, 3.0, '2024-01-15 11:00:00');

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================

-- Verify table creation and data insertion
SELECT 'Rooms' as table_name, COUNT(*) as count FROM room
UNION ALL
SELECT 'Base Stations', COUNT(*) FROM base_station
UNION ALL  
SELECT 'Employees', COUNT(*) FROM employee
UNION ALL
SELECT 'Environmental Factors', COUNT(*) FROM env_factor
UNION ALL
SELECT 'Login Users', COUNT(*) FROM login
UNION ALL
SELECT 'Location Records', COUNT(*) FROM location;

-- Show foreign key relationships
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE REFERENCED_TABLE_SCHEMA = 'indoor_pos'
    AND REFERENCED_TABLE_NAME IS NOT NULL;

-- =====================================================
-- NOTES AND WARNINGS
-- =====================================================
/*
IMPORTANT NOTES:
1. This schema is based on analysis of the Java codebase
2. Password storage should use proper hashing (BCrypt, PBKDF2, etc.) in production
3. Consider adding indexes based on actual query patterns
4. Layout images in room table can be large - consider file storage with path references
5. RSSI values are typically negative (e.g., -40 to -100 dBm)

BUGS FOUND IN CODEBASE (need fixing):
1. BaseStationManageImpl.java:107 - Delete uses wrong column (room_id instead of base_id)
2. HistoryLocationImpl.java:47 - Query uses wrong table (base_station instead of location)
3. EnvFactorManageImpl.java:63-68 - Duplicate insert statements

RECOMMENDATIONS:
1. Add data validation constraints
2. Implement proper error handling for foreign key violations
3. Consider partitioning location table by timestamp for better performance
4. Add monitoring for positioning accuracy and system performance
*/