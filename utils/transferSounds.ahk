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

edisonToTransfer()                 ; from edison, save a sound file to _transfer. Then another program can access the file.
{
    WinGet, id, ID, A
    if (!isMasterEdison(id))
        return

    clearTransferFolder()
    saveEdisonSound(transferFolder, transferFileName)
}

saveEdisonSound(destinationFolder, fileName := "")
{
    Send {Ctrl Down}s{Ctrl Up}
    savePromptId := waitNewWindowOfClass("#32770", id)
    WinMove, ahk_id %savePromptId%,, 300, 300, 500, 500
    moveMouse(302, 45)
    Click
    TypeText(destinationFolder)
    Send {Enter}
    Sleep, 100
    moveMouse(332, 393)
    Click
    if (fileName != "")
    {
        TypeText(fileName)
        Send {Enter}
    }
    else
    {
        str := randString(5, 40)
        TypeText(str)
    }
}

; -- Audacity ---------------------------
activateAudacity()
{
    WinGet, WinList, List, ahk_exe audacity.exe ahk_class wxWindowNR
    Loop %WinList%
    {
        id := WinList%A_Index%
        if (isVisible(id))
        {
            WinActivate, ahk_id %id%
            break
        }
    }
}

fromEdisonToAudacity()
{
    edisonToTransfer()
    audacityId := WinExist("ahk_exe audacity.exe ahk_class wxWindowNR")
    if (!audacityId)
        audacityId := openAudacity()
    else
        activateAudacity()
    openTransferSoundInAudacity(audacityId)      
}

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
    return audacityId 
}

openTransferSoundInAudacity(audacityId)
{
    SendInput ^o
    openWinId := waitNewWindowOfClass("#32770", audacityId)
    Sleep, 300
    WinMove, ahk_id %openWinId%,, -1920, 568, 300, 300

    MouseMove, 51, 65       ; quick access
    Sleep, 100
    Click
    toolTip("waiting quick access")
    waitForColor(119, 72, [0xFFFFFF], 0, 2000, "", False, True)
    toolTip()

    MouseMove, 162, 89      ; first icon
    Sleep, 100
    Click
    Sleep, 200
    Loop, 3
    {
        Send p
        Sleep, 200
    }
    Sleep, 200
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
    toolTip("waiting quick access")
    waitForColor(119, 72, [0xFFFFFF], 0, 2000, "", False, True)
    toolTip()

    MouseMove, 162, 89      ; first icon
    Sleep, 100
    Click
    
    Sleep, 200
    Loop, 3
    {
        Send p
        Sleep, 200
    }
    Sleep, 200
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

    toolTip("Place mouse on transferFile, Accept")
    MouseMove, 0, 46, 0, R
    unfreezeMouse()
    res := waitAcceptAbort()
    if (!res)
        return
    freezeMouse()
    toolTip("Dragging to Edison")
    dragSampleToEdison()
    toolTip("Choose file name")
    saveEdisonSound(packsPath)
}
; ----


; -- Melodyne ----------------------------
fromEdisonToMelodyne()
{
    msg("fromEdisonToMelodyne not implemented")
}


openMelodyne()
{
    WinGet, currWinId, id, A
    melodynePath := "C:\Program Files\Celemony\Melodyne editor\Melodyne singletrack.exe"
    Run, %melodynePath%
    melodyneId := waitNewWindowOfProcess("Melodyne singletrack.exe", currWinId)
    WinActivate, ahk_id %melodyneId%
    ;WinMove, ahk_id %melodyneId%,, 300, 300, 500, 500    
    WinMove, ahk_id %melodyneId%,, -1928, 565, 1936, 639
    return melodyneId
}

melodyneLoadSound(melodyneId, fileName = "latestTransferFile.wav")
{
    SendInput, ^o
    openWinId := waitNewWindowOfClass("#32770", melodyneId)
    Sleep, 100
    WinMove, ahk_id %openWinId%,, 300, 300, 500, 500


    MouseMove, 51, 65       ; quick access
    Sleep, 100
    Click
    toolTip("waiting quick access")
    waitForColor(119, 72, [0xFFFFFF], 0, 2000, "", False, True)
    toolTip()    
 
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
 
    MouseMove, 146, 218     ; _transfert
    Sleep, 100
    Click
    Send {Enter}

    MouseMove, 229, 413     
    Sleep, 100
    Click
    TypeText(fileName)
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
    {
        msg("overwrite")
        Send {Left}{Enter}
    }

    Sleep, 1000
    WinClose, ahk_exe Melodyne singletrack.exe
}
; ----

; -- Cellphone ---------------------------
cellphoneToTransferFolder()
{
    WinGet, winId, ID, A
    Run, utils\browseExplorer.bat
    explorer1Id := waitNewWindowOfProcess("Explorer.EXE", winId)
    WinMove, ahk_id %explorer1Id%,,,, 1000,800
    Sleep, 50
    moveMouse(722, 73)
    Click
    recPath := "This PC\Galaxy A8 (2018)\Card\Voice Recorder"
    typeText(recPath)
    Send {Enter}
    centerMouse(explorer1Id)
    toolTip("Select a file")
    unfreezeMouse()
    res := waitAcceptAbort(False, False)
    freezeMouse()
    toolTip()
    if (res == "accept")
    {
        Send {F2}
        Send {CtrlDown}c{CtrlUp}
        fileName := clipboard
        Send {Esc}
        SendInput ^c
        Run, utils\browseTransferFolder.bat
        explorer2Id := waitNewWindowOfProcess("Explorer.EXE", explorer1Id)
        waitForModifierKeys()
        SendInput ^v
        Sleep, 750
        WinClose, ahk_id %explorer2Id%
        WinClose, ahk_id %explorer1Id%
    }
    return fileName
}

cellphoneWavToMidi()
{
    fileName := cellphoneToTransferFolder()
    melodyneId := openMelodyne()
    melodyneLoadSound(melodyneId, fileName)
    toolTip("Accept when sound loaded")
    unfreezeMouse()
    waitAcceptAbort(False, False)
    freezeMouse()
    toolTip()
    melodyneExportMidi(melodyneId)
    WinActivate, ahk_exe FL64.exe
    browsePacks(9)
}
; ----