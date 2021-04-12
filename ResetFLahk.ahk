#SingleInstance ForceIgnorePromptOff
#Include %A_MyDocuments%/AutoHotkey/Lib/maLib.ahk

FLahkPID := 
midiCTLpid := 

resetFLahk()
{
    global FLahkPID
    Process, close, %FLahkPID%
    run, ahk FLahk.ahk, C:/Util2/FLahk, Hide, FLahkPID
    return %FLahkPID%
}

setSoundDevice(start = True)
{
        Switch start
        {
        Case True:
            SysCommand("nircmd.exe setdefaultsounddevice ""Audio 4 DJ (Ch A, Out 1|2)"" 1")
        Case False:
            SysCommand("nircmd.exe setdefaultsounddevice ""Audio 4 DJ (Ch B, Out 3|4)"" 1")
        }
}
; ---------------------------------------------------------



Sleep, 1000
resetFLahk()

; Alt + F1   reset FLahk
#!F1::
!F1::
    HideTaskbar(True)
    if (WinActive("ahk_exe Code.exe"))
    {
        SendInput ^k
        Send s
    }
    ToolTip, Resetting 
    resetFLahk() 
    ;setSoundDevice(True)

    Sleep, 100
    ToolTip
    Send {Shift}
    Sleep, 700
    WinClose, ahk_class TloopMIDIForm
    return
