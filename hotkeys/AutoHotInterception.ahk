global AHI := new AutoHotInterception()



; -- main keyboard --------------------------------------
;mainKeyboardId := AHI.GetKeyboardId(0x046D, 0xC318)
;mainKeyboardContext := AHI.CreateContextManager(mainKeyboardId)
;AHI.SubscribeKey(mainKeyboardId, GetKeySC("Enter"), True, Func("EnterKey"), 2)
; -- second keyboard ------------------------------------
;secondKeyboardId := AHI.GetKeyboardId(0x046D, 0xC517)
;secondKeyboardContext := AHI.CreateContextManager(secondKeyboardId)

; -- numpad1 --------------------------------------------
numpad1Id := AHI.GetKeyboardId(0x1C4F, 0x0002, 1)
if (numpad1Id)
{
    numpad1Context := AHI.CreateContextManager(numpad1Id)
    ;msgTip("numpad: " numpad1Id)
}
else
{
    msgTip("numpad not recognized")
}




; -- main mouse -----------------------------------------
;mainMouseId := AHI.GetMouseId(0x046D, 0xC52B)
;mainMouseContext := AHI.CreateContextManager(mainMouseId)


; -- second  mouse --------------------------------------
secondMouseId := AHI.GetMouseId(0x045E, 0x07FD)
if (secondMouseId)
{
    AHI.SubscribeMouseMove(secondMouseId, True, Func("onMouseCtlMove"))
    AHI.SubscribeMouseButton(secondMouseId, 0, True, Func("mouseCtlLButton"))
    AHI.SubscribeMouseButton(secondMouseId, 1, True, Func("mouseCtlRButton"))
    AHI.SubscribeMouseButton(secondMouseId, 5, True, Func("mouseCtlWheel"))
    ;AHI.SubscribeMouseButton(secondMouseId, 2, True, Func("mouseCtlWheelClick"))
}



/*
; -- tablet ---------------------------------------------
;0x046D, 0xC52B         ; get the string handle?
;0x056A, 0x033C

;tabletHandle := "HID\VID_056A&PID_033C&REV_0100&Col01"      ; tablet trackpad
;tabletTrackpadId := AHI.GetDeviceIdFromHandle(True, tabletHandle)


;tabletId := AHI.GetMouseId(0x046D, 0xC52B)                     
tabletId := AHI.GetMouseId(0x056A, 0x033C)
;AHI.SubscribeMouseMove(tabletId, True, Func("tabletMove"))
;AHI.SubscribeMouseButton(12, 0, True, Func("tabletMove"))
AHI.SubscribeMouseMoveAbsolute(tabletId, True, Func("tabletMove"))  ;;; absolute: 0..65535
;AHI.SubscribeMouseButton(tabletId, True, Func("tabletMove"))  ;;; absolute: 0..65535

tabletClick(state)
{
    msgBox(state " ")
}

tabletMove(x, y)
{
    toolTip(x " " y)
}
*/