import os, random

hasard = 10

def pick_dir(root):
    global hasard
    hasard = max(0, hasard-1)
    all_files = os.listdir(root)
    all_files = list(map(lambda f: os.path.join(root, f), all_files))
    dirs = list(filter(lambda f: os.path.isdir(f), all_files))
    if random.randint(0, hasard) == 0 or len(dirs) == 0:
        return root
    else:
        d = random.choice(dirs)
        return pick_dir(d)


d = pick_dir(r'C:\Program Files\Image-Line\FL Studio 20\Data\Patches\Packs')
print(d)