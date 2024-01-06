<img src="https://i.imgur.com/R6YP2Iu.gif"
     alt="FLahk"
     style="float: left; margin-right: 10px;" />

FLahk is an interface that sits over FL Studio. It's main intent is to speed up music production and add randomization to put the musician in unprecedented situations.

The initial motive was to completely change the way sound samples are chosen. The program can output files containing multiple concatanated sounds chosen randomly using parameters given by the user. These files can then be fed to one of my granular synthesizers. This way, instead of choosing sounds manually by browsing files, it can be done in real time without taking time or effort. Since choosing sounds is now trivial, creating new patterns/loops that use the sound library in unprecedented ways is also trivial. Therefore, the musician can choose generations and make them musically interact.<br>
This feature is a small portion of the whole project. It features:<br>.A module that maps notes using chords and scales.<br>.Complex macros that perform multiple operations that automate the keyboard and mouse by looking at the screen's pixels.<br>.Guis 

Throughout this project, randomization takes a major role in order to make every step of music production unique and to challenge the musician. (Sounds, notes, rythms, names, etc)


<br/><br/>

## Basic window history tutorial:

The window history is a feature that makes window navigation more natural. By popular demand, here's how to implement something similar:

### First steps with AHK:
Install [AHK](https://www.autohotkey.com/). It features a little program called Window Spy that will be useful. Here's what it [looks like](https://i.imgur.com/tNnV2wl.jpg). Window Spy shows you basic information about the currently active window and the mouse position. (As you can see in the image, even though Chrome was the active window, Window Spy stays on top so we can see it) In the upper rectangle you can see in order: The [window title](https://i.imgur.com/lhZsUna.png), the window class (in FL Studio, plugins are of class TPluginForm, the mixer is TFXForm, etc), the window's executable (chrome.exe in this instance or FL64.exe when it's FL Studio) and Pid (process ID) is an arbitrary number given to every exe running. And like for processes, every single window also has an ID. So every time a window is spawned, your operating system gives it an arbitrary number to distinguish it from others and AHK can access this number.

Summary: Windows can be distinguished with there title, class, exe, pid and id. Title: It's usually the text on top, it can change. Class:  It's always the same for a particular window but many window can have the same class. Exe: in our case, we only want FL64.exe windows. Pid: useless in our case. Id: It's new every time a window is spawned but it's unique. So in the script, once you're sure you found the window of interest, keep its ID and use only that to manipulate it.

Important: In FL, you need to [make all your windows Detached](https://i.imgur.com/i2Yd9KP.png). Otherwise, your operating system will only perceive FL Studio as one window.

<br/>

### First look at a script file:

A AHK script is a regular text file but its name should end with .ahk (instead of the regular .txt extension). Here's what it can look like:

    ; Lines starting with ";" are comments. They don't affect the code
    
    
    ; -- Part 1: The functions -----------------------
    ; When AHK reads this file, reading the functions doesn't do
    ; anything except knowing what to do when these functions
    ; will be called.
    function1()
    {
        ; do stuff
        return
    }
    
    sum(a, b)
    {
        return a + b
    }
    ; ----
    
    
    ; -- Part 2: the initial function calls ----------
    ; There might be one or two functions you want to be called
    ; immediately after the script starts. Maybe create a gui, etc.
    ; ex:
    
    function1()
    answer := sum(2, 2)
    ; ----
    
    
    ; -- Part 3: the HotKeys ------------------------
    ^{F1}::                ; This line is a hotkey. (^ means Ctrl)
        function1()        ; Ctrl+F1 will call function1
        return             ; return means the execution stops there
                           ; otherwise, the code in the next hotkey
                           ; would be executed too.
    
    ^p::                   ; Ctrl+p would calculate 4 + 7
        sum(4, 7)
        return
    ; ----
    
    ; -- Part 4: the GoTos ---------------------------
    ; GoTos are like functions, but more basic.
    ; They are useful in a few cases (for us, we will use a clock
    ; that will periodically check the currently active window)
    ; In AHK, Clocks can't trigger a regular function, but they
    ; can trigger a GoTo so that's why we use them.

    CLOCK_TICK:
        WinGetClass, currWinClass, A
        ; If the "CLOCK_TICK" Goto is called while the mixer is open,
        ; currWinClass will be a string of value "TFXForm"
        return 
    ; ----

In this code example, I used [WinGetClass](https://www.autohotkey.com/docs/commands/WinGetClass.htm). The AHK documentation is very useful. It's not important (or possible) to remember everything. Also, this [doc page](https://www.autohotkey.com/docs/KeyList.htm) is useful to know that \^ means Ctrl, ! means Alt, etc.

It is possible to split a script into multiple files for clarity. So for example, you could put your functions, hotkeys and gotos in their respective files. The main  script could then look like this:

    #Include functions.ahk
    
    ; -- initial function calls ----
    function1()
    answer := sum(2, 2)
    ; ----

    #Include hotkeys.ahk
    #Include gotos.ahk

And finally, I suggest you edit your code with [VSCode](https://code.visualstudio.com/) and when prompted, accept to install the suggested ahk plugin so your code looks like [this](https://i.imgur.com/KLOzuCM.jpg).

&#x200B;

### The interesting part: keeping track of the FL Studio windows

We will make a clock that will periodically look at the current window and decide if we want to keep track of it. I chose to keep two window histories. One for the plugins and another one for the main windows (channel rack, piano roll, mixer, etc). Then we will set {Tab} to activate the previously active plugin and {Caps} for the previous main window. And Pressing these keys with Ctrl will do the same but go forward in the history.

    ; these functions start and stop our clock
    ; The clock will trigger a Goto called "WINDOW_HISTORY_CLOCK"
    ; every 500 milliseconds
    
    startWinHistoryClock()
    {
        SetTimer, WINDOW_HISTORY_CLOCK, 500
    }
    
    stopWinHistoryClock()
    {
        SetTimer, WINDOW_HISTORY_CLOCK, Off           
    }

When the program starts, we can start our clock immediately.

    startWinHistoryClock() 

Here's our Goto:

    WINDOW_HISTORY_CLOCK:
        winHistoryTick()
        return
    
    ; I like to always work with regular functions so the GoTo
    ; just calls a function.

&#x200B;

### The winHistoryTick function:

*tick as the sound a clock does*

This function is called every 500ms unless the clock is stopped. I will write a basic version of it first in order to highlight the important parts. And just before the function, we will create a variable where the history will be kept in memory.

    ; for this example, we will keep only one history for both plugins and main windows

    global winHistory := []
    ; "global" means this variable is accessible from any function.
    ; [] means it's an Array. An array is a collection of values.
    ; In our case, these values will be window ids.
    
    global winHistoryIndex := 1
    ; The index is where we are in the history. By default,
    ; we area always at 1, but if we go back, the index will be 2
    ; then 3, etc. If there are 3 windows, going back again will
    ; go to 1.
    
    winHistoryTick()
    {
        WinGet, id, ID, A  
        ; I suggest you google "ahk WinGet" in order to read the doc
        ; Basically, it gets the id of the currently active window.
           
    
        
        ; I will show the following functions later, but
        ; they do pretty much what their names say.
        ; Do stuff only if it's a FL Studio Window
        ; and only if it is 
        ; not the same we saw at the last tick
        if (isFLWindow(id) and justChangedWindow(id))
        {
    
            
            index := inWinHistory(id, mode)
            ; this checks if the current id is already somewhere
            ; in the history

            ; if for example, it was the 3rd window in the history,
            ; index will be 3. We would then remove it from
            ; this position because we will later put it
            ; first in the history
            ; And if index is null, it means it wasn't in the history
            ; and we don't have to remove it
            if (index)    
                removeWinFromHistory(index, mode)
    
            ; this puts the id in the history at the current index
            registerWinToHistory(id)
        }
    }

Now here are the functions used in this winHistoryTick() example:

    isFLWindow(id)
    {
        WinGet, exe, ProcessName, ahk_id %id%
        return exe == "FL64.exe"
    }
    
    justChangedWindow(id)
    {
        return id != winHistory[winHistoryIndex] 
    }
    
    removeWinFromHistory(index)
    {
        winHistory.RemoveAt(index)
        
        if (winHistoryIndex >= index)
            winHistoryIndex -= 1
        ; We might change the index because
        ; if the window we were looking at before
        ; was 3rd in history and we remove the 2nd
        ; then the 3rd becomes the 2nd
    }
    
    registerWinToHistory(id)
    {
        winHistory.InsertAt(winHistoryIndex, id)
    }

Here are the hotkeys:

    Tab::
        activatePrevWin()
        return
    
    ^Tab::
        activateNextWin()
        return

And the functions they call:

    activatePrevWin()
    {
        winHistoryIndex += 1
        if (winHistoryIndex > winHistory.MaxIndex())
            winHistoryIndex := 1
        id := winHistory[winHistoryIndex]
    }
    
    ; The function activateNextWin would be very similar, except
    ; the index would decrease. Btw, in AHK, the first index
    ; of an array is 1. So if decreasing the index makes it equal
    ; to zero, we would loop
    ; and make it equal to winHistory.MaxIndex()

<br/>
### Summary

For the sake of this explanation, I simplified a bit these functions in order to display their key features. For example a missing feature in activatePrevWin() considers the case where the previous window in the history has been closed. We could check if it's still open with [WinExist](https://www.autohotkey.com/docs/commands/WinExist.htm). If not, we would get rid of this id from the history and make the same verification for the next window until we find one that is still open. (or until we realize there are no other opened window)

Also, in the script I actually use, I keep an history for plugins and another one for windows like the channel rack, mixer, etc. I really like the user experience it makes. To do that, keep two window historys (two global arrays) and two global indexes. In winHistoryTick(), you can check if the current window is a plugin by looking at its class (TPluginForm for plugins, TWrapperPluginForm for plugins loaded inside Patcher) or a main window (Channel Rack: TStepSeqForm, Pianoroll EventEditor and Playlist: TEventEditForm, Mixer: TFXForm).

&#x200B;

You can look at the actual script I use which is more detailed:

[The winHistory functions page](https://github.com/francoismartineau/FLahk/blob/master/utils/winHistory.ahk)

[The clocks page](https://github.com/francoismartineau/FLahk/blob/master/run/clock.ahk)

[The gotos page](https://github.com/francoismartineau/FLahk/blob/master/run/goto.ahk)

[The hotkey page](https://github.com/francoismartineau/FLahk/blob/master/hotkeys/hotkeys.ahk) featuring the Tab, \^Tab, Caps, \^Caps hotkeys

All these pages are included in the [main page](https://github.com/francoismartineau/FLahk/blob/master/FLahk.ahk) which is the actual file I tell ahk to read in order to run the script.

&#x200B;

Feel free to ask more specific questions!