rsync -r -a -v --exclude ".git" --exclude "pi" --exclude "vendor" --exclude ".bundle" -e "ssh -l pi -p 2222" /home/torsten/ruby-x/rubyx localhost:/home/pi/
#afplay /System/Library/Sounds/Morse.aiff
