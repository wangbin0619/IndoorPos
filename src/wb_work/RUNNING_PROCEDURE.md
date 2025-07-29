# Indoor Positioning System - Running Procedure Guide

## Project Overview
This is an iBeacon-based indoor positioning system using Java 1.7, Maven, MySQL, and Netty for real-time location tracking.

## System Requirements
- **Java**: Version 1.8+ (compatible with Java 1.7 target)
- **MySQL**: Version 8.4+ (service running on port 3306)
- **IntelliJ IDEA**: For development and testing
- **Maven**: For dependency management and building

## Pre-Running Setup Checklist

### ✅ 1. Database Setup
- **Service Status**: MySQL84 service running
- **Database**: `indoor_pos` created and populated
- **Credentials**: 
  - Username: `root`
  - Password: `123456`
- **Configuration**: `src/main/resources/jdbc.properties` updated

### ✅ 2. Project Structure
- **Image File**: `image/test.jpg` exists for DispMain GUI
- **Dependencies**: All JAR dependencies in `pom.xml`
- **Source Code**: Complete in `src/main/java/` and `src/test/java/`

### ✅ 3. Network Ports
- **Port 50006**: Main positioning server
- **Port 50005**: Display server for GUI clients
- **Port 3306**: MySQL database connection

## Running Procedure in IntelliJ IDEA

### Step 1: Open Project
1. Launch IntelliJ IDEA
2. **File** → **Open**
3. Select: `D:\01 本地-增量备份-天翼云\A.1 北航-Main\11-科研项目\01.01-IndoorPos`
4. Wait for Maven import and indexing to complete

### Step 2: Start Main Server (MANDATORY FIRST)
```
Location: src/main/java/org/hqu/indoor_pos/server/Server.java
Action: Right-click → "Run 'Server.main()'"
Port: 50006
Status: Must be running before any clients
```

**Expected Output:**
```
Server started on port 50006
Spring context loaded
Database connection established
Waiting for positioning data...
```

### Step 3: Run Position Clients (Data Simulation)
```
Location: src/test/java/org/hqu/indoor_pos/test/PosClient1.java (or PosClient2-8)
Action: Right-click → "Run 'PosClient1.main()'"
Function: Sends RSSI data to server for positioning calculation
Data Format: "baseStationId,rssi;baseStationId,rssi;...;terminalId"
```

**Sample Data Sent:**
```
10001,-69;10002,-74;10003,-73;10004,-82;869511023026821
```

### Step 4: Run Display GUI (Optional Visualization)
```
Location: src/test/java/org/hqu/indoor_pos/test/DispMain.java
Action: Right-click → "Run 'DispMain.main()'"
Port: Connects to server on port 50005
Function: Real-time positioning visualization
```

**Expected Behavior:**
- Opens GUI window with room layout
- Shows red dots representing calculated positions
- Updates every 1000ms with new location data

### Step 5: Run Unit Tests (Development Testing)
```
Location: src/test/java/org/hqu/indoor_pos/test/test.java
Action: Right-click → "Run 'test'" or run individual @Test methods
Function: Tests database operations, algorithms, and RMI services
```

## Execution Sequence
```
1. Server.java        ← START FIRST (port 50006)
2. PosClient1.java    ← Send positioning data
3. DispMain.java      ← Optional: Visual display
4. test.java          ← Unit testing
```

## System Architecture Flow
```
Mobile Terminal → PosClient → Server (port 50006) → Database
                                ↓
Display Client ← DispServer (port 50005) ← Positioning Algorithm
```

## Available Test Clients
- **PosClient1-8.java**: Different terminal simulations with pre-recorded RSSI data
- **ClientMain.java**: General client template
- **DispMain.java**: GUI visualization client

## Positioning Algorithms Available
1. **Trilateral.java**: Basic trilateral positioning
2. **WeightTrilateral.java**: Weighted trilateral positioning  
3. **Centroid.java**: Weighted centroid positioning
4. **CombineAlgorithm.java**: Combination of multiple algorithms

## Database Tables Used
- **base_station**: iBeacon coordinates and properties
- **employee**: Employee and terminal device mapping
- **location**: Historical positioning results
- **env_factor**: Environmental factors for RSSI calculations
- **room**: Room layouts and scale information
- **login**: User authentication

## Troubleshooting Guide

### Common Issues:
1. **Port Already in Use**
   - Solution: Check if previous server instances are still running
   - Kill process or restart IDEA

2. **Database Connection Failed**
   - Check: MySQL service status (`sc query MySQL84`)
   - Verify: Password in `jdbc.properties` is "123456"

3. **Maven Dependencies Not Resolved**
   - Solution: File → Reload Maven Projects
   - Or: View → Tool Windows → Maven → Refresh

4. **No Positioning Results**
   - Ensure: Server is running before starting clients
   - Check: Database has sample base station data

5. **GUI Not Displaying**
   - Verify: `image/test.jpg` exists
   - Check: Display server is running on port 50005

## Performance Notes
- System supports multiple concurrent clients
- Positioning accuracy depends on base station placement
- Real-time updates every 1000ms
- Uses thread-safe CopyOnWriteMap for caching

## Development Tips
- Use different PosClient files to simulate multiple terminals
- Monitor server console for positioning calculations
- Check database `location` table for historical data
- Modify environmental factors in `env_factor` table for calibration

---
**Created**: 2025-07-29  
**Purpose**: Complete guide for running indoor positioning system in IntelliJ IDEA  
**Author**: Development Team