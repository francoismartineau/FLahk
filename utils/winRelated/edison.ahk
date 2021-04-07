scrollMasterEdison(dir)
{
    MouseGetPos, mX, mY
    record := [175, 50]
    onPlay := [231, 46]
    sound := [929, 279]
    if (dir == "down")
    {
        if (mx < record[1])
        {
            mx := record[1]
            my := record[2]
        }
        else if (mx < onPlay[1])
        {
            mx := onPlay[1]
            my := onPlay[2]            
        }
        else if (mx < sound[1])
        {
            mx := sound[1]
            my := sound[2] 
        }
        else
        {
            mx := record[1]
            my := record[2]            
        }
    }
    else if (dir == "up")
    {
        if (mx < record[1]+10)
        {
            mx := sound[1]
            my := sound[2]
        }
        else if (mx < onPlay[1]+10)
        {
            mx := record[1]
            my := record[2]            
        }
        else if (mx < sound[1]+10)
        {
            mx := onPlay[1]
            my := onPlay[2] 
        }
        else
        {
            mx := sound[1]
            my := sound[2]            
        }        
    }
    MouseMove, %mX%, %mY%, 0
}


edisonArmed()
{
    x := 174
    y := 49
    col := [0xB62B08]
    colVar := 0
    hint := ""
    return colorsMatch(x, y, col, colVar, hint)
}

setOnPlay(edisonID)
{
    WinActivate, ahk_id %edisonID%
    Click, 233, 50
    Click, 225, 127
}

setOnInput(edisonID)
{
    WinActivate, ahk_id %edisonID%
    Click, 233, 50
    Click, 237, 83
}

toggleArmEdison()
{
    MouseMove, 182, 49
    MouseClick
}