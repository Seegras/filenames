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
rm *.THM 2> /dev/null
mmv '*.JPG' '#1.jpg' 2>&1 > /dev/null
mmv '*.MP4' '#1.mp4' 2>&1 > /dev/null
mmv 'GOPR*.mp4' 'GO-#1-00.mp4' 2>&1 > /dev/null
mmv 'GP??*.mp4' 'GO-#3-#1#2.mp4' 2>&1 > /dev/null
mmv 'GOPR*.mkv' 'GO-#1-00.mkv' 2>&1 > /dev/null
mmv 'GP??*.mkv' 'GO-#3-#1#2.mkv' 2>&1 > /dev/null

