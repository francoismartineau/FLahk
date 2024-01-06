midiRequesting := False
midiAnswer := ""

midiRequest(req, param := 0)
{
    global midiRequesting, midiAnswer
    toFL := True
    toPD := False
    toTD := False
    toPY := False
    timeout := 2
    if (!midiRequesting)
    {
        toolTip("midi request: " req, 6)
        midiRequesting := True
        needAnswer := False
        
        Switch req
        {
        Case "get_pattern":
            cc := 127
            needAnswer := True

        Case "set_pattern":
            cc := 126

        Case "set_mixer_track_route":
            cc := 125

        Case "get_mixer_track":
            cc := 124
            needAnswer := True

        Case "set_mixer_track":
            cc := 123

        Case "toggle_play_pause_twice":
            cc := 122

        Case "stop_external":
            cc := 121
            toFL := False
            toPD := True
            toTD := True

        Case "stop":
            cc := 121

        Case "toggle_rec":
            cc := 120

        Case "toggle_play_pause_external":
            cc := 119
            toFL := False
            toPD := True
            toTD := True        

        Case "toggle_play_pause":
            cc := 119
            
        Case "save_load_song_pos":
            cc := 118            

        Case "deselect_all_channels":
            cc := 117
        
        Case "get_bpm_from_FL":
            cc := 116
            needAnswer := True
        
        Case "send_bpm":
            cc := 115
            toFL := False
            toPD := True

        Case "test_FL":
            cc := 50    
            needAnswer := True

        Case "set_PY_TO_FL_FILTER":
            cc := 30    
            toFL := False
            toPY := True
        }



        channel := 15
        /*
        if (toPD and WinExist("ahk_exe wish85.exe"))
        {
            midiO_PD.controlChange(cc, param, channel)
            if (toPdDelay)
                Sleep, %toPdDelay%
        }
        if (toTD and WinExist("ahk_exe TouchDesigner.exe"))
            midiO_TD.controlChange(cc, param, channel)
        */
        if (toPY)
            midiO_PY.controlChange(cc, param, channel)
        if (toFL)
            midiO_FL.controlChange(cc, param, channel)



        if (needAnswer)
        {
            t1 := A_Now
            while (midiAnswer == "" and (t2-t1 <= timeout))
            {
                Sleep, 10
                t2 := A_Now
            }
            answer := midiAnswer
            midiAnswer := ""
        }

        midiRequesting := False
        toolTip("", 6)
    }
    return answer
}

