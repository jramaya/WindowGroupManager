# Window Group Manager

An advanced AutoHotkey v2 project for powerful window management, custom hotkeys, and enhanced productivity on Windows.

## About The Project

**WindowGroupManager** is a collection of modular AutoHotkey v2 scripts designed to streamline your workflow on Windows. The core of this project is a powerful, configuration-driven window cycler that allows you to group application windows and switch between them with a single, custom hotkey.

Tired of `Alt+Tab`-ing through dozens of windows to find the right one? This project lets you define logical groups (e.g., all your code editor windows, all your browser windows) and cycle through them effortlessly. This level of organization can be so effective that it can reduce the need for an extra monitor, maximizing your screen real estate.

Beyond window management, this project includes several quality-of-life enhancements:

*   **Run as Administrator:** Quickly launch a terminal or File Explorer with elevated privileges.
*   **Enhanced CapsLock:** Transform your rarely-used `CapsLock` key into an additional `Ctrl` key.
*   **Shortcut Override:** Disable default Windows shortcuts (like `Win+E`) to free them up for your custom actions.

## Key Features

*   🚀 **Dynamic Window Cycling:** Define application groups in a simple `.ini` file and assign a unique hotkey to cycle through each group's windows.
*   🛡️ **Admin Launchers:** Dedicated hotkeys to open a terminal and File Explorer as an administrator.
*   ⌨️ **CapsLock to Ctrl:** Remaps `CapsLock` to `Left Ctrl` for easier access to shortcuts, without losing the ability to toggle CapsLock when needed.
*   ⚙️ **Highly Configurable:** No need to edit the source code. All window groups and hotkeys are managed through the `config.ini` file.
*   ✨ **Custom Hotkeys:** A simple module to add your own personal hotkeys for common actions.
*   ⛔ **Disable Native Shortcuts:** Reclaim valuable `Win+` key combinations for your own productivity scripts.

## Getting Started

### Prerequisites

You must have AutoHotkey v2.0 or a newer version installed.

### Installation

1.  Clone the repository to your local machine:
    ```sh
    git clone https://github.com/jramaya/WindowGroupManager.git
    ```
2.  Navigate to the cloned directory.
3.  Customize the `config.ini` file to define your own application groups and hotkeys (see Configuration section below).
4.  Run `init.ahk` to start the script.

## Configuration

The behavior of the window manager is controlled entirely by `config.ini`. You can define as many application groups as you need.

Each application is defined as a section (e.g., `[MyBrowser]`). Inside each section, you must provide the following key-value pairs:

```ini
[AppName]
GroupName=SomeGroup
WinTitle=ahk_exe application.exe
Path=path_to_application.exe
Hotkey=#k
```

### Configuration Keys

*   **`GroupName`**: An internal, unique name for this group of windows.
*   **`WinTitle`**: The criteria AutoHotkey uses to identify the windows belonging to this group. The most common method is `ahk_exe process_name.exe`. You can find more options in the AutoHotkey documentation.
*   **`Path`**: The command or full path to the executable used to launch the application if no windows from that group are found.
*   **`Hotkey`**: The hotkey that will trigger the window cycling for this group.
    *   `#` = Win
    *   `^` = Ctrl
    *   `!` = Alt
    *   `+` = Shift
    *   Example: `Hotkey=#s` means `Win + S`.