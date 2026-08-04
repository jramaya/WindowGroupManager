; CustomHotkeys.ahk
#Requires AutoHotkey v2.0

; --- Custom Hotkeys ---

; win+h behaves like the Backspace key.
#h::Send "{Backspace}"
#m::Send "{Enter}"
#c::Send "{Escape}"

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
