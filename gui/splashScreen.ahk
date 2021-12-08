global splashScreenStartTime
global splashScreenId
global splashScreenToggle

showSplashScreen()
{
    if (!splashScreenToggle)
        return
	splashScreenFile := "D:\Projets\FLahk vid\logo.gif"
	Gui, SplashScreen:-Caption +E0x08000000 +AlwaysOnTop +LastFound +ToolWindow +HwndsplashScreenId
	AGif := AddAnimatedGIF(splashScreenFile, 0, 0, "", "", "SplashScreen")
	Gui, SplashScreen:Show, w1002 h586
    backgroundCol := 0x3f474c
    WinSet, TransColor, %backgroundCol% 200, ahk_id %splashScreenId%
    ;backgroundCol2 := 0x3f464c
    ;WinSet, TransColor, %backgroundCol2% 255, ahk_id %splashScreenId%
    splashScreenStartTime := A_TickCount
}

hideSplashScreen()
{
    if (!splashScreenToggle)
        return    
    t := 
    timeout := 1300
    while ((t - splashScreenStartTime <= timeout))
    {
        Sleep, 50
        t := A_TickCount
    }    
	Gui, SplashScreen:Destroy
}