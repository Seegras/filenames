#!/bin/sh
#
# sorts gopro-files to the correct order
#
# Author:   Peter Keel <seegras@discordia.ch>
# Date:     ?
# Revision: 2019-10-08
# Version:  0.1
# License:  Public Domain
# 
rm ./*.THM 2> /dev/null
mmv '*.JPG' '#1.jpg'> /dev/null 2>&1
mmv '*.MP4' '#1.mp4'> /dev/null 2>&1
mmv 'GOPR*.mp4' 'GO-#1-00.mp4'> /dev/null 2>&1
mmv 'GP??*.mp4' 'GO-#3-#1#2.mp4'> /dev/null 2>&1
mmv 'GOPR*.mkv' 'GO-#1-00.mkv'> /dev/null 2>&1
mmv 'GP??*.mkv' 'GO-#3-#1#2.mkv'> /dev/null 2>&1

