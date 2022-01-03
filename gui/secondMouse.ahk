global mouseCursorPath := FLahkPath "\mouse_cursror.png"
global MouseCursorGuiId :=
global MouseCursorImageId :=

global mouseCursorW := 
global mouseCursorH := 
global secondMouseX := 100
global secondMouseY := 100

makeMouseCursor()
{
    Gui, MouseCursor:-Caption +AlwaysOnTop +E0x08000000 +E0x20 +HwndMouseCursorGuiId 
    Gui, MouseCursor:Add, Picture, x0 y0 hwndMouseCursorImageId, %mouseCursorPath%
    Gui, MouseCursor:Color, 0x596267
    controlgetpos,,, mouseCursorW, mouseCursorH,,ahk_id %MouseCursorImageId%
    Gui, MouseCursor:Show, x%secondMouseX% y%secondMouseY% w%mouseCursorW% h%mouseCursorH%, ; +E0x08000000, 
}