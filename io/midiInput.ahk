class MidiInput
{
    receiveCc(cc)
    {
        ; -- FL midi script ----
        if (cc.channel == 16 and cc.controller == 127)
        {
            midiAnswer := cc.value
            midiRequesting := False
        }
        ; -- FL to AHK ----
        else if (cc.channel == 2)
        {
            Switch cc.controller
            {
            Case 50:
                PianoRoll.tempMsg("PITCH:`r`nv->amt  n->att")
            Case 51:
                PianoRoll.tempMsg("REV:`r`nv->amt  n->att")
            Case 52:
                PianoRoll.tempMsg("GROSS:  1")
            Case 53:
                PianoRoll.tempMsg("GROSS:  2")
            Case 54:
                PianoRoll.tempMsg("GROSS:  3")                                    
            Case 55:
                speed := MidiInput.__midiModValToSpeed(cc.value)
                if (speed)
                    PianoRoll.tempMsg("MOD: " speed)        
            Case 56:
                PianoRoll.tempMsg("MOD offs: " Round(cc.value/127, 1))
            Case 57:
                PianoRoll.tempMsg("MOD A: " Round(cc.value/127, 1))
            Case 58:
                ; val
                PianoRoll.tempMsg("MOD note val: " Round(cc.value/127, 1))
            Case 59:
                plusVal := MidiInput.__midiModPlusValCentered(cc.value)
                PianoRoll.tempMsg("MOD note val " plusVal)
            Case 60:
                PianoRoll.tempMsg("MOD feedback: " cc.value "%")
            Case 61:
                if (cc.value > 0)
                    PianoRoll.tempMsg("MOD pitch  (" Round(cc.value/127, 1) " out)")
            Case 62:
                if (cc.value > 0)
                    PianoRoll.tempMsg("MOD delay  (" Round(cc.value/127, 1) " out)")
            Case 63:
                if (cc.value > 0)
                    PianoRoll.tempMsg("MOD phaser  (" Round(cc.value/127, 1) " out)")
            Case 64:
                PianoRoll.tempMsg("MOD D while W: " Round(cc.value/127, 1))
            Case 65:
            Case 66:
            }      
        }
    }

    ; -- FL MidiOut ---------------------------------------------
    __midiModValToSpeed(val)
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

    __midiModPlusValCentered(value)
    {
        plusVal := value/127-.5
        if (plusVal < 0.01)
            op := "-"
        else
            op := "+"
        return op "" Round(Abs(plusVal), 1)
    }
    ; ----
}