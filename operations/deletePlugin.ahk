deletePlugin()
{
    global retrieveMouse
    if (WinActive("ahk_class TPluginForm"))
    {
        openPluginMainCtxMenu()
        len := getPluginCtxMenuLength()
        if (len == "fx")
        {

            WinGet, id, ID, A
            Click, 31, 58
            promptId := waitNewWindow(id)
            centerMouse(promptId)
            clickAlsoAccepts := True
            unfreezeMouse()
            waitAcceptAbort(True)
            freezeMouse()
            activatePrevNextWin("plugin", "prev")
        }
        else
        {
            Send {Esc}
            StepSeq.bringWin(True)
            retrieveMouse := False
            msgTip("Press delete again", 500)
        }
    } 
    else if (WinActive("ahk_class TStepSeqForm"))
    {
        deleteActiveChannel()
    }
}

deleteActiveChannel()
{
    WinGet, id, ID, A
    Send {AltDown}{Del}{AltUp}
    promptId := waitNewWindow(id)
    centerMouse(promptId)
    clickAlsoAccepts := True
    unfreezeMouse()
    waitAcceptAbort(True)
    freezeMouse()
    StepSeq.bringWin(True)
}