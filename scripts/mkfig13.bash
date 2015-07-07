#!/bin/bash

source $STARLINK_DIR/etc/profile

kappa

export PGPLOT_PS_FONT=Times

imag1="'../data/horsehead-specx(-74:75,-70:104,)'"
imag2="'../data/horsehead-pipeline-align(-74:75,-70:104,)'"
datamin=0
datamax=35

gdset /avcps
lutcubehelix0

echo "Colour=black" > sty
echo "Colour(ticks)=black" >> sty
echo "Colour(border)=black" >> sty
echo "drawtitle=0" >> sty
echo "Width=3" >> sty

gdclear
picdef mode=a xpic=2 ypic=1 prefix=a outline=no
display $imag1 margin=\[0.15,0,0.15,0.15\] axes badcol=gray nokey mode=sc low=$datamin high=$datamax \
                   style=^sty accept

picsel a2
display $imag2 margin=\[0.15,0.15,0.15,0\] axes badcol=gray mode=sc low=$datamin high=$datamax \
                   style="'^sty,drawtitle=0,numlab(2)=0,textlab(2)=0'" key keypos=0.02 keystyle="'Color=black'" accept

epstopdf pgplot.ps
rm pgplot.ps
pdfcrop pgplot.pdf final.pdf

