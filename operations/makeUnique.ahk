makeUnique(multipleClips = True)
{
    bringPlaylist(False)
    MouseGetPos, oriX, oriY
    Click
    Sleep, 50

    clipType := clipCtxMenuType()

    if (clipType == "sound")
        n := 7
    else if (clipType == "pattern")
        n := 6

    Loop, %n%
        Send {Down}
    Send {Enter}                                    ; make this clip unique
    closePromptIfNecessary()
    
    if (clipType == "sound")
    {
        MouseMove, 20, 0,, R
        Click, 2
        waitNewWindowOfClass("TPluginForm", id)
    }
    acceptAbort := rename("", True)
    if (clipType == "sound")
        bringPlaylist(False)

    MouseMove, %oriX%, %oriY%
    if (acceptAbort != "abort" and multipleClips)
        selectSourceForAllSelectedClips()           ; let user select new clip as source for all selected
}

closePromptIfNecessary()
{
    msgFormID := waitNewWindowOfClass("TMsgForm", id, 400)
    if (msgFormID)
        Send {Enter}
}

selectSourceForAllSelectedClips()
{
    Send  {Shift Down}
    Click
    Sleep, 50

    Send {Down}{Down}{Right}{Down}{WheelUp}
    clickAlsoAccepts := True
    unfreezeMouse()
    acceptAbort := waitAcceptAbort(True, False)
    if (acceptAbort == "abort")
        Send {Esc}    
    Send {Shift Up}

}

selectSimilarClips() 
{
    if (hoveringUpperMenuPattern())
    {
        Click, Right
        Send {Right}
        Send {Down}{Down}{Down}
        Send {Enter}
    }    
    else
    {
        WinGet, id, ID, A
        if (isPlaylist(id))
        {
            Click
            Sleep, 50
            clipType := clipCtxMenuType()
            if (clipType == "sound")
                n := 8
            else if (clipType == "pattern")
                n := 7

            Loop, %n%
                Send {Down}        
            Send {Enter}
        }
    }
}

clipCtxMenuType()
{
    MouseGetPos, mx, my
    x1 := mx + 111
    y1 := my + 128

    x2 := mx + 270
    y2 := my + 229

    PixelGetColor, col1, %x1%, %y1% , RGB
    if (colorsMatch(x2, y2, [col1], 10, "", False))
        res := "sound"
    else
        res := "pattern"
    return res
}

reverseSound()
{
    Click, 2
    winId := waitNewWindowOfClass("TPluginForm", id)
    if (winId)
    {
        QuickClick(299, 244)     
        Send {Esc}
    }
}