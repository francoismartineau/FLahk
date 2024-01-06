getMidiInputDevice(midiI, name)
{
    for i, d in __midiInDevices
    {
        if (d.deviceName == name)
        {
            index := d.deviceNumber
            break
        }
    }
    if index != ""
        midiI.OpenMidiIn(index)
    else
        msg("Couldn't not start " name)
}

getMidiOutputDevice(name)
{
    for i, d in MidiOut.getDeviceList()
    {
        if (d.name == name)
        {
            index := d.id
            break
        }
    }
    if index != ""
        midiO := new MidiOut(index)
    else
        msg("Couldn't not start " name)
    return midiO
}

; ----------------------------------------------------------

try
{
    global midiO_FL
    midiO_FL := getMidiOutputDevice("AHK_TO_FL")

    ;global midiO_TD
    ;midiO_TD := getMidiOutputDevice("AHK_TO_TD")

    ;global midiO_PD
    ;midiO_PD := getMidiOutputDevice("AHK_TO_PD")

    global midiO_PY
    midiO_PY := getMidiOutputDevice("AHK_TO_PY")

    global midiI := new Midi()    
    getMidiInputDevice(midiI, "FL_TO_AHK")
    getMidiInputDevice(midiI, "PY_TO_AHK")
}
catch e
{
    msgTip("midiInit.ahk error. Are loopMidi and its virtual midi devices running?`r`n" e)
}