# extractVideoClips
# -----------------
#
# Rubyscript for Datavyu that extracts video clips defined by the cells in a specified column. The 
# script generates a batch script (for Windows) which calls ffmpeg with appropriate parameters. 
# Selected codes of the cells are added as metadata (title and comment) to the clips.
#
# Settings need to be adjusted to your needs (see variable definitions after MAIN SETTINGS below. 
#
# ffmpeg needs to be installed on the system. For more details: https://ffmpeg.org/ffmpeg.html
#
# Written by Laura Mandt, Julius Verrel, Robin Nehls
# Max Planck Institute for Human Development, Berlin 
#
 
require 'Datavyu_API.rb'


begin
	# MAIN SETTINGS(ADJUST TO YOUR SYSTEM AND REQUIREMENTS)
	outputDir = "~/Desktop/Video-Tool/VideoClips/"  # output path for batch file and video clips
	batCommand = 'extractClips.bat'					# name of batch file
	videoColumn = 'video'                          	# name of the column defining the video clips
    infoName = 'info'								# name of cell code n videoColumn, that contains
													# general info to be included as metadata (title)
	commentName = 'comment'							# name of cell code n videoColumn, that contains
													# comment to be included as metadata (comment)
	ffmpegCommand = 'ffmpeg'						# command for calling ffmpeg. Add path in case
													# ffmpeg is not found on system path
	ffmpegPreset = 'ultrafast'                    	# specifies video quality. Possible presets: 
													# ultrafast,superfast, veryfast, faster, fast, 
													# medium, slow, slower, veryslow, placebo 
													# (https://trac.ffmpeg.org/wiki/Encode/H.264)
    ffmpegAudio = '-an' 							# Audio input. -an means NO audio input. 
													# (https://ffmpeg.org/ffmpeg.html#Audio-Options )
    ffmpegCode = 'libx264'                         	# Encoder used for video extraction 
													# (https://ffmpeg.org/ffmpeg.html#Main-options)

	
	# FILE NAMES AND DIRECTORIES
	out_file = File.expand_path(outputDir) +'/'  	# output path
	command = File.new(out_file + batCommand, 'w')	# batch file name
	
	# GET FILE NAME OF CURRENT VIDEO
	dvs = $viewers.dataViewers.toArray   			# get data viewers (one for each media source)
	if dvs.length>0  								# if vide files attached:
		videoFileName = dvs[0].getDataFeed			# 	take first media file (THIS CAN BE CHANGED)
	else											# otherwise
		raise "No connection to video." 			# 	error message
	end

	# GET VIDEO COLUMN FROM DATAVYU SPREADSHEET			
	columns = getColumnList() 						# get column list  
	
	if columns.include?(videoColumn) 							
		video = getVariable(videoColumn)			# get video-column if it exists		
	else
		raise "No column called "+ videoColumn + "!"
	end
	
	# GENERATE BATCH SCRIPT
	#
	# Script loops through cells in column videoColumn, generating one ffmpeg command for each cell
	# to generate corresponding video clip. the batch script needs to be executed to actually run
	# ffmpeg and extract the video clips.
	
	in_video = videoFileName 
	projectName = $pj.getProjectName
	count = 0 										# count trial numbers - included in name of video
	
	# loop that goes through all cells in the video-column
	for cell in video.cells	
			
		# check names for special characters, thus that files can be generated (because filenames cannot contain some special characters)
		info = eval('cell.'+infoName).gsub(/[ ,:;=.*\/]/, '_') 	# substitute special characters with "_"
		comment = eval('cell.'+commentName).gsub('"', "'") 		# comments cannot contain '"' - characters
			
		count = count.to_i + 1 									# count number of videos
        out_video = count.to_s + "_Trial.mp4" 					# video-file names
		duration = cell.offset - cell.onset						# calculate duration of video
		
		# adding metadata to video: http://wiki.multimedia.cx/index.php?title=FFmpeg_Metadata
		metaTitle = projectName + ',' + info  					# include project name and information about specific video-clip in main title of video
		metaComment = '"' + comment + '"'
		
		# 'command.syswrite' writes all information into the bat-file that is needed to generate the videos from the command-line
		# put start time at beginning for faster search
		# add metadata("info" is added in title and "comment" in comment of video-file)
		command.syswrite("ffmpeg -ss " + (cell.onset/1000.0).to_s + " -i "  + in_video.to_s  + " -metadata title=" + metaTitle + " -metadata comment=" +  metaComment +  " -c:v " + ffmpegCode + " -preset " + ffmpegPreset + " -crf 22 " + ffmpegAudio +  " -t " + (duration.to_i/1000.0).to_s + " " + out_video + "\r\n")
	
	end	
	puts count.to_s + " videos should be generated. Check text in 'info' and 'comment' for special characters if filenumbers don't match."
end		
