; CustomHotkeys.ahk
#Requires AutoHotkey v2.0

; --- Custom Hotkeys ---

#h:: {
    ; Mark that a Win+key combo was triggered so LWin Up won't treat this as a lone Win press
    global WinKeyComboTriggered
    WinKeyComboTriggered := true
    Send "{Backspace}"
}

#m:: {
    global WinKeyComboTriggered
    WinKeyComboTriggered := true
    Send "{Enter}"
}

#c:: {
    global WinKeyComboTriggered
    WinKeyComboTriggered := true
    Send "{Escape}"
}

~LWin:: {
	global WinKeyComboTriggered
	WinKeyComboTriggered := false
}

~LWin Up:: {
	global WinKeyComboTriggered
	if !WinKeyComboTriggered
		StartSystemPanelTrigger("Menu Inicio", 150)
	WinKeyComboTriggered := false
}

~#a:: {
	global WinKeyComboTriggered
	WinKeyComboTriggered := true
	StartSystemPanelTrigger("Win+A", 100)
}

; Win+B handler: move cursor to tray chevron and open hidden icons
#b:: {
    global WinKeyComboTriggered, WinABeforeWindow, NewlyLaunchedPendingSelection
    WinKeyComboTriggered := true
    ;for groupName in NewlyLaunchedPendingSelection
    ;    NewlyLaunchedPendingSelection[groupName] := false
    ;; Save previous active window and trigger mouse follow for the system panel.
    ;WinABeforeWindow := WinExist("A")
    ;MouseFollowActiveWindow("Win+B", 220)

    ; Send native Win+B to open the notification area. We intentionally do
    ; NOT send Enter here because previous attempts to auto-send Enter could
    ; activate the wrong window depending on timing and focus.
    Send("#b")

    ; TODO: implement a more reliable detection that the notification panel
    ; is focused before sending Enter (e.g. reuse MoveMouseToActive's
    ; polling and/or check shell process/class). For now, avoid sending Enter
    ; to prevent accidental input in the active window.
}
