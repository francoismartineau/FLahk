showMidiDevices := True
if (showMidiDevices)
{
    toolTip(MidiIn.QueryMidiInDevices())
    ;toolTip(MidiOut.getDeviceList(), 2)
}

try
{
    global midiI := new Midi()
    midiI.OpenMidiIn(1)
    global midiO_1 := new MidiOut(1)
    global midiO_2 := new MidiOut(2)
}
catch e
{
    msgTip("Midi error. Are loopMidi and its virtual midi devices running?`r`n"  e)
}