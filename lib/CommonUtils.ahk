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
    global WindowGroupIndex, LastGroup, LastActive, NewlyLaunchedPendingSelection

    if NewlyLaunchedPendingSelection.Get(groupName, false)
        return

    ids := WinGetList("ahk_group " groupName)
    if ids.Length = 0 {
        NewlyLaunchedPendingSelection[groupName] := true
        try {
            Run(exePath)
        } catch Error as e {
            NewlyLaunchedPendingSelection[groupName] := false
            MsgBox("❌ Could not launch " exePath ".`n`nError: " e.Message, "Launch Failed", 48)
            return
        }
        SetTimer(() => SelectLaunchedWindow(groupName, A_TickCount + 15000), -100)
        WindowGroupIndex[groupName] := 1
        LastGroup := groupName
        return
    }

    active := WinExist("A")
    ; Repeated presses should recenter the only window even when no switch is needed.
    if ids.Length = 1 && ids[1] = active {
        LastGroup := groupName
        LastActive[groupName] := active
        CenterMouse(active)
        return
    }

    if LastGroup != groupName {
        LastGroup := groupName
        if RestoreLastActiveWindow(groupName)
            return
    }

    CycleThroughWindows(groupName, ids, active)
}

SelectLaunchedWindow(groupName, deadline) {
    global NewlyLaunchedPendingSelection, LastActive, LastGroup

    if !NewlyLaunchedPendingSelection.Get(groupName, false)
        return

    ids := WinGetList("ahk_group " groupName)
    if ids.Length {
        id := ids[1]
        try {
            ShowSelectionDebug(groupName, id)
            WinActivate("ahk_id " id)
            CenterMouse(id)
            if WinWaitActive("ahk_id " id, , 0.2) && NewlyLaunchedPendingSelection.Get(groupName, false) {
                LastActive[groupName] := id
                LastGroup := groupName
                NewlyLaunchedPendingSelection[groupName] := false
                return
            }
        } catch Error {
            ; The window may have closed before it could be activated.
        }
    }

    if A_TickCount < deadline
        SetTimer(() => SelectLaunchedWindow(groupName, deadline), -100)
    else
        NewlyLaunchedPendingSelection[groupName] := false
}

RestoreLastActiveWindow(groupName) {
    global LastActive, WinABeforeWindow

    try {
        if LastActive.Has(groupName) && WinExist("ahk_id " LastActive[groupName]) {
            WinABeforeWindow := WinExist("A")
            ShowSelectionDebug(groupName, LastActive[groupName])
            WinActivate("ahk_id " LastActive[groupName])
            ; The follow-up timer only reacts to a changed active window, so recenter directly if already active.
            if WinABeforeWindow = LastActive[groupName]
                CenterMouse(LastActive[groupName])
            else
                MouseFollowActiveWindow("Restoring " groupName, 80)
            return true
        }
    } catch Error as e {
        ; Do nothing, continue without interruption
    }
    return false
}

CycleThroughWindows(groupName, ids, active) {
    global WindowGroupIndex, LastActive, LastGroup, WinABeforeWindow

    if WindowGroupIndex[groupName] > ids.Length
        WindowGroupIndex[groupName] := 1

    Loop {
        if WindowGroupIndex[groupName] > ids.Length
            WindowGroupIndex[groupName] := 1

        id := ids[WindowGroupIndex[groupName]]
        WindowGroupIndex[groupName] += 1

        if id != active {
            WinABeforeWindow := active
            ShowSelectionDebug(groupName, id)
            WinActivate(id)
            MouseFollowActiveWindow("Changing " groupName, 80)
            LastActive[groupName] := id
            LastGroup := groupName
            return
        }
    }
}

ShowSelectionDebug(groupName, hwnd) {
    global ShowTooltips
    if !ShowTooltips
        return

    caller := Error("", -2)
    active := WinExist("A")
    target := "ahk_id " hwnd
    title := "(window not available)"
    process := "(unknown)"
    try {
        title := WinGetTitle(target)
        process := WinGetProcessName(target)
    }

    centering := caller.What = "SelectLaunchedWindow" || (caller.What = "RestoreLastActiveWindow" && active = hwnd)
        ? "CenterMouse (direct)" : "MouseFollowActiveWindow (deferred)"
    ToolTip("Group: " groupName "`nActive window: ahk_id " active
        . "`nTarget: " target "`nTitle: " title "`nProcess: " process
        . "`nActivation: WinActivate`nCentering: " centering
        . "`nCaller: " caller.What " (" caller.File ":" caller.Line ")"
        . "`nStack:`n" caller.Stack, , , 20)
    SetTimer(HideSelectionDebugTooltip, -5000)
}

HideSelectionDebugTooltip() {
    ToolTip(, , , 20)
}

StartSystemPanelTrigger(label, delay) {
    global WinABeforeWindow
    WinABeforeWindow := WinExist("A")
    MouseFollowActiveWindow(label, delay)
}

MouseFollowActiveWindow(label, delay := 100) {
    ;ToolTip(label ": trigger detected",,,20)
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

    ;ToolTip("Active window not found",,,20)
    ;SetTimer(() => ToolTip(,,,20), -2000)
}
