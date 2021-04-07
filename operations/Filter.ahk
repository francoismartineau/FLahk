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

Filter() {
    pluginId := loadFx(5)
    if (pluginId) {
        randomizePlugin(pluginId)
    }
}