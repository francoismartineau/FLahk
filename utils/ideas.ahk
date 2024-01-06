global ideas := []
ideas.Push("Avant de toucher à l'ordi:`r`nDessine une toune")
ideas.Push("Chante dans le cell,`r`nImporte la mélodie")
ideas.Push("Pas de chords:`r`nMélodie simple, occasionnelle")
ideas.Push("Stereo Arp style Donna Summer / Giorgio Moroder")
ideas.Push("FM -> Edison -> Ps")
ideas.Push("Arp (none), Delay-4-pitchs montant`r`n`r`nEnregistrer to Edison et Sequence de ça")
ideas.Push("Compose sans son. ""Dessine""`r`nLorsque tu es prêt, mets les écouteurs.")
ideas.Push("Ostinato:`r`nRépéter de n'importe quoi de manière insistante.`r`nGamme étrange? 12 tons? À l'extérieur des tons? Ok!")
ideas.Push("Un synth dont le pitch est contrôlé par un knob / peak sur son ostinato")
ideas.Push("Sample sur rythme prévisible, Accords sur le même rythme.`r`nRevenir au sample, remplacer une instance de sample par un accord, loop, une autre instance, loop, et ainsi de suite.")
ideas.Push("Autom channel ""shift"" et ""swing"" pour que ça drift dans le temps")
ideas.Push("Voix choppées")
ideas.Push("Ouvre un ancien projet et crée une template avec")
ideas.Push("Graph Editor")
ideas.Push("Autom mutée, déclencher avec notes. (est LFO complexe)")
ideas.Push("Typing keyboard only, pas de feedback")
ideas.Push("Render drums?")
ideas.Push("Rec on play, mouse on slcx keyboard")


; --------------------------------------------------
displayRandomOpeningIdea()
{
    title := ""
    Loop 20
        title := title "" randomChoice([" ", "🎲"])
    message := randomChoice(ideas)
    msgBox(message, title)
}

displayRandomIdea()
{
    idea := randomChoice(ideas)
    unfreeze := True
    waitToolTip(idea, unfreeze)
}