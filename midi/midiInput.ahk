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
        Case 56:
            pianoRollTempMsg("MOD offs: " Round(cc.value/127, 1))
        Case 57:
            pianoRollTempMsg("MOD A: " Round(cc.value/127, 1))
        Case 58:
            ; val
            pianoRollTempMsg("MOD note val: " Round(cc.value/127, 1))
        Case 59:
            plusVal := midiModPlusValCentered(cc.value)
            pianoRollTempMsg("MOD note val " plusVal)
        Case 60:
            pianoRollTempMsg("MOD feedback: " cc.value "%")
        Case 61:
            if (cc.value > 0)
                pianoRollTempMsg("MOD pitch  (" Round(cc.value/127, 1) " out)")
        Case 62:
            if (cc.value > 0)
                pianoRollTempMsg("MOD delay  (" Round(cc.value/127, 1) " out)")
        Case 63:
            if (cc.value > 0)
                pianoRollTempMsg("MOD phaser  (" Round(cc.value/127, 1) " out)")
        Case 64:
            pianoRollTempMsg("MOD D while W: " Round(cc.value/127, 1))
        Case 65:
        Case 66:
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
    speeds[32] := "4 B4rs"
    speeds[36] := "3 B4rs"
    speeds[41] := "2 B4rs"
    speeds[45] := "1.5 B4rs"
    speeds[50] := "4 bars"
    speeds[54] := "3 bars"
    speeds[60] := "2 bars"
    speeds[64] := "1.5 bars"
    speeds[69] := "4 beats"
    speeds[73] := "3 beats"
    speeds[79] := "2 beats"
    speeds[83] := "1.5 beats"
    speeds[88] := "1 beat"
    speeds[92] := "3/4 beat"
    speeds[98] := "1/2 beat"
    speeds[104] := "1/3 beat"
    speeds[108] := "1/4 beat"
    speeds[113] := "1/6 beat"
    speeds[117] := "1/8 beat"
    speeds[123] := "1/12 beat"
    speeds[127] := "1/16 beat"
    return speeds[val]
}

midiModPlusValCentered(value)
{
    plusVal := value/127-.5
    if (plusVal < 0.01)
        op := "-"
    else
        op := "+"
    return op "" Round(Abs(plusVal), 1)
}
; ----

; -- PY -----------------------------------------------------
displayMode(val)
{
    ; this is the real order of modes
    ; I modified it in PY settings so Major is C, Minor is G and other mode feelings "fit" the feeling of the corresponding notes
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