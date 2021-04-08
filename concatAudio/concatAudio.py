import os, sys, ctypes, random, traceback, argparse, re
import pyperclip, soundfile


""" 
    Concatenates randomly chosen sounds in one sound file.
    The resulting file is created in FL Studio's Packs/_gen3 folder.

    --paths One or more paths containing candidate sounds. Subfolders will be browsed too.
    --num Number of sounds to concatenate
    --len Length of every sound (0 to deactivate and use --gate)
    --gate When this dB threshold is reached, the sound is cut (ex: -20) (0 to deactivate and use --len)

"""
packs_path = r"C:\Program Files\Image-Line\FL Studio 20\Data\Patches\Packs"
PATHS = ""
num = 0
longueur = 0
noise_gate = 0
fade_len = .3   # * .1 sec

#--------------------------------------------------------------------------------------
fade_len = fade_len *.1
fade_len = min(fade_len, longueur)
output_dir = os.path.join(packs_path, "_gen3")
temp_prefix = '___temp'
max_msg_box = 10

#--------------------------------------------------------------------------------------
def get_args():
    global packs_path, PATHS, num, longueur, noise_gate
    parser = argparse.ArgumentParser(description='Concatenante multiple audio files.')
    parser.add_argument('--paths', nargs='+', action="store", dest="PATHS", 
                        default=[packs_path], help='root(s) of folder search')
    parser.add_argument('--num', action="store", type=int, dest="num", default=10, help='number of sounds')
    parser.add_argument('--len', action="store", type=float, dest="len", default=0, help='lenght of each sample')
    parser.add_argument('--gate', action="store", dest="gate", default='0', help='threshold of noisegate')
    arg_results = parser.parse_args()
    PATHS = arg_results.PATHS 
    num = arg_results.num
    longueur = arg_results.len
    noise_gate = arg_results.gate

def get_input_path():
    input_paths = PATHS
    for i_p in input_paths:
        assert os.path.isdir(i_p)
    return input_paths

def get_sounds(paths):
    sounds = []
    for p in paths:
        sounds += get_sounds_recursive(p)
    return sounds

def get_sounds_recursive(root, snds=[]):
    for s in os.listdir(root):
        path = os.path.join(root, s)
        if os.path.isdir(path):
            get_sounds_recursive(path, snds) 
        elif is_sound_file(path):
            snds.append(path)
    return snds

def is_sound_file(f):
    result = True
    _, ext = os.path.splitext(f)
    correct_exts = ['.wav', '.wv', '.mp3', '.aif', '.aiff', '.ogg']
    if ext.lower() not in correct_exts or os.path.basename(f).startswith('._'):
        result = False
    return result

def choose_some_sounds(snds):
    selection = []
    for _ in range(int(num)):
        selection.append(random.choice(snds))
    return selection

def gen_temp_files(snds):
    for i, s in enumerate(snds):
        print(type(s))
        if is_wav_vorbis(s):
            s = wav_to_ogg(s, i)
            snds[i] = s

        sr = get_samplerate(s) 
        cmd = 'ffmpeg -ss 00:00:00 -t {} -i "{}" -ar {} '.format(longueur, s, sr)
        num_samples = int(longueur*sr) #python has a built-in module to get the sample rate of a wav file. The module pydub gives mp3 sample rate.
        fade_start = int(num_samples - fade_len*sr)
        cmd += '-af '
        if longueur != 0:
            cmd += 'apad=whole_len={},afade=type=out:ss={}:d={}'.format(num_samples, fade_start, fade_len)
        elif noise_gate != 0:
            cmd += 'silenceremove=start_periods=0:start_duration=0:start_threshold=0:stop_periods=-1:stop_duration=0.01:stop_threshold={}dB'.format(noise_gate)
        output_path = os.path.join(output_dir, '{}{:02d}.wav'.format(temp_prefix, i))
        cmd += ' -y "{}"'.format(output_path)
        os.system(cmd)

def is_wav_vorbis(s):
    result = False
    b = b''
    with open(s, 'rb') as f:
        b = f.read()
    if b'ENCODER=vorbis.acm' in b:
        result = True
    return result

def wav_to_ogg(s, i):
    b = b''
    with open(s, 'rb') as f:
        b = f.read()
    offset = b.index(b'OggS')
    b = b[offset:]
    ogg_path = os.path.join(output_dir, '{}{:02d}.ogg'.format(temp_prefix, i))
    with open(ogg_path, 'wb') as f:
        f.write(b)
    return ogg_path

def get_samplerate(s):
    sr = 44100
    try:
        _, sr = soundfile.read(s)
    except:
        pass
    return sr

def gen_output():
    os.chdir(output_dir)
    temp_sounds = [s for s in os.listdir(output_dir) if os.path.basename(s).startswith(temp_prefix) and os.path.basename(s).endswith('.wav')]
    txt_path = os.path.join(output_dir, "{}.txt".format(temp_prefix))
    txt = open(txt_path, 'w')
    for s in temp_sounds:
        txt.write("file '{}'\n".format(os.path.join(output_dir, s)))
    txt.close()
    output_name = get_output_name()
    msg_box(output_name, copy=True)
    cmd = 'ffmpeg -f concat -safe 0 -i "{}" -c copy -y "{}.wav"'.format(txt_path, os.path.join(output_dir, output_name))
    os.system(cmd)

# --------------------------------------
def get_output_name():
    global PATHS, num, longueur, noise_gate
    folder_name = format_folder_name(PATHS)
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

def format_folder_name(paths):
    words = ""
    for i in range(len(paths)):
        folder_name = os.path.basename(paths[i])
        if folder_name[0].isdigit() or folder_name[0] == "_":
            folder_name = folder_name[1:]
        folder_name = list(filter(lambda c: c != " ", folder_name))
        folder_name = list(map(lambda w: w[0].upper() + w[1:], folder_name))
        words += "".join(folder_name)
        if (i < len(paths)-1):
            words += "_"
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

# --------------------------------------
def delete_temp_files():
    for f in os.listdir(output_dir):
        if f.startswith(temp_prefix):
            f = os.path.join(output_dir, f)
            os.remove(f)

def msg_box(*msg, copy=False, force=False):
    global max_msg_box
    if max_msg_box > 0 or force:
        output = ""
        for m in msg:
            output = output + str(m) + " "
        if copy:
            pyperclip.copy(output)
        ctypes.windll.user32.MessageBoxW(0, output, "", 1)
        max_msg_box = max_msg_box -1 

if __name__ == '__main__':
    try:
        delete_temp_files()
        get_args()
        input_paths = get_input_path()
        snds = get_sounds(input_paths)
        snds = choose_some_sounds(snds)

        gen_temp_files(snds)
        gen_output()
        delete_temp_files()
    except:
        msg_box(traceback.format_exc(), force=True)