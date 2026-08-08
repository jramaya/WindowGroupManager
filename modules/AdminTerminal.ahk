#Requires AutoHotkey v2.0
; #Include CommonUtils.ahk

GroupAdd("AdminTermGroup", "ahk_exe alacritty.exe ahk_title AdminTermAlacritty")

#+t::RunAdminTerminalOnce()

RunAdminTerminalOnce() {
    adminTitle := "AdminTermAlacritty"
    if WinExist("ahk_group AdminTermGroup") {
        WinABeforeWindow := WinExist("A")
        WinActivate(adminTitle)
        MouseFollowActiveWindow("Admin Terminal", 80)
        return
    }
    try {
        WinABeforeWindow := WinExist("A")
        Run("*RunAs alacritty.exe --title " adminTitle)
        MouseFollowActiveWindow("Admin Terminal", 120)
    } catch Error as e {
        MsgBox("Could not start terminal as administrator.`n`nError: " e.Message, "Launch Error", 48)
    }
}
