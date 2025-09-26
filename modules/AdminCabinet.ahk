#Requires AutoHotkey v2.0

; Define a group for File Explorer windows.
; Note: Unlike AdminTerminal, we can't easily set a unique title
; for a File Explorer window launched as administrator.
; Therefore, activating a specific pre-existing *admin* Explorer window
; is less straightforward.
GroupAdd("AdminCabinetGroup", "ahk_class CabinetWClass ahk_exe explorer.exe")

; Hotkey to try to run/focus a File Explorer as administrator
#^e::RunAdminCabinet()

RunAdminCabinet() {
    ; Criteria to find an Explorer window.
    ; Since we can't easily set a unique title for the admin explorer at launch,
    ; "ahk_group AdminCabinetGroup" will match any explorer window.
    local targetWinCriteria := "ahk_group AdminCabinetGroup"

    ; If a suitable window is not found, or to ensure an admin prompt,
    ; run explorer.exe with admin privileges.
    Run("*RunAs explorer.exe")
}