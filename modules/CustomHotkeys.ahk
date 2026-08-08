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
