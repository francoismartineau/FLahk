

msg = ""

for i in range(127):
    msg += "MidiControlChange{0}:\n   knobCCIn({0})\n    return\n".format(i)


print(msg)