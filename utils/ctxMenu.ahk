; -----------------------------------
global ctxMenuColors := [0xb9c2c7, 0xbcc4c3] ;[0xbdc6cb, 0xb9c2c7, 0xBBC3C8, 0xb7bfc4, 0x5d6b74, 0xbac1c0, 0xb8c0c5, 0xbbc4c5]
global ctxMenuColVar := 10
global ctxMenuSepColor := [0x939d9c]
global ctxMenuBorderColors := [0x141c1b, 0x151e23, 0x131c1d]
global ctxMenuBorderColVar := 10
global ctxMenuRowHeight := 26
global ctxMenuY := {"normal": {}, "time": {}, "patcherMap": {}, "patcherTime": {}, "patcherSurface": {}, "notActivatedMap": {}, "notActivatedMapTime": {}, "notActivatedSurface": {}, "semiActivatedMap": {}, "semiActivatedMapTime": {}, "semiActivatedSurface": {}}
global ctxMenuCheckX := 10
global ctxMenuCheckBlack := [0x000000]

; This is a pixel list (left to right)
; This recognizes a "Activate" row in ctx menu
; The first pixel is the blue pixel on the top right of c in "Activate"
; Each ctxMenu entry with "Activate" has the y value where to check
global ctxMenuActivateColorList := [0x284F85, 0x896A3A, 0x190200, 0x081B28] ;, 0x3B699B, 0xA79C64, 0x304886, 0xA29E68, 0x2D3773, 0xA2BFC5]
global ctxMenuActivateColorListX := 31
global ctxMenuPasteTMiddleX := 37
global ctxMenuPasteTMiddleCol := [0x110000]

ctxMenuY["normal"]["editEventsCheck"] := 50
ctxMenuY["normal"]["automation"] := 147
ctxMenuY["normal"]["linkCheck"] := 187
ctxMenuY["normal"]["copy"] := 238
ctxMenuY["normal"]["pasteTMiddleY"] := 256
ctxMenuY["normal"]["length"] := 307

ctxMenuY["time"]["editEventsCheck"] := 69
ctxMenuY["time"]["automation"] := 170
ctxMenuY["time"]["linkCheck"] := 206
ctxMenuY["time"]["copy"] := 258
ctxMenuY["time"]["pasteTMiddleY"] := 275
ctxMenuY["time"]["length"] := 326

ctxMenuY["patcherMap"]["activateCheck"] := 34
ctxMenuY["patcherMap"]["activateColorListY"] := 30
ctxMenuY["patcherMap"]["editEventsCheck"] := 76
ctxMenuY["patcherMap"]["automation"] := 177
ctxMenuY["patcherMap"]["linkCheck"] := 213
ctxMenuY["patcherMap"]["copy"] := 265 
ctxMenuY["patcherMap"]["pasteTMiddleY"] := 282 

ctxMenuY["patcherTime"]["activateCheck"] := 53
ctxMenuY["patcherTime"]["activateColorListY"] := 49
ctxMenuY["patcherTime"]["editEventsCheck"] := 95
ctxMenuY["patcherTime"]["automation"] := 194
ctxMenuY["patcherTime"]["linkCheck"] := 232
ctxMenuY["patcherTime"]["copy"] := 284
ctxMenuY["patcherTime"]["pasteTMiddleY"] := 301
ctxMenuY["patcherTime"]["length"] := 352

ctxMenuY["patcherSurface"]["activateCheck"] := 41
ctxMenuY["patcherSurface"]["activateColorListY"] := 37
ctxMenuY["patcherSurface"]["editEventsCheck"] := ctxMenuY["patcherMap"]["editEventsCheck"]
ctxMenuY["patcherSurface"]["automation"] := ctxMenuY["patcherMap"]["automation"]
ctxMenuY["patcherSurface"]["linkCheck"] := ctxMenuY["patcherMap"]["linkCheck"]
ctxMenuY["patcherSurface"]["copy"] := ctxMenuY["patcherMap"]["copy"]
ctxMenuY["patcherSurface"]["pasteTMiddleY"] := ctxMenuY["patcherMap"]["pasteTMiddleY"]
; ----

; -- ctxMenuLen -----------------------------
global linkKnobDontMoveWin := False     ;used only for 2nd mouse
openKnobCtxMenu(mX, mY, ctxMenuLen := "", row := 0, patcherType := "") ;, winX, winY, winId)
{
    if (!linkKnobDontMoveWin)
        moveKnobWinIfNecessary(knobX, knobY, winX, winY, winId)

    Click, Right
    if (waitCtxMenuUnderMouse() and !ctxMenuLen)
    {
        if (row != 0)
            ctxMenuLen := searchCtxMenuActivates(mX, mY, row, patcherType)
        else
        {
            if (isNormalCtxMenu(mX, mY))
                ctxMenuLen := "normal"
            else if (isTimeCtxMenu(mX, mY))
                ctxMenuLen := "time"           
            else
            {
                patcherTypes := ["patcherSurface", "patcherMap", "patcherTime"]
                i := 1
                while (!ctxMenuLen and i <= patcherTypes.MaxIndex())
                {
                    patcherType := patcherTypes[i]
                    ctxMenuLen := searchCtxMenuActivates(mX, mY, row, patcherType)
                    i := i + 1
                }
            } 
        }
    }
    return ctxMenuLen
}

searchCtxMenuActivates(mX, mY, row, patcherType)
{
    textX := mX + ctxMenuActivateColorListX
    checkX := mX + ctxMenuCheckX

    while (ctxMenuLen == "" and row < 10)
    {
        ;msg("row: " row)
        textY := mY + ctxMenuY[patcherType]["activateColorListY"] + row * ctxMenuRowHeight
        activateFound := scanColorsLine(textX, textY, ctxMenuActivateColorList, ctxMenuColVar)
        ;msg("activateFound: " activateFound)
        if (activateFound)
        {
            checkY := mY + ctxMenuY[patcherType]["activateCheck"] + row * ctxMenuRowHeight
            activateChecked := colorsMatch(checkX, checkY, ctxMenuCheckBlack)
            ;msg("checked: " activateChecked)
            row := row + 1
            if (!activateChecked)
            {
                moveMouse(textX, textY)
                Click
                moveMouse(mX, mY)
                ctxMenuLen := openKnobCtxMenu(mX, mY, "", row, patcherType)
            }
        }
        else if (row > 0)
            ctxMenuLen := patcherType "" row
        else
            break       ; no activate found for this patcherType
    }
    return ctxMenuLen
}

moveKnobWinIfNecessary(mX, mY, winX, winY, winId, coord := "Client")
{
    global Mon1Top, Mon2Top
    movedWin := False
    x := mX + winX
    y := mY + winY
    if (x >= 0)
        top := Mon2Top
    else
        top := Mon1Top

    maxY := Mon2Height - ctxMenuY["patcherTime"]["length"] - 30 + top

    if (y > maxY)
    {
        dist := y - maxY
        newWinY := winY - dist
        WinMove, ahk_id %winId%,, %winX%, %newWinY%
        moveMouse(mX, mY, coord)
        movedWin := True
    }    
    return movedWin
}

isNormalCtxMenu(mX, mY)
{
    return isCtxMenuLength(mX, mY, "normal")    
}

isTimeCtxMenu(mX, mY)
{
    return isCtxMenuLength(mX, mY, "time")
}

isCtxMenuLength(mX, mY, ctxMenu)
{
    x := mX + 5
    yIn := mY + ctxMenuY[ctxMenu]["length"]
    yOut := mY + ctxMenuY[ctxMenu]["length"] + 1
    res := colorsMatch(x, yIn, ctxMenuColors, ctxMenuColVar) and colorsMatch(x, yOut, ctxMenuBorderColors, ctxMenuBorderColVar)     
    return res
}

getCtxMenuRowY(ctxMenuLen, option)
{
    rowOffset := 0
    if (InStr(ctxMenuLen, "patcher"))
    {
        row := SubStr(ctxMenuLen, 0)
        rowOffset := (row-1) * ctxMenuRowHeight
        ctxMenuLen := SubStr(ctxMenuLen, 1, -1)
    }
    y := ctxMenuY[ctxMenuLen][option] + rowOffset
    return y
}
; -----

; -- Edit Events ----
clickEditEvents(ctxMenuLen)
{
    MouseGetPos, mX, mY, winId
    x := mX + ctxMenuCheckX

    y := mY + getCtxMenuRowY(ctxMenuLen, "editEventsCheck")
    eventWindowOpen := colorsMatch(x, y, ctxMenuCheckBlack)
    if (!eventWindowOpen)
    {
        MouseMove, %x%, %y%
        Click
        eventWinId := waitNewWindow(winId)        
    }
    else
    {
        Send {Esc}
        WinActivate, Events -           ; Activate existing event editor window
        WinGet, eventWinId, ID, A       
    }
    return eventWinId
}
; ----

; -- Automation ----
clickCreateAutomation(ctxMenuLen)
{
    y := getCtxMenuRowY(ctxMenuLen, "automation")
    MouseMove, ctxMenuCheckX,  %y%, 0, R
    Click
}
; ----

; -- Link ------
clickLinkController(ctxMenuLen)
{
    y := getCtxMenuRowY(ctxMenuLen, "linkCheck")
    MouseMove, ctxMenuCheckX, %y%, 0, R
    Click
    return waitNewWindowOfClass("TMIDIInputForm", winId)
}

linkControllerChecked(ctxMenuLen)
{
    MouseGetPos, mX, mY
    x := mX + ctxMenuCheckX
    y := mY + getCtxMenuRowY(ctxMenuLen, "linkCheck")
    res := colorsMatch(x, y, ctxMenuCheckBlack)
    return res
}
; ----

; -- Clipboard ----
clickCopy(ctxMenuLen)
{
    y := getCtxMenuRowY(ctxMenuLen, "copy")
    MouseMove, ctxMenuCheckX,  %y%, 0, R
    Click
}

clickPaste(ctxMenuLen)
{
    if (pasteClickable(ctxMenuLen))
    {
        y := getCtxMenuRowY(ctxMenuLen, "pasteTMiddleY")
        MouseMove, ctxMenuCheckX,  %y%, 0, R
        Click     
        res := True
    }
    else
    {
        msg("nothing to paste")
        MouseMove, -1, 0, R
        Click
        res := False
    }
    return res
}

pasteClickable(ctxMenuLen)
{
    MouseGetPos, mX, mY
    x := mX + ctxMenuPasteTMiddleX
    y := mY + getCtxMenuRowY(ctxMenuLen, "pasteTMiddleY")
    res := colorsMatch(x, y, ctxMenuPasteTMiddleCol, ctxMenuColVar)
    return res
}
; ----