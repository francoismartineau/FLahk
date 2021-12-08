showMidiDevices := True
if (showMidiDevices)
{
    msg(MidiIn.QueryMidiInDevices())
    ;toolTip(MidiOut.getDeviceList(), 2)
}

try
{
    global midiI := new Midi()
    midiI.OpenMidiIn(2)                         ; answers from FL    
    ;global midiInKnob := new Midi()
    ;midiInKnob.OpenMidiIn(1)                   ; knob

    global midiO_1 := new MidiOut(2)    ; unidirectional requests, mouseCtl         2?  1?
    global midiO_2 := new MidiOut(3)    ; bidirectional requests                    3?  2?
}
catch e
{
    msgTip("Midi error. Are loopMidi and its virtual midi devices running?`r`n"  e)
}