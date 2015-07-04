#!/bin/csh
# Assumes the KAPPA definitions are available.

# Annotate with the Times fount (introduced 2015 Feb 6).
setenv PGPLOT_PS_FONT Times

# Obtain approximately the aspect ratio used originally.
setenv PGPLOT_PS_HEIGHT 29940
setenv PGPLOT_PS_WIDTH 10500  # Should be the default

gdset apscol_l

cat >! Fig9.sty << EOF
Size(NumLab)=1.3
Size(TextLab)=1.3
Colour=Black
DrawTitle=0
Width=3
EOF

# Not sure if the first is the one used in the original submission
# but it's close if not.
linplot edginessH07 mode=gaphist \
        style="'^Fig9.sty,colour(curve)=black'" \
        margin="[0.15,0.1,0.05,0.15]"

# Convert to PDF and crop whitespace edges.  For some reason the landscape graphic
# is rotated to portrait, so rotate by 90 degrees clockwise (east).
epstopdf pgplot.ps
pdfcrop pgplot.pdf Fig9.pdf
pdftk Fig9.pdf cat 1east output raw_edginess_profile.pdf
\rm pgplot.ps pgplot.pdf Fig9.pdf Fig9.sty

