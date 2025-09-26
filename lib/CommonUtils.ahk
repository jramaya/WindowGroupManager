; CommonUtils.ahk
CenterMouse(hwnd) {
    x := y := w := h := 0
    WinGetPos(&x, &y, &w, &h, hwnd)
    MouseMove(x + w // 2, y + h // 2, 0)
}

HandleGroup(groupName, exePath) {
    global WindowGroupIndex, LastGroup

    ids := WinGetList("ahk_group " groupName)
    if ids.Length = 0 {
        try {
            Run(exePath)
        } catch Error as e {
            MsgBox("❌ Could not launch " exePath ".`n`nError: " e.Message, "Launch Failed", 48)
            return
        }
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
            WinActivate("ahk_id " LastActive[groupName])
            CenterMouse(LastActive[groupName])
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
            WinActivate(id)
            CenterMouse(id)
            LastActive[groupName] := id
            LastGroup := groupName
            return
        }
    }
}