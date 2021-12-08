cloneActiveInstr()
{
    toolTip("clone channel")
    bringStepSeq(False)
    currChannY := moveMouseToSelY()
    res := cloneChannelUnderMouse()
    clonedChannY := res[1]
    clonedPluginId := res[2]
    copyChannelScore(currChannY, clonedChannY)
    
    WinActivate, ahk_id %clonedPluginId%
    toolTip()
}

;; En construction ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
/*

copyChannelScoreAllPatterns(sourceChannY, destChannY)
{
    oriPatt := midiRequest("get_pattern")
    patt := 1
    while (patt < 50)
    {
        midiRequest("set_pattern", patt)
        copyChannelScore(currChannY, clonedChannY)
        patt += 1
        msg("patt: " patt, 20)
        ;;;;;;;;;;;;;;;;;;;;;
        ;;;;;;;;;;;;;;;;;;;;;
        ;;;;;;;;;;;;;;;;;;;;;
        ;;;;;;;;;;;;;;;;;;;;;
        ;;;;;;;;;;;;;;;;;;;;;
        ; how to know when last patt is reached?

        ;   - cycle through 128 patt (or something)
        ;   - next empty patt, 1st empty patt
        ;   - cycle empty patts and note which are they?
    }
    midiRequest("set_pattern", oriPatt)
}

findLastPattern()
{
    ; cycle empty patterns
        ; if over X empty in a row, stop

    oriPatt := midiRequest("get_pattern")
    midiRequest("set_pattern", 1)

    emptyPatts := []
    while (True)
    {
        SendInput, ^{F4}
        patt := midiRequest("get_pattern")
        emptyPatts.Push(patt)
        if (patt >= 100)
            break
    }

    toolTip(emptyPatts)
    sleep, 100000
    return

    lastPatt := ""
    patt := 1
    while (patt < 100)
    {
        pattUsed := !hasVal(patt, emptyPatts)
        msg("check if " patt " is used: " pattUsed)
        if (pattUsed)
            lastPatt := patt
        patt += 1
    }
    midiRequest("set_pattern", oriPatt)
    return lastPatt
}
*/

copyChannelScore(sourceChannY, destChannY) 
{
    stepSeqGrey := [0x5F686D]
    scoreX := 296
    sourceChannHasScore := !colorsMatch(scoreX, sourceChannY, stepSeqGrey, 0)
    if (sourceChannHasScore) 
    {
        moveMouse(186 , sourceChannY)
        copyMouseChannelNotes()
        moveMouse(186 , destChannY)
        pasteMouseChannelNotes()
    }
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

cloneChannelUnderMouse()
{
    selectChannelUnderMouse()
    WinGet, ssId, ID, A
    Send {AltDown}c{AltUp}
    clonedPluginId := waitNewWindowOfClass("TPluginForm", ssId)
    cloneSetName()
    WinActivate, ahk_id %ssId%
    clonedChannY := getFirstSelChannelY()
    return [clonedChannY, clonedPluginId]
}

; -----------------------------------------------
cloneSetName()
{
    WinGet, winId, ID, A
    nameEditorId := bringNameEditor(winId)
    if (nameEditorId)
    {

        Send {F2}
        clipboardSave := clipboard
        Send {CtrlDown}c{CtrlUp}
        name := clipboard
        clipboard := clipboardSave
        splitName := StrSplit(name , " ")
        prefix := splitName[1] " "
        cloneNum := splitName[splitName.MaxIndex()]
        cloneNum := SubStr(cloneNum, 2)

        if (splitName.MaxIndex() >= 3)
        {
            suffix := splitName[2]
            if suffix is integer
                isInt := True
            if ((isInt or isRomanNum(suffix)) and splitName.MaxIndex() == 3)
            {
                oldCloneNum := suffix
                suffix := ""
            }
            else
            {
                if (oneChanceOver(3))
                    suffix := randomizeStringOrder(suffix)
                suffix := suffix " "
            }
        }

        if (splitName.MaxIndex() >= 4)
            oldCloneNum := splitName[splitName.MaxIndex()-1]

        if (splitName.MaxIndex() > 4)
        {
            i := 3
            while (i <= splitName.MaxIndex()-2)
            {
                suffix := suffix "" splitName[i] " " 
                i := i + 1
            }
        }

        if (isRomanNum(oldCloneNum))
        {
            cloneNum := romanToArabNum(oldCloneNum) + 1
            if (oneChanceOver(4, "invert"))
                cloneNum := arabToRomanNum(cloneNum)
        }
        else if oldCloneNum is integer
        {
            cloneNum := oldCloneNum + 1
            if (oneChanceOver(4))
                cloneNum := arabToRomanNum(cloneNum)
        }

        name := prefix "" suffix "" cloneNum
        typeText(name)
        Send {Enter}
    }
}
; ---------