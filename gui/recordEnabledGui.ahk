global RecordEnabledGuiId
global RecordEnabledGui
global recordMode := ""
global RecordEnabledText
global recordGuiW := 80
global recordGuiH := 20


makeRecordEnabledGui()
{
    Gui, RecordEnabledGui:New   
    Gui, RecordEnabledGui:-Caption +E0x08000000 +E0x20 +AlwaysOnTop +LastFound +ToolWindow +HwndRecordEnabledGuiId
    Gui, RecordEnabledGui:Color, 0xFF0000
    Gui, RecordEnabledGui:Add, Text, x1 y1 w%recordGuiW% vRecordEnabledText
}

showRecordEnabledGui(x, y)
{
    Gui, RecordEnabledGui:Show, x%x% y%y% w%recordGuiW% h%recordGuiH% NoActivate, RecordEnabledGui
    WinSet, Transparent, 150, ahk_id %RecordEnabledGuiId%
}

hideRecordEnabledGui()
{
    Gui, RecordEnabledGui:Hide
}

updateRecordModeGui()
{
    GuiControl, RecordEnabledGui:, RecordEnabledText, ⏺ %recordMode%
}