; Ouvre MouseCoords
; Alt + C: MouseClick at

; Alt + W: Activate Active Window
; WinMove, title,, x, y
; WinGetPos, x, y, w, h, title
; WinGetTitle, title, A

; MouseMove, x, y,, R
; Send, {Wheelup}
; MouseClick, Left, x, y,,,, R
; KeyWait, LButton, D ; attendre un click

Equo() {
    loadFx(3)
}