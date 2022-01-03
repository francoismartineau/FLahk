global pyToFlMode
setPyToFlMode()
{
    title := "-- Receive from PY ----"
    choices := ["all", "notes", "cc", "mute"]
    vals := [1, 2, 3, 4]
    if (pyToFlMode)
        initIndex := hasVal(choices, choices[pyToFlMode])
    else
        initIndex := 1
    if (toolTipChoice(choices, title, initIndex))
    {
        pyToFlMode := vals[toolTipChoiceIndex]
        midiRequest("set_PY_TO_FL_MODE", pyToFlMode)
    }
}

stopPY()
{
    FileDelete, %PYnotesPath%\PY_is_running.pid
    tempMsg("Stopping PY")
}

checkIfPYrunning()
{
    FileEncoding, UTF-8
    FileRead, pid, %PYnotesPath%\PY_is_running.pid
    Process, Exist, %pid%
    return ErrorLevel == pid
}

restartPY()
{
    tempMsg("Starting PY")
    run, %pythonPath% main.py %FLahkPID%, %PYnotesPath%\, Hide, PYnotesPID
}