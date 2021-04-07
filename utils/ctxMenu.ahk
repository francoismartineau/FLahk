getKnobCtxMenuLength(debug = False)
{
    result := 
    lightGrey := [0xB7BFC4]
    MouseGetPos, x, y
    if (!waitCtxMenuUnderMouse())
        result := False     
    else if (colorsMatch(x+84, y+350, lightGrey, 10, "", debug))  and !(colorsMatch(x-20, y+350, lightGrey, 10, "", debug)) 
        result := "patcherTimeRelated"
    else if (colorsMatch(x+84, y+330, lightGrey, 10, ""))
        result := "patcher"
    else if (colorsMatch(x+84, y+323, lightGrey, 10, ""))
        result := "timeRelated"    
    else if (colorsMatch(x+84, y+302, lightGrey, 10, ""))      ; small     (most knobs)
        result := "other"
    return result
}

linkControllerChecked()
{
    ctxMenuLen := getKnobCtxMenuLength()
    Switch ctxMenuLen
    {
    Case "patcherTimeRelated":
        y := 187+47
    Case "patcher":
        y := 187+27     
    Case "timeRelated":
        y := 187+22
    Case "other":
        y := 187
    }  
    lightGrey := [0xB7BFC4]
    MouseGetPos, mX, mY
    x := mX + 10
    y := mY + y
    return !colorsMatch(x, y, lightGrey)
}

clickLinkController()
{
    ctxMenuLen := getKnobCtxMenuLength()
    Switch ctxMenuLen
    {
    Case "patcherTimeRelated":
        y := 229
    Case "patcher":
        y := 209
    Case "timeRelated":
        y := 204
    Case "other":
        y := 182
    }      
    MouseMove, 10, %y%, 0, R
    Click
    return waitNewWindowOfClass("TMIDIInputForm", winId)
}

clickEditEvents(knobX, knobY, winId)
{
    ctxMenuLen := getKnobCtxMenuLength()
    Switch ctxMenuLen
    {
    Case "patcherTimeRelated":
        y := 95
    Case "patcher":
        y := 77
    Case "timeRelated":
        y := 70
    Case "other":
        y := 49
    }    

    x := 10 + knobX
    y := y + knobY
    ;greyMenu := [0xbbc3c8, 0xb7bfc4, 0x8f9ca2, 0xb6bec3]
    eventWindowOpen := colorsMatch(x, y, [0x000000], 100, "")
    if (!eventWindowOpen)
    {
        MouseMove, %x%, %y%
        Click
        eventWinId := waitNewWindow(winId)        
    }
    else
    {
        Send {Esc}
        WinActivate, Events -
        WinGet, eventWinId, ID, A       ; Activate already open window
    }
    return eventWinId
}

clickCopy()
{
    ctxMenuLen := getKnobCtxMenuLength()
    Switch ctxMenuLen
    {
    Case "patcherTimeRelated":
        y := 280
    Case "patcher":
        y := 267
    Case "timeRelated":
        y := 258
    Case "other":
        y := 237
    }
    MouseMove, 46,  %y%, 0, R
    Click
}

clickPaste(ctxMenuLen = "")
{
    if (ctxMenuLen == "")
        ctxMenuLen := getKnobCtxMenuLength()
    Switch ctxMenuLen
    {
    Case "patcherTimeRelated":
        y := 305
    Case "patcher":
        y := 284
    Case "timeRelated":
        y := 277
    Case "other":
        y := 258
    }
    MouseMove, 46,  %y%, 0, R
    Click     
}
