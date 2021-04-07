assignMixerTrackRoute(track)
{
    Switch track
    {
    Case "no bass":
        track := 1        
    Case "m1":
        track := 2
    Case "m2":
        track := 3
    Case "m3":
        track := 4
    Case "bass":
        track := 5
    }
    answer := midiRequest("set_mixer_track_route", track)
}


getMixerTrack()
{
    n := midiRequest("get_mixer_track")
    if n is not digit
        n := 0
    return n
}

setMixerTrack(n)
{
    return midiRequest("set_mixer_track", n)
}