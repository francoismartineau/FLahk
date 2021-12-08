global knobChannel := 5

knobCcIn(cc)
{
    ev := midiInKnob.MidiIn()
    ;if (ev.channel == knobChannel)
    ;{
        toolTip("cc: " ev.value "`rchann: " ev.channel "`rcc: " cc, 8)
        ;midiO_1.controlChange(cc, ev.value, ev.channel)
    ;}
}

