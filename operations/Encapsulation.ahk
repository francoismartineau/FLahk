; ------------------------------------------
; While a sound is open (in a saved project)
; get its name and folder
; save
; open project with the name in the folder

unwrapProject()
{
    WinGetClass, class, A
    if (class == "TPluginForm")
    {    
        WinGet, winId, ID, A
        projectName := getParentProjectName(winId)
        ;msgTip("project name:" projectName, 2000)
        clipboardSave := clipboard
        projectFolder := getParentProjectFolder(winId)
        ;msgTip("project folder:" projectFolder,2000)
        WinActivate, FL Studio 20 ahk_class TFruityLoopsMainForm 
        save()
        openParentProject(winId, projectFolder, projectName)
        clipboard := clipboardSave
    }
}

getParentProjectName(winId)
{
    WinGetTitle, projectName, ahk_id %winId%                    ; le nom du projet à ouvrir
    projectName := StrSplit(projectName , "")[1]
    projectName := StrSplit(projectName , "_")[1]               ; si projet_1 ou projet: projet
    return projectName
}

getParentProjectFolder(winId)
{
    Click, 222, 97
    browseWindowId := waitNewWindowOfClass("#32770", winId)
    WinMove, ahk_id %browseWindowId%,, 439, 250, 872, 668
    MouseMove, 310, 17      ;msgtip("over path", 2000)
    Sleep, 100
    Click
    Send {Ctrl Down}c{Ctrl Up}
    projectFolder := clipboard
    WinClose, ahk_id %browseWindowId%
    WinActivate, ahk_id %winId%
    return projectFolder
}

openParentProject(winId, projectFolder, projectName)
{
    Send {Ctrl Down}o{Ctrl Up}
    browseWindowId := waitNewWindowOfClass("#32770", winId)
    WinMove, ahk_id %browseWindowId%,, 439, 250, 872, 668
    
    MouseMove, 292, 15, 0           ;msgTip("over folder")
    Click
    Send {Ctrl Down}v{Ctrl Up}{Enter}
    
    ;projectsPath = C:\Users\ffran\Documents\Image-Line\FL Studio\Projects
    ;TypeText(projectsPath)
    ;Send {Enter}
    ;MouseMove, 552, 23, 0           ;msgTip("over search")
    ;Click
    ;msgTip("search active")
    ;TypeText(projectFolder)
    ;Send {Enter}
    ;Sleep 100
    ;MouseMove, 580, 15, 0           
    ;msgTip("folder: " projectFolder "   over ->")
    ;Click
    
    MouseMove, 328, 447, 0          ;msgTip("over file name")
    Click
    Send {CtrlDown}a{CtrlUp}
    TypeText(projectName ".flp")
    MouseMove, 444, 476, 0          ;msgTip("over Open")
    Click


    ;Send {Enter}
    ;MouseMove, 184, 85, 0
    ;msgTip("over file")
    ;Click
    ;Send {Enter}
}

; ------------------------------------------
; While a saved project is open
; save
; export mp3 and note the name
; create new project
wrapInNewProject()
{
    WinActivate, FL Studio 20 ahk_class TFruityLoopsMainForm  
    save()
    projectName := exportMp3()
    projectName := getNextProjectName(projectName)
    newProject(projectName)
    WinActivate, ahk_exe Explorer.EXE
}

save()
{
    Send {Ctrl Down}s{Ctrl Up}
    Sleep, 200
}

exportMp3()
{
    MouseClick, Left, 14, 15                        ; open menu
    Sleep, 200
    Loop, 8
    {
        Send {Down}
        Sleep, 100
    }
    Send {Right}
    Sleep, 100
    Send {Down}
    Sleep, 100
    Send {Enter}                                    ; export
    Sleep, 200
    WinWaitActive, Save As,, 3
    Sleep, 500
    projectName := getProjectName()
    Send {Enter}
    WinWaitActive, ahk_class TWAVRenderForm,, 3     
    Send {Enter}
    WinWaitClose, ahk_class TWAVRenderForm          ; rendering
    WinWaitActive, ahk_exe Explorer.EXE,, 3
    Sleep, 200
    WinActivate, ahk_exe FL64.exe                   ; activate FL, keep explorer window
    Sleep, 100
    WinActivate, FL Studio 20 ahk_class TFruityLoopsMainForm  
    Sleep, 500
    return projectName
}

getProjectName()
{
    global clipboardSave
    clipboardSave := clipboard
    Sleep, 200
    Send {Ctrl Down}c{Ctrl Up}              ; copy name in save as window
    Sleep, 500
    projectName := SubStr(clipboard, 1 , StrLen(clipboard) - 4)
    return projectName
}

getNextProjectName(projectName)
{
    num := getProjectNameNumber(projectName) + 1
    projectname = %projectName%_%num%
    return projectName
}

getProjectNameNumber(projectName)
{
        projectNameNumber := 
        n := SubStr(projectName, StrLen(projectName) - 1 , StrLen(projectName))
        nIsNumber := False
        if n is digit
            isNumber := True
        underscore := SubStr(projectName, StrLen(projectName) - 2 , StrLen(projectName) - 1)
        isFirst := (underscore != "_" or !nIsNumber)
        if (isFirst)
            projectNameNumber := 1
        else
            projectNameNumber := n
    return projectNameNumber
}

newProject(projectName)
{
    global clipboardSave
    MouseClick, Left, 14, 15                ; open menu
    Sleep, 200
    Send {Down}
    Sleep, 100
    Send {Enter}                            ; new project
    Sleep, 4000
    Send {Ctrl Down}s{Ctrl Up}
    WinWaitActive, Save As,, 3
    clipboard := projectName
    Sleep, 1000
    Send {Ctrl Down}v{Ctrl Up}
    Sleep, 200
    Send {Enter}
    clipboard := clipboardSave
    Sleep, 200
    WinWaitActive, FL Studio 20 ahk_class TFruityLoopsMainForm,, 3
}

; ------------------------------------------
openNextProject()
{
    global clipboardSave
    WinActivate, FL Studio 20 ahk_class TFruityLoopsMainForm  
    MouseClick, Left, 14, 15                        ; open menu
    Sleep, 1000
    Loop, 3
    {
        Send {Down}
        Sleep, 100
    }
    Send {Enter}

    GroupAdd, nextWindow, ahk_class TMsgForm
    GroupAdd, nextWindow, Open
    msgTip("waiting for new win")
    WinWaitActive, ahk_group nextWindow,, 3
    WinGetClass, class, A
    if (class == "TMsgForm")
    {
        msgTip("found save prompt")
        Send {Enter}
        WinWaitActive, Open,, 3
    }
    projectName := getProjectName()
    nextProjectName := getNextProjectName(projectName)
    clipboardSave := clipboard
    clipboard := nextProjectName
    Sleep, 1000
    Send {Ctrl Down}v{Ctrl Up} 
    Sleep, 1000
    Send {Enter}
}
