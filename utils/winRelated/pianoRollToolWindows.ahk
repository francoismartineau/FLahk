; -- len --------------------------
scrollPianorollLen()
{
    goNextKnob := InStr(A_ThisHotkey, "Down")
    MouseGetPos, mx, my
    ; 1: options   42, 39 
    ; 2: multiply  88, 73         3: gap    162, 71
    ; 4: var       87, 123        5: seed   166, 126  
    top := my < 53
    if (top)
        index := 1
    else
    {
        left := mx < 122
        mid := my < 102
        if (mid and left)
            index := 2
        else if (mid)
            index := 3
        else if (left)
            index := 4
        else
            index := 5
    }

    if (goNextKnob)
        index := index + 1
    else
        index := index - 1

    if (index < 1)
        index := 5
    if (index > 5)
        index := 1

    Switch index
    {
    Case 1:
        mx := 42
        my := 39
    Case 2:
        mx := 88
        my := 73
    Case 3:
        mx := 162
        my := 71
    Case 4:
        mx := 87
        my := 123
    Case 5:
        mx := 166
        my := 126
    }
    MouseMove, %mx%, %my%, 0
}

mouseOverPianorollLenOptions()
{
    MouseGetPos, mx, my
    return my < 45 and mx < 67 and 7 < mx and 29 < my
}

; -- gen --------------------------
moveMouseOnToggle()
{
    MouseMove, 20, 84, 0
}

; -- rand -----------------------
scrollPianorollRand()
{
    goNextKnob := InStr(A_ThisHotkey, "Down") > 0
    MouseGetPos, mx, my
    ; 1 oct: 99, 65         2 range: 215, 66            1
    ; 3 key: 87, 94         4 scale: 168, 91            2
    ; 5 len: 91, 145                                    3
    ; 6 pop: 90, 188        7 stack: 215, 185           4
    ;                       8 seed : 246, 236           5
    ; 9 vel: 105, 313                                   6

    if (my < 78)
        height := 1
    else if (my < 120)
        height := 2
    else if (my < 167)
        height := 3
    else if (my < 218)
        height := 4
    else if (my < 274)
        height := 5
    else if (my > 266)
        height := 6

    if (mx < 144)
        left := True
    else 
        left := False

    Switch height
    {
    Case 1:
        if (left)
            index := 1
        else
            index := 2    
    Case 2:
        if (left)
            index := 3
        else
            index := 4      
    Case 3:
        index := 5
    Case 4:
        if (left)
            index := 6
        else
            index := 7     
    Case 5:
        index := 8
    Case 6:
        index := 9
    }

    if (goNextKnob)
        index := index + 1
    else
        index := index - 1
    
    if (index < 1)
        index := 9
    else if (index > 9)
        index := 1        

    Switch index
    {
    Case 1:
        mx := 99
        my := 65
    Case 2:
        mx := 215
        my := 66
    Case 3:
        mx := 87
        my := 94
    Case 4:
        mx := 168
        my := 91
    Case 5:
        mx := 91
        my := 145
    Case 6:
        mx := 90
        my := 188
    Case 7:
        mx := 215
        my := 185
    Case 8:
        mx := 246
        my := 236
    Case 9:
        mx := 105
        my := 313                            
    }    

    MouseMove, %mx%, %my%, 0
}

changeSeed()
{
    moveMouse(256, 240)
    Click
}