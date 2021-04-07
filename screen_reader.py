#pip intall future
#pip intall opencv_python
#pip intall desktopmagic
#pip intall pywin32


#from __future__ import log_function
import os, sys, cv2, pytesseract, ctypes, time

from PIL import Image
from desktopmagic.screengrab_win32 import getScreenAsImage
pytesseract.pytesseract.tesseract_cmd = r'C:/Program Files/Tesseract-OCR/tesseract'

x = int(sys.argv[1])
y = int(sys.argv[2])
w = int(sys.argv[3])
h = int(sys.argv[4])
word = sys.argv[5]

interpolation = 10
debug = False

#----------------------------------------------------------------
def xywh2ltrb(x, y, w, h):
    left = x + 1920
    top = y
    right = x + w + 1920
    bottom = y + h
    return left, top, right, bottom

def msg_box(msg):
    ctypes.windll.user32.MessageBoxW(0, msg, "", 1)

def search_word(img):
    global word
    _, imgH = img.size
    letter_count = 0
    error_count = 0
    wordCoords = []
    success = False
    for b in pytesseract.image_to_boxes(img).splitlines():
        b = b.split(' ')
        letter = b[0]
        if letter == word[letter_count]: # ou si error ajoutée dernièrement, regarder pour letter_count-1
            letter_count += 1
            left, bottom, right, top = int(b[1]), imgH - int(b[2]), int(b[3]), imgH - int(b[4])
            if letter_count == 1:
                wordCoords = [left, top]
            elif letter_count == len(word):
                wordCoords.extend([right, bottom])
                success = True
        else:
            error_count += 1
            if error_count > len(word)/3:
                wordCoords = []
                letter_count = 0
                error_count = 0
        if success:
            break
    return success, wordCoords

def log_to_file(x, y):
    with open("screen_reader_log.txt", "w") as f:
        f.write("x: {} y: {}".format(x, y))


        


#---------------------------------------------------------------------------------
if __name__ == '__main__':
    try:
        if debug:
            img = Image.open("test.png")
        else:
            img = getScreenAsImage()
            left, top, right, bottom = xywh2ltrb(x, y, w, h)
            img = img.crop((left, top, right, bottom))
            img = img.resize((w*interpolation, h*interpolation))
            img.save("test.png")
        
        
        result, coords = search_word(img)
        if result:
            left, top, right, bottom = coords[0], coords[1], coords[2], coords[3]
            x = int((left + (right-left)/2) / interpolation) 
            y = int((top + (bottom-top)/2) / interpolation)
            print("{} {} ".format(x, y))        # This is the answer FLahk gets. The last space is important.
            log_to_file(x, y)
        else:
            log_to_file("resultat:", pytesseract.image_to_string(img))
    except Exception as e:
        print(e)
        log_to_file(e, 0)
