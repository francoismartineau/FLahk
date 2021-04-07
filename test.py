import math, random, sys
import os, re


def draw():
    for i in range(30):
        n = randExp(.5, 0, 127)
        print(n)


def randExp(c, min, max):
    return int(min + (random.random() ** c)* max)


def format_folder_name(path):
    folder_name = os.path.dirname(path)
    folder_name = os.path.basename(path)
    words = re.split(" |-", folder_name)
    if words[0].isdigit():
        words = words[1:]
    words = list(filter(lambda w: len(w) > 0, words))
    words = words[0] + "".join(list(map(lambda w: w[0].upper() + w[1:], words[1:])))
    return words

def format_sound_cut_option(longueur, noise_gate):
    word = ""
    if longueur:
        if longueur < 1:
            word = "short"
        elif longueur < 2:
            word = "mid"
        else:
            word = "long"
    elif noise_gate:
        word = "{}dB".format(noise_gate)
    return word


PATH = r"C:\Program Files (x86)\Image-Line\FL Studio 20\Data\Patches\Packs\5   Kits\pro dj-funky"
num = 13
longueur = 0
noise_gate = 6
output_dir = "C:\\Program Files (x86)\\Image-Line\\FL Studio 20\\Data\\Patches\\Packs\\_gen"

def get_output_name():
    num = 0
    folder_name = format_folder_name(PATH)
    sound_cut_option = format_sound_cut_option(longueur, noise_gate)
    output_name = "_".join([folder_name, "n"+str(num), sound_cut_option])
    temp_output_name = output_name
    nth_instance_of_name = 1
    for f in os.listdir(output_dir):
        if f.lower().endswith('.wav'):
            name = os.path.basename(f)[:-4]
            if temp_output_name == name:
                nth_instance_of_name += 1
            if (nth_instance_of_name > 1):
                temp_output_name = "{}_{:02d}".format(output_name, nth_instance_of_name)
    output_name = temp_output_name + ".wav"
    return output_name




