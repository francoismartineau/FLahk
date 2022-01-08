#If WinActive("ahk_exe FL64.exe") and isOneOfTheSamplers("", True)
~!LButton Up::
    waitForModifierKeys()
    freezeExecute("altClickSampler", [], True, True)
#If