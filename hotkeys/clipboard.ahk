#If WinActive("ahk_exe FL64.exe")
^!c UP::
    clipboardUtilities()
    return

^!x UP::
    clipboardMultipleXY()
    return

^!+x UP::
    clipboard := ";"
    return

^!+z UP::
    clipboardColorMatches()
    return

^!r UP::
    clipboardRelativeMouse()
    return
#If