cloneActiveInstr()
{
    toolTip("clone channel")
    bringStepSeq(False)
    moveMouseToSelY()
    cloneChannelUnderMouse()
    toolTip()
}

cloneChannelUnderMouse()
{
    toolTip("clone channel")
    selectChannelUnderMouse()
    Send {AltDown}c{AltUp}
    cloneSetName()
    toolTip()
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