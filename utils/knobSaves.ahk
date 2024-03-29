﻿global knobSavesDebug := False
global knobSaves := {}
;global knobSaves := {"title1" :             ; winTitle      { winTitle   : panels of this win }
;
;                                {1:         ; panels        { panelId : array of position }
;
;                                    [       
;                                            ; positions       1 position:      [1] := [x,y]
;                            [[10, 20], [3,4,5,6,7]],    ;                      [2] := [v1, v2, v3, v4, v5]
;                            [[10, 20], [3,4,5,6,7]], 
;                            [[10, 20], [3,4,5,6,7]]
;                            
;                                    ] 
;                                }
;                    }

;;; une clée de dict peut être une array. Modifier position? {[x, y] : [1,2,3,4,5]}

; ----------------------------------------------
global loadKnobPosIndex := 0
global numKnobPos := 0
global latestLoadKnobPosIndexChange := "incr"

; -- Load Knob Pos --------------------------------------------------------
incrLoadKnobPosIndex()
{
    if (numKnobPos > 0)
    {
        loadKnobPosIndex := loadKnobPosIndex + 1
        if (loadKnobPosIndex > numKnobPos)
            loadKnobPosIndex := 1
        latestLoadKnobPosIndexChange := "incr"
    }
}

decrLoadKnobPosIndex()
{
    if (numKnobPos > 0)
    {
        loadKnobPosIndex := loadKnobPosIndex - 1
        if (loadKnobPosIndex < 1)
            loadKnobPosIndex := numKnobPos
        latestLoadKnobPosIndexChange := "decr"
    }
}


loadKnobPos()
{
    MouseGetPos, mX, mY, winId
    ;loadPotentialAssociatedKnobSaves(mX, mY, winId)  

    if (numKnobPos == 0)
        return
    i := 1
    found := False
    stopSearching := False
    for savedWinTitle, winPanels in knobSaves
    {
        for savedPanelId, panelPositions in winPanels
        {
            for posIndex, savedPos in panelPositions
            {
                if (i == loadKnobPosIndex)
                {
                    knobX := savedPos[1][1]
                    knobY := savedPos[1][2]
                    MouseGetPos, mX, mY
                    if (mouseOnWindow(savedWinTitle, savedPanelId) and mouseInKnobPos(knobX, knobY, mX, mY))
                    {
                            searchForNextPos()
                            stopSearching := True
                            break
                    }
                    else
                    {
                        found := True
                        break
                    }
                }
                i := i + 1

            }
            if (found or stopSearching)
                break
        }
        if (found or stopSearching)
            break
    }
    if (found)
    {
        SetTitleMatchMode, 3
        WinGet, winId, ID, %savedWinTitle%
        SetTitleMatchMode, 2
        if (winId)
        {
            WinActivate, ahk_id %winId%
            if (isInstr(winId) and savedPanelId != getActivePanel())
            {

                Switch savedPanelId
                {
                Case 1:
                    panelX := 27
                Case 2:
                    panelX := 70
                Case 3:
                    panelX := 109
                Case 4:
                    panelX := 159
                }
                panelY := 50
                quickClick(panelX, panelY)
            }
            moveMouse(knobX, knobY)
        }
        else
            searchForNextPos()
    }
    searchForNextPosNumCalls := 0
}

saveKnobPos()
{
    ;loadPotentialAssociatedKnobSaves(knobX, knobY, winId)
    activateWinUnderMouse()
    if (knobX == "" or knobY == "")
        winId := mouseGetPos(knobX, knobY)
    WinGetTitle, winTitle, ahk_id %winId%

    if (isInstr(winId))
        panelId := getActivePanel() 
    else
        panelId := 1          
    success := saveKnob(winTitle, panelId, knobX, knobY, "")
    return success
}

global searchForNextPosNumCalls := 0
searchForNextPos()
{
    searchForNextPosNumCalls := searchForNextPosNumCalls + 1
    if (searchForNextPosNumCalls < numKnobPos)
    {
        if (latestLoadKnobPosIndexChange == "incr")
            incrLoadKnobPosIndex()
        else if (latestLoadKnobPosIndexChange == "decr")
            decrLoadKnobPosIndex()
        loadKnobPos()
    }
}
; -------------------


; -- Save Load Knob Values ------------------------------------------------
saveLoadKnob(mode, saveSlot = "")
{
    if (currProjPath == "")
    {
        msg("Save project first")
        return
    }
    activateWinUnderMouse()
    winId := mouseGetPos(mX, mY)
    ;loadPotentialAssociatedKnobSaves(mX, mY, winId)
    saveWinPos(winId)
    WinGetTitle, winTitle, ahk_id %winId%
    
    if (isInstr())
        panelId := getActivePanel() 
    else
        panelId := 1    

    if (mode == "save")
        success := saveKnob(winTitle, panelId, mX, mY, saveSlot)
    else if (mode == "load")
        success := loadKnob(winTitle, panelId, mX, mY, saveSlot)

    if (success)
    {
        MouseMove, %mX%, %mY%, 0
        unfreezeMouse()
        retrieveMouse := False
        freezeExecuting := False
        msgTip(mode " knob " saveSlot)
    }

    retrieveWinPos(winId)
}

loadKnob(winTitle, panelId, mX, mY, saveSlot)
{
    success := False
    winPanels := findSavedWindow(winTitle)
    if (winPanels)
    {
        panelPositions := findSavedPanel(winPanels, panelId)
        if (panelPositions)
        {
            res := findSavedPosition(panelPositions, mX, mY)
            if (res)
            {
                values := res[2]
                val := values[saveSlot]
            }
        }
    }
    if (val != "")
    {
        moveMouse(mX, mY)
        Knob.paste(False, val)
        success := True
    }
    return success
}

saveKnob(winTitle, panelId, mX, mY, saveSlot := "") ; if saveSlot is ommited, only Position is saved
{
    if (saveSlot != "")
    {
        moveMouse(mX, mY)
        val := Knob.copy(False)
    }

    success := False
    winPanels := findSavedWindow(winTitle)
    if (winPanels)
    {
        panelPositions := findSavedPanel(winPanels, panelId)
        if (panelPositions)
        {
            res := findSavedPosition(panelPositions, mX, mY)
            if (res)
            {
                posIndex := res[1]
                savePositionData(winTitle, panelId, posIndex, saveSlot, val)
                success := True
            }
            else
            {
                newPositionData := createNewPositionData(mX, mY, saveSlot, val)
                knobSaves[winTitle][panelId].Push(newPositionData)
                success := True
            }
        }
        else
        {
            newPanelData := createNewPanelData(mX, mY, saveSlot, val)
            knobSaves[winTitle].Insert(panelId, newPanelData)
            success := True  
        }
    }
    else
    {
        winData := createNewWinData(panelId, mX, mY, saveSlot, val)
        knobSaves.Insert(winTitle, winData)  
        success := True
    }
    return success
}
; -------------------

; -- Search ----------------------------------------------
findSavedWindow(winTitle)
{
    found := False
    for savedWinTitle, data in knobSaves
    {
        if (winTitle == savedWinTitle)
        {
            found := True
            break
        }
    }
    if (found)
        return data
}

findSavedPanel(winPanels, panelId)
{
    found := False
    for savedPanelId, data in winPanels
    {
        if (panelId == savedPanelId)
        {
            found := True
            break
        }
    }
    if (found)
        return data
}

findSavedPosition(panelPositions, mX, mY)
{
    found := False
    for posIndex, savedPos in panelPositions
    {
        savedX := savedPos[1][1]
        savedY := savedPos[1][2]
        if (mouseInKnobPos(savedX, savedY, mX, mY))
        {
            found := True
            break
        }
    }
    if (found)
    {
        values := savedPos[2]
        return [posIndex, values]
    }
}

mouseOnWindow(winTitle, panelId)
{
    MouseGetPos,,, mWinId
    WinGetTitle, mWinTitle, ahk_id %mWinId%
    mPanelId := getActivePanel()
    return mWinTitle == winTitle and mPanelId == panelId
}

mouseInKnobPos(knobX, knobY, mX, mY)
{
    return Abs(mX-knobX) <= 15 and Abs(mY-knobY) <= 15
}
; -------------------


; -- Write ------------------------------------------------
savePositionData(winTitle, panelId, posIndex, saveSlot, val)
{
    if (saveSlot != "")
        knobSaves[winTitle][panelId][posIndex][2][saveSlot] := val
}

createNewPositionData(mX, mY, saveSlot, val)
{
    numKnobPos := numKnobPos + 1
    position := [[mX, mY], ["", "", "", "", ""]]
    if (saveSlot != "")
        position[2][saveSlot] := val
    return position
}

createNewPanelData(mX, mY, saveSlot, val)
{
    return [createNewPositionData(mX, mY, saveSlot, val)]
}

createNewWinData(panelId, mX, mY, saveSlot, val)
{
    newPanelData := createNewPanelData(mX, mY, saveSlot, val)
    newWinData := {}
    newWinData.Insert(panelId, newPanelData)
    return newWinData
}
;-------------------


; -- File -------------------------------------------------
global savesFolderPath := Paths.FLahk "\saves"
global savesFilePath := ""
global knobSavesLoaded := False

loadKnobSaves()
{
    res := loadDumpedToFile(savesFilePath, currProjPath, "knobSaves")
    if (IsObject(res))
    {
        knobSaves := res
        countNumKnobPos()
        knobSavesLoaded := True    
    }
}

saveKnobSavesToFile()
{
    if (knobSaves.Count())
        dumpToFile(knobSaves, savesFilePath, currProjPath, "knobSaves")
}


countNumKnobPos()
{
    numKnobPos := 0
    for winTitle, panels in knobSaves
    {
        for panelId, positions in panels
            numKnobPos := numKnobPos + positions.MaxIndex()
    }
}

; -- Debug -----------------------------------------------
knobSavesDebuger()
{
    if (knobSavesDebug)
        toolTip(knobSaves, toolTipIndex["debug"], 1422, 82, "Screen")
}

knobSavesDebugToggle()
{
    GuiControlGet, checked,, knobSavesDebugToggleGui
    knobSavesDebug := checked
    if (!knobSavesDebug)
        toolTip("", toolTipIndex["debug"])    
}