#
#
#

form dynamic segmenter
	sentence MainPipelineDirectory /mnt/c/Users/cat4624/Documents/projects/production_tones/analysis/pilot_ct/pipeline_scripts
	sentence ParticipantID PILOT_CT
endform
Erase all
clearinfo

#####FUTURE: add check box for mac
mac=1
os_slash$ = "\"
if mac
	os_slash$="/"
endif

inDirAudio$ = "'MainPipelineDirectory$''os_slash$'input'os_slash$'raw'os_slash$''ParticipantID$''os_slash$'"
outDir$ = "'MainPipelineDirectory$''os_slash$'output'os_slash$'production_extraction'os_slash$''ParticipantID$''os_slash$'"

#wavListFileName$="'ParticipantID$'_wavlist.txt"
#textgridListFileName$="'ParticipantID$'_texgrid.txt"

createFolder: outDir$

Create Strings as file list: "soundFileObj",  "'inDirAudio$'*.wav"
number_of_files = Get number of strings
for i from 1 to number_of_files
	selectObject: "Strings soundFileObj"
	current_file$ = Get string: 'i'
	name_prefix$ = current_file$ - ".wav"
	Read from file: "'inDirAudio$''current_file$'"
	
	
	To Intensity... 50 0.001
	mean_intensity = Get mean... 0.0 0.0
	max_intensity = Get maximum... 0.0 0.0 parabolic
	#appendInfoLine: max_intensity
	mean_intensity = 0 - (max_intensity-mean_intensity)
	if max_intensity > mean_intensity
	nowarn To TextGrid (silences)... mean_intensity 0.01 0.05 silent sounding

	selectObject: "Sound 'name_prefix$'"
	plusObject: "TextGrid 'name_prefix$'"

	Extract intervals where... 1 no "is equal to" sounding


	sounds# = selected# ("Sound")
	end_time_highest=0
	index_of_highest=0
	for x to size (sounds#)
		selectObject: sounds# [x]
		output_name$ = selected$ ("Sound")
   		end_time = Get end time
		
		if end_time > end_time_highest
			end_time_highest = end_time
			index_of_highest = x
		else
			Remove
  		endif

		#appendInfoLine: "index: ", x 
	endfor
	selectObject (sounds#[index_of_highest])
	output_name$ = selected$ ("Sound")
	#nowarn Resample... 16000 50
	#Convert to mono

	wavFileName$="'outDir$''output_name$'.wav"
	textgridFileName$="'outDir$''output_name$'.TEXTGRID"
	

		#if i == 1
			#writeFileLine: "'wavListFileName$'", "'wavFileName$'"
			#writeFileLine: "'textgridListFileName$'", "'textgridFileName$'"
		#else
			#appendFileLine: "'wavListFileName$'", "'wavFileName$'"
			#appendFileLine: "'textgridListFileName$'", "'textgridFileName$'"
		#endif

	nowarn Save as WAV file: "'wavFileName$'"
	nowarn To TextGrid... VOT_window
	nocheck Insert boundary... 1 0.18
	nocheck Set interval text... 1 1 VOT
	Save as text file: "'textgridFileName$'"

## finish and clear  
  select all
    minusObject: "Strings soundFileObj"
    Remove
else
    appendInfoLine: "could not run analysis for file"
endif
endfor
select all
Remove
