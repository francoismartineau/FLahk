global transferFolder := "C:\Program Files\Image-Line\FL Studio 20\Data\Patches\Packs\_transfert"
global transferFileName := "latestTransferFile.wav"
clearTransferFolder()
{
    transferFiles := transferFolder "\" transferFileName ".*"
    while (FileExist(transferFiles))
    {
        FileDelete, %transferFiles%    
    }
}

; -- Audacity ---------------------------
openAudacity()
{
    Run, "C:\Program Files (x86)\Audacity\audacity.exe"
    WinGet, id, ID, A
    waitNewWindowOfClass(id, "wxWindowNR")
    audacityId := WinExist("Audacity ahk_exe audacity.exe ahk_class wxWindowNR")
    WinClose, Master Edison
    WinRestore, ahk_id %audacityId%
    WinActivate, ahk_id %audacityId%
    WinMove, ahk_id %audacityId%,, -1928, 565, 1936, 639
    centerMouse(audacityId)   
}

dragSoundFromAudacity()
{
    clearTransferFolder()
    WinGet, audacityId, ID, A
    moveMouse(26, 43)
    Click
    Send e
    moveMouse(283, 209)
    Click
    saveWinId := waitNewWindowOfClass("#32770", audacityId)
    Sleep, 300
    WinMove, ahk_id %saveWinId%,, -1920, 568, 300, 300

    MouseMove, 51, 65       ; quick access
    Sleep, 100
    Click
 
    MouseMove, 162, 89      ; first icon
    Sleep, 100
    Click
    Sleep, 200
    Loop, 3
    {
        Send p
        Sleep, 200
    }
    Sleep, 100
    Send {Enter}            ; packs
 
    MouseMove, 160, 219     ; transfert
    Sleep, 100
    Click
    Send {Enter}

    MouseMove, 283, 341     
    Sleep, 100
    Click
    TypeText(transferFileName)
    Sleep, 100
    Send {Enter}
    
    WinActivate, ahk_exe FL64.exe
    bringMainFLWindow()
    browsePacks(9)
}
; ----


; ---- 
melodyneMidi()
{

}

edisonToTransfer()                 ; from edison, save a sound file to _transfer. Then another program can access the file.
{
    WinGet, id, ID, A
    if (!isMasterEdison(id))
        return

    clearTransferFolder()
    Send {Ctrl Down}s{Ctrl Up}
    savePromptId := waitNewWindowOfClass("#32770", id)
    WinMove, ahk_id %savePromptId%,, -1920, 568, 1383, 695
    Sleep, 100
    Click, 923, 23
    TypeText(transferFolder)

    Sleep, 100
    Click, 531, 561
    TypeText(transferFileName)
    Send {Enter}
}


runMelodyne()
{
    WinGet, currWinId, id, A
    melodynePath := "C:\Program Files\Celemony\Melodyne editor\Melodyne singletrack.exe"
    Run, %melodynePath%
    melodyneId := waitNewWindowOfProcess("Melodyne singletrack.exe", currWinId)
    WinActivate, ahk_id %melodyneId%
    WinMove, ahk_id %melodyneId%,, 300, 300, 500, 500    
    return melodyneId
}

melodyneLoadSound(melodyneId)
{
    SendInput, ^o
    openWinId := waitNewWindowOfClass("#32770", melodyneId)
    Sleep, 100
    WinMove, ahk_id %openWinId%,, 300, 300, 500, 500


    MouseMove, 51, 65       ; quick access
    Sleep, 100
    Click
 
    MouseMove, 162, 89      ; first icon
    Sleep, 100
    Click
    Loop, 3
    {
        Send p
        Sleep, 100
    }
    Sleep, 100
    Send {Enter}            ; packs
 
    MouseMove, 151, 184     ; _melodyne
    Sleep, 100
    Click
    Send {Enter}

    MouseMove, 229, 413     
    Sleep, 100
    Click
    TypeText("latestMelodyneMidiSound.wav")
    Send {Enter}

    Sleep, 100
    /*
    loadCircleColor := [0x868686]
    loadCircleX := 360
    loadCircleY := 283
    res := colorsMatch(loadCircleX, loadCircleY, loadCircleColor, 20, "", True)    
    msgTip(res, 10000)
    */
}

melodyneExportMidi(melodyneId)
{


    SendInput, ^+s
    saveWinId := waitNewWindowOfClass("#32770", melodyneId)
    Sleep, 100
    WinMove, ahk_id %saveWinId%,, 300, 300, 500, 500

    MouseMove, 268, 392         ; file type
    Sleep, 100     
    Click

    MouseMove, 259, 462         ; midi
    Sleep, 100     
    Click

    Sleep, 100     
    Send {Enter}
    if (waitNewWindowTitled("Confirm Save As", saveWinId, 200))
        Send {Left}{Enter}

    Sleep, 1000
    WinClose, ahk_exe Melodyne singletrack.exe
}