global msgRefreshLines := []
global msgRefreshCondition := ""

msgRefreshTick()
{
    txt := ""
    for _, line in msgRefreshLines
        txt .= line "`r`n"
    if (execFunc(msgRefreshCondition))
        toolTip(txt, toolTipIndex["msgRefresh"])
    else
        toolTip("", toolTipIndex["msgRefresh"])
}

startMsgRefresh(initLines, condition)
{
    msgRefreshLines := initLines
    msgRefreshCondition := condition
    startMsgRefreshClock()
}

stopMsgRefresh()
{
    msgRefreshLines := []
    msgRefreshCondition := ""
    hideMsgRefresh()
}

hideMsgRefresh()
{
    stopMsgRefreshClock()
    toolTip("", toolTipIndex["msgRefresh"])
}

unhideMsgRefresh()
{
    startMsgRefreshClock()
}

msgRefreshAddLine(line := "")
{
    msgRefreshLines.Push(line)
}

msgRefreshRemoveLine()
{
    msgRefreshLines.Pop()
}

msgRefreshMsg(txt, t := 1000, n := 1)
{
    hideMsgRefresh()
    msg(txt, t, n)
    unhideMsgRefresh()
}