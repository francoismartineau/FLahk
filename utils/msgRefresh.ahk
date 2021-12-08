global msgRefreshLines := []
global msgRefreshCondition := ""

msgRefreshTick()
{
    txt := ""
    for _, line in msgRefreshLines
        txt .= line "`r`n"
    if (msgRefreshCondition != "" and !%msgRefreshCondition%())
    {
        toolTip()
    }
    else
        toolTip(txt)
}

startMsgRefresh(initLinesList)
{
    msgRefreshLines := initLinesList
    startMsgRefreshClock()
}

resetMsgRefresh()
{
    msgRefreshText := []
    msgRefreshCondition := ""
}

hideMsgRefresh()
{
    hideMsgRefreshClock()
    toolTip()
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