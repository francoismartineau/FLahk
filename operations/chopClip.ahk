
;;; aussi couper aux time selections

chopClip() {
    snapActivated := checkIfSnap()
    saveMousePos()
    activateCutTool()
    retrieveMousePos()

    x1 := makeFirstCut(snapActivated)
    if (!x1)
    {
        Tooltip, couldn't find cut line, %playlistToolTipX%, %playlistToolTipY%
        return
    }

    x2 := makeSecondCut(snapActivated)
    if (!x2) {
        Tooltip, couldn't find cut line, %playlistToolTipX%, %playlistToolTipY%
        return
    }  

    xEnd := makeEndCut()
    MouseGetPos,, y
    space := x2 - x1
    x := x2 + space

    while (x <= xEnd) {
        MouseMove, %x%, %y% 
        Send {Shift Down}
        Click
        Send {Shift Up}
        x := x + space
    }
    unfreezeMouse()
    activateBrushTool()
        ;; [peut aller à gauche ou à droite]  (ça marche tu déjà?)
}

makeFirstCut(snapActivated)
{
    MouseGetPos, x1, y
    Send {Shift Down}
    Click, Down
    if (snapActivated)
        x1 := findExactCutX(x1, y)
    Click, Up
    Send {Shift Up}        
    return x1
}



makeSecondCut(snapActivated)
{
    playlistToolTip("Press c at 2nd cut")
    unfreezeMouse()
    KeyWait, c, D
    KeyWait, c
    freezeMouse()
    
    MouseGetPos, x2, y
    Send {Shift Down}
    Click, Down
    if (snapActivated)
        x2 := findExactCutX(x2, y)
    Click, Up
    Send {Shift Up}       
    return x2
}

makeEndCut()
{
    playlistToolTip("Press c at end")
    
    unfreezeMouse()
    KeyWait, c, D
    KeyWait, c
    freezeMouse()

    MouseGetPos, xEnd
    Send {Shift Down}
    Click, Down  
    Click, Up
    Send {Shift Up}       
    ToolTip
    return xEnd
}



findExactCutX(x, y) {
    cols := [0x72A3FF, 0x3C77F2, 0x6D7770, 0x6C756E] ;, 0x4f80f3, 0x6e807f]
    colVar := 20
    incr := 1
    hint := ""
    width := 15
    ;w := Floor(width / 2)
    y := y - 10
    x := Floor(x - width / 2)
    x := scanColorRight(x, y, width, cols, colVar, incr, hint)
    ;x := scanColorLeftRight(x, y, w, cols, colVar, incr, hint)
    return x
}

cutUnderMouse(removeAfter = False) {
    MouseGetPos, mX, mY
    currTool := whichToolActivated()
    if (currTool != "cutTool")
    {
        activateCutTool()
        retrieveMousePos()
    }
    Send {Shift Down}
    Click
    Send {Shift Up}
    if (removeAfter)
    {
        MouseMove, 10, 0,, R
        Send {Ctrl Down}{LButton}{Ctrl Up}
        Send {Delete}
        MouseMove, -20, 0,, R
    }
    Switch currTool
    {
    Case "pencilTool":
        activatePencilTool()
    Case "brushTool":
        activateBrushTool()
    Case "muteTool":
        activateMuteTool()
    }
    
    moveMouse(mX-10, mY)
    Click
    moveMouse(mX+10, mY)
    retrieveMouse := False
}

cutAfterMouse()
{
    cutUnderMouse(True)
}