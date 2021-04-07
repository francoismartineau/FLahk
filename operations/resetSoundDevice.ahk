resetSoundDevice()
{
    wasOpen := bringMixer(False)
    currTrack := getMixerTrack()
    if (currTrack > 0)
        Click, 83, 108,, 1                      ; Master Track
    Click, 1780, 598                            ; change output
    Send {Down}{Enter}                          ; A
    Sleep, 100
    Click
    Send {Up}                                   
    Send {Enter}                                ; B
    if (currTrack > 0)
        setMixerTrack(currTrack)    
    if (!wasOpen)
    {
        Sleep, 50
        WinClose, ahk_class TFXForm
    }
}