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
global ctxMenuPasteTMiddleX := 37           ; every paste entry must be the middle pixel of paste's "t"
global ctxMenuPasteTMiddleCol := [0x110000]

ctxMenuY["normal"]["editEventsCheck"] := 50
ctxMenuY["normal"]["automation"] := 147
ctxMenuY["normal"]["linkCheck"] := 187
ctxMenuY["normal"]["copy"] := 238
ctxMenuY["normal"]["paste"] := 256
ctxMenuY["normal"]["length"] := 307

ctxMenuY["time"]["editEventsCheck"] := 69
ctxMenuY["time"]["automation"] := 170
ctxMenuY["time"]["linkCheck"] := 206
ctxMenuY["time"]["copy"] := 258
ctxMenuY["time"]["paste"] := 275
ctxMenuY["time"]["length"] := 326

ctxMenuY["patcherMap"]["activateCheck"] := 34
ctxMenuY["patcherMap"]["activateColorListY"] := 30
ctxMenuY["patcherMap"]["editEventsCheck"] := 76
ctxMenuY["patcherMap"]["automation"] := 177
ctxMenuY["patcherMap"]["linkCheck"] := 213
ctxMenuY["patcherMap"]["copy"] := 265 
ctxMenuY["patcherMap"]["paste"] := 282 

ctxMenuY["patcherTime"]["activateCheck"] := 53
ctxMenuY["patcherTime"]["activateColorListY"] := 49
ctxMenuY["patcherTime"]["editEventsCheck"] := 95
ctxMenuY["patcherTime"]["automation"] := 194
ctxMenuY["patcherTime"]["linkCheck"] := 232
ctxMenuY["patcherTime"]["copy"] := 284
ctxMenuY["patcherTime"]["paste"] := 301
ctxMenuY["patcherTime"]["length"] := 352

ctxMenuY["patcherSurface"]["activateCheck"] := 41
ctxMenuY["patcherSurface"]["activateColorListY"] := 37
ctxMenuY["patcherSurface"]["editEventsCheck"] := ctxMenuY["patcherMap"]["editEventsCheck"]
ctxMenuY["patcherSurface"]["automation"] := ctxMenuY["patcherMap"]["automation"]
ctxMenuY["patcherSurface"]["linkCheck"] := ctxMenuY["patcherMap"]["linkCheck"]
ctxMenuY["patcherSurface"]["copy"] := ctxMenuY["patcherMap"]["copy"]
ctxMenuY["patcherSurface"]["paste"] := ctxMenuY["patcherMap"]["paste"]
; ----

class CtxMenu
{
; -- Main -----
    createAutomation(menuLen := "")
    {
        success := CtxMenu.__openAndClick(menuLen, "automation")
        return success
    }
    editEvents(menuLen := "")
    {
        winId := mouseGetPos(mX, mY)
        menuLen := CtxMenu.__open(menuLen)
        if (menuLen)
        {        
            checkmarkX := mX + ctxMenuCheckX
            checkmarkY := mY + CtxMenu.__getOptionY(menuLen, "editEventsCheck")
            eventWindowOpen := colorsMatch(checkmarkX, checkmarkY, ctxMenuCheckBlack)
            if (!eventWindowOpen)
            {
                quickClick(checkmarkX, checkmarkY)
                eventWinId := waitNewWindowOfClass("TEventEditForm", winId)
            }
            else
            {
                Send {Esc}
                eventWinId := bringEventEditor(False)
            }
        }
        return eventWinId  
    }
    linkToController(menuLen := "", ByRef linkChecked := "")
    {
        menuLen := CtxMenu.__open(menuLen)
        if (menuLen)
        {
            linkChecked := CtxMenu.__linkChecked(menuLen)
            WinGet, currWinId, ID, A
            CtxMenu.__click(menulen, "linkCheck")
            toolTip("waiting Link Win")
            linkWinId := waitNewWindowOfClass("TMIDIInputForm", currWinId, 0)
            toolTip()
        }
        return linkWinId
    }
    __linkChecked(menuLen)
    {
        mouseGetPos(mX, mY)
        x := mX + ctxMenuCheckX
        y := mY + CtxMenu.__getOptionY(ctxMenuLen, "linkCheck")
        res := colorsMatch(x, y, ctxMenuCheckBlack)
        return res
    }    
; --
; -- Clipboard ----
    copy(menuLen := "")
    {
        success := CtxMenu.__openAndClick(menuLen, "copy")
        return success
    }
    paste(menuLen := "")
    {
        success := False
        menuLen := CtxMenu.__open(menuLen)
        if (menuLen)
        {
            if (CtxMenu.__pasteClickable(menuLen))
                success := CtxMenu.__click(menuLen, "paste")
            else
            {
                success := False
                msg("nothing to paste")
                MouseMove, -1, 0, 0, R
                Click
            }
        }
        return success  
    }
    __pasteClickable(menuLen)
    {
        MouseGetPos, mX, mY
        x := mX + ctxMenuPasteTMiddleX
        y := mY + CtxMenu.__getOptionY(menuLen, "paste")
        res := colorsMatch(x, y, ctxMenuPasteTMiddleCol, ctxMenuColVar)
        return res
    }
; --    
; -- Utils -----
    ; Enlever des arguments ici
    ; row: currRow? currLookedRow?
    ; faire une autre version recursive?
    static dontMoveWin := False
    __open(menuLen := "", mX := "", mY := "", row := 0, patcherType := "") ;, winX, winY, winId)
    {
        CtxMenu.__makeSurePatcherLenIsNumbered(menuLen)
        if (mx == "" or mY == "")
            mouseGetPos(mX, mY)
        if (!CtxMenu.dontMoveWin)
            CtxMenu.__moveWinIfNecessary()


        Click, Right
        if (waitCtxMenuUnderMouse() and !menuLen)
        {
            saveKnobPos()
            if (row != 0)
                menuLen := CtxMenu.__searchActivates(mX, mY, row, patcherType)
            else
            {
                if (CtxMenu.__isNormalMenu(mX, mY))
                    menuLen := "normal"
                else if (CtxMenu.__isTimeMenu(mX, mY))
                    menuLen := "time"           
                else
                {
                    patcherTypes := ["patcherSurface", "patcherMap", "patcherTime"]
                    i := 1
                    while (!menuLen and i <= patcherTypes.MaxIndex())
                    {
                        patcherType := patcherTypes[i]
                        menuLen := CtxMenu.__searchActivates(mX, mY, row, patcherType)
                        i := i + 1
                    }
                } 
            }
        }
        if (!menuLen)
            msg("CtxMenu.__open(): Can't find length")
        return menuLen
    }
    __makeSurePatcherLenIsNumbered(ByRef menuLen)
    {
        if (InStr(menuLen, "patcher"))
        {
            lastChar := SubStr(menuLen, menuLen.MaxIndex())
            if lastChar is not integer
                menuLen := menuLen "1"
        }
    }
    __moveWinIfNecessary()
    {
        global Mon1Top, Mon2Top
        moveWin := False

        winId := mouseGetPos(mX, mY, "Screen")
        if (mX >= 0)
        {
            top := Mon2Top
            maxX := Mon2Right - 174
        }
        else
        {
            top := Mon1Top
            maxX := Mon1Right - 174
        }
        maxY := Mon2Height - ctxMenuY["patcherTime"]["length"] - 30 + top
        
        WinGetPos, winX, winY,,, ahk_id %winId%
        if (mY > maxY)
        {
            dist := mY - maxY
            winY := winY - dist
            moveWin := True
        }    
        if (mX > maxX)
        {
            dist := mX - maxX
            winX := winX - dist
            moveWin := True
        }
        if (moveWin)
        {
            mouseGetPos(mX, mY, "Client")
            WinMove, ahk_id %winId%,, winX, winY
            moveMouse(mX, mY, "Client")
        }
        return moveWin
    }      
    __searchActivates(mX, mY, row, patcherType)
    {
        textX := mX + ctxMenuActivateColorListX
        checkX := mX + ctxMenuCheckX

        while (ctxMenuLen == "" and row < 10)
        {
            textY := mY + ctxMenuY[patcherType]["activateColorListY"] + row * ctxMenuRowHeight
            activateFound := scanColorsLine(textX, textY, ctxMenuActivateColorList, ctxMenuColVar)
            if (activateFound)
            {
                checkY := mY + ctxMenuY[patcherType]["activateCheck"] + row * ctxMenuRowHeight
                activateChecked := colorsMatch(checkX, checkY, ctxMenuCheckBlack)
                row := row + 1
                if (!activateChecked)
                {
                    moveMouse(textX, textY)
                    Click
                    moveMouse(mX, mY)
                    ctxMenuLen := CtxMenu.__open("", mX, mY, row, patcherType)
                }
            }
            else if (row > 0)
                ctxMenuLen := patcherType "" row
            else
                break       ; no activate found for this patcherType
        }
        return ctxMenuLen
    }
    __isMenuLen(mX, mY, menuLen)
    {
        x := mX + 5
        yIn := mY + ctxMenuY[menuLen]["length"]
        yOut := mY + ctxMenuY[menuLen]["length"] + 1
        res := colorsMatch(x, yIn, ctxMenuColors, ctxMenuColVar) and colorsMatch(x, yOut, ctxMenuBorderColors, ctxMenuBorderColVar)     
        return res
    }     
    __isNormalMenu(mX, mY)
    {
        success := CtxMenu.__isMenuLen(mX, mY, "normal")    
        return success
    }
    __isTimeMenu(mX, mY)
    {
        success := CtxMenu.__isMenuLen(mX, mY, "time")
        return success
    } 
    __getOptionY(menuLen, option)
    {
        activatesOffset := 0
        if (InStr(menuLen, "patcher"))
        {
            activateQty := SubStr(menuLen, 0)
            activatesOffset := (activateQty-1) * ctxMenuRowHeight
            menuLen := SubStr(menuLen, 1, -1)
        }
        y := ctxMenuY[menuLen][option] + activatesOffset
        return y
    }   
    __click(menuLen, option)
    {
        y := CtxMenu.__getOptionY(menuLen, option)
        MouseMove, ctxMenuCheckX,  %y%, 0, R
        Click   
        success := True
        return success
    }    
    __openAndClick(menuLen, option)
    {
        success := False
        menuLen := CtxMenu.__open(menuLen)
        if (menuLen)
        {
            success := CtxMenu.__click(menuLen, option)
        }
        return success   
    }       
; -- 
}

; -- ctxMenuLen -----------------------------


;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;; Continuer de cleaner Ctx Menu
;;;;;;;;;;;;;;;;;; Pour continuer de cleaner Knob, LinkWin
;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;

/*
moveKnobWinIfNecessary(mX := "", mY := "", winId := "")
{
    global Mon1Top, Mon2Top
    movedWin := False

    if (mX == "" or mY == "" or winId == "")
        winId := mouseGetPos(mX, mY, "Client")
    WinGetPos, winX, winY,,, ahk_id %winId%

    x := mX + winX
    y := mY + winY
    if (x >= 0)
    {
        top := Mon2Top
        maxX := Mon2Right - 174
    }
    else
    {
        top := Mon1Top
        maxX := Mon1Right - 174
    }

    maxY := Mon2Height - ctxMenuY["patcherTime"]["length"] - 30 + top
    if (y > maxY)
    {
        dist := y - maxY
        winY := winY - dist
        movedWin := True
    }    
    if (x > maxX)
    {
        dist := x - maxX
        winX := winX - dist
        movedWin := True
    }
    if (movedWin)
    {
        WinMove, ahk_id %winId%,, winX, winY
        moveMouse(mX, mY, "Client")
    }
    return movedWin
}
*/
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
        eventWinId := waitNewWindowOfClass("TEventEditForm", winId)
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



; -- Record ----
recordModeEnabled(mode)
{
    prevMode := setPixelCoordMode("Screen")
    mouseGetPos(mX, mY, "Screen")
    Switch mode
    {
    Case "autom":
        res := colorsMatch(mX+ctxMenuCheckX, mY+recordCtxMenuAutomY, ctxMenuCheckBlack)
    Case "note":
        res := colorsMatch(mX+ctxMenuCheckX, mY+recordCtxMenuNoteY, ctxMenuCheckBlack)
    }
    setPixelCoordMode(prevMode)
    return res
}
; ----