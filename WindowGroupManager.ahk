#Requires AutoHotkey v2.0
#Include "lib/CommonUtils.ahk"

; Initializes the global maps that will be populated from the INI file.
global WindowGroupIndex := Map() ; Stores the index of the active window for each group.
global AppPaths := Map() ; Stores the executable path for each group.
global LastActive := Map() ; Stores the last active window for each group.
global LastGroup := "" ; Stores the last group that was used.
global configFile


allSections := IniRead(configFile)

Loop parse allSections, "`n"
{
    currentSection := A_LoopField ; The current section name, for example, "VSCode".
    if (currentSection = "") ; If the line is empty, skip it.
        continue

    ; Reads the configuration values for the current section.
    groupName := IniRead(configFile, currentSection, "GroupName")
    winTitle := IniRead(configFile, currentSection, "WinTitle") 
    path := IniRead(configFile, currentSection, "Path") 
    hotkeyDef := IniRead(configFile, currentSection, "Hotkey")

    if !(groupName && winTitle && path && hotkeyDef)
        continue

    ; Populates the global maps with the read configuration.
    WindowGroupIndex[groupName] := 1 ; Initializes the window index for the new group.
    AppPaths[groupName] := path ; Associates the executable path with the group name.

    ; Creates the window group dynamically.
    GroupAdd(groupName, winTitle) ; Creates the window group for AutoHotkey.

    ; Creates the hotkey dynamically.
    CreateHotkey(hotkeyDef, groupName, path)
}

#r::Run("powershell -c (New-Object -ComObject 'Shell.Application').FileRun()")

CreateHotkey(key, group, path) {
    ; By passing variables as parameters to this function, a new scope is created.
    Hotkey(key, (*) => HandleGroup(group, path))
}
