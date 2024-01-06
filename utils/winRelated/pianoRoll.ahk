global PianoRollMenu1Id
global PianoRollMenu2Id
global PianoRollMenu3Id
global pianoRollMenu1Txt
pianoRollMenu1Txt =
(
            1           2           3           4                   !x1  : set col
           Rand        len         slide       add space            !x2  : sel col
shift      Gen                     blank note  crop                 ! v^ : scroll colors
alt        Arp         !len        !pitch      del                  (+!)e: mute
                                                                    ^i   : inv sel
)

class PianoRoll
{
; -- Loop -----
    static timelineCol := [0x1d2830, 0x9b5356]
    activateLoop(activate := True)
    {
        toolTip((activate? "Activating":!activate? "Deactivating":) " loop")
        PianoRoll.__activateLoopArrow()
        PianoRoll.__zoomOut()
        
        if (PianoRoll.__isDisabledLoopMarker())
        {
            PianoRoll.__enableDisabledLoopMarker()
            return
        }

        debug := False
        markerX := PianoRoll.__findLoopMarker(activate, debug)
        if (markerX)
        {
            markerY := PianoRoll.__getMarkerY()
            moveMouse(markerX+2, markerY)
            if (activate)
                PianoRoll.activateLoopMarkerUnderMouse()
            else
                PianoRoll.__deactivateLoopMarkerUnderMouse()
        }
        PianoRoll.__zoomRetrieve()
        toolTip()
        if (!activate)  
            PianoRoll.__deactivateLoopArrow()
        if (markerX == "")
            msg("Loop marker not found")
    }
    deactivateLoop()
    {
        PianoRoll.activateLoop(False)
    }
    __getMarkerY()
    {
        if (PianoRoll.__timelineIsThick())
            y := 72
        else
            y := 58
        return y
    }
    __timelineIsThick()
    {
        ; check border between note color and vertical keyboard
        x := 1
        y := 64
        col := [0x1d262b]
        return !colorsMatch(x, y, col)
    }
    __makeTimelineThick()
    {
        Loop, 2
            PianoRoll.__toggleLoopArrow()
    }
    __activateLoopArrow(activate := True)
    {
        loopActivated := colorsMatch(100, 11, [0x9BEF7D], 20)
        if (loopActivated != activate)
            PianoRoll.__toggleLoopArrow()
    }
    __deactivateLoopArrow()
    {
        PianoRoll.__activateLoopArrow(False)
    }
    __toggleLoopArrow()
    {
        quickClick(96, 10)
    }
    burnLoopButton()
    {
        Click, Right
        quickClick(152, 104)
    }
    burnLoopMarker()
    {
        Click, Right
        MouseMove, 23, 172 , 0, R
        Click
    }
    createEndMarker()
    {
        Click, R
        saveMousePos()
        Send {WheelDown}
        Click
        nameEditorId := waitNewWindowOfClass("TNameEditForm", "", 0)
        if (!nameEditorId)
            return
        typeText("end         ")
        Send {Enter}
        res := waitWindowNotOfClass("TNameEditForm", 0)
        if (!res)
            return
        retrieveMousePos()
        Click, R
        Loop, 4
        {
            Send {WheelUp}
            Sleep, 10
        }
        Click
    }
    activateLoopMarkerUnderMouse()
    {
        Click, R
        Loop, 6
        {
            Sleep, 3
            Send {WheelDown}
            Sleep, 3
        }
        Click
    }
    __deactivateLoopMarkerUnderMouse()
    {
        Click, Right
        Send {WheelDown}
        Click
    }
    __findLoopMarker(activate, debug := False)
    {
        if (debug)
        {
            colorsMatchDebug := True
            colorsMatchDebugTime := 300
        }
        ; could use getPianoRollMarkerY() ?     and other more global stuff ?
        colVar := 3
        incr := 40
        timeLineStart := 75
        x := timeLineStart
        y := 71
        timelineEnd := 1895
        w := timelineEnd - x
        reverse := True
        doneSearching := False
        while (!doneSearching and w > incr)
        {
            if (debug)
                msg("Searching loop marker...", 500)
            
            markerX := scanColorsRight(x, y, w, timelineCol, colVar, incr, reverse)
            if (markerX)    ; found a marker, check if it's a loop one by looking at its arrow
            {
                if (debug)
                    msg("found markerX", 500)
                arrowGreen := 0x4AE4A8
                arrowColVar := 50
                if (colorComparison(lastColorMatchResCol, arrowGreen, arrowColVar))
                    doneSearching := True
                else
                {
                    incr := 5
                    x := Max(markerX - 55, timeLineStart)
                    w := 55
                    arrowX := scanColorsRight(x, y, w, [arrowGreen], arrowColVar, incr, False) ; dead-> ,False, "isTimeLinePixel")
                    if (arrowX)
                        doneSearching := True
                }
            }
            if (!doneSearching)
            {
                incr := 40
                x := markerX + 56
                w := timelineEnd - x
            }
        }
        if (debug)
            colorsMatchDebug := False
        return markerX
    }
    __isDisabledLoopMarker()
    {
        return colorsMatch(76, 73, [0x3C484F])
    }
    __enableDisabledLoopMarker()
    {
        moveMouse(76, 75)
        Click, R
        Loop, 5
        {
            Send {WheelDown}
            Sleep, 10
        }
        Click
    }
; --
; -- Stamps -----
    static stampState := False
    static stampMode := "min"
    static stampRand
    toggleStampState()
    {
        PianoRoll.stampState := !PianoRoll.stampState
        if (PianoRoll.stampState)
        {
            Switch PianoRoll.stampMode
            {
            Case "min":
                PianoRoll.activateMinStamp()
            Case "maj":
                PianoRoll.activateMajStamp()
            Case  "rand":
                PianoRoll.randomizeStamp()
            }
        }
        else
            PianoRoll.deactivateStamp()
        PianoRoll.__updateGuiStampMode()
    }
    minMajStamp()
    {
        if (!PianoRoll.stampState)
            PianoRoll.stampState := True
        if (PianoRoll.stampMode == "min")
        {
            PianoRoll.stampMode := "maj"
            PianoRoll.activateMajStamp()
        }
        else
        {
            PianoRoll.stampMode := "min"
            PianoRoll.activateMinStamp()
        }
        PianoRoll.__updateGuiStampMode()
    }
    activateMajStamp()
    {
        Click, 76, 13
        Click, 116, 220
    }
    activateMinStamp()
    {
        Click, 76, 13
        Click, 126, 276
    }
    deactivateStamp()
    {
        Send {ShiftDown}n{ShiftUp}
    }
    randomizeStamp()
    {
        PianoRoll.stampState := True
        PianoRoll.stampMode := "rand"
        Click, 76, 13
        /*
        advanced := oneChanceOver(2)
        if (advanced)
        {
            MouseMove, 109, 87, 0
            MouseMove, 150, 0, 0, R
            minY := 39
            row2 := oneChanceOver(6)
            if (row2)
            {
                x := 382
                maxY := 256                
            }
            else
            {
                x := 274
                maxY := 1048
            }

            Random, y, %minY%, %maxY%
            MouseMove, %x%, %y%, 0
        }
        else
        {
            x := 112 
            minY := 105
            maxY := 1050
            while (!y or yOnSeparator)
            {
                Random, y, %minY%, %maxY%
                yOnSeparator := (343 < y and 360 < y) or (778 < y and 794 < y)
            }
            MouseMove, %x%, %y%, 0
        }
        */

        ;;;;; juste des chords normales
        x := 112
        minY := 105
        maxY := 340
        Random, y, %minY%, %maxY%
        PianoRoll.stampRand := y
        MouseMove, %x%, %y%, 0
        Sleep, 300
        Click
        PianoRoll.__updateGuiStampMode()
    }
; --
; -- Time -----
    addSpace()
    {
        if (PianoRoll.proposeTimeSel("+space", "time"))
            Send {CtrlDown}{AltDown}{Insert}{CtrlUp}{AltUp}
    }
    disableLenghts()
    {
        if (PianoRoll.proposeTimeSel("!len", "notes"))
            Send {ShiftDown}d{ShiftUp}
    }
    delTimeSel()
    {
        if (PianoRoll.proposeTimeSel("del time", "time"))
        {
            Send {CtrlDown}{Delete}{CtrlUp}
            Send {CtrlDown}d{CtrlUp}
        }
    }
    cropTimeSel()
    {
        if (PianoRoll.proposeTimeSel("crop", "time"))
        {
            quickClick(12, 13)
            Send {Down}{Down}{Right}
            quickClick(257, 479)
        }
    }
; --
; -- Note Color -----
    static scrollingColors := False
    static scrollingColorsSavedMousePos := []
    static scrollColorsPos := [37, 43]
    scrollColors(dir)
    {
        if (!PianoRoll.scrollingColors)
        {
            mouseGetPos(mX, mY)
            moveMouse(PianoRoll.scrollColorsPos[1], PianoRoll.scrollColorsPos[2])
            Click
            PianoRoll.scrollingColors := True
            PianoRoll.scrollingColorsSavedMousePos := [mX, mY]
        }
        if (dir == "up")
            Send {WheelUp}
        else if (dir == "down")
            Send {WheelDown}
    }
    stopScrollColors()
    {
        PianoRoll.scrollingColors := False
        Click
        mX := PianoRoll.scrollingColorsSavedMousePos[1]
        mY := PianoRoll.scrollingColorsSavedMousePos[2]
        moveMouse(mX, mY)
    }    
    setNoteCol(n := 1)
    {
        quickClick(PianoRoll.scrollColorsPos[1], PianoRoll.scrollColorsPos[2])
        if (n < 10)
            Send %n%
        else
        {
            Send 9
            n -= 9
            Loop %n%
            {
                Send {WheelDown}
                Sleep, 3
            }
        }
    }
    setSelectedNotesCol()
    {
        sendinput !c
    }
    selNotesOfCurrColor()
    {
        sendinput +c
    }    
; --
; -- Note Param -----
    activateParamX()
    {
        PianoRoll.__activateParam(4)
    }
    activateParamY()
    {
        PianoRoll.__activateParam(5)
    }
    activateParamVel()
    {
        PianoRoll.__activateParam(2)
    }
    __activateParam(n)
    {
        moveMouse(34, 896)
        Click
        y := 35 + (n-1) * 19
        MouseMove, 0, y, 0, R
        Click
        retrieveMouse := False
    }
    createBlankNote()
    {
        if (PianoRoll.mouseOverNotesArea())
        {
            pianoRollId := mouseGetPos(mX, mY)
            activatePencilTool()
            moveMouse(mX, mY)
            Click, 2
            notePropWinId := waitNewWindowOfClass("TPRNotePropForm", pianoRollId, 50)
            while (!notePropWinId)
            {
                res := waitToolTip("Move mouse on note and accept")
                if (!res)
                    return
                Click, 2
                toolTip("waiting Note Properties Win")
                notePropWinId := waitNewWindowOfClass("TPRNotePropForm", pianoRollId, 0)                
                toolTip()
            }

            mouseGetPos(screenMx, screenMy, "Screen")
            WinMove, ahk_id %notePropWinId%,, %screenMx%, %screenMy%

            y := 70
            knobs := {}
            knobs["pan"] := {"x": 70, "nWheel": 11}
            knobs["vel"] := {"x": 100, "nWheel": 16}
            knobs["modX"] := {"x": 175, "nWheel": 11}
            knobs["modY"] := {"x": 212, "nWheel": 11}
            knobs["pitch"] := {"x": 250, "nWheel": 20}
            speed := 3
            for _, info in knobs
            {
                moveMouse(info["x"], y)
                Loop, 22
                {
                    Send {WheelDown}
                    Sleep, %speed%
                }
                nWheel := info["nWheel"]
                Loop, %nWheel%
                {
                    Send {WheelUp}
                    Sleep, %speed%
                }
            }
            Send {Enter}        
        }
    }
    toogleNoteSlide()
    {
        if (PianoRoll.__timelineIsThick())
            y := 71
        else
            y := 55     
        quickClick(60, y)
    }    
; --
; -- Tool windows -----
    proposeTimeSel(prefix := "", mode := "time")
    {
        Switch mode
        {
        Case "time":
            txt := "sel TIME         accept / abort"
            moveMouse(400, 54)
        Case "notes":
            txt := "sel NOTES        accept / abort"
        }
        if (prefix != "")
            txt := prefix "`r`n" txt
        PianoRoll.tempMsg(txt, "", 0, 4)
        res := waitToolTip("Accept / Abort")
        return res
    }
    quantize()
    {
        if (!PianoRoll.proposeTimeSel("note lfo", "notes"))
            return      
        WinGet, currWinId, ID, A
        Send {AltDown}q{AltUp}
        qId := waitNewWindowOfClass("TPRQuantizeForm", currWinId)
        PianoRoll.moveToolWin(qId)
        moveMouse(93, 107)
        retrieveMouse := False
    }
    genNotes()
    {
        WinGet, currWinId, ID, A
        rec := recordEnabled()
        play := songPlaying()
        Send {AltDown}e{AltUp}
        genId := waitNewWindowOfClass("TPRScoreCreatorForm", currWinId)
        if (rec)
            midiRequest("toggle_rec")
        if (!play) 
            Send {Space}
        PianoRoll.moveToolWin(genId)
        moveMouseOnToggle()
        retrieveMouse := False
    }
    randNotes()
    { 
        WinGet, currWinId, ID, A
        rec := recordEnabled()
        PianoRoll.proposeTimeSel("Rand:", "time")
        Send {AltDown}r{AltUp}
        randId := waitNewWindowOfClass("TPRRandomForm", currWinId)
        txt := "1: Seed"
        PianoRoll.tempMsg(txt, "", 0, 4)
        if (rec)
            midiRequest("toggle_rec")       
        PianoRoll.moveToolWin(randId)
        MouseMove, 92, 188, 0
        retrieveMouse := False    
    }
    arp()
    { 
        WinGet, currWinId, ID, A
        rec := recordEnabled()
        PianoRoll.proposeTimeSel("Arp:", "notes")
        Send {AltDown}a{AltUp}
        arpId := waitNewWindowOfClass("TPRArpForm", currWinId)
        if (rec)
            midiRequest("toggle_rec")       
        PianoRoll.moveToolWin(arpId)
        MouseMove, 93, 107, 0
        retrieveMouse := False    
    }
    notesLen()
    {
        WinGet, currWinId, ID, A
        rec := recordEnabled()
        Send {AltDown}l{AltUp}       
        lenId := waitNewWindowOfClass("TPRLegatoForm", currWinId)
        if (rec)
            midiRequest("toggle_rec")      
        PianoRoll.moveToolWin(lenId)
        MouseMove, 84, 70, 0
        retrieveMouse := False    
    }
    mapNotes()
    {
        if (!PianoRoll.proposeTimeSel("note lfo", "notes"))
            return      
        WinGet, currWinId, ID, A
        rec := recordEnabled()
        Send {AltDown}k{AltUp}    
        mapId := waitNewWindowOfClass("TPRKeyLimitForm", currWinId)
        if (rec)
            midiRequest("toggle_rec")      
        PianoRoll.moveToolWin(mapId)
        MouseMove, 147, 68, 0
        retrieveMouse := False 
        return mapId     
    }
    dismissPitches()
    {
        mapId := PianoRoll.mapNotes()
        retrieveMouse := True      
        y := 179
        moveMouse(10, y)
        Send {LButton Down}
        moveMouse(195, y)
        Send {LButton Up}

        moveMouse(418, y)
        Send {LButton Down}
        moveMouse(195, y)
        Send {LButton Up}
        Send {Enter}

        sendinput +d  ; disable lenghts
        sendinput ^g  ; remove overlaps
    }
    strum()
    {
        if (!PianoRoll.proposeTimeSel("note lfo", "notes"))
            return       
        WinGet, currWinId, ID, A
        rec := recordEnabled()
        SendInput !s
        strumId := waitNewWindowOfClass("TPRStrumForm", currWinId)
        if (rec)
            midiRequest("toggle_rec")      
        PianoRoll.moveToolWin(strumId)
        moveMouse(78, 85)
        retrieveMouse := False     
    }
    noteTwins()
    {
        if (!PianoRoll.proposeTimeSel("note lfo", "notes"))
            return     
        WinGet, currWinId, ID, A
        rec := recordEnabled()
        SendInput !f
        twinsId := waitNewWindowOfClass("TPRFlamForm", currWinId)
        if (rec)
            midiRequest("toggle_rec")      
        PianoRoll.moveToolWin(twinsId)
        moveMouse(78, 85)
        retrieveMouse := False       
    }
    noteChop()
    {
        if (!PianoRoll.proposeTimeSel("note lfo", "notes"))
            return 
        WinGet, currWinId, ID, A
        rec := recordEnabled()
        Send {AltDown}u{AltUp}    
        chopId := waitNewWindowOfClass("TPRSliceForm", currWinId)
        if (rec)
            midiRequest("toggle_rec")      
        PianoRoll.moveToolWin(chopId)
        MouseMove, 88, 110, 0
        retrieveMouse := False       
    }
    noteFlip()
    {
        if (PianoRoll.proposeTimeSel("note lfo", "notes"))
        {       
            WinGet, currWinId, ID, A
            rec := recordEnabled()
            Send {AltDown}y{AltUp}    
            flipId := waitNewWindowOfClass("TPRFlipForm", currWinId)
            if (rec)
                midiRequest("toggle_rec")      
            PianoRoll.moveToolWin(flipId)
            MouseMove, 19, 45, 0
            retrieveMouse := False       
        }
    }
    noteScale()
    {
        if (PianoRoll.proposeTimeSel("note lfo", "notes"))
        {    
            WinGet, currWinId, ID, A
            rec := recordEnabled()
            Send {AltDown}x{AltUp}    
            scaleId := waitNewWindowOfClass("TPRLevelScaleForm", currWinId)
            if (rec)
                midiRequest("toggle_rec")      
            PianoRoll.moveToolWin(scaleId)
            quickClick(44, 249) ; Reset scaling
            MouseMove, 85, 100, 0
            retrieveMouse := False       
        }
    }
    noteParamLfo()
    {
        if (PianoRoll.proposeTimeSel("note lfo", "notes"))
        {
            WinGet, id, ID, A
            rec := recordEnabled()
            SendInput !o
            lfoId := waitNewWindowOfClass("TPRLFOForm", id)
            if (rec)
                midiRequest("toggle_rec")      
            PianoRoll.moveToolWin(lfoId)
            PianoRoll.lfoSetTime()
            retrieveMouse := False
        }
    }
    lfoSetTime()
    {
        moveMouse(74, 169)

        choices := ["1/4", "1/2", "1 beat", "2", "1 bar", "2", "4 bars", "8", "4 -----", "8 -----"]
        initIndex := randInt(1, choices.MaxIndex())
        toolTipChoice(choices, "", initIndex)
        n := toolTipChoiceIndex
        if (n == "")
            return

        Click, R
        Loop %n%
        {
            Sleep, 20
            Send {WheelDown}
        }
        Sleep, 20
        Click
    }
    moveToolWin(toolWinId)
    {
        WinMove, ahk_id %toolWinId%,, -621, 761
    }
; --
; -- Mouse Pos -----
    mouseOverNoteCol()
    {
        res := False
        winId := mouseGetPos(mX, mY, "ClientUnderMouse")
        if (PianoRoll.isWin(winId))
        {
            res := mX < 51 and mY < 76 and mY > 25
        }
        return res
    }
    mouseOverNotesArea()
    {
        winId := mouseGetPos(mX, mY, "ClientUnderMouse")
        return PianoRoll.isWin(winId) and mX > 73 and mX < 1897 and mY > 82 and mY < 811
    }    
    mouseOnLoopButton()
    {
        mouseGetPos(mX, mY, "ClientUnderMouse")
        return mX < 108 and mY < 22 and mY > 1 and mX > 87
    }  
    mouseOnTimeline(mX := "", mY := "")
    {
        if (mX == "" or mY == "")
            winId := mouseGetPos(mX, mY, "ClientUnderMouse")
        return PianoRoll.isWin(winId) and mY < PianoRoll.__getMarkerY()+10 and mY > 65 and mX > 71 and mX < 1897
    }  
    mouseOnMarker()
    {
        success := False
        winId := mouseGetPos(mX, mY, "ClientUnderMouse")
        if PianoRoll.isWin(winId)
        {
            WinActivate, ahk_id %winId%
            success := PianoRoll.mouseOnTimeline(mX, mY) and !colorsMatch(mX, mY, PianoRoll.timelineCol, 30)
        }
        return success
    }        
    mouseOverChannChoice()
    {
        success := False
        winId := mouseGetPos(mX, mY, "ClientUnderMouse")
        if (PianoRoll.isWin(winId))
        {
            success := mX > 414 and mX < 533 and mY < 20
        }
        return success
    }
    moveMouseToChannChoice()
    {
        moveMouse(415, 10)
    }
; --
; -- Window -----
    static winId := ""
    isWin(winId := "", debug := False)
    {
        success := False
        if (winId == "")
            WinGet, winId, ID, A
        WinGetClass, class, ahk_id %winId%
        if (class == "TEventEditForm")
        {
            WinGetTitle, title, ahk_id %winId%
            success := InStr(title, "Piano roll") and winExists(winId)
        }
        ;success := success or winId == PianoRollMenu1Id or winId == PianoRollMenu2Id
        ;; We don't want PianoRollMenu1Id as PianoRoll.winId
        ;; PianoRollMenu1Id should not be activated anyway...
        if (success)
            PianoRoll.winId := winId
        return success
    }

    bringWin(prepare := True, moveMouse := True, winId := "")
    {
        debugOn := True
        if (winId == "")
            winId := PianoRoll.__forceGetWinId()

        PianoRoll.moveWin(winId)
        if (prepare)
        {
            PianoRoll.bringCurrChan()
            WinActivate, ahk_id %winId%
            PianoRoll.setMenu3Mode()
        }
        WinActivate, ahk_id %winId%
        if (moveMouse)
            centerMouse(winId)   
        debugOn := False
        return winId     
    }
    __forceGetWinId()
    {
        winId := PianoRoll.winId
        if (!PianoRoll.isWin(winId))
            winId := PianoRoll.__getExistingWin()
        if (!PianoRoll.isWin(winId))
            winId := PianoRoll.__bringWinWithKey()
        if (!PianoRoll.isWin(winId))
            return ""
        else
            return winId
    }
    __getExistingWin()
    {
        WinGet, winId, ID, ahk_class TEventEditForm, Piano roll
        return winId
    }
    __bringWinWithKey()
    {
        WinGet, currId, ID, A
        Send {F7}
        pianoRollId := waitNewWindowTitled("Piano roll", currId)
        return pianoRollId
    }
    moveWin(winId := "")
    {
        if (winId == "")
            winId := PianoRoll.winId
        if (!PianoRoll.isWin(winId))
            winId := PianoRoll.__getExistingWin()
        if (!PianoRoll.isWin(winId))
            return
        WinActivate, ahk_id %winId%
        WinMove, ahk_id %winId%,, %Mon1Left%, %Mon1Top%, %Mon1Width%, %Mon1Height%
        WinMaximize, ahk_id %winId%
    }    
    winOpen()
    {
        success := winExists(PianoRoll.winId)
        return success
    }
; -- 
; -- Util -----
    static magnet := True
    toggleMagnet()
    {
        if (PianoRoll.magnet)
            PianoRoll.__setMagnet(False)
        else
            PianoRoll.__setMagnet(True)
    }
    disableMagnet()
    {
        PianoRoll.__setMagnet(False)
    }
    enableMagnet()
    {
        PianoRoll.__setMagnet(True)
    }    
    __setMagnet(enable)
    {
        quickClick(53, 12)
        moveMouse(57, 31)
        if (enable)
        {
            n := 2
            PianoRoll.magnet := True
            txt := "On"
        }
        else
        {
            n := 3
            PianoRoll.magnet := False
            txt := "Off"
        }
        tempMsg("Magnet " txt)
        Loop %n%
        {
            Send {WheelDown}
            Sleep, 4
        }        
        Click
        PianoRoll.__updateGuiMagnet()
    }

    focusNotes()
    {
        moveMouse(767, 356)
        SendInput ^{Wheelup}
        SendInput ^{RButton}
    }

    static sepY := 885
    adjustSep(pianoRollId := "")
    {
        stopGuiClock()
        Gui, PianoRollMenu1:Hide
        if (!pianoRollId)
            pianoRollId := PianoRoll.bringWin(False, False)
        else
            WinActivate, ahk_id %pianoRollId%
        
        x:= 400
        currSepY := PianoRoll.__locateSep(x)
        if (currSepY and currSepY != PianoRoll.sepY)
        {
            moveMouse(x, currSepY)
            Click, down
            moveMouse(x, PianoRoll.sepY)
            Click, up
        }
        Gui, PianoRollMenu1:Show
        startGuiClock()
    }
    __locateSep(x)
    {
        cols := [0x3F484D]
        colVar := 0
        if (!colorsMatch(x, PianoRoll.sepY, cols, colVar))
        {
            startY := 1070
            h := 1020
            incr := -6
            toolTip("searching separator")
            y := scanColorsDown(x, startY, h, cols, colVar, incr)
            toolTip()
            if (!y)
                msgTip("fail")
        }
        else
            msgTip("Piano roll separator is fine.")
        return y
    }
    __zoomOut()
    {
        moveMouse(75, 88)
        Send {Ctrl Down}{RButton Down}
        moveMouse(1890, 811)    
        Send {RButton Up}{Ctrl Up}
        moveMouse(426, 105)
        Send {CtrlDown}{Rbutton}{CtrlUp} 
        Sleep, 40
    }
    __zoomRetrieve()
    {
        moveMouse(426, 105)
        Send {CtrlDown}{Rbutton}{CtrlUp} 
    }    
    tempMsg(txt := "", ttIndex := "", yOffs := 0, sec := 1)
    {
        if (ttIndex == "")
            ttIndex := toolTipIndex["PianoRollTempMsg"]
        if (PianoRoll.isWin())
        {
            prevMode := setToolTipCoordMode("Client")
            tempMsg(txt, sec*1000, 74, 47+yOffs, ttIndex)
            setToolTipCoordMode(prevMode)
        }
    }
    goToOctave(n)
    {
        if (n > 8 or n < 0)
            return
        if (!PianoRoll.__timelineIsThick()) 
            PianoRoll.__makeTimelineThick()
        PianoRoll.__normalizeZoom()
        quickClick(1906, 70)    ; scroll top
        moveMouse(707, 152)
        n := 1 + (8-n) * 4
        Loop, %n%               ; scroll octave
        {
            Send {WheelDown}
            Sleep, 10
        }
    }
    static normalizedNoteHeight := 22
    __normalizeZoom()
    {
        moveMouse(1909, 34)
        Click, Down
        MouseMove, 0, 200 , 0, R
        Click, Up
        Sleep, 100
        Loop, 8
        {
            Send {WheelUp}
            Sleep, 10
        }
    }
; --
; -- Channels -----
    static __chanMenuPos := [420, 11]
    activateChan(chan)
    {
        waitKey("LButton")
        res := PianoRoll.__openChanMenu()
        if (!res)
            return
        n := PianoRoll.__chans[chan]
        Loop %n%
        {
            Send {Down}
            Sleep, 1
        }
        Send {Enter}
    }
    __openChanMenu()
    {
        x := PianoRoll.__chanMenuPos[1]
        y := PianoRoll.__chanMenuPos[2]
        quickClick(x, y)
        return waitToolTip("Move to first ""chans"" instr")
    } 
    bringCurrChan()
    {
        mX := PianoRoll.__chanMenuPos[1]
        mY := PianoRoll.__chanMenuPos[2]
        moveMouse(mX, mY)
        Click, R
        pluginId := waitNewWindowOfClass("TPluginForm", PianoRoll.winId, 0)
        if (pluginId)
        {
            winX := 242
            winY := 168
            WinMove, ahk_id %pluginId%,, %winX%, %winY%
            winHistoryTick()
        }
        return pluginId
    }
; --
; -- Gui -----
    static menusShown := False
    makeMenus()
    {
        PianoRoll.__makeMenu1()
        PianoRoll.__makeMenu2()
        PianoRoll.__makeMenu3()
    }
    showMenus()
    {
        PianoRoll.menusShown := True
        Gui, PianoRollMenu1:Show, NoActivate
        Gui, PianoRollMenu2:Show, NoActivate
        Gui, PianoRollMenu3:Show, NoActivate
    }
    hideMenus()
    {
        Gui, PianoRollMenu1:Hide
        Gui, PianoRollMenu2:Hide
        Gui, PianoRollMenu3:Hide
        PianoRoll.menusShown := False
    }       
    __makeMenu1()
    {
        Gui, PianoRollMenu1:New
        Gui, PianoRollMenu1:+AlwaysOnTop +LastFound +ToolWindow +HwndPianoRollMenu1Id -Caption +E0x08000000
        Gui, PianoRollMenu1:Font, s9 c%windowMenuFontColor%, %mainFont%
        Gui, PianoRollMenu1:Color, %windowMenuColor%
        Gui, PianoRollMenu1:Show, x-1846 y1380 w1826 h73 NoActivate, PianoRollMenu1
        Gui, PianoRollMenu1:Hide
        Gui, PianoRollMenu1:Add, Text, x5 y5 w50 h50 vGuiStampMode gTOGGLE_STAMP_STATE
        incr := 92/2
        x := 90
        Gui, PianoRollMenu1:Add, Text, x%x% y5 w%incr% h50 gPIANOROLL_QUANTIZE, quantize
        x := x + incr*2
        Gui, PianoRollMenu1:Add, Text, x%x% y5 w%incr% h50 gPIANOROLL_MAP, map
        x := x + incr*2
        Gui, PianoRollMenu1:Add, Text, x%x% y5 w%incr% h50 gPIANOROLL_STRUM, |/ chords
        x := x + incr*2
        Gui, PianoRollMenu1:Add, Text, x%x% y5 w%incr% h50 gPIANOROLL_TWINS, twins 
        x := x + incr*2
        Gui, PianoRollMenu1:Add, Text, x%x% y5 w%incr% h50 gPIANOROLL_CHOP, chop
        x := x + incr*2
        Gui, PianoRollMenu1:Add, Text, x%x% y5 w%incr% h50 gPIANOROLL_FLIP, flip
        x := x + incr*2
        Gui, PianoRollMenu1:Add, Text, x%x% y5 w%incr% h50, 
        x := x + incr*2
        Gui, PianoRollMenu1:Add, Text, x%x% y5, %pianoRollMenu1Txt%
        return

        TOGGLE_STAMP_STATE:
        freezeExecute("PianoRoll.toggleStampState")
        return

        PIANOROLL_QUANTIZE:
        freezeExecute("PianoRoll.quantize")
        return

        PIANOROLL_MAP:
        freezeExecute("PianoRoll.mapNotes")
        return

        PIANOROLL_STRUM:
        freezeExecute("PianoRoll.strum")
        return

        PIANOROLL_TWINS:
        freezeExecute("PianoRoll.noteTwins")
        return   

        PIANOROLL_CHOP:
        freezeExecute("PianoRoll.noteChop")
        return  

        PIANOROLL_FLIP:
        freezeExecute("PianoRoll.noteFlip")
        return  
    }
    __makeMenu2()
    {
        Gui, PianoRollMenu2:New
        Gui, PianoRollMenu2:+AlwaysOnTop +LastFound +ToolWindow +HwndPianoRollMenu2Id -Caption +E0x08000000
        Gui, PianoRollMenu2:Font, s9 c%windowMenuFontColor%, %mainFont%
        Gui, PianoRollMenu2:Color, %windowMenuColor%
        Gui, PianoRollMenu2:Show, x-1919 y1490 w69 h161 NoActivate, PianoRollMenu2
        Gui, PianoRollMenu2:Hide
        x := 20
        y := 10
        Gui, PianoRollMenu2:Add, Text, x%x% y%y% gPIANOROLL_SCALE, scale 
        Gui, PianoRollMenu2:Add, Text, x%x% y+10 gPIANOROLL_LFO, lfo
        static ADJUST_PIANOROLL_SEP
        global ADJUST_PIANOROLL_SEP_TT := "Adjusts pianoroll separator so flahk clicks at the right places."
        Gui, PianoRollMenu2:Add, Button, x%x% y+10 w35 h15 vADJUST_PIANOROLL_SEP gADJUST_PIANOROLL_SEP, sep
        PianoRoll.__updateGuiStampMode()
        return

        PIANOROLL_SCALE:
        freezeExecute("PianoRoll.noteScale")
        return

        PIANOROLL_LFO:
        freezeExecute("PianoRoll.noteParamLfo")
        return

        ADJUST_PIANOROLL_SEP:
        freezeExecute("PianoRoll.adjustSep")
        return
    }
    __makeMenu3()
    {
        PianoRoll.__makeMenu3Base()

        PianoRoll.__makeMenu3PY()
        PianoRoll.__makeMenu3PYfeedback()
        PianoRoll.__makeMenu3PYsettings()

        PianoRoll.__makeMenu3Mod()
        PianoRoll.__makeMenu3ModSettings()
        PianoRoll.__makeMenu3ModSpeeds()

        PianoRoll.__makeMenu3m_()
        PianoRoll.__makeMenu3mArp()
        PianoRoll.__makeMenu3arp()
        PianoRoll.__makeMenu3Gross()
        PianoRoll.__makeMenu3EnvFx()

        PianoROll.__setMenu3Mode(mode := "")
    }
    ; -- Menu 3 Controls
    static __menu3baseControls := []
    __makeMenu3Base()
    {
        Gui, PianoRollMenu3:New
        Gui, PianoRollMenu3:+AlwaysOnTop +LastFound +ToolWindow +HwndPianoRollMenu3Id -Caption +E0x08000000
        Gui, PianoRollMenu3:Font, s9 c%windowMenuFontColor%, %mainFont%
        Gui, PianoRollMenu3:Color, %windowMenuColor%
        winX := Mon1Left+1746
        winY := Mon1Top+82
        winW := 154
        winH := 730
        Gui, PianoRollMenu3:Show, x%winX% y%winY% w%winW% h%winH% NoActivate, PianoRollMenu3
        Gui, PianoRollMenu3:Hide  

        global GuiPianoRollMagnet
        Gui, PianoRollMenu3:Add, Text, x5 y10 vGuiPianoRollMagnet gPIANOROLL_MAGNET, 🧲 Snap
        global GuiPianoRollRefreshChan
        Gui, PianoRollMenu3:Add, Text, x+20 vGuiPianoRollRefreshChan gPIANOROLL_REFRESH_CURR_CHAN, ⟳ bring
        PianoRoll.__menu3baseControls := ["GuiPianoRollMagnet", "GuiPianoRollRefreshChan"]
        return

        PIANOROLL_MAGNET:
        waitKey("LButton")
        freezeExecute("PianoRoll.toggleMagnet")
        return

        PIANOROLL_REFRESH_CURR_CHAN:
        waitKey("LButton")
        freezeExecute("PianoRoll.bringWin", [True, True])
        return
    }
    static __menu3PYcontrols := []
    __makeMenu3PY()
    {
        x := 5
        y := 30
        global GuiPyTitle
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiPyTitle, -- PY -----
        global GuiPyActivateSettings
        Gui, PianoRollMenu3:Add, Text, x%x% y+5 vGuiPyActivateSettings gPY_ACTIVATE_SETTINGS, Settings
        global GuiPyActivate10
        Gui, PianoRollMenu3:Add, Text, x+5 vGuiPyActivate10 gPY_ACTIVATE_10, 10
        global GuiPyActivate11
        Gui, PianoRollMenu3:Add, Text, x+5 vGuiPyActivate11 gPY_ACTIVATE_11, 11
        global GuiPyActivate12
        Gui, PianoRollMenu3:Add, Text, x+5 vGuiPyActivate12 gPY_ACTIVATE_12, 12

        y := 600
        yIncr := 15
        global GuiPianoRollTonic
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% w70 vGuiPianoRollTonic, Tonic:
        y += yIncr
        global GuiPianoRollChord
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% w70 vGuiPianoRollChord, Chord:
        y += yIncr
        global GuiPianoRollChordLen
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% w100 vGuiPianoRollChordLen, Len:
        y += yIncr
        global GuiPianoRollScale
        Gui, PianoRollMenu3:Add, Text, x%x% y+10 w200 vGuiPianoRollScale, Scale:
        y += yIncr
        global GuiTick
        Gui, PianoRollMenu3:Add, Text, x%x% y+10 w200 vGuiTick, Tick: 
        y += yIncr
        global GuiNumberedTick
        Gui, PianoRollMenu3:Add, Text, x%x% y+10 w200 vGuiNumberedTick,        

        PianoRoll.__menu3PYcontrols := ["GuiPyTitle", "GuiPyActivateSettings", "GuiPyActivate10", "GuiPyActivate11", "GuiPyActivate12"]
        PianoRoll.__menu3PYcontrols.Push("GuiPianoRollTonic", "GuiPianoRollChord", "GuiPianoRollChordLen")
        PianoRoll.__menu3PYcontrols.Push("GuiPianoRollScale", "GuiTick", "GuiNumberedTick")      
        return

        PY_ACTIVATE_SETTINGS:
        waitKey("LButton")
        StepSeq.bringKnownChannel("PY settings", True)
        return
        PY_ACTIVATE_10:
        waitKey("LButton")
        StepSeq.bringKnownChannel("PY 10", True)
        return
        PY_ACTIVATE_11:
        waitKey("LButton")
        StepSeq.bringKnownChannel("PY 11", True)
        return
        PY_ACTIVATE_12:
        waitKey("LButton")
        StepSeq.bringKnownChannel("PY 12", True)
        return
    }
    static __menu3PYsettingsControls := []
    __makeMenu3PYsettings()
    {
        noteHeight := PianoRoll.normalizedNoteHeight
        x := 5
        y := 400
        global GuiPYC1
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiPYC1,  map in 10     --C1
        y -= noteHeight
        global GuiPYCS1
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiPYCS1, map out, bis ^     
        y -= noteHeight*2

        global GuiPYC2
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiPYC2,  Modes ^       --C2
        y -= noteHeight*2

        global GuiPYC3
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiPYC3,  Chords ^      --C3

        PianoRoll.__menu3PYsettingsControls := ["GuiPYC1", "GuiPYCS1", "GuiPYC2", "GuiPYC3"]
        return
    }
    static __menu3PYfeedbackControls := []
    __makeMenu3PYfeedback()
    {
        x := 5
        y := 100
        global GuititlePY10
        Gui, PianoRollMenu3:Add, Text, x%x% y+10 vGuititlePY10, _10_
        global GuiWrapping10
        Gui, PianoRollMenu3:Add, Text, y+10 vGuiWrapping10, Wrapping
        global GuiWrappingBase10
        Gui, PianoRollMenu3:Add, Text, y+10 w200 vGuiWrappingBase10, 
        global GuiWrappingInterval10
        Gui, PianoRollMenu3:Add, Text, y+10 w200 h100 vGuiWrappingInterval10, 

        global GuititlePY11
        Gui, PianoRollMenu3:Add, Text, x%x% y+10 vGuititlePY11, _11_
        global GuiWrapping11
        Gui, PianoRollMenu3:Add, Text, y+10 vGuiWrapping11, Wrapping
        global GuiWrappingBase11
        Gui, PianoRollMenu3:Add, Text, y+10 w200 vGuiWrappingBase11, 
        global GuiWrappingInterval11
        Gui, PianoRollMenu3:Add, Text, y+10 w200 h50 vGuiWrappingInterval11,         

        global GuititlePY12
        Gui, PianoRollMenu3:Add, Text, x%x% y+10 vGuititlePY12, _12_
        global GuiWrapping12
        Gui, PianoRollMenu3:Add, Text, y+10 vGuiWrapping12, Wrapping
        global GuiWrappingBase12
        Gui, PianoRollMenu3:Add, Text, y+10 w200 vGuiWrappingBase12, 
        global GuiWrappingInterval12
        Gui, PianoRollMenu3:Add, Text, y+10 w200 h50 vGuiWrappingInterval12,  

        PianoRoll.__menu3PYfeedbackControls := []
        for _, num in [10, 11, 12]
        {
            PianoRoll.__menu3PYfeedbackControls.Push("GuititlePY" num, "GuiWrapping" num)
            PianoRoll.__menu3PYfeedbackControls.Push("GuiWrappingBaseOctave" num, "GuiWrappingInterval" num)
        }          
        return
    }
    static __menu3ModControls := []
    __makeMenu3Mod()
    {
        x := 5
        y := 30
        global GuiModTitle
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModTitle, -- 11-16 MOD -----
        global GuiModActivateSettings
        Gui, PianoRollMenu3:Add, Text, x%x% y+5 vGuiModActivateSettings gMOD_ACTIVATE_SETTINGS, Settings
        global GuiModActivateSpeeds
        Gui, PianoRollMenu3:Add, Text, x+5 vGuiModActivateSpeeds gMOD_ACTIVATE_SPEEDS, Speeds
        PianoRoll.__menu3ModControls := ["GuiModTitle", "GuiModActivateSettings", "GuiModActivateSpeeds"]
        return 

        MOD_ACTIVATE_SETTINGS:
        waitKey("LButton")
        freezeExecute("PianoRoll.__setMenu3Mode", ["MOD settings"])
        return

        MOD_ACTIVATE_SPEEDS:
        waitKey("LButton")
        freezeExecute("PianoRoll.__setMenu3Mode", ["MOD speeds"])
        return
    }
    static __menu3ModSpeedControls := []
    __makeMenu3ModSpeeds()
    {
        noteHeight := PianoRoll.normalizedNoteHeight
        x := 5
        y := 708
        global GuiModC4
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModC4 gMOD_SPEEDS_SET_OCTAVE, 4 b4rs _ _ _ _  C4
        y -= noteHeight
        global GuiModCS4
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModCS4, 3
        y -= noteHeight
        global GuiModD4
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModD4, 2
        y -= noteHeight
        global GuiModDS4
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModDS4, 1.5
        y -= noteHeight*2
        global GuiModE4
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModE4, 4 bars ----
        y -= noteHeight
        global GuiModFS4
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModFS4, 3
        y -= noteHeight
        global GuiModG4
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModG4, 2
        y -= noteHeight
        global GuiModGS4
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModGS4, 1.5
        
        y -= noteHeight*4
        global GuiModC5
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModC5 gMOD_SPEEDS_SET_OCTAVE, 4 beats - - - - C5
        y -= noteHeight
        global GuiModCS5
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModCS5, 3
        y -= noteHeight
        global GuiModD5
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModD5, 2
        y -= noteHeight
        global GuiModDS5
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModDS5, 1.5
        y -= noteHeight*2
        global GuiModE5
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModE5, 1 beat   -
        y -= noteHeight
        global GuiModFS5
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModFS5, 3/4
        y -= noteHeight
        global GuiModG5
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModG5, 1/2
        y -= noteHeight
        global GuiModGS5
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModGS5, 1/3
        
        y -= noteHeight*4
        global GuiModC6
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModC6 gMOD_SPEEDS_SET_OCTAVE, 1/4  .  .  .  . C6
        y -= noteHeight
        global GuiModCS6
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModCS6, 1/6
        y -= noteHeight
        global GuiModD6
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModD6, 1/8
        y -= noteHeight
        global GuiModDS6
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModDS6, 1/12
        y -= noteHeight
        global GuiModE6
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModE6, 1/16           

        PianoRoll.__menu3ModSpeedControls := []
        for _, octave in [4, 5, 6]
        {
            notes := ["C", "CS", "D", "DS", "E", "FS", "G", "GS"]
            if octave == 6:
                notes := slice(notes, 1, 5)
            for _, note in notes
                PianoRoll.__menu3ModSpeedControls.Push("GuiMod" note "" octave)
        }
        return

        MOD_SPEEDS_SET_OCTAVE:
        waitKey("LButton")
        freezeExecute("PianoRoll.goToOctave", [4])
        return        
    }
    static __menu3ModSettingsControls := []
    __makeMenu3ModSettings()
    {
        noteHeight := PianoRoll.normalizedNoteHeight
        x := 5
        y := 708
        global GuiModC7
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModC7 gMOD_SETTINGS_SET_OCTAVE, offset        --C7
        y -= noteHeight
        global GuiModCS7
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModCS7, A      
        y -= noteHeight
        global GuiModD7
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModD7, pw      
        y -= noteHeight
        global GuiModEb7
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModEb7, skew    
        y -= noteHeight
        global GuiModE7
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModE7, tens    
        y -= noteHeight
        global GuiModF7
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModF7, val    
        y -= noteHeight
        global GuiModFS7
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModFS7, val+-                        
        y -= noteHeight
        global GuiModG7
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModG7, feedback
        y -= noteHeight
        y -= noteHeight
        global GuiModA7
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModA7, paser (v: out vol)
        y -= noteHeight
        global GuiModBb7
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModBb7, delay (v: out vol)        
        y -= noteHeight
        global GuiModB7
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModB7, pitch (v: out vol)
        y -= noteHeight
        global GuiModC8
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiModC8 gMOD_SETTINGS_SET_OCTAVE, D while W     --C8

        PianoRoll.__menu3ModSettingsControls := []
        for _, note in ["C8", "B7", "Bb7", "A7", "G7", "FS7", "F7", "E7", "Eb7", "D7", "CS7", "C7"]
            PianoRoll.__menu3ModSettingsControls.Push("GuiMod" note)        
        return

        MOD_SETTINGS_SET_OCTAVE:
        waitKey("LButton")
        freezeExecute("PianoRoll.goToOctave", [7])
        return          
    }
    static __menu3m_Controls := []
    __makeMenu3m_()
    {
        noteHeight := PianoRoll.normalizedNoteHeight
        x := 5
        y := 30
        global Guim_Title
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuim_Title, -- Mute masters ----

        y := 708
        y -= noteHeight*11      
        global Guim_B4
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuim_B4, no bass
        y -= noteHeight
        global Guim_C4
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuim_C4 g3m_SET_OCTAVE, m1            --C4
        y -= noteHeight*2
        global Guim_D4
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuim_D4, m2
        y -= noteHeight*2
        global Guim_E4
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuim_E4, m3
        y -= noteHeight
        global Guim_F4
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuim_F4, bass
        PianoRoll.__menu3m_Controls := ["Guim_Title", "Guim_B4","Guim_C4","Guim_D4","Guim_E4","Guim_F4"]
        return

        3m_SET_OCTAVE:
        waitKey("LButton")
        freezeExecute("PianoRoll.goToOctave", [4])
        return
    }
    static __menu3mArpControls := []
    __makeMenu3mArp()
    {
        noteHeight := PianoRoll.normalizedNoteHeight
        x := 5
        y := 30     
        global GuimArpTitle
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuimArpTitle, -- m Arp ----
        x += 10
        global GuimArpBringArp
        Gui, PianoRollMenu3:Add, Text, x%x% y+5 vGuimArpBringArp g3mARP_BRING_ARP, -> Arp
        x := 5
        y := 708
        y -= noteHeight*7   
        global GuimArpG3
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuimArpG3 g3mARP_SET_OCTAVE, Arp          --G3
        y -= noteHeight
        global GuimArpGS3
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuimArpGS3, arp none
        y -= noteHeight
        global GuimArpA3
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuimArpA3, n echoes
        y -= noteHeight
        global GuimArpBb3
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuimArpBb3, pitch
        y -= noteHeight
        global GuimArpB3
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuimArpB3, feedback
        y -= noteHeight
        global GuimArpC4
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuimArpC4 g3mARP_SET_OCTAVE, Time         --C4
        y -= noteHeight*11
        global GuimArpB4
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuimArpB4 g3mARP_SET_OCTAVE, max time     --B4

        PianoRoll.__menu3mArpControls := ["GuimArpTitle", "GuimArpBringArp", "GuimArpG3", "GuimArpGS3", "GuimArpA3", "GuimArpBb3", "GuimArpB3", "GuimArpC4", "GuimArpB4"]
        return

        3mARP_SET_OCTAVE:
        waitKey("LButton")
        freezeExecute("PianoRoll.goToOctave", [3])
        return

        3mARP_BRING_ARP:
        waitKey("LButton")
        freezeExecute("PianoRoll.__3mArpBringCorrespondingArp", ["up"])
        return
    }
    __3mArpBringCorrespondingArp(dir)
    {
        PianoRoll.moveMouseToChannChoice()
        Click
        Send {Wheel%dir%}
        Click
        PianoRoll.bringWin()
    }
    static __menu3arpControls := []
    __makeMenu3arp()
    {
        x := 5
        y := 30     
        global GuiArpTitle
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiArpTitle, -- Arp ----
        x += 10
        global GuiArpBringmArp
        Gui, PianoRollMenu3:Add, Text, x%x% y+5 vGuiArpBringmArp g3ARP_BRING_mARP, -> m Arp
        PianoRoll.__menu3arpControls := ["GuiArpTitle", "GuiArpBringmArp"]
        return

        3ARP_BRING_mARP:
        waitKey("LButton")
        freezeExecute("PianoRoll.__3mArpBringCorrespondingArp", ["down"])
        return
    }
    static __menu3GrossControls := []
    __makeMenu3Gross()
    {
        noteHeight := PianoRoll.normalizedNoteHeight
        x := 5
        y := 30     
        global GuiGrossTitle
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiGrossTitle, -- 21-26 3xGross ----  
        y := 708
        global GuiGrossC4
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiGrossC4 g3GROSS_SET_OCTAVE, 1            --C4
        y -= noteHeight*2
        global GuiGrossD4
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiGrossD4, 2
        y -= noteHeight*2
        global GuiGrossE4
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiGrossE4, 3
        y -= noteHeight
        global GuiGrossF4
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiGrossF4, D while W
        PianoRoll.__menu3GrossControls := ["GuiGrossTitle", "GuiGrossC4", "GuiGrossD4", "GuiGrossE4", "GuiGrossF4"]
        return

        3GROSS_SET_OCTAVE:
        waitKey("LButton")
        freezeExecute("PianoRoll.goToOctave", [4])
        return        
    }
    static __menu3EnvFxControls := []
    __makeMenu3EnvFx()
    {
        noteHeight := PianoRoll.normalizedNoteHeight
        x := 5
        y := 30     
        global GuiEnvFxTitle
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiEnvFxTitle, -- 31-36 3xEnvFx ----`r`nVel: amount`r`nNote: attack speed
        y := 708
        global GuiEnvFxC4
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiEnvFxC4 g3EnvFx_SET_OCTAVE, Pitch env ^  --C4
        y -= noteHeight*12
        global GuiEnvFxC5
        Gui, PianoRollMenu3:Add, Text, x%x% y%y% vGuiEnvFxC5 g3EnvFx_SET_OCTAVE, Rev ^        --C5
        PianoRoll.__menu3EnvFxControls := ["GuiEnvFxTitle", "GuiEnvFxC4", "GuiEnvFxC5"]
        return

        3ENVFX_SET_OCTAVE:
        waitKey("LButton")
        freezeExecute("PianoRoll.goToOctave", [4])
        return      
    }
    setMenu3Mode()
    {
        static winControls := {}
        winControls["PY settings"] := "PY settings"
        winControls["PY metronome"] := "PY settings"
        winControls["PY 10"] := "PY feedback"
        winControls["PY 11"] := "PY feedback"
        winControls["PY 12"] := "PY feedback"
        winControls["11-16 MOD"] := "MOD settings"
        winControls["m_"] := "m_"
        winControls["m "] := "m "
        winControls["arp"] := "arp"
        winControls["3xGross"] := "Gross"
        winControls["EnvFx"] := "EnvFx"

        mode := ""
        lastPluginTitle := getLastPluginTitle()
        for key, tempMode in winControls
            if (InStr(lastPluginTitle, key))
            {
                mode := tempMode
                break
            }
        PianoRoll.__setMenu3Mode(mode)
    }
    __setMenu3Mode(mode := "")
    {
        PianoRoll.showMenus()
        PianoRoll.__hideMenu3Controls()
        PianoRoll.__showMenu3Controls(PianoRoll.__menu3baseControls)
        if (InStr(mode, "PY"))
        {
            PianoRoll.__showMenu3Controls(PianoRoll.__menu3PYcontrols)
            Switch mode
            {
            Case "PY feedback":
                PianoRoll.__showMenu3Controls(PianoRoll.__menu3PYfeedbackControls)
                PianoRoll.goToOctave(4)
            Case "PY settings":
                PianoRoll.__showMenu3Controls(PianoRoll.__menu3PYsettingsControls)
                PianoRoll.goToOctave(1)
            }
        }
        else if (InStr(mode, "MOD"))
        {
            PianoRoll.__showMenu3Controls(PianoRoll.__menu3ModControls)
            Switch mode
            {
            Case "MOD settings":
                PianoRoll.__showMenu3Controls(PianoRoll.__menu3ModSettingsControls)
                PianoRoll.goToOctave(7)
            Case "MOD speeds":
                PianoRoll.__showMenu3Controls(PianoRoll.__menu3ModSpeedControls)
                PianoRoll.goToOctave(4)
            }
        }
        else if (mode == "m_")
        {
            PianoRoll.__showMenu3Controls(PianoRoll.__menu3m_Controls)
            PianoRoll.goToOctave(3)
        }
        else if (mode == "m ")
        {
            PianoRoll.__showMenu3Controls(PianoRoll.__menu3mArpControls)
            PianoRoll.goToOctave(3)
        }
        else if (mode == "arp")
        {
            PianoRoll.__showMenu3Controls(PianoRoll.__menu3arpControls)
            PianoRoll.goToOctave(4)
        }
        else if (mode == "Gross")
        {
            PianoRoll.__showMenu3Controls(PianoRoll.__menu3GrossControls)
            PianoRoll.goToOctave(4)
        }
        else if (mode == "EnvFx")
        {
            PianoRoll.__showMenu3Controls(PianoRoll.__menu3EnvFxControls)
            PianoRoll.goToOctave(4)
        }        
    }
    __showMenu3Controls(controls)
    {
        for _, c in controls
            GuiControl, PianoRollMenu3:Show, %c%
    }
    __hideMenu3Controls()
    {
        WinGet, controlsList, ControlList, ahk_id %PianoRollMenu3Id%
        Loop, Parse, controlsList, `n
            GuiControl, PianoRollMenu3:Hide, %A_LoopField%
    }
    ; --
    ; -- Update -----
    __updateGuiStampMode()
    {
        if (!PianoRoll.stampState)
        {
            stamp := "___"
            col := windowMenuFontColor2
        }
        else
        {
            stamp := PianoRoll.stampMode
            if (PianoRoll.stampMode == "rand")
                stamp := stamp "" PianoRoll.stampRand
            col := windowMenuFontColor
        }
        Gui, PianoRollMenu1:Font, c%col%
        GuiControl, PianoRollMenu1:, GuiStampMode, Stamp`r`n(r,m)`r`n%stamp%
    }      
    __updateGuiMagnet()
    {
        if (PianoRoll.magnet)
            Gui, PianoRollMenu3:Font, c%windowMenuFontColor%
        else
            Gui, PianoRollMenu3:Font, c%windowMenuFontColor2%
        GuiControl, PianoRollMenu3:Font, GuiPianoRollMagnet
    }
    updateGuiWrappingBase(base, chan)
    {
        txt := "Base: " base
        GuiControl, PianoRollMenu3:Text, GuiWrappingBase%chan%, %txt%
    }
    updateGuiWrappingInterval(interval, chan)
    { 
        txt := "H: " interval
        GuiControl, PianoRollMenu3:Text, GuiWrappingInterval%chan%, %txt%

    }
    updateGuiTonic(tonic)
    {
        txt := "Tonic: " tonic
        GuiControl, PianoRollMenu3:Text, GuiPianoRollTonic, %txt%
    }
    updateGuiChord(chordNum)
    {
        txt := "Chord: " chordNum
        GuiControl, PianoRollMenu3:Text, GuiPianoRollChord, %txt%
    }
    updateGuiChordLen(len)
    {
        txt := "Len: " len
        GuiControl, PianoRollMenu3:Text, GuiPianoRollChordLen, %txt%
    }    
    updateGuiScale(scale)
    {
        txt := "Scale: " scale
        GuiControl, PianoRollMenu3:Text, GuiPianoRollScale, %txt%
    }    
    updateGuiNumberedTick(n)
    {
        if (n)
            txt := "Set tick: " n
        else
            txt := ""
        GuiControl, PianoRollMenu3:, GuiNumberedTick, %txt%
    }
    updateGuiTick(n)
    {
        txt := "Tick: " n
        GuiControl, PianoRollMenu3:, GuiTick, %txt%
    }
    ; --
; --
}