activateCutTool()
{
    if (!cutToolActivated())
    {
        if (PianoRoll.isWin())
        {
            x := 239
            y := 7
        }
        else ;if (Playlist.isWin())
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
        if (PianoRoll.isWin())
        {
            x := 211
            y := 12  
        }
        else ;if (Playlist.isWin())
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
        if (PianoRoll.isWin())
        {
            x := 149
            y := 9
        }
        else ;if (Playlist.isWin())
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
        if (PianoRoll.isWin())
        {
            x := 128
            y := 10
        }
        else if (Playlist.isWin())
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
    if (PianoRoll.isWin())
    {
        x := 239
        y := 7
    }
    else ;if (Playlist.isWin())
    {
        x := 178
        y := 10
    }
    return colorsMatch(x, y, [0x85B3FF])
}


muteToolActivated()
{
    if (PianoRoll.isWin())
    {
        x := 211
        y := 12  
    }
    else ;if (Playlist.isWin())
    {
        x := 128
        y := 15
    }    
    return colorsMatch(x, y, [0xFF54B0])
}


brushToolActivated()
{
    if (PianoRoll.isWin())
    {
        x := 149
        y := 9
    }
    else ;if (Playlist.isWin())
    {
        x := 87
        y := 12
    }    
    return colorsMatch(x, y, [0x7BCEFD])
}


pencilToolActivated()
{
    if (PianoRoll.isWin())
    {
        x := 128
        y := 10
    }
    else if (Playlist.isWin())
    {
        x := 67
        y := 13
    }    
    return colorsMatch(x, y, [0xFFC43F])
}