global toolTipChoiceIndex := 1
global whileToolTipChoice := False
global tooTipChoices := []
global toolTipTitle := ""

incrToolTipChoiceIndex()
{
    toolTipChoiceIndex := toolTipChoiceIndex - 1 
    if (toolTipChoiceIndex == 0)
        toolTipChoiceIndex := tooTipChoices.MaxIndex()        

    displayToolTipChoice()
}

decrToolTipChoiceIndex()
{
    toolTipChoiceIndex := toolTipChoiceIndex + 1
    if (toolTipChoiceIndex > tooTipChoices.MaxIndex())
        toolTipChoiceIndex := 1   
    displayToolTipChoice()
}

toolTipChoice(choices, title := "", initIndex := 1, specialKey := "")
{
    toolTipChoiceIndex := initIndex
    tooTipChoices := choices
    clickAlsoAccepts := True
    whileToolTipChoice := True
    toolTipTitle := title
    displayToolTipChoice()

    res := waitAcceptAbort(False, False, specialKey)
    if (res == "accept")
        choice := choices[toolTipChoiceIndex]
    else if (res == "abort")
        choice := ""
    toolTip("", toolTipIndex["toolTipChoice"])
    tooTipChoices := []
    toolTipTitle := ""
    whileToolTipChoice := False
    return choice
}

displayToolTipChoice()
{
    msg := ""
    if (toolTipTitle)
        msg := toolTipTitle "`r`n"
    for i, choice in tooTipChoices
    {
        if (i == toolTipChoiceIndex)
            msg := msg  "> "
        else
            msg := msg  "  "
        msg := msg "" choice "`r`n"
    }
    toolTip(msg, toolTipIndex["toolTipChoice"])
}


; vals must be from high to low
indexOfClosestValue(val, vals)
{
    for i, newVal in vals
    {
        if (val == newVal)
        {
            index := i
            break
        }
        else if (i > 1 and val > newVal)
        {
            prevVal := vals[i-1]
            diffPrevVal := Abs(val - prevVal)
            diffNewVal := Abs(val - newVal)
            if ((diffPrevVal - diffNewVal) > 0)
                index := i
            else 
                index := i - 1
            break
        }
        else if (i == vals.Count())
            index := i
    } 
    return index   
}
