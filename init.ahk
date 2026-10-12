; init.ahk
#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook
SetTitleMatchMode("2")
SendMode("Input") ; Can improve the speed and reliability of Send

global configFile := A_ScriptDir . "\config.ini"
global ShowTooltips := false ; Set to true to enable diagnostic and CapsLock tooltips.

; --- Included Modules ---

; #Include "lib/DisableWinKeyCombinations.ahk"
#Include "modules/CapsToCtrl.ahk"
#Include "WindowGroupManager.ahk"
#Include "modules/CustomHotkeys.ahk"
#Include "modules/AdminTerminal.ahk"
#Include "modules/AdminCabinet.ahk"
