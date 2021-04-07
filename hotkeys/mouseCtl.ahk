global mCtlCcL := 52
global mCtlValL := 63
global mCtlIncrL := 0

global mCtlCcR := 53
global mCtlValR := 63
global mCtlIncrR := 0

global mCtlChan := 2


global mCtlRatio := 20

global mCtlActive := "L"
global mCtlLMode := "manual"
global mCtlRMode := "manual"

global lastLvalues := []
global lastRvalues := []
global numMouseValueSaves := 5

; stop / pacman / pong
global mctlIncrMode := "stop"


; --------------------------
onMouseCtlMove(_, diffY)
{
    diffY := -diffY
    Switch mCtlActive
    {
    Case "L":
        mCtlValL := clipMidiCtlVal(mCtlValL + diffY)
        sendMidiCtl(mCtlCcL, mCtlValL)        
    Case "R":   
        mCtlValR := clipMidiCtlVal(mCtlValR + diffY)
        sendMidiCtl(mCtlCcR, mCtlValR)      
    }
}

clipMidiCtlVal(val)
{
    maximum := 127 * mCtlRatio
    minimum := 0
    return Min(maximum, Max(0, val))
}

sendMidiCtl(cc, val)
{   
    if (mouseCtlOutputMidi == True)
    {
        val := Floor(val/mCtlRatio)
        updateGuiMouseCtl(cc, val)
        midiO.controlChange(cc, val, 2)
    }
}


; --------------------------
mouseCtlLButton(state)
{
    if (state)
    {
        mCtlActive := "L"
        static txt := "^"
        GuiControl, Main2:, GuiMouseCtlActive, %txt%
    }

}

mouseCtlRButton(state)
{
    if (state)
    {
        mCtlActive := "R"
        static txt := "        ^"
        GuiControl, Main2:, GuiMouseCtlActive, %txt%
    }
}

mouseCtlWheel(state)
{
    if (state == 1)                     ; up
    {
        if (mCtlActive == "L")
        {
            mCtlLMode := "incr"
            mCtlIncrL := setIncr(mCtlValL, lastLvalues)
        }
        else if (mCtlActive == "R")
        {
            mCtlRMode := "incr"
            mCtlIncrR := setIncr(mCtlValR, lastRvalues)
        }
    }
    else if (state == -1)               ; down
    {
        if (mCtlActive == "L")
            mCtlLMode := "manual"
        else if (mCtlActive == "R")
            mCtlRMode := "manual"      
    }
    updateGuiMouseCtlIncrActive()
}


; -- Incr values -------------------
setIncr(currVal, lastValues)
{
    res := 0
    for i, val in lastValues
    {
        if (i > 1)
            res := res + (val-lastVal)
        lastVal := val
    }
    if (lastValues.MaxIndex() > 0)
    {
        res := res + (currVal-lastVal)
        res := Round(res / lastValues.MaxIndex()) 
    }
    return res
}

saveLastLValues(prevL)
{
    if (lastLvalues.MaxIndex() >= numMouseValueSaves)
        lastLvalues.Remove(1)
    lastLvalues.Push(prevL)
}

saveLastRValues(prevR)
{
    if (lastRvalues.MaxIndex() >= numMouseValueSaves)
        lastRvalues.Remove(1)
    lastRvalues.Push(prevR)
}
; --


; --------------------------
global mouseCtlOutputMidi := True
mouseCtlTick()
{
    static prevL
    static prevR

    if (mCtlActive == "L" and mCtlLMode == "manual")
    {
        saveLastLValues(prevL)
        prevL := mCtlValL
    }
    else if (mCtlLMode == "incr")
    {
        val := incrMouseCtlValue(mCtlValL, mCtlIncrL)
        Switch val
        {
        Case "stopIncr": 
            mCtlLMode := "manual"
            updateGuiMouseCtlIncrActive()
            if (mCtlIncrL > 0)
                mCtlValL := 127*mCtlRatio
            else
                mCtlValL := 0                
        Case "mirrorIncr":
            mCtlIncrL := -mCtlIncrL
        Default:
            mCtlValL := val
        }
        sendMidiCtl(mCtlCcL, mCtlValL)        
    }

    if (mCtlActive == "R" and mCtlRMode == "manual")
    {
        saveLastRValues(prevR)
        prevR := mCtlValR      
    }    
    else if (mCtlRMode == "incr")
    {
        val := incrMouseCtlValue(mCtlValR, mCtlIncrR)
        Switch val
        {
        Case "stopIncr":
            mCtlRMode := "manual"
            updateGuiMouseCtlIncrActive()
            if (mCtlIncrR > 0)
                mCtlValR := 127*mCtlRatio
            else if (mCtlIncrR < 0)
                mCtlValR := 0            
        Case "mirrorIncr":
            mCtlIncrR := -mCtlIncrR            
        Default:
            mCtlValR := val 
        }       
        sendMidiCtl(mCtlCcR, mCtlValR)        
    }    
}

incrMouseCtlValue(val, incr)
{
    val := val + incr
    Switch mctlIncrMode
    {
    Case "stop":
        if (val > 127*mCtlRatio or val < 0)
            val := "stopIncr"
    Case "pacman":
        if (val < 0)
            val := 127*mCtlRatio
        else if (val > 127*mCtlRatio)
            val := 0
    Case "pong":
        if (val > 127*mCtlRatio or val < 0)
            val := "mirrorIncr"
    }
    return val
}

; --------------------------
updateGuiMouseCtl(cc, val)
{
    if (cc == mCtlCcL)
        GuiControl, Main2:, GuiMouseCtlL, L: %val%
    else if (cc == mCtlCcR)
        GuiControl, Main2:, GuiMouseCtlR, R: %val%
}

updateGuiMouseCtlIncrMode()
{
    GuiControl, Main2:, GuiMouseCtlIncrMode, %mctlIncrMode%
}

updateGuiMouseCtlIncrActive()
{
    txt := "L"
    Switch mCtlLMode
    {
    case "incr":
        txt := txt "1"
    case "manual":
        txt := txt "0"
    }
    txt := txt " R"
    Switch mCtlRMode
    {
    case "incr":
        txt := txt "1"
    case "manual":
        txt := txt "0"
    }    
    GuiControl, Main2:, GuiMouseCtlIncrActive, %txt%
}
