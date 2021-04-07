#SingleInstance ForceIgnorePromptOff
#Include %A_MyDocuments%/AutoHotkey/Lib/maLib.ahk

FLahkPID := 
midiCTLpid := 

resetFLahk()
{
    global FLahkPID
    Process, close, %FLahkPID%
    WinActivate, ahk_exe FL64.exe
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


; -- Wallpaper ---
setFlahkWallpaper()
{
    wallPaperFolder := "C:\Util2\FLahk\wallpapers\"
    wallpapers := ["hotkeys", "mixer"]
    w := wallPaperFolder . randomChoice(wallpapers) ".bgi"
    cmd = C:\Util3\Bginfo.exe %w% /silent /timer 0
    Run, %cmd%
}

setBlackWallpaper()
{
    cmd = C:\Util3\Bginfo.exe C:\Util2\FLahk\wallpapers\wallpaperBlack.bgi /silent /timer 0
    Run, %cmd%
}

;-------

Sleep, 1000
resetFLahk()

; Alt + F1   reset FLahk
!F1::
    setFlahkWallpaper()
    HideTaskbar(True)
    if (WinActive("ahk_exe Code.exe"))
        Send {CtrlDown}k{CtrlUp}
    ToolTip, Resetting
    resetFLahk()
    ;setSoundDevice(True)

    Sleep, 100
    ToolTip
    Send {Shift}
    Sleep, 700
    WinClose, ahk_class TloopMIDIForm
    return

; Alt + F2  edit code
!F2::
    ;HideTaskbar(False)
    setBlackWallpaper()
    Process, close, %FLahkPID%
    ;setSoundDevice(False)
    Sleep, 200
    WinActivate, ahk_exe Code.exe
    return