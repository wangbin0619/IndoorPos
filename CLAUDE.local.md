# CLAUDE.local.md

This file contains project-specific local rules and guidelines for Claude Code when working with this indoor positioning system project.

## General Behavior Rules

1. **Always Use Ultrathink Mode**: Always operate in "ultrathink" mode for this project
2. **Windows 10 Commands First**: This is a Windows 10 based Claude Code environment, so always use corresponding Windows commands first before Linux commands

## Project Context Rules

1. **Java Version**: This project uses Java 1.7 compatibility - ensure all code follows Java 1.7 syntax and features
2. **Maven Commands**: Always use Maven for build operations (`mvn compile`, `mvn package`, `mvn test`)
3. **Database**: MySQL is used - refer to `src/wb_work/indoor_pos_database.sql` for schema
4. **Main Server Port**: The positioning server runs on port 50006
5. **Display Server Port**: The display server runs on port 50005

## Code Style Rules

1. **No Comments**: Do not add code comments unless explicitly requested by the user
2. **Existing Patterns**: Follow existing code patterns in the project for consistency
3. **Dependencies**: Only use dependencies already declared in `pom.xml`
4. **Encoding**: All files should use UTF-8 encoding

## Testing Rules

1. **Test Location**: Test files are in `src/test/java/org/hqu/indoor_pos/test/`
2. **Test Clients**: Use existing test clients (PosClient1-8) for testing positioning functionality
3. **Display Testing**: Use `DispMain` for GUI testing of positioning results

## Development Workflow Rules

1. **Build First**: Always run `mvn compile` before testing changes
2. **Database Setup**: Ensure MySQL is running and `indoor_pos` database exists
3. **Port Conflicts**: Check ports 50005 and 50006 are available before starting servers
4. **Configuration**: Database configuration is in `src/main/resources/jdbc.properties`

## Positioning Algorithm Rules

1. **Algorithm Interface**: All positioning algorithms must implement the `Dealer` interface
2. **RSSI Format**: Positioning data format is `"baseStationId1,rssi1;baseStationId2,rssi2;...;terminalId"`
3. **Coordinate System**: Use consistent coordinate system across all algorithms
4. **Caching**: Leverage existing concurrent maps for base station and employee data

## File Organization Rules

1. **Core Server**: `src/main/java/org/hqu/indoor_pos/server/`
2. **Algorithms**: `src/main/java/org/hqu/indoor_pos/algorithm/`
3. **Data Models**: `src/main/java/org/hqu/indoor_pos/bean/`
4. **RMI Services**: `src/main/java/org/hqu/indoor_pos/rmi/`
5. **Configuration**: `src/main/resources/`
6. **Work Files**: `src/wb_work/` for development documentation