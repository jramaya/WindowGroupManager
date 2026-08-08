; CommonUtils.ahk
global WinABeforeWindow := 0

CenterMouse(hwnd) {
    x := y := w := h := 0
    ; Save and restore previous CoordMode for Mouse
    prevCoordMode := CoordMode("Mouse")
    CoordMode("Mouse", "Screen")
    WinGetPos(&x, &y, &w, &h, hwnd)
    MouseMove(x + w // 2, y + h // 2, 0)
    CoordMode("Mouse", prevCoordMode)
}

HandleGroup(groupName, exePath) {
    global WindowGroupIndex, LastGroup

    ids := WinGetList("ahk_group " groupName)
    if ids.Length = 0 {
        WinABeforeWindow := WinExist("A")
        try {
            Run(exePath)
        } catch Error as e {
            MsgBox("❌ Could not launch " exePath ".`n`nError: " e.Message, "Launch Failed", 48)
            return
        }
        MouseFollowActiveWindow(groupName, 120)
        WindowGroupIndex[groupName] := 1
        LastGroup := groupName
        return
    }

    active := WinExist("A")

    if LastGroup != groupName {
        LastGroup := groupName
        if RestoreLastActiveWindow(groupName)
            return
    }

    if ids.Length = 1 && ids[1] = active
        return

    CycleThroughWindows(groupName, ids, active)
}

RestoreLastActiveWindow(groupName) {
    global LastActive

    try {
        if LastActive.Has(groupName) && WinExist("ahk_id " LastActive[groupName]) {
            WinABeforeWindow := WinExist("A")
            WinActivate("ahk_id " LastActive[groupName])
            MouseFollowActiveWindow("Restaurando " groupName, 80)
            return true
        }
    } catch Error as e {
        ; Do nothing, continue without interruption
    }
    return false
}

CycleThroughWindows(groupName, ids, active) {
    global WindowGroupIndex, LastActive, LastGroup

    if WindowGroupIndex[groupName] > ids.Length
        WindowGroupIndex[groupName] := 1

    Loop {
        if WindowGroupIndex[groupName] > ids.Length
            WindowGroupIndex[groupName] := 1

        id := ids[WindowGroupIndex[groupName]]
        WindowGroupIndex[groupName] += 1

        if id != active {
            WinABeforeWindow := active
            WinActivate(id)
            MouseFollowActiveWindow("Cambiando " groupName, 80)
            LastActive[groupName] := id
            LastGroup := groupName
            return
        }
    }
}

StartSystemPanelTrigger(label, delay) {
    WinABeforeWindow := WinExist("A")
    MouseFollowActiveWindow(label, delay)
}

MouseFollowActiveWindow(label, delay := 100) {
    ;ToolTip(label ": trigger detectado",,,20)
    ;SetTimer(() => ToolTip(,,,20), -1200)
    SetTimer(MoveMouseToActive, -delay)
}

MoveMouseToActive() {
    global WinABeforeWindow

    Loop 20 {
        activeWindow := WinExist("A")
        if activeWindow && activeWindow != WinABeforeWindow {
            try {
                CenterMouse(activeWindow)
                return
            } catch {
                ; Continue polling until a valid active window is found.
            }
        }
        Sleep(30)
    }

    ;ToolTip("No se encontro la ventana activa",,,20)
    ;SetTimer(() => ToolTip(,,,20), -2000)
}
