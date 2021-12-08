browsePostGen()
{
    genPath := packsPath "\_gen"
    weights := [fileNumInDir(genPath)]
    i := 2
    genFolderQty := 3
    while (i <= genFolderQty)
    {
        weights.Push(fileNumInDir(genPath . i))
        i := i + 1
    }
    genNum := weightedRandomChoiceIndexOnly(weights)
    foldersBeforeGen1 := 1
    browsePacks(genNum + foldersBeforeGen1, "postGen")
}