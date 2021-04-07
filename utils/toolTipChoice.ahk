global toolTipChoiceIndex := 1
global whileToolTipChoice := False
global tooTipChoices := []

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

toolTipChoice(choices)
{
    tooTipChoices := choices
    clickAlsoAccepts := True
    acceptPressed := False
    abortPressed := False
    whileToolTipChoice := True
    displayToolTipChoice()

    while (!(acceptPressed or abortPressed))
        Sleep, 200

    toolTip()
    whileToolTipChoice := False
    clickAlsoAccepts := False
    if (acceptPressed)
        res := "accept"
    else if (abortPressed)
        res := "abort"
    acceptPressed := True
    abortPressed := True        
    clickAlsoAccepts := False
    return res
}

displayToolTipChoice()
{
    msg := ""
    for i, choice in tooTipChoices
    {
        if (i == toolTipChoiceIndex)
            msg := msg  "> "
        else
            msg := msg  "  "
        msg := msg "" choice "`r`n"
    }
    toolTip(msg)
}

indexOfClosestValue(val, vals)
{
    for i, newVal in vals
    {
        if (val == newVal)
        {
            index := i
            break
        }
        else if (val > newVal)
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
