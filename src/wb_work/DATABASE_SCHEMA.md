# Indoor Positioning System - Database Schema

## Overview

This document describes the database schema for the Indoor Positioning System that uses iBeacon (Bluetooth 4.0) technology for indoor location tracking. The system calculates positions using RSSI data and various positioning algorithms including trilateral positioning, weighted trilateral positioning, and weighted centroid positioning.

## Database: `indoor_pos`

**Character Set:** UTF8MB4  
**Collation:** utf8mb4_unicode_ci  
**Engine:** InnoDB

## Table Structure

### 1. `room` Table
**Purpose:** Stores room information and layout images

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `room_id` | INT | PRIMARY KEY, AUTO_INCREMENT | Room identifier |
| `room_name` | VARCHAR(100) | NOT NULL | Room name/description |
| `layout_image` | LONGBLOB | NULL | Room layout image binary data |
| `pixels_per_m` | INT | NULL | Scale factor: pixels per meter for image coordinates |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Record creation time |
| `updated_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP ON UPDATE | Record update time |

### 2. `base_station` Table
**Purpose:** Stores iBeacon base station information and coordinates

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `base_id` | VARCHAR(50) | PRIMARY KEY | Base station identifier (iBeacon UUID) |
| `room_id` | INT | NOT NULL, FOREIGN KEY | Room where base station is located |
| `x_axis` | DOUBLE | NOT NULL | X coordinate of base station in meters |
| `y_axis` | DOUBLE | NOT NULL | Y coordinate of base station in meters |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Record creation time |
| `updated_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP ON UPDATE | Record update time |

**Foreign Keys:**
- `room_id` → `room(room_id)` ON DELETE CASCADE ON UPDATE CASCADE

**Indexes:**
- `idx_room_id` on `room_id`

### 3. `employee` Table
**Purpose:** Stores employee information and terminal device mapping

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `emp_id` | VARCHAR(50) | PRIMARY KEY | Employee identifier |
| `name` | VARCHAR(100) | NOT NULL | Employee name |
| `sex` | VARCHAR(10) | NULL | Employee gender (男/女) |
| `terminal_id` | VARCHAR(50) | UNIQUE | Associated mobile terminal/device ID |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Record creation time |
| `updated_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP ON UPDATE | Record update time |

**Indexes:**
- `idx_terminal_id` on `terminal_id`

### 4. `env_factor` Table
**Purpose:** Stores environmental factors for RSSI signal propagation calculation

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `room_id` | INT | PRIMARY KEY | Room identifier |
| `height` | DOUBLE | NOT NULL | Height compensation value in meters |
| `atten_factor` | DOUBLE | NOT NULL | Environmental attenuation factor (n value) |
| `p0` | DOUBLE | NOT NULL | RSSI value received at 1 meter distance (dBm) |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Record creation time |
| `updated_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP ON UPDATE | Record update time |

**Foreign Keys:**
- `room_id` → `room(room_id)` ON DELETE CASCADE ON UPDATE CASCADE

### 5. `login` Table
**Purpose:** Stores user authentication information

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `user_id` | VARCHAR(50) | PRIMARY KEY | User identifier |
| `username` | VARCHAR(50) | NOT NULL, UNIQUE | Login username |
| `password` | VARCHAR(100) | NOT NULL | Login password (should be hashed) |
| `role` | VARCHAR(20) | NOT NULL, DEFAULT 'user' | User role/permissions (admin, user) |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Record creation time |
| `updated_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP ON UPDATE | Record update time |

**Indexes:**
- `idx_username` on `username`

### 6. `location` Table
**Purpose:** Stores historical positioning results

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| `id` | INT | PRIMARY KEY, AUTO_INCREMENT | Auto-increment primary key |
| `emp_id` | VARCHAR(50) | NOT NULL, FOREIGN KEY | Employee identifier |
| `room_id` | INT | NOT NULL, FOREIGN KEY | Room where position was calculated |
| `x_axis` | DOUBLE | NOT NULL | X coordinate of calculated position in meters |
| `y_axis` | DOUBLE | NOT NULL | Y coordinate of calculated position in meters |
| `timestamp` | TIMESTAMP | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Time when position was calculated |

**Foreign Keys:**
- `emp_id` → `employee(emp_id)` ON DELETE CASCADE ON UPDATE CASCADE
- `room_id` → `room(room_id)` ON DELETE CASCADE ON UPDATE CASCADE

**Indexes:**
- `idx_emp_id` on `emp_id`
- `idx_room_id` on `room_id`
- `idx_timestamp` on `timestamp`
- `idx_emp_timestamp` on `emp_id, timestamp` (composite)

## Entity Relationships

```
room (1) ←→ (N) base_station
room (1) ←→ (1) env_factor
room (1) ←→ (N) location
employee (1) ←→ (N) location
```

## Sample Data Summary

The database includes sample data for testing:

- **3 Rooms:** Conference Room A, Office Area B, Laboratory C
- **7 Base Stations:** 4 in Conference Room A, 3 in Office Area B
- **4 Employees:** With terminal mappings
- **3 Environmental Factor Sets:** One per room with RSSI propagation parameters
- **2 Login Users:** 1 admin, 1 regular user
- **6 Location Records:** Historical positioning data for testing

## Key Features

### Security
- Foreign key constraints ensure data integrity
- Cascading deletes maintain referential integrity
- Username uniqueness enforced
- Password field sized for hashed storage

### Performance
- Strategic indexes on frequently queried columns
- Composite index on employee-timestamp for historical queries
- InnoDB engine for ACID compliance and row-level locking

### Scalability
- Auto-increment primary keys for efficient inserts
- Timestamp-based partitioning ready for location table
- UTF8MB4 support for international characters

## Data Types and Ranges

### Coordinate System
- **Coordinates:** DOUBLE precision for sub-meter accuracy
- **Scale Factor:** pixels_per_m for image coordinate conversion
- **Height:** Compensation value for 3D positioning

### RSSI Values
- **p0:** Typically -30 to -50 dBm (signal strength at 1 meter)
- **n:** Typically 1.5 to 4.0 (path loss exponent)
- **RSSI Range:** Usually -40 to -100 dBm in practice

### Identifiers
- **Employee IDs:** Alphanumeric, max 50 characters
- **Base Station IDs:** iBeacon UUID format, max 50 characters
- **Terminal IDs:** Device identifiers, max 50 characters

## Usage Notes

1. **Setup:** Run `indoor_pos_database.sql` to create schema and populate sample data
2. **Configuration:** Update `jdbc.properties` with correct database credentials
3. **Testing:** Use sample data to verify positioning algorithms
4. **Production:** Replace sample data with actual room layouts and base station coordinates

## Maintenance Recommendations

1. **Regular Backups:** Especially for location history data
2. **Index Monitoring:** Monitor query performance and add indexes as needed
3. **Data Archiving:** Consider archiving old location records
4. **Security Updates:** Implement proper password hashing and regular security reviews