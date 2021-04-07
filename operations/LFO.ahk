LFO()
{
    WinGetClass, class, A
    if (class == "TPluginForm")
    {
        copyName()
        lfoID := applyController(4, False, OcrToggleEnabled, 3)

        setLFOParams(lfoID)
        pasteName("LFO", False)
    }
    else 
    {
        lfoID := loadFx(4)
        setLFOParams(lfoID, False)
        rename("LFO", True)
    }
}

setLFOParams(lfoID, pasteValue = True)
{
    WinActivate, ahk_id %lfoID%
    randomizePlugin(lfoID)              ; one preset name starts with r so "Randomize" is the 2nd R choice
    moveMouse(235, 77)                  ; set Base value to ori knob value
    if (pasteValue)
        pasteKnob(False)                    
}
