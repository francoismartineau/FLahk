#Include %A_MyDocuments%/AutoHotkey/Lib/maLib.ahk
debugOn := False

Test()
{
    ;freezeExecute("cellphoneWavToMidi", False)
}


Test2()
{

}


if (A_ScriptName == "Test.ahk")
{
    ;a := -3 - (-3)
    ;msgTip(a)s
    ;ExitApp
}

;;;;  TESTS   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/*
testMidiRequest()
{
    answer := midiRequest("test_FL")
    if (answer == 49)
        msgBox("sucess")
    else
        msgBox("Expected answer: 49     answer: " answer)
}

testColorUnderMouse()
{
    MouseGetPos, x, y
    cols := [0x313C45]
    colVar := 0
    hint := " "
    matches := colorsMatch( x, y, cols, colVar, hint)
    PixelGetColor, resCol, x, y, RGB
    col := cols[1]
    msgBox(col " == " resCol " -> " matches)
}

testColorRightToMouse()
{
    MouseGetPos, x, y
    ;cols := [0x313C45] vrai couleur
    cols := [0x303C45] ; modifié de 1 
    colVar := 1         ; à 0 ça marcherait pas
    hint := " "
    incr := 10
    hint := "         "
    w := 500
    foundX := scanColorRight(x, y, w, cols, colVar, incr, hint)    
    relX := foundX - x
    msgBox("x: " foundX " relX: " relX)
}




#if GetKeyState("Shift")
+WheelUp::  
    state := GetKeyState("Shift")
    msgTip("state: " state)
    Send !{WheelUp}
    return

WheelDown::
    ToolTip, wheel down shift
    Send !{WheelDown}
    return
#if
*/


/*

+WheelUp::
    toolTip("wheel up")
    SendInput !{WheelUp}
    return

+WheelDown::
    SendInput !{WheelDown}
    return



+WheelUp::
    toolTip("up")
    Send {AltDown}{WheelUp}{AltUp}
    ;SendInput !{Blind}{WheelUp}
    return

+WheelDown::
    toolTip("dwon")
    Send {AltDown}{WheelDown}{AltUp}
    ;SendInput !{Blind}{WheelDown}
    return


; SendMode Event ; Default
; SendMode Input ; Recommended
; SendMode Play  ; Some apps like it

#if GetKeyState("Shift", "P")
    +WheelUp::Send !{WheelUp}
    +WheelDown::Send !{WheelDown}
#if
*/
