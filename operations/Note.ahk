loadScore(n)
{
    pianoRollID := bringPianoRoll(False, False)
    Click, 10, 13
    Send {Down}{Right}{Down}{Enter}
    waitNewWindow(pianoRollID)
    Send %n%{Shift Down}-{Shift Up}
    Sleep, 25
    Send {Down}{Enter}
}

toggleHoveredNoteLenght()
{
    if (!hoveringNote())
        return
    WinGet, pianoRollID, ID, A
    Click, 2
    notePropID := waitNewWindowOfClass("TPRNotePropForm", pianoRollID)
    isLongNote := !colorsMatch(117, 224, [0x8b4351], 10) and !colorsMatch(116, 224, [0x8b4351], 10)
    if (isLongNote)
        wheel := "WheelDown"
    else
        wheel := "WheelUp"

    moveMouse(123, 223)
    Sleep, 1
    Loop, 128
    {
        Sleep, 1
        Send {%wheel%}
    }

    if (isLongNote)
    {
        Sleep, 1
        Send {WheelDown}
        moveMouse(140, 223)
        Loop, 4
        {
            Sleep, 1
            Send {WheelUp}
        }
    }
    Sleep, 1
    Click, 252, 266
}

hoveringNote()
{    
    ;       note colors 1    darker    2         3           4       5           6       7           8       9           10      11          12      13          14      15          16      17
    noteCols := [0x9ED1A5, 0x62926B, 0x9FD3BA, 0xA1D6D0, 0xA3CAD8, 0xA5B8DB, 0xA8A7DE, 0xBCA7DE, 0xD1A7DE, 0xDDA7D6, 0xDBA5C0, 0xD9A3A9, 0xD6AFA2, 0xD4C1A0, 0xD1D29E, 0xBDD19E, 0xA9D19D, 0xE49091]
    colVar := 10
    MouseGetPos, x, y
    return colorsMatch(x, y, noteCols, colVar, "")
}