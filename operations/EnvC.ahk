Class EnvC
{
; -- Chan -----
    mIzeCurrChan()
    {
        if (!isInstr())
        {
            msg("mIzeCurrChan: not an instrument")
            return
        }
        WinGet, chanId, ID, A
        chanName := copyName()
        StepSeq.bringWin(False, False)
        oriChanIndex := StepSeq.getFirstSelChanIndex(True)
        mName := "m " chanName
        mId := loadInstr(2, 1, mName, "step seq")
        pasteColor()
        StepSeq.bringWin(False, False)
        StepSeq.moveSelectedChannel(oriChanIndex+1)
        WinActivate, ahk_id %chanId%
        Sleep, 50
        clickInstrWrench()
        res := EnvC.__mIzeCurrChanMakeLinks(mName)
        if (res)
        {
            WinActivate, ahk_id %mId%
            msg("Success")
            return True
        }
        else
        {
            msg("mIzeCurrChan: not completed")
            return False
        }
    }
    __mIzeCurrChanMakeLinks(mName)
    {
        ctlBaseName := mName " - Articulator "

        moveMouseToWrenchPanelKnob("arpDir")
        params := {"ctxMenuLen": "normal", "pickCtl": True, "autoAccept": True}
        params["pickCtlMsg"] := ctlBaseName "1"
        res := Knob.link(params)
        if (!res)
            return False

        moveMouseToWrenchPanelKnob("arpChord")
        params["pickCtlMsg"] := ctlBaseName "7"
        params["relToPrevPickCtl"] := 6
        res := Knob.link(params)
        if (!res)
            return False

        moveMouseToWrenchPanelKnob("echoNum")
        params["pickCtlMsg"] := ctlBaseName "5"
        params["relToPrevPickCtl"] := -2
        res := Knob.link(params)
        if (!res)
            return False

        moveMouseToWrenchPanelKnob("echoPitch")
        params["pickCtlMsg"] := ctlBaseName "6"
        params["relToPrevPickCtl"] := 1
        res := Knob.link(params)
        if (!res)
            return False

        moveMouseToWrenchPanelKnob("echoFeed")
        params["pickCtlMsg"] := ctlBaseName "4"
        params["relToPrevPickCtl"] := -2
        res := Knob.link(params)    
        if (!res)
            return False

        moveMouseToWrenchPanelKnob("echoTime")
        params["pickCtlMsg"] := ctlBaseName "3"
        params["relToPrevPickCtl"] := -1
        res := Knob.link(params)       
        if (!res)
            return False

        moveMouseToWrenchPanelKnob("arpTime")
        params["pickCtlMsg"] := ctlBaseName "2"
        params["ctxMenuLen"] := "time"
        params["relToPrevPickCtl"] := -1
        res := Knob.link(params)    
        if (!res)
            return False

        return True        
    }
; --
; -- Apply EnvC to knob -----
    applyCtl()
    {
        oriId := mouseGetPos(knobX, knobY)
        oriName := copyName()
        values := Knob.copyMinMax()
        if (!values)
            return
        ecId := loadInstr(2)
        if (!ecId)
            return

        WinActivate, ahk_id %oriId%
        moveMouse(knobX, knobY)
        params := {"autoAccept": True, "pickCtl": True}
        res := Knob.link(params)
        if (!res)
            return

        WinActivate, ahk_id %ecId%
        envCname := makeControllerName("EC", oriName, randString(1))
        rename(envCname)
        EnvC.__adjustParams(values)
        centerMouse(ecId)
    }
    __adjustParams(values := "")
    {
        if (IsObject(values))
        {
            min := values[1]
            max := values[2]
            base := min
            Knob.setVal(262, 110, base, "normal")
            env := .5 + (max-min)*.5
            Knob.setVal(301, 95, env, "normal")
        }
    }
; --
; -- Lfo -----
    setLfoTime()
    {
        EnvC.activateTempo()
        timeX := 35
        timeY := 448  - isWrapperPlugin(id)*yOffsetWrapperPlugin

        vals := [0.252168430015445, 0.281080831773579, 0.322803887538612, 0.352946604602039, 0.395961491391063, 0.426796260289848, 0.470441683195531, 0.501568651758134, 0.545598547905684, 0.57680241111666, 0.62109375, 0.652405265718698, 0.696773499250412, 0.728208046406508, 0.741034079343081, 0.772530143149197, 0.81700602825731, 0.848332922905683, 0.892701156437397, 0.924750860780478, 0.968503937125206, 1]
        choices := ["4       --------- b4rs", "3      ", "2      ", "1.5      " , "4 bars ----", "3", "2", "1.5", "4 beats ------", "3", "2", "1.5", "1 beat ------", "3/4", "2/3", "1/2 --", "1/3", "1/4 --", "1/6", "1/8", "1/12", "1/16"]
        moveMouse(timeX, timeY)
        currVal := Knob.copy(False)
        moveMouse(timeX, timeY)
        initIndex := indexOfClosestValue(currVal, vals, "asc")
        if (toolTipChoice(choices, "", initIndex))
            val := vals[toolTipChoiceIndex]    
        if (val != "")
            Knob.setVal(timeX, timeY, val)
    }
    isLfo(id := "")
    {
        res := False
        if (id == "")
            WinGet, id, ID, A
        if (EnvC.isWin(id))    
        {
            y := 156 - isWrapperPlugin(id)*yOffsetWrapperPlugin
            res := colorsMatch(204, y, [0x90a1a8]) and colorsMatch(197, y, [0xa2a8a4]) and colorsMatch(191, y, [0x94a89b])
        }
        return res
    }    
    activateTempo()
    {
        if (!EnvC.__tempoActivated())
            quickClick(124, 428)
    }
    __tempoActivated()
    {
        return colorsMatch(124, 428, [0xb6bdcd])
    }    
; --
; -- Window -----
    isWin(id := "")
    {
        res := False
        if (id == "")
            WinGet, id, ID, A
        if (isPlugin(id))
            res := colorsMatch(135, 76, [0x31373B]) and colorsMatch(129, 76, [0x21272B])
        return res
    }    
    isM(title, id := "")
    {
        success := False
        if (id == "")
            WinGet, id, ID, A
        if (Envc.isWin(id))
        {
            WinGetTitle, foundTitle, ahk_id %id%
            success := InStr(foundTitle, title)
        }
        return success   
    }
; --
; -- Gui -----
    makeMmenu()
    {
        Gui, Mmenu:New
        Gui, Mmenu:-Caption +AlwaysOnTop +LastFound +ToolWindow +HwndMmenuId
        Gui, Mmenu:+E0x08000000
        Gui, Mmenu:Font, s9 c%windowMenuFontColor%, %mainFont%
        Gui, Mmenu:Show, NoActivate, Mmenu
        Gui, Mmenu:Hide
        Gui, Mmenu:Color, %windowMenuColor%
        Gui, Mmenu:Add, Text, x10, %mGuiText%
    }
    showMmenu(mId)
    {
        mMenuShown := True
        WinGetPos, m1X, m1Y, m1W, m1H, ahk_id %mId%
        menuH := 40   
        menuX := m1X
        menuY := m1Y - menuH
        Gui, Mmenu:Show, x%menuX% y%menuY% w%m1W% h%menuH% NoActivate    
        startGuiClock(50)
    }
    hideMmenu()
    {
        Gui, Mmenu:Hide
        mMenuShown := True
        startGuiClock()
    }
; --
}

bringM1()
{
    stepSeqId := StepSeq.bringWin(False)
x := 180
    quickClick(x, 13)           ; Group
    quickClick(x, 37)           ; All
    moveMouse(x, 60)            ; 1st Chan
    m1Id := StepSeq.bringChanUnderMouse(False)
    restoreWin(m1Id)
    Sleep, 200
    if (EnvC.isM(m1Id, "m1"))
    {
        EnvC.m1Id := m1Id
        centerMouse(m1Id)
    }
    else
    {
        WinClose, ahk_id %m1Id%
        m1Id := ""        
    }
    return m1Id
}

global mGuiText
mGuiText = 
(
[1] G4: mute M1           [2] B4: mute bass         [3]C3-B slcxDel(speed-vel)[4] C4  slcxFeed   (vel)
[5]                       [6]                       [7]                       [8] C#4 slcxEchoes (vel)
)
;5]                       [6]                       [7]                       [8]