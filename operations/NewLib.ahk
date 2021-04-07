NewLib() {
    InputBox, libName , Action Name
    InputBox, isHotKey, Is it a hot key? (1 or 0)
    ; Si l'utilisateur veut faire un hot key

    libName := StrReplace(libName, " ", "_")
    includeFLAHK(libName)
    createButton(libName)
    createGoTo(libName)
    createLibFile(libName)
    editLibFile(libName)
}



includeFLAHK(libName) {
    path = %A_WorkingDir%/FLahk.ahk
    add = #Include Library/%libName%.ahk
    flag := "-- Lib"
    insertCode(path, add, flag)
}

createButton(libName) {
    path = %A_WorkingDir%/gui/g.ahk
    StringUpper, libNameCap, libName
    StringUpper, libNameTitle, libName, T
    add = `n    Gui, Main1:Add, Button, x+10 g%libNameCap%, %libNameTitle%
    flag := "-- Lib"
    insertCode(path, add, flag)
}

createGoTo(libName) {
    path = %A_WorkingDir%/goto.ahk
    StringUpper, libNameCap, libName
    StringUpper, libNameTitle, libName, T
    add = `n`n %libNameCap%:`n    freezeExecute("%libNameTitle%")`n    return
    flag := "-- Lib"
    insertCode(path, add, flag)
}

insertCode(path, add, flag) {
    FileRead, text, %path%
    pos := InStr(text, flag)
    pos := pos + StrLen(flag)
    start := SubStr(text, 1, pos)
    StringUpper, libNameCap, libName
    StringUpper, libNameTitle, libName, T
    end := SubStr(text, pos)
    text = %start%%add%%end%
    FileDelete, %path%
    FileAppend, %text%, %path%   
}


createLibFile(libName) {
    StringUpper, libNameTitle, libName, T
    libFileContent = 
    (
; Ouvre MouseCoords
; Alt + C: MouseClick at

; Alt + W: Activate Active Window
; WinActivate, title

; WinMove, title,, x, y
; WinGetPos, x, y, w, h, title
; WinGetTitle, title, A   

; MouseMove, x, y,, R
; MouseGetPos , x, y, win
; Send, {Wheelup}
; MouseClick, Left, x, y,,,, R
; KeyWait, LButton, D ; attendre un click

%libNameTitle%() {

}
    )
    FileAppend, %libFileContent%, %A_WorkingDir%/Library/%libNameTitle%.ahk
}

editLibFile(libName) {
    StringUpper, libNameTitle, libName, T
    cmd = code C:\Util2\FLahk\Library\%libNameTitle%.ahk
    SysCommand(cmd)
}


