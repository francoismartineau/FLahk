global mixerSlotIndex := 1
global lastmixerSlotIndexTime


clickM123(m)
{
    mY := -4
    Switch m
    {
    Case "m1":
        mX := 254
    Case "m2":
        mX := 292
    Case "m3":
        mX := 326
    }
    moveMouse(mX, mY)
    clickAlsoAccepts := True
    acceptAbort := waitAcceptAbort(False, True)
    if (acceptAbort == "accept")
        assignMixerTrackRoute(m)
}

assignMixerTrack()
{
    Send {Ctrl down}l{Ctrl up}
    bringMixer()
}

moveMouseOnMixerSlot(dir = "")
{ 
    MouseGetPos,, my
    index := mixerYToSlotIndex(my)
    if (dir == "up")
        index := index - 1
    else if (dir == "down")
        index := index + 1
    if (index > 10)
        index := 1
    else if (index < 1)
        index := 10
    mixerSlotIndex := index
    my := mixerSlotIndexToY(mixerSlotIndex)
    MouseMove, 1766, %my%, 0
}

mouseOverMixerSlotSection()
{
    MouseGetPos,,, winId
    res := False
    if (isMixer((winId)))
    {
        WinGet, activeId, ID, A
        if (activeId != winId)
            WinActivate, ahk_id %winId%
        MouseGetPos, mx, my
        res := 1709 < mx and mx < 1860 and 60 < my and my < 347
    }
    return res
}

mixerOpenSlot()
{
    if (mouseOverEmptySlot())
    {
        Click
        Send 1
        CoordMode, Mouse, Screen
        Random, mouseY , 805 , 1180
        MouseMove, -441, %mouseY%
        CoordMode, Mouse, Client
        clickAlsoAccepts := True
        unfreezeMouse()
        action := waitAcceptAbort(False)
        freezeMouse()
        Switch action
        {
        Case "accept":
            if (!acceptedWithClick)
                Send {Enter}
            pluginId := waitNewWindowOfClass("TPluginForm", "", 1000)
            if (pluginId)
                centerMouse(pluginId)        
        Case "abort":
            Send {Esc}{Esc}{Esc}
            moveMouseOnMixerSlot()
        }
    }
    else
    {
        WinGet, mixerId, ID, A
        Click
        pluginId := waitNewWindowOfClass("TPluginForm", "", 50)
        if (!pluginId)
        {
            Click
            pluginId := waitNewWindowOfClass("TPluginForm", "", 1000)
        }
        if (pluginId)
        {
            if (isProbablyEq(pluginId))
            {
                MouseMove, 606, 295, 0
                retrieveMouse := False
            }
            else
                centerMouse(pluginId)
        }
    }
}

mixerSlotIndexToY(mixerSlotIndex)
{
    return 73 + (mixerSlotIndex-1) * 30
}

mixerYToSlotIndex(y)
{
    top := 62
    bottom := 352
    if (y < top)
        slot := 1
    else if (y > bottom)
        slot := 10
    else
        slot := Floor((y-top)/29) + 1
    return slot
}

resetMixerTrack()
{
    space := "                                                           "
    msg := space . space . space . space "Reset mixer track?" space . space . space . space
    ToolTip, %msg%, 145, 186
    clickAlsoAccepts := True
    res := waitAcceptAbort()
    toolTip()
    if (res == "accept")
    {
        quickClick(16, 17)
        quickClick(62, 164)
        Send {Enter} 
    }
}

incrInstrMixerTrack(dir)
{
    WinGet, id, ID, A
    coords := isInstr(id)
    if (coords)
    {
        x := coords[1]
        y := coords[2]
        MouseMove, %x%, %y%, 0
        if (dir == "up")
            dir := "WheelUp"
        else if (dir == "down")
            dir := "WheelDown"
        Send {%dir%}
    }
}

global mixerMenuXs := [1639, 1555, 1464, 1374, 1295, 1215, 1124, 1041, 956, 873, 791, 686, 417, 370, 334, 284, 255]
scrollMixerMenu(dir)
{
    MouseGetPos, mX
    for i, x in mixerMenuXs
    {
        if (mX >= x)
        {
            if (mX == x)
                leftIndex := i + 1
            else
                leftIndex := i

            rightIndex := i-1

            if (rightIndex < 1)
                rightIndex := mixerMenuXs.MaxIndex()
            if (leftIndex > mixerMenuXs.MaxIndex())
                leftIndex := 1

            if (dir == "left")
                newMx := mixerMenuXs[leftIndex]
            else if (dir == "right")
                newMx := mixerMenuXs[rightIndex]
            break
        }
    }
    MouseMove, %newMx%, -5, 0
}

; -- Clone Track State -----------------------------------
mouseOverMixerDuplicateTrackRegion()
{
    res := False
    MouseGetPos, x, y, winID
    return isMixer(winID) and y < 72 and 29 < y and x < 1677 and 145 < x
}


cloneMixerTrackState()
{
    y := 111
    MouseGetPos, x
    if (x < 1422)
        x := x + 312
    Click, Right
    Loop, 5
        Send {Down}
    Send {Right}
    MouseMove, %x%, 95
}
; --