; This script
; Download: https://github.com/francoismartineau/FLahk
if (FLahkPath == "")
    global FLahkPath := "C:\Util2\FLahk"

; FLahk uses BGinfo to change the desktop wallpaper
; Download: https://docs.microsoft.com/en-us/sysinternals/downloads/bginfo
if (BGinfoPath == "")
    global BGinfoPath := "C:\Util3\Bginfo.exe"

if (pythonPath == "")
    global pythonPath := "python"

; Script to map and create midi events according to scales and chords
; Download: https://github.com/francoismartineau/PYnotes
if (PYnotesPath == "")
    global PYnotesPath := "C:\Util2\PYnotes"

; Script to merge random audio files
; Download: https://github.com/francoismartineau/concat_audio
if (ConcatAudioPath == "")
    global ConcatAudioPath := "C:\Util2\concat_audio"


; Location of audio samples for FL Studio
if (packsPath == "")
    global packsPath := "C:\Program Files\Image-Line\FL Studio 20\Data\Patches\Packs"


if (audacityPath == "")
    global audacityPath := "C:\Program Files (x86)\Audacity\audacity.exe"
if (melodynePath == "")
    global melodynePath := "C:\Program Files\Celemony\Melodyne editor\Melodyne singletrack.exe"

; AHK script included with AHK, useful to get window and mouse info
; AHK download: https://www.autohotkey.com/
if (windowSpyPath == "")
    global windowSpyPath := "C:\Program Files\AutoHotkey\WindowSpy.ahk"
