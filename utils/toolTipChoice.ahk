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

toolTipChoice(choices, title := "", initIndex := 1, specialKey := "", alternativeChoice := False)
{
    toolTipChoiceIndex := initIndex
    tooTipChoices := choices
    clickAlsoAccepts := True
    whileToolTipChoice := True
    toolTipTitle := title
    displayToolTipChoice()

    res := waitAcceptAbort(False, False, specialKey, alternativeChoice)
    if (res == "accept")
        choice := choices[toolTipChoiceIndex]
    else if (res == "abort")
        choice := ""
    else if (res == "alternative")
        choice := res
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


indexOfClosestValue(val, vals, valsOrder := "desc") ; or asc
{
    Switch valsOrder
    {
    Case "desc":
        i := 1
        incr := 1
    Case "asc":
        i := vals.MaxIndex()
        incr := -1
    }
    while (i >= 1 and i <= vals.MaxIndex())
    {
        newVal := vals[i]
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

        i += incr
    } 
    return index   
}
