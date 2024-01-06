class StepSeq
{
; -- Channels -----
    static firstChannPixelY := 51
    static channelHeight := 30
    static knownChannels := {}
    initKnownChannels()
    {
        StepSeq.knownChannels["m_"] := {"group": "utils", "index": 1}
        StepSeq.knownChannels["PercEnv Pads"] := {"group": "utils", "index": 2}

        StepSeq.knownChannels["PercEnv"] := {"group": "chans", "index": 1}
        StepSeq.knownChannels["PY settings"] := {"group": "chans", "index": 5}
        StepSeq.knownChannels["PY 10"] := {"group": "chans", "index": 6}
        StepSeq.knownChannels["PY 11"] := {"group": "chans", "index": 8}
        StepSeq.knownChannels["PY 12"] := {"group": "chans", "index": 9}
    }
    bringKnownChannel(chanName, inPianoRoll := False)
    {
        if (!StepSeq.knownChannels.HasKey(chanName))
        {
            msg("bringKnownChannel: unknown """ chanName """")
            return
        }

        knownWinId := StepSeq.knownChannels[chanName]["id"]
        if (winExists(knownWinId))
        {
            WinActivate, ahk_id %knownWinId%
            centerMouse(knownWinId)
        }
        else
        {
            stepSeqId := StepSeq.bringWin(False)
            x := 180
            StepSeq.changeGroup(StepSeq.knownChannels[chanName]["group"])
            y := StepSeq.channelIndexToY(StepSeq.knownChannels[chanName]["index"])
            moveMouse(x, y)
            knownWinId := StepSeq.bringChanUnderMouse()
            StepSeq.knownChannels[chanName]["id"] := knownWinId
            if (inPianoRoll)
                openInstrInPianoRoll()
        }
        return knownWinId
    }
    toggleMidiChannelThrough()
    {
        StepSeq.moveMouseToSelChan()
        Click, R
        Loop, 4
        {
            Send, {WheelUp}
            Sleep, 5
        }
        Sleep, 100      ; to let user see
        Click
    }    
    openMixerInsert()
    {
        mixerId := bringMixer(False)
        centerMouse(mixerId)
    }    
    chanUnderMouseIsOpen()
    {
        ; Checks if channel is open by looking at shadow on top of channel
        mouseGetPos(_, mY, "Screen")
        WinGetPos, ssX, ssY,,, ahk_class TStepSeqForm
        mY -= ssY
        colY1 := ssY + (Floor((my - StepSeq.firstChannPixelY) / StepSeq.channelHeight) * StepSeq.channelHeight) + StepSeq.firstChannPixelY
        colY2 := colY1 + 2
        colX := ssX + 115

        CoordMode, Pixel, Screen
        PixelGetColor, col1, %colX%, %colY1% , RGB
        PixelGetColor, col2, %colX%, %colY2% , RGB
        CoordMode, Pixel, Relative
        return col1 < col2          ; if top is darker
    }     
    scrollChannels(dir)
    {
        mouseGetPos(_, mY)
        WinGet, stepSeqId, ID, ahk_class TStepSeqForm
        WinGetPos,,,, winH, ahk_id %stepSeqId%
        firstChannY := 77
        lastChannY := winH - 63
        numChannels := Floor(winH-126) / StepSeq.channelHeight + 1
        nth := StepSeq.__findClosestChannel(mY, numChannels, firstChannY, lastChannY)

        if (dir == "up")
            nth -= 1
        else if (dir == "down")
            nth += 1

        if (nth < 1)
            nth := numChannels
        else if (nth > numChannels)
            nth := 1

        y := (nth-1) * StepSeq.channelHeight + 62
        moveMouse(190, y)
    }
    __findClosestChannel(mY, numChannels, firstChannY, lastChannY)
    {
        nth := 1
        if (mY > lastChannY)
            nth := numChannels
        else                        
        {
            y := firstChannY
            while (mY > y)              ; in between
            {
                y := y + StepSeq.channelHeight
                nth := nth + 1
            }
        }
        return nth
    }
    bringChanUnderMouseInPianoRoll(centerM := True)
    {
        WinClose, Piano roll - ahk_class TEventEditForm
        WinGet, currWinId, ID, A
        Send {RButton}{WheelDown}{LButton}
        pianoRollId := waitNewWindowOfClass("TEventEditForm", currWinId, 100)
        PianoRoll.bringWin(True, centerM)
    }  
    bringChanUnderMouse(centerM := True)
    {
        toolTip("open instr")
        closeFirst := StepSeq.chanUnderMouseIsOpen()
        if (closeFirst)
        {
            msg("close first")
            Click

        }
        WinGet, currWinId, ID, A
        Send {AltDown}{LButton}{AltUp}
        Sleep, 30
        pluginId := waitNewWindowOfClass("TPluginForm", currWinId, 500)
        if (centerM)
            centerMouse(pluginId)
        toolTip()
        return pluginId
    }
    moveMouseToChanIndex(n)
    {
        mY := StepSeq.channelIndexToY(n)
        moveMouse(184, mY)
    }
    channelIndexToY(n)
    {
        n -= 1
        y := StepSeq.firstChannPixelY + n*StepSeq.channelHeight + StepSeq.channelHeight/2
        return y
    }   
    __channelYToIndex(y)                          
    {
        index := 1 + Round((y - StepSeq.firstChannPixelY) / StepSeq.channelHeight)
        return index
    }
    moveSelectedChannel(chanIndex, currChanIndex := "")
    {
        if (currChanIndex == "")
            currChanIndex := StepSeq.getFirstSelChanIndex()
        chanOffset := chanIndex - currChanIndex
        StepSeq.__moveSelectedChannelGetDir(chanOffset, dir)
        StepSeq.moveMouseToSelChan()
        Send {Shift Down}
        Loop, %chanOffset%
        {
            Send {Wheel%dir%}
            Sleep, 50
        }
        Send {Shift Up}
    }
    __moveSelectedChannelGetDir(ByRef chanOffset, ByRef dir)
    {
        if (chanOffset < 0)
        {
            chanOffset := Abs(chanOffset)
            dir := "up"
        }
        else
            dir := "down"
    }
    bringLastChan()
    {
        stepSeqID := StepSeq.bringWin(False)
        WinGetPos,,,, winH, ahk_id %stepSeqID%

        chanY := winH - 60
        quickClick(147, chanY)
        chanId := waitNewWindowOfClass("TPluginForm", stepSeqID)
        MoveWin.switchMon("right", chanId)
        return chanId
    }
; --
; -- Channels selection -----
    static selChanCols := [0xA8E44A, 0xFFBC40]
    moveMouseToSelChan()
    {
        y := StepSeq.getFirstSelChanY() + 10
        moveMouse(220, y)
        return y
    }
    getFirstSelChanY()
    {
        WinGetPos,,,, ssH, A
        x := 283
        h := ssH - StepSeq.firstChannPixelY
        colVar := 30
        return scanColorsDown(x, StepSeq.firstChannPixelY, h, StepSeq.selChanCols, colVar, StepSeq.channelHeight)
    }
    getFirstSelChanIndex(hint := False)
    {
        if (hint)
            toolTip("getting chan index")
        y := StepSeq.getFirstSelChanY()
        index := StepSeq.__channelYToIndex(y)
        if (hint)
            toolTip()
        return index
    }
    selChanIndexes(chanIndexes)
    {
        for i, chanIndex in chanIndexes
        {
            StepSeq.moveMouseToChanIndex(chanIndex)
            if (i == 1)
                StepSeq.selOnlyChanUnderMouse()
            else
                StepSeq.addChanUnderMouseToSel()
        }
    }
    selOnlyChanUnderMouse(unsel := False)
    {
        StepSeq.bringWin(False)
        mouseGetPos(_, y)
        isAlreadySel := colorsMatch(StepSeq.sepX-1, y, StepSeq.selChanCols)
        moveMouse(StepSeq.sepX, y)
        if (isAlreadySel)
            Click, Right   
        if (!unsel) 
            Click
    }
    unselChannelUnderMouse()
    {
        StepSeq.selOnlyChanUnderMouse(True)
    }
    addChanUnderMouseToSel()
    {
        Send {ShiftDown}
        StepSeq.selOnlyChanUnderMouse()
        Send {ShiftUp}
    }
; --
; -- Mouse pos -----
    mouseOverInstrOrNotes()
    {
        res := False
        winId := mouseGetPos(mX, mY, "Screen")
        if (StepSeq.isWin(winId))
        {
            WinGetPos, winX, winY, winW, winH, ahk_id %winID%
            mX -= winX
            mY -= winY
            res :=  100 < mX and mX < winW and 50 < mY and mY < winH - 45    
        }
        return res 
    }
    mouseOverInstr()
    {
        res := False
        winId := mouseGetPos(mX, mY, "Screen")
        if (StepSeq.isWin(winId))
        {
            WinGetPos, winX, winY,,winH, ahk_id %winId%
            mX -= winX
            mY -= winY
            res := 105 < mX and mX < StepSeq.sepX-11 and 50 < mY and mY < winH-45
        }
        return res
    }
    mouseOverMixerInserts()
    {
        res := False
        winId := mouseGetPos(mX, mY, "Screen")
        if (StepSeq.isWin(winId))
        {
            WinGetPos, winX, winY,,winH, ahk_id %winId%
            mX -= winX
            mY -= winY
            res := mX < 98 and 68 < mX and mY < winH-51 and 53 < mY
        }
        return res
    }
    mouseOverLoop()
    {
        res := False
        winId := mouseGetPos(mX, mY, "Screen")
        if (StepSeq.isWin(winId))
        {
            WinGetPos, winX, winY, winW ,winH, ahk_id %winId%
            mX -= winX
            mY -= winY
            res := winW-66 < mX and mX < winW-28 and mY < winH-51 and 53 < mY
        }    
        return res
    }    
    mouseOverGroupButton()
    {
        success := False
        winId := mouseGetPos(mX, mY, "Screen")
        if (StepSeq.isWin(winId))
        {
            WinGetPos, winX, winY,,, ahk_id %winId%
            mX -= winX
            mY -= winY
            success := mY < 27 and mY > 4 and mX > 106 and mX < 270
        }
        return success 
    }   
    mouseOnStepSeqMenu()
    {
        MouseGetPos,,, winId
        return winId == StepSeqMenuId
    }         
; --
; -- Separator -----
    static sepX := 281
    adjustSep(stepSeqId := "")
    {
        if (!stepSeqId)
            stepSeqId := StepSeq.bringWin(False)
        else
            WinActivate, ahk_id %stepSeqId%
        Sleep, 500                  ; step seq gradual activation color

        y := 13                     ; si pas sel, si mouse over
        currSepX := StepSeq.__locateSep(y)
        if (currSepX and currSepX != StepSeq.sepX)
        {
            moveMouse(currSepX, y)
            Click, Down
            moveMouse(StepSeq.sepX, y)
            Click, Up
        }
    }
    __locateSep(y)
    {
        cols := [0x837E75]
        colVar := 0
        if (!colorsMatch(StepSeq.sepX+3, y, cols, colVar))
        {
            startX := 178
            w := 200
            incr := 1
            toolTip("searching separator")
            x := scanColorsRight(startX, y, w, cols, colVar, incr)
            toolTip()
            if (!x)
                msgTip("fail")
        }
        else
        {
            msgTip("Step Seq separator is fine.")
        }
        return x
    }
; --
; -- Groups -----
    static currInstrGroup := 
    changeGroup(dir, checkIfAll := True)
    {
        if (!StepSeq.isWin())
            Click, 2
        buttX := 187
        buttY := 16
        Switch dir
        {
        Case "left":
            Send {PgUp}
        Case "right":
            Send {PgDn}
        Case "chans":
            quickClick(buttX, buttY)
            Send c
        Case "utils":
            quickClick(buttX, buttY)
            Send u
        }
        if (checkIfAll)
        {
            Loop, 3 ; check 3 times because of graphical lag
            {
                if (StepSeq.isGroupAll())
                {
                    StepSeq.changeGroup(dir, False)
                    break
                }
                Sleep, 10
            }
        }

    }
    isGroupAll()
    {
        ; pixels above A's bar. From the bluish/backgroundish pixel
        colorListX := 111
        colorListY := 15
        colorList := [0x262f44, 0x6297ae, 0x987c50]
        res := scanColorsLine(colorListX, colorListY, colorList)
        return res
    }        
; --
; -- Window -----
    static winId := 0
    maximized(ssId := "")
    {
        res := False
        if (ssId == "")
            WinGet, ssId, ID, ahk_class TStepSeqForm
        if (ssId != "")
        {
            WinGetPos,,, ssW, ssH, ahk_id %ssId%
            if (ssH >= 126)
            {
                scrollBarX := ssW - 15
                scrollBarY := 52
                greyBackground := [0x5F686D]
                res := colorsMatch(scrollBarX, scrollBarY, greyBackground)
            }
        }
        return res
    }

    maximize(ssId := "")
    {
        if (StepSeq.isGroupAll())
            StepSeq.changeGroup("chans")
        if (ssId == "")
            WinGet, ssId, ID, ahk_class TStepSeqForm
        if (ssId != "")
        {   
            makeSureWinInMonitor(ssId) 
            WinGetPos,,, ssW, ssH, ahk_id %ssId%
            moveMouse(ssW/2, ssH-4)
            Send {LButton down}
            moveMouse(10, "", "Client")
            moveMouse("", Mon1Bottom, "Screen")
            Send {LButton up}
        }        
    }

    isWin(id := "", underMouse := False)
    {
        if (!id)
        {
            if (underMouse)
                MouseGetPos,,, id
            else
                WinGet, id, ID, A
        }
        WinGetClass, class, ahk_id %id%
        success := class == "TStepSeqForm"
        if (success)
            StepSeq.winId := id
        return success
    }

    bringWin(moveMouse := True, checkGroup := True, winId := "")
    {
        if (winId == "")
            winId := StepSeq.__forceGetWinId()

        WinActivate, ahk_id %winId%

        if (!StepSeq.maximized(winId))
            StepSeq.maximize(winId)

        if (checkGroup and StepSeq.isGroupAll())
        {
            Sleep, 400
            StepSeq.changeGroup("chans")        
        }
        if (moveMouse)
            centerMouse(winId)
        return winId
    }    
    __forceGetWinId()
    {
        winId := StepSeq.winId
        if (!StepSeq.isWin(winId))
            winId := StepSeq.__getExistingWin()
        if (!StepSeq.isWin(winId))
            winId := StepSeq.__bringWinWithKey()
        if (!StepSeq.isWin(winId))
            return False
        else
            return winId
    }
    __getExistingWin()
    {
        WinGet, id, ID, ahk_class TStepSeqForm
        return id
    }    
    __bringWinWithKey()
    {
        WinGet, currId, ID, A
        Send {F6}
        id := waitNewWindowOfClass("TStepSeqForm", currId)
        return id
    }    
; --
; -- Clipboard -----
    copyMouseChannelNotes()
    {
        StepSeq.selOnlyChanUnderMouse()
        Send {CtrlDown}c{CtrlUp}
    }

    cutMouseChannelNotes()
    {
        StepSeq.selOnlyChanUnderMouse()
        Send {CtrlDown}x{CtrlUp}
    }

    pasteMouseChannelNotes()
    {
        StepSeq.selOnlyChanUnderMouse()
        Send {CtrlDown}v{CtrlUp}
    }    
; --
; -- Split pattern -----
    splitPattern()
    {
        Send {CtrlDown}x{CtrlUp}
        insertPattern(True)
        res := waitToolTip("Patt name:")
        if (!res)
        {
            Send {Esc}
            WinGet, currWinId, ID, A
            deletePattern()
            if (waitNewWindowOfClass("TMsgForm", currWinId))
                Send {Enter}
            StepSeq.bringWin(True)
        }
        else
        {
            Send {Enter}
            StepSeq.bringWin(True)
            Send {CtrlDown}v{CtrlUp}
        }
    }    
;--
; -- Load -----
    loadInstr(num)
    {
        Switch num
        {
        Case "1_1":
            loadSynth()
        Case "1_2":
            loadRandomFlSynth()
        Case "2_1":
            loadLongSynth()
        Case "2_2":
            loadPlucked()
        Case "3_1":
            loadChords()
        Case "3_2":
            loadBeepMap()
        Case "4_1":
            loadVox()
        Case "4_2":
            loadAutogun()
        Case "5_1":
            loadRaveGen()
        Case "5_2":
            loadBooBass()
        Case "6_1":
            loadSpeech()
        Case "6_2":
            loadPiano()
        Case "7_1":
            loadGrnl()
        Case "7_2":
            loadPatcherSlicex()
        Case "8_1":
            load3xosc()
        Case "8_2":
            loadPads()
        Case "9_1":
        Case "9_2":
        }
    }
; --
; -- Gui -----
    static menusShown = False
    makeMenus()
    {
        Gui, StepSeqMenu:New
        Gui, StepSeqMenu:-Caption +AlwaysOnTop +LastFound +ToolWindow +HwndStepSeqMenuId
        Gui, StepSeqMenu:+E0x08000000
        Gui, StepSeqMenu:Font, s9 c%windowMenuFontColor%, %mainFont%
        Gui, StepSeqMenu:Show, NoActivate, StepSeqMenu
        Gui, StepSeqMenu:Hide
        Gui, StepSeqMenu:Color, %windowMenuColor%
        text := StepSeqGuiText
        Gui, StepSeqMenu:Add, Text, x10, %text%

        Gui, StepSeqMenu2:New
        Gui, StepSeqMenu2:-Caption +AlwaysOnTop +LastFound +ToolWindow +HwndStepSeqMenu2Id
        Gui, StepSeqMenu2:+E0x08000000
        Gui, StepSeqMenu2:Font, s9 c%windowMenuFontColor%, %mainFont%
        Gui, StepSeqMenu2:Show, NoActivate, StepSeqMenu2
        Gui, StepSeqMenu2:Hide
        Gui, StepSeqMenu2:Color, %windowMenuColor%    
        static SPLIT_PATTERN
        global SPLIT_PATTERN_TT := "Sends sel chan's notes to new patt. If multiple chans, notes might be pasted on wrong chans."
        Gui, StepSeqMenu2:Add, Button, x10 w55 h15 vSPLIT_PATTERN gSPLIT_PATTERN, split p
        static ADJUST_STEP_SEQ_SEP
        global ADJUST_STEP_SEQ_SEP_TT := "Adjusts step seq separator so flahk clicks at the right places."
        Gui, StepSeqMenu2:Add, Button, x+2 w35 h15 vADJUST_STEP_SEQ_SEP gADJUST_STEP_SEQ_SEP, sep
        return

        SPLIT_PATTERN:
        freezeExecute("StepSeq.splitPattern")
        return

        ADJUST_STEP_SEQ_SEP:
        freezeExecute("StepSeq.adjustSep")
        return
    }
    mouseOnMenuSection()
    {
        MouseGetPos, mx, my
        if (mx > 48 and mx < 109)
            pos := "1"
        else if (mx > 109 and mx < 173)
            pos := "2"
        else if (mx > 173 and mx < 236)
            pos := "3"
        else if (mx > 236 and mx < 300)
            pos := "4"
        else if (mx > 300 and mx < 362)
            pos := "5"
        else if (mx > 362 and mx < 425)
            pos := "6"
        else if (mx > 425 and mx < 487)
            pos := "7"
        else if (mx > 487 and mx < 541)
            pos := "8"
        else if (mx > 541 and mx < 611)
            pos := "9"
        else if (mx > 611)
            pos := "0"

        if (my > -47 and my < -18)
            pos := pos "_1"
        else if (my > -18 and my < 1)
            pos := pos "_2"

        return pos
    }
    showMenus(ssId)
    {
        StepSeq.menusShown := True
        WinGetPos, ssX, ssY, ssW, ssH, ahk_id %ssId%
        menu1H := 53    
        menu1X := ssX
        menu1Y := ssY - menu1H
        Gui, StepSeqMenu:Show, x%menu1X% y%menu1Y% w%ssW% h%menu1H% NoActivate
        menu2H := 30
        menu2Y := ssY + ssH - menu2H
        menu2X := 3
        menu2W := 105 - menu2X
        menu2X := menu2X + ssX
        Gui, StepSeqMenu2:Show, x%menu2X% y%menu2Y% w%menu2W% h%menu2H% NoActivate
        startGuiClock(50)        
    }
    hideMenus()
    {
        Gui, StepSeqMenu:Hide
        Gui, StepSeqMenu2:Hide
        StepSeq.menusShown := False
        startGuiClock()        
    }
; --
}

StepSeq.initKnownChannels()
global StepSeqGuiText
StepSeqGuiText =
(
      1        2        3        4        5        6        7        8        L: toggle lock 
      synth    long     chords   vox     rave      speech   Grnl     3x                            
alt   rand     plucked  beep     gun     bass      piano    Slcx     pads     +(!)scroll
)
;     1        2        3        4        5        6        7        8        9        0

    /*
    channelAtYIsSelected(y)
    {
        x := 280
        res := colorsMatch(x, y, StepSeq.selChanCols, 30)
        return res
    }
    */