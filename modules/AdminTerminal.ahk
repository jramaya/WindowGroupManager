#Requires AutoHotkey v2.0
; #Include CommonUtils.ahk

GroupAdd("AdminTermGroup", "ahk_exe alacritty.exe ahk_title AdminTermAlacritty")

#+t::RunAdminTerminalOnce()

RunAdminTerminalOnce() {
    adminTitle := "AdminTermAlacritty"
    if WinExist("ahk_group AdminTermGroup") {
        WinActivate(adminTitle)
        ; CenterMouse(WinExist(adminTitle))
        return
    }
    try {
        Run("*RunAs alacritty.exe --title " adminTitle)
    } catch Error as e {
        MsgBox("Could not start terminal as administrator.`n`nError: " e.Message, "Launch Error", 48)
    }
}
