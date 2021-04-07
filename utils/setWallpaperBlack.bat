@echo off
reg add "HKCU\control panel\desktop" /v wallpaper /t REG_SZ /d "" /f 
reg add "HKCU\control panel\desktop" /v wallpaper /t REG_SZ /d "C:\Users\ffran\Pictures\black.jpg" /f 
reg delete "HKCU\Software\Microsoft\Internet Explorer\Desktop\General" /v WallpaperStyle /f
reg add "HKCU\control panel\desktop" /v WallpaperStyle /t REG_SZ /d 2 /f
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters 
exit