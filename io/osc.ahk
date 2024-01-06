global osc = new Osc()
osc.AddListener("OscInput.displayScale", "/displayScale")
osc.AddListener("OscInput.displayChord", "/displayChord")
osc.AddListener("OscInput.displayChordLen", "/displayChordLen")
osc.AddListener("OscInput.displayTonic", "/displayTonic")
osc.AddListener("OscInput.displayChanMapping", "/displayChanMapping")
osc.AddListener("OscInput.displayNumberedTick", "/displayNumberedTick")
osc.AddListener("OscInput.displayTick", "/displayTick")
osc.AddListener("OscInput.displayWrappingBase", "/displayWrappingBase")
osc.AddListener("OscInput.displayWrappingInterval", "/displayWrappingInterval")
osc.AddListener("OscInput.displayMapping", "/displayMapping")


class OscInput
{

    displayScale(scale)
    {
        PianoRoll.updateGuiScale(scale)
    }
    displayChordLen(len)
    {
        PianoRoll.updateGuiChordLen(len)
    }    
    displayChord(chord)
    {
        PianoRoll.updateGuiChord(chord)
    }        
    displayTonic(tonic)
    {
        PianoRoll.updateGuiTonic(tonic)
    }
    displayChanMapping(mapping)
    {
        mapping := StrSplit(mapping, "-|-")
        tempMsg(mapping[1] "  " mapping[2] "  " mapping[3])
    }
    displayNumberedTick(n)
    {
        PianoRoll.updateGuiNumberedTick(n)
    }
    displayTick(n)
    {
        PianoRoll.updateGuiTick(n)
    }
    static prevDisplayMapping
    displayMapping(txt)
    {
        if (txt != OscInput.prevDisplayMapping)
        {
            parsed := StrSplit(txt, "-|-")
            value := parsed[1]
            chan := parsed[2]
            tempMsg(value "`r`nPY" chan)
            OscInput.prevDisplayMapping := txt
        }
    }
    displayWrappingBase(txt)
    {
        wrapping := StrSplit(txt, "-|-")
        base := wrapping[1]
        chan := wrapping[2]
        PianoRoll.updateGuiWrappingBase(base, chan)
    }
    displayWrappingInterval(txt)
    {
        wrapping := StrSplit(txt, "-|-")
        interval := wrapping[1]
        chan := wrapping[2]
        PianoRoll.updateGuiWrappingInterval(interval, chan)
    }
}