receiveCc(cc)
{
    ; -- FL midi script ----
    if (cc.channel == 16 and cc.controller == 127)
    {
        midiAnswer := cc.value
        midiRequesting := False
    }
    ; -- FL toAHK ----
    else if (cc.channel == 2)
    {
        Switch cc.controller
        {
        Case 50:
            pianoRollTempMsg("PITCH:`r`nv->amt  n->att")
        Case 51:
            pianoRollTempMsg("REV:`r`nv->amt  n->att")
        Case 52:
            pianoRollTempMsg("GROSS:  1")
        Case 53:
            pianoRollTempMsg("GROSS:  2")
        Case 54:
            pianoRollTempMsg("GROSS:  3")                                    
        Case 55:
            speed := midiModValToSpeed(cc.value)
            if (speed)
                pianoRollTempMsg("MOD: " speed)        
        }      
    }
    ; -- PY ----
    else if (cc.channel == 15)
    {
        Switch cc.controller
        {
        Case 30:
            displayMode(cc.value)
        Case 31:
            displayChord(cc.value)
        Case 32:
            displayTonic(cc.value)
        Case 33:
            displayChanMapTo(cc.value)
        Case 34:
            displayChanMapEnable(cc.value)
        Case 35:
            displayChordLen(cc.value)
        }        
    }
}

; -- FL MidiOut ---------------------------------------------
midiModValToSpeed(val)
{ 
    if (val == 0)
        return

    speeds := {}
    speeds[114] := "4 B4rs"
    speeds[107] := "3 B4rs"
    speeds[101] := "2 B4rs"
    speeds[96] := "1.5 B4rs"
    speeds[89] := "4 bars"
    speeds[84] := "3 bars"
    speeds[76] := "2 bars"
    speeds[71] := "1.5 bars"
    speeds[64] := "4 beats"
    speeds[59] := "3 beats"
    speeds[51] := "2 beats"
    speeds[46] := "1.5 beats"
    speeds[40] := "1 beat"
    speeds[35] := "3/4 beat"
    speeds[29] := "1/2 beat"
    speeds[23] := "1/3 beat"
    speeds[20] := "1/4 beat"
    speeds[15] := "1/6 beat"
    speeds[12] := "1/8 beat"
    speeds[9] := "1/12 beat"
    speeds[7] := "1/16 beat"
    return speeds[val]
}
; ----

; -- PY -----------------------------------------------------
displayMode(val)
{
    modes := ["Major", "Dorian", "Phrygian", "Lydian", "Mixolydian", "Minor", "Locrian"]
    pianoRollTempMsg(modes[val], toolTipIndex["pianoRollModeMsg"], 22)
}

displayChord(val)
{
    pianoRollTempMsg("Chord " val, toolTipIndex["pianoRollChordMsg"])
}

displayTonic(val)
{
    note := ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"][Mod(val, 12)+1]
    oct := Floor(val/12)
    pianoRollTempMsg("Tonic: " note "" oct)
}

displayChanMapTo(val)
{
    chan := val>>1
    mapToChord := val&1
    mapping := {1: "chords", 0: "scale"}[mapToChord]
    pianoRollTempMsg("Map chan " chan " to: " mapping, "", 40)
}

displayChanMapEnable(val)
{
    chan := val>>1
    enable := val&1
    toggle := {1: "enable", 0: "disable"}[enable]
    pianoRollTempMsg("Chan " chan " " toggle " mapping", "", 40)    
}

displayChordLen(len)
{
    pianoRollTempMsg("Chord len: " len, "", 40)    
}
; ----