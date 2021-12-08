activateCutTool()
{
    if (!cutToolActivated())
    {
        if (isPianoRoll())
        {
            x := 239
            y := 7
        }
        else ;if (isPlaylist())
        {
            x := 178
            y := 10
        }        
        quickClick(x, y)
    }
}

activateMuteTool()
{
    if (!muteToolActivated())
    {
        if (isPianoRoll())
        {
            x := 211
            y := 12  
        }
        else ;if (isPlaylist())
        {
            x := 128
            y := 15
        }         
        quickClick(x, y)
    }
}

muteSelection()
{
    sendinput !m
    sendinput ^d
}

unmuteSelection()
{
    sendinput +!m
    sendinput ^d
}

invertSelection()
{
    sendinput +i
}

activateBrushTool()
{
    if (!brushToolActivated())
    {
        if (isPianoRoll())
        {
            x := 149
            y := 9
        }
        else ;if (isPlaylist())
        {
            x := 87
            y := 12
        }        
        quickClick(x, y)
    }
}


activatePencilTool()
{
    if (!pencilToolActivated())
    {
        if (isPianoRoll())
        {
            x := 128
            y := 10
        }
        else if (isPlaylist())
        {
            x := 67
            y := 13
        }          
        quickClick(x, y)
    }
}


; --------------------------------------
whichToolActivated()
{
    res := ""
    if (pencilToolActivated())
        res := "pencilTool"
    else if (brushToolActivated())
        res := "brushTool"
    else if (cutToolActivated())
        res := "cutTool"
    else if (muteToolActivated())
        res := "muteTool"
    return res
}

cutToolActivated()
{
    if (isPianoRoll())
    {
        x := 239
        y := 7
    }
    else ;if (isPlaylist())
    {
        x := 178
        y := 10
    }
    return colorsMatch(x, y, [0x85B3FF], 0, "")
}


muteToolActivated()
{
    if (isPianoRoll())
    {
        x := 211
        y := 12  
    }
    else ;if (isPlaylist())
    {
        x := 128
        y := 15
    }    
    return colorsMatch(x, y, [0xFF54B0], 0, "")
}


brushToolActivated()
{
    if (isPianoRoll())
    {
        x := 149
        y := 9
    }
    else ;if (isPlaylist())
    {
        x := 87
        y := 12
    }    
    return colorsMatch(x, y, [0x7BCEFD], 0, "")
}


pencilToolActivated()
{
    if (isPianoRoll())
    {
        x := 128
        y := 10
    }
    else if (isPlaylist())
    {
        x := 67
        y := 13
    }    
    return colorsMatch(x, y, [0xFFC43F], 0, "")
}