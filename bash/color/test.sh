# only works on machines with tput on them (linux)
# tput is ncurses for shell scripting, really complex!

text="Hello, World!"
moretext="More text!!"

tput blink && \
tput setab 7 && \
tput setaf 4 && \
echo $text && \
tput sgr0

tput smso && \
tput bold && \
tput smul && \
echo $moretext && \
tput sgr0

