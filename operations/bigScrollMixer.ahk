global mainMixerTracks := [0, 1, 5, 7, 11, 124, 125]

bigScrollMixer(dir)
{
    track := midiRequest("get_mixer_track")
    index := hasVal(mainMixerTracks, track)
    isImportantMixerTrack := index != 0
    if (isImportantMixerTrack)
    {
        if (track == 0)
        {
            leftTrack := 125
            rightTrack := 1
        }
        else if (track == 125)
        {
            rightTrack := 0
            leftTrack := 124
        }     
        else
        {
            leftTrack := mainMixerTracks[index-1]
            rightTrack := mainMixerTracks[index+1]
        }
    }
    else
    {
        for i, _ in mainMixerTracks
        {
            if (i < mainMixerTracks.MaxIndex())
            {
                
                leftTrack := mainMixerTracks[i]
                rightTrack := mainMixerTracks[i+1]
                if (leftTrack < track and track < rightTrack)
                    break
            }
        }
    } 
    
    if (dir == "left")
        track := leftTrack
    else if (dir == "right")
        track := rightTrack
    midiRequest("set_mixer_track", track)
    
    if (track > 120)
        scrollMixer("right")
    else if (track < 12)
        scrollMixer("left")
}

scrollMixer(dir)
{
    MouseMove, 1606, 606, 0
    if (dir == "left")
        wheel := "WheelUp"
    else if (dir == "right")
        wheel := "WheelDown"
    Loop, 34
        Send {%wheel%}
}
