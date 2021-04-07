openVsCode() {
    if (WinExist("ahk_exe Code.exe")) {
        WinActivate, ahk_exe Code.exe
    } else {
        freezeExecute("consoleOpenVsCode")
    }
}

VsCodeRun() {
    Send {CtrlDown}k{CtrlUp}s
    MouseClick, Left, 1266, 1004        ; clique console
    Send {VK08}{VK08}ahk .\FLahk.ahk{VK2E}{VK2E}{Enter}
    Sleep, 200
    if (WinExist("ahk_exe Code.exe")) {
        WinActivate, ahk_exe ahk.exe    ; accept prompt
        Sleep, 500
        Send {Enter}
    }
    return
}
 

consoleOpenVsCode() {
    Send {LWin}cmd
    Sleep, 500
    Send {Enter}
    Sleep, 500
    Send code -n C:{LShift down}{VKDE}{LShift up}Util2{LShift down}{VKDE}{LShift up}FLahk{Enter}
}

VsCodeMsgBox() {
    Send MsgBox `% ;{VK2E}
    WinActivate, ahk_exe Code.exe
}