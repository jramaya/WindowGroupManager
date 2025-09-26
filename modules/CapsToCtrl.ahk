#Requires AutoHotkey v2.0

; Completely blocks CapsLock and turns it into Left Ctrl
$*CapsLock::
{
    local holdThreshold := 2000  ; 2 seconds
    local pressTime := A_TickCount

    Send("{Ctrl down}")
    ; Wait for the key to be released
    KeyWait("CapsLock")
    Send("{Ctrl up}")

    local heldTime := A_TickCount - pressTime
    if (heldTime >= holdThreshold) {
        ToolTip("To toggle caps lock: Ctrl + PrintScreen")
        SetTimer(() => ToolTip(), -3000)
    }
    return
}

; Always keeps CapsLock off
SetCapsLockState("Off")

; Ctrl + PrintScreen toggles caps lock
^PrintScreen::
{
    SetCapsLockState(!GetKeyState("CapsLock", "T"))
    TrayTip("CapsLock Toggle", "Status: " . (GetKeyState("CapsLock", "T") ? "On" : "Off"), 1000)
}
