#!/bin/csh

# Format the sky co-ordinates as desired.
wcsattrib ndf=ga20141117_23_2_integ mode=set name=format"(1)" newval=hms
wcsattrib ndf=ga20141117_23_2_integ mode=set name=format"(2)" newval=dm
wcsattrib ndf=12CO_AN-a-bottom_narrow_INTEG mode=set name=format"(1)" newval=hms
wcsattrib ndf=12CO_AN-a-bottom_narrow_INTEG mode=set name=format"(2)" newval=dm

# Annotate with the Times fount (introduced 2015 Feb 6).
setenv PGPLOT_PS_FONT Times

gdset apscol_l
gdclear

# Mimic Xwindows aspect ratio.  The right panel is drawn slighly
# smaller than the left if the default apscol_l aspect ratio is used.
# This leaves a gap but that's desirable to not highlight the slightly
# different pixe-to-WCS mappings.
picdef mode=bl aspect=1.6 nooutline

# Form to FRAME pictures.
picgrid 2 1 current nooutline

# Left panel
# ==========

# Left Panel: adjust the text labelling to fit inside the viewport and
# to make the plot less tall.  Enlarge the text by 20% to improve
# legibility.
picsel 1
display ga20141117_23_2_integ lut=$KAPPA_DIR/cubehelix0_lut nokey \
        style="'DrawTitle=0,Size=1.2,Colour(NumLab)=Black,TextLabGap(1)=0.03,TextLabGap(2)=0.01'" \
        margin="[0.15,0.0,0.15,0.15]" \
        mode=sc low=1 high=96

# Right panel: adjust the key attributes to make the text bigger and
# not overprint the key itself.  Make the margins the same as before
# except the horizontal margin is to the right for the key, whereas it
# was to the left in the left panel to accommodate the declination
# axis labelling.
picsel 2
display 12CO_AN-a-bottom_narrow_INTEG lut=$KAPPA_DIR/cubehelix0_lut key \
        style="'DrawTitle=0,Size=1.2,NumLab(2)=0,TextLab(2)=0,Colour(NumLab)=Black,TextLabGap(1)=0.03,TextLabGap(2)=0.01'"\
        margin="[0.15,0.15,0.15,0.0]" \
        keystyle="'Color=black,Size=1.3,NumLabGap=0.05,TextBackColour=clear'" \
        mode=sc low=1 high=96

# Convert to PDF and crop whitespace edges.  For some reason the landscape graphic
# is rotated to portrait, so rotate by 90 degrees clockwise (east).
epstopdf pgplot.ps
pdfcrop pgplot.pdf Fig12.pdf
pdftk Fig12.pdf cat 1east output 12CO_flat_comparison.pdf
\rm pgplot.ps pgplot.pdf Fig12.pdf
