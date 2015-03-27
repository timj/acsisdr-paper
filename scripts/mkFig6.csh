#!/bin/csh

# The dataset used to make this graphics was created as follows:
#   timesort a20080711_00007_01_raw0002 a20080711_00007_01_ts002
#   ndfcopy a20080711_00007_01_ts002"(1875:2230,8,1:312)" fig6ts trim trimwcs
#   wcsattrib fig6ts set Format'(2)' '%g'
#   wcsattrib fig6ts set timeorigin 54658.271689
#   wcsattrib fig6ts set Unit"(2)" s

# Annotate with the Times fount (introduced 2015 Feb 6).
setenv PGPLOT_PS_FONT Times

gdset pscol_l
gdclear

# Mimic Xwindows aspect ratio.  The right panel is drawn slighly
# smaller than the left if the default apscol_l aspect ratio is used.
# This leaves a gap but that's desirable to not highlight the slightly
# different pixe-to-WCS mappings.
picdef mode=bl aspect=1.44 nooutline

cat >! Fig6.sty << EOF
Size(NumLab)=1.3
Size(TextLab)=1.3
TextLabGap=0.02
DrawAxis(2)=1
DrawDSB=0
Label(2)=Time
Colour=Black
DrawTitle=0
Colour(Ticks)=Yellow
EOF

cat >! Fig6_key.sty << EOF
Colour=black
Size=1.3
NumLabGap=0.05
TextBackColour=clear
Colour(Ticks)=Yellow
EOF

display fig6ts mode=sc low=-11 high=4 margin="[0.15,0.15,0.0,0.15]" key \
        style=^Fig6.sty keystyle=^Fig6_key.sty \
        lut=$KAPPA_DIR/blulut_lut keypos=0.0

# Convert to PDF and crop whitespace edges.  For some reason the landscape graphic 
# is rotated to portrait, so rotate by 90 degrees clockwise (east).
epstopdf pgplot.ps
pdfcrop pgplot.pdf Fig6.pdf
pdftk Fig6.pdf cat 1east output high_freq_three_types.pdf
\rm pgplot.ps pgplot.pdf Fig6.pdf
