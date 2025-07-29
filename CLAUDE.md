# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an indoor positioning system server using iBeacon (Bluetooth 4.0) technology. The system receives RSSI (Received Signal Strength Indicator) data from mobile terminals and calculates location using various positioning algorithms including trilateral positioning, weighted trilateral positioning, and weighted centroid positioning.

## Build and Development Commands

This is a Maven-based Java project. Common commands:

- **Build the project**: `mvn compile`
- **Package JAR**: `mvn package`
- **Run tests**: `mvn test`
- **Clean build**: `mvn clean compile`

The project uses Java 1.7 and requires Maven for dependency management.

## Running the Application

- **Main server**: Run `org.hqu.indoor_pos.server.Server` - starts positioning server on port 50006
- **Display client**: Run `org.hqu.indoor_pos.test.DispMain` - GUI client for visualizing positioning results
- **Test clients**: Various test clients available in `src/test/java/org/hqu/indoor_pos/test/` (PosClient1-8, etc.)

## Architecture Overview

The system consists of several key components:

### Core Server Components
- **Server.java**: Main Netty-based server that receives positioning data on port 50006
- **PosServerHandler.java**: Handles incoming positioning requests and processes RSSI data
- **DispServer.java**: Serves positioning results to display clients on port 50005

### Positioning Algorithms (src/main/java/org/hqu/indoor_pos/algorithm/)
All algorithms implement the `Dealer` interface:
- **Trilateral.java**: Basic trilateral positioning using least squares method
- **WeightTrilateral.java**: Weighted trilateral positioning (assigns higher weights to closer base stations)
- **Centroid.java**: Weighted centroid positioning using triangle intersections
- **CombineAlgorithm.java**: Combination of multiple algorithms

### Data Models (src/main/java/org/hqu/indoor_pos/bean/)
- **BaseStation.java**: Base station coordinates and properties
- **Location.java**: Positioning results
- **Employee.java**: Employee/terminal mapping
- **EnvFactor.java**: Environmental factors (p0, n, h values for signal propagation model)

### RMI Services (src/main/java/org/hqu/indoor_pos/rmi/)
Management interfaces for:
- Base station management
- Employee management
- Environmental factor management
- Historical location data
- Room management
- Login services

## Database Integration

The system uses MySQL with Druid connection pool. Configuration in `src/main/resources/`:
- **jdbc.properties**: Database connection settings
- **spring/applicationContext-db.xml**: Database configuration
- **spring/applicationContext-rmi.xml**: RMI service configuration

## Key Dependencies

- **Spring Framework 4.1.3**: IoC container and JDBC templates
- **Netty 5.0.0.Alpha1**: NIO server framework for high-concurrency positioning requests
- **MySQL 5.1.32**: Database storage
- **Druid 1.0.9**: Database connection pooling
- **JAMA 1.0.3**: Java matrix package for positioning calculations

## Positioning Data Format

The system expects positioning data in the format:
`"baseStationId1,rssi1;baseStationId2,rssi2;...;terminalId"`

For example: `"001,-65;002,-72;003,-68;terminal123"`

## Caching System

The server maintains several concurrent maps for performance:
- Employee ID mapping cache
- Room ID mapping cache  
- Base station location cache
- Environmental factor cache

These are populated on startup from the database and stored in thread-safe `CopyOnWriteMap` instances.