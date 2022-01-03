#Include %A_MyDocuments%/AutoHotkey/Lib/maLib.ahk
#SingleInstance Force
debugOn := False


Test()
{
    envcActivateArticulator(8)
    ;freezeExecute("bringPercnv")
    ;projectNameNoExtension := "Test"
    ;setDataFolder()
   
} 



Test2()
{

}

if (A_ScriptName == "Test.ahk")
{
    Test()
    Sleep, 4000
    ExitApp
}

/*
TEST:
    msg("OK")
    return
;*/

;;;;; WIN COVERED WIP ;;;;;;;;;;;;;;;;;
/*
Test()
{

    activeId := WinExist("A")
    WinGet, idList, List,,, ahk_exe FL64.exe
    Loop, %idList%
    {
        currId := idList%A_Index%
        WinGetTitle, winTitle, ahk_id %currId%
        if (currId == activeId)
            continue
        if winIsCovered(activeId, currId)
        {
            msg("WIN IS COVERED")
            Break
        }
    }
} 

winIsCovered(winId, coverWinId)
{
    WinGetPos, x1, y1, w1, h1, ahk_id %winId%
    WinGetPos, x2, y2, w2, h2, ahk_id %coverWinId%

    topMightBeCovered := y1>=y2 and y1<=y2+h2
    bottomMightBeCovered := y1+h1>= y2 and y1+h1<=y2+h2
    leftMightBeCovered := x1>=x2 and x1<=x2+w2
    rightMightBeCovered := x1+w1<=x2+w2 and x1+w1>=x2

    aCornerIsCovered := (leftMightBeCovered and (topMightBeCovered or bottomMightBeCovered)) or (rightMightBeCovered and (topMightBeCovered or bottomMightBeCovered))
    if (aCornerIsCovered)
    {
        msg("corner")
        return True

    }
    
    middleXmightBeCovered := x1 < x2 and x1+w1 > x2+w2
    middleYmightBeCovered := y1 < y2 and y1+h1 > y2+h2
    middleXisCovered := middleXmightBeCovered and !(y1+h1<y2) and !(y1>y2+h2)
    middleYisCovered := middleXmightBeCovered and !(x1+w1<x2) and !(x1>x2+w2)
    if (middleXisCovered or middleYisCovered)
        return True

    return False
}
*/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



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
    foundX := scanColorsRight(x, y, w, cols, colVar, incr, hint)    
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
