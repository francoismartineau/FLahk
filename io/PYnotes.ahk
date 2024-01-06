global pyToFlFilter
pyNoteToggle()
{
    GuiControlGet, checked,, PYnoteToggleGui
    if (checked)
        startPYbootClock()
    else
    {
        stopPYbootClock()
        stopPY()
    }    
}

global whileSetPyToFlFilter := False
setPyToFlFilter()
{
    whileSetPyToFlFilter := True
    title := "-- Receive from PY ----"
    choices := ["all", "notes", "cc", "mute"]
    vals := [1, 2, 3, 4]
    if (pyToFlFilter)
        initIndex := hasVal(choices, choices[pyToFlFilter])
    else
        initIndex := 1
    if (toolTipChoice(choices, title, initIndex))
    {
        pyToFlFilter := vals[toolTipChoiceIndex]
        midiRequest("set_PY_TO_FL_FILTER", pyToFlFilter)
    }
    whileSetPyToFlFilter := False
}

stopPY()
{
    pyNotesPath := Paths.PYnotes
    FileDelete, %pyNotesPath%\PY_is_running.pid
    tempMsg("Stopping PY")
}

checkIfPYrunning()
{
    FileEncoding, UTF-8
    pyNotesPath := Paths.PYnotes
    FileRead, pid, %pyNotesPath%\PY_is_running.pid
    Process, Exist, %pid%
    return ErrorLevel == pid
}

restartPY()
{
    tempMsg("Starting PY")
    pythonPath := Paths.python
    pyNotesPath := Paths.PYnotes
    clipboard = %pythonPath% main.py %FLahkPID%, %pyNotesPath%
    run, %pythonPath% main.py %FLahkPID%, %pyNotesPath%\, Hide, PYnotesPID
}