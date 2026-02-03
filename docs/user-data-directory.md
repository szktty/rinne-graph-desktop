# User Data Directory Specification

## Overview

RinneGraph uses a dedicated directory structure to manage user data. This document describes the specification and structure of the user data directory.

## Directory Structure

### Basic Structure

```
[Documents Directory]/App/
├── Stacks/                    # Stack storage directory
│   ├── [Stack Name 1].stack/  # Individual stack directory
│   ├── [Stack Name 2].stack/  # Individual stack directory
│   └── ...
└── [Directory for Future Extensions]
```

### Base Directories by Platform

| Platform | Base Directory |
|---|---|
| macOS | `~/Documents/App/` |
| Windows | `%USERPROFILE%\Documents\App\` |
| Linux | `~/Documents/App/` |

## Stacks Directory

### Purpose
- Storage location for user-created stacks (databases)
- Default save location when creating a new stack

### Features
- Automatically created upon application startup
- If manually deleted by the user, it will be recreated on the next startup
- Stack files are saved as directories with a `.stack` extension

### Stack Directory Naming Convention
- Stack names are sanitized before use
- Invalid characters (`<>:"/\\|?*`) are replaced with underscores (`_`)
- Consecutive whitespace characters are replaced with underscores (`_`)
- Example: `My Project Stack` → `My_Project_Stack.stack`

## Implementation Details

### Initialization Process
- The `Stacks directory` is created during the initialization of the `core_foundation` package
- Designed not to hinder application startup if an error occurs

### Access Method
```dart
// Access using FileSystemService
final fileSystemService = FileSystemService();
final appDir = await fileSystemService.getApplicationDocumentsDirectory();
final stacksDir = Directory('${appDir.path}/Stacks');
```

### Behavior When Creating a New Stack
1. The `Stacks directory` is presented as the default save location.
2. The user can specify an alternative location.
3. If the specified directory is not empty, an error is displayed.

## Security and Privacy

### Data Ownership
- All data is stored on the user's local machine
- Users can directly manipulate the directory structure
- Data remains accessible after the application is closed

### Backup and Portability
- Data can be migrated by copying the entire `App` directory
- Individual stack directories can be copied to duplicate stacks

## Future Extensions

### Planned Additional Directories
- `Templates/` - For storing stack templates
- `Plugins/` - For storing user plugins
- `Cache/` - For temporary files and cache
- `Logs/` - For application logs

### Configuration Files
The following configuration files may be added in the future:
- `config.json` - Application settings
- `preferences.json` - User settings

## Troubleshooting

### Common Problems

#### Stacks directory not created
- Check write permissions for the documents directory
- Check disk space
- Check application logs for error messages

#### Error occurs during stack creation
- Confirm that the save destination directory is empty
- Check write permissions for the directory
- Check if the stack name contains invalid characters

### Manual Directory Creation
If necessary, manual creation is possible with the following commands:

```bash
# macOS/Linux
mkdir -p ~/Documents/App/Stacks

# Windows (PowerShell)
New-Item -ItemType Directory -Path "$env:USERPROFILE\Documents\App\Stacks" -Force
```

## Related Documents

- [Stack Specification](../packages/core/stack/docs/specification.md)
- [File System Service](../packages/core/foundation/README.md)