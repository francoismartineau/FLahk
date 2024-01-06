Class GetWords
{
    static __num := 1
    static choosingNum := False
    static rightClickGenWords := False
    incrNum(dir)
    {
        GetWords.__num += {"up": 1, "down": -1}[dir]
        GetWords.__num := Max(1, GetWords.__num)
        tempMsg("num: " GetWords.__num)
    }
    gen(num := "")
    {
        if (num != "")
            GetWords.__num := num
        toolTip("Generating word" (GetWords.__num > 1 ? "s": "") "...")
        cmd := Paths.python " " Paths.Words "\get_pseudo_words.py" ;"\wikipedia_scrapper\random_words.py"
        cmd := cmd " --num " GetWords.__num
        ;cmd := cmd " --from_file "
        while (!words)
            words := SysCommand(cmd)
        toolTip()
        words := removeBreakLines(words)
        return words
    }
}