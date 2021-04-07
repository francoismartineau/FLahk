MidiControlChange127:
    cc := midi.MidiIn()
    ;toolTip("chan: " cc.channel "   cc: " 127 "     val: " cc.value)
    if (cc.channel == 16)
    {
        midiAnswer := cc.value
        midiRequesting := False
    }

