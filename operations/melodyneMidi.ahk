
melodyneMidi()
{

}


melodyneMidiSaveSound()
{
    WinGet, id, ID, A
    if (!isMasterEdison(id))
        return
    Send {Ctrl Down}s{Ctrl Up}
    savePromptId := waitNewWindowOfClass("#32770", id)
    WinMove, ahk_id %savePromptId%,, -1920, 568, 1383, 695
    Click, 923, 23
    static melodyneDir := "C:\Program Files (x86)\Image-Line\FL Studio 20\Data\Patches\Packs\_melodyne"
    TypeText(melodyneDir)

    Click, 531, 561
    static melodyneFileName := "latestMelodyneMidiSound.wav"
    TypeText(melodyneFileName)
    Send {Enter}

    if (waitNewWindow(savePromptId, 300))
        Send {Left}{Enter}
}