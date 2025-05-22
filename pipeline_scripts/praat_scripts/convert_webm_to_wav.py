## Extract just audio from webm file
import os
import subprocess

fs = os.listdir('../../input/uploads_webm')
print('starting')
for f in fs:
    if f.split('.')[1]!='webm':
        continue
    else:
        subprocess.run(['ffmpeg', '-i',  f'../../input/uploads_webm/{f}', '-vn', f'../../input/uploads/{f.split(".")[0]}.wav'])
print('done')