#python3 trim_ltas_batch.python praat /output/ltas_trim_nopitchcorrect_0.075sec /vot/data/out_tg 0 0.075 70 True
import os, sys

script_dir=os.getcwd()
script_path = script_dir+"/vowel_detector.praat"
pipeline_dir=script_dir+"/../../"
praat_path = sys.argv[1]
input_folder = pipeline_dir+"output/production_extraction"


smoothing = 10
threshold = 0.08
mindur = 0
technique = "Amplitude"

output_folder = pipeline_dir + sys.argv[2] + f'_{technique.lower()}_smooth{smoothing}_threshold{threshold}_min{mindur}' #/output/ltas_trim

quiet = sys.argv[3]

print(quiet)

folders=os.listdir(input_folder)
print('running for task builder v2'
      '')
print(f'running over {len(folders)} folders')
not0 = []


print(folders)
for p in folders:

    import os

    if not os.path.exists(f'{output_folder}/{p}'):
        os.mkdir(f'{output_folder}/{p}')

    command = f'{praat_path} --run {script_path} "Multiple file" {input_folder}/{p}/ {output_folder}/{p}/ .wav Butterworth 900 2000 {smoothing} {technique} {threshold} Both {mindur} 1'

    if quiet == 'True':
        command += " >/dev/null 2>&1"
    else:
        print(command)
    out = os.system(command)

    if out != 0:
        not0.append(i)
    fs = [0]
    print(f'{len(fs) - len(not0)}/{len(fs)} completed successfully for participant {p}')
print('done')