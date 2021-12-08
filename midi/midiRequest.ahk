midiRequesting := False
midiAnswer := ""

midiRequest(req, param=0, timeout=2)
{
    global midiRequesting, midiAnswer
    if (!midiRequesting)
    {
        toolTip("midi request: " req)
        midiRequesting := True
        needAnswer := False
        
        Switch req
        {
        Case "test_FL":
            cc := 50    
            needAnswer := True

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

        Case "stop":
            cc := 121

        Case "toggle_rec":
            cc := 120

        Case "toggle_play_pause":
            cc := 119

        Case "save_load_song_pos":
            cc := 118            

        Case "deselect_all_channels":
            cc := 117
            
        Case "test_func":
            cc := 116
        }

        channel := 15
        if (needAnswer)
        {
            midiO_2.controlChange(cc, param, channel)
            t1 := A_Now
            while (midiAnswer == "" and (t2-t1 <= timeout))
            {
                Sleep, 10
                t2 := A_Now
            }
            answer := midiAnswer
            midiAnswer := ""
        }
        else
            midiO_1.controlChange(cc, param, channel)

        midiRequesting := False
        Tooltip
    }
    return answer
}

