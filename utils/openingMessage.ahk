global openingMessages := []
openingMessages.Push("Avant de toucher à l'ordi:`r`nDessine une toune")
openingMessages.Push("Chante dans le cell,`r`nImporte la mélodie")
openingMessages.Push("Pas de chords:`r`nMélodie simple, occasionnelle")
openingMessages.Push("Stereo Arp style Donna Summer / Giorgio Moroder")
openingMessages.Push("FM -> Edison -> Ps")
openingMessages.Push("Arp (none), Delay-4-pitchs montant`r`n`r`nEnregistrer to Edison et Sequence de ça")
openingMessages.Push("Compose sans son. ""Dessine""`r`nLorsque tu es prêt, mets les écouteurs.")
openingMessages.Push("Ostinato:`r`nRépéter de n'importe quoi de manière insistante.`r`nGamme étrange? 12 tons? À l'extérieur des tons? Ok!")
openingMessages.Push("Un synth dont le pitch est contrôlé par un knob / peak sur son ostinato")
openingMessages.Push("Sample sur rythme prévisible, Accords sur le même rythme.`r`nRevenir au sample, remplacer une instance de sample par un accord, loop, une autre instance, loop, et ainsi de suite.")
openingMessages.Push("Autom channel ""shift"" et ""swing"" pour que ça drift dans le temps")


displayRandomOpeningMessage()
{
    title := ""
    Loop 20
        title := title "" randomChoice([" ", "🎲"])
    message := randomChoice(openingMessages)
    msgBox(message, title)
}