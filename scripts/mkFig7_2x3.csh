#!/bin/csh

#+
#  Name:
#     mkFig7_2x3.csh

#  Purpose:
#     Creates Figure 7 graphic for ACSIS-DR MNRAS paper.

#  Language:
#     Unix C-shell

#  Invocation:
#     source Fig7_2x3.csh

#  Description:
#     This script creates The Figure 7 graphics for the ACSIS-DR paper.
#     The figure shows some examples of non-linear baselines arranged in
#     a 2 by 3 grid.  Smoothed spectra are show in red displaced from
#     the raw data drawn in black.  Only one pair of axis labels are
#     drawn.

#  Notes:
#     - Requires the raw data and smoothed offset NDFs.
#     - Currently only configured to run at JAC.
#     - It uses KAPPA picture manipulation tasks and LINMPLOT to make
#     PostScript file and then ps2pdf to create the PDF.

#  Output:
#     A PDF of the plot called examples_non-linear_baselines.pdf.

#  Prior Requirements:
#     -  KAPPA V2.1 or later.

#  Authors:
#     MJC: Malcolm J. Currie (JAC/EAO)
#     {enter_new_authors_here}

#  History:
#     2014 September 13 (MJC):
#        Original version.
#     2015 March 20 (MJC):
#        Rename from Fig6_2x3.csh.  Reduce the line width from 3 to 2.
#        Crop the PDF.
#     {enter_further_changes_here}

#-

# Set the plotting width.
set w = 2

# Set up a picture grid for an accumulating PostScript device.
gdset apscol_l
gdclear
picgrid 2 3 nooutline

# Very noisy low-amplitude oscillations
picsel 1
linplot spectra/a20090521_37_01_3 margin="[0.20,0.02,0.02,0.15]" mode=GapHist \
        style="'DrawDSB=0,Colour=Black,Size(NumLab)=1.2,Size(TextLab)=1.2,Width=$w,TextLab(1)=1,TextLab(2)=0,DrawTitle=0,NumLabGap(2)=0.02'"
linplot spectra/a20090521_37_01_3_sm27 noclear noaxes style=+colour=yellow

# Subtle wiggle
picsel 2
linplot /jcmtdata/raw/acsis/spectra/20091011/00038/a20091011_00038_01_0001"(101:937,8,1685)" ytop=3.5 \
        style="'DrawTitle=0,DrawDSB=0,Colour=Black,Size(NumLab)=1.2,Width=$w,TextLab=0,NumLabGap(2)=0.02'"
linplot spectra/a20091011_00038_01_8_plus2 noclear noaxes style=+colour=red

# Turn down and narrow waves.
picsel 4
linplot /jcmtdata/raw/acsis/spectra/20080821/00060/a20080821_00060_01_0001"(~90%,16,872)" ytop=3.5 \
        style="'DrawTitle=0,DrawDSB=0,Colour=Black,Size(NumLab)=1.2,Width=$w,TextLab=0,NumLabGap(2)=0.02'"
linplot spectra/a20080821_00060_01_16_plus2 noclear noaxes style=+colour=red

# Multiple deep waves
picsel 5
linplot /jcmtdata/raw/acsis/spectra/20071219/00030/a20071219_00030_01_0001"(~90%,10,1483)" ytop=24 ybot=-20 \
        style="'DrawTitle=0,DrawDSB=0,Colour=Black,Size(NumLab)=1.2,Width=$w,TextLab=0,NumLabGap(2)=0.02'"
linplot spectra/a20071219_00030_01_10_plus16 noclear noaxes style=+colour=red

# Big wave
picsel 6
linplot /jcmtdata/raw/acsis/spectra/20071123/00041/a20071123_00041_02_0001"(95:933,5,90)" ytop=8 \
        style="'DrawTitle=0,DrawDSB=0,Colour=Black,Size(NumLab)=1.2,Width=$w,TextLab=0,NumLabGap(2)=0.02'"
linplot spectra/a20071123_00041_02_5_plus6 noclear noaxes style=+colour=red

# Need to plot this cell last so that the long ordinmate label is not
# overwritten.  The length of the list of plotting attributes exceeds
# 132 characters, so write the attributes to an indirection file.
# Allow plenty of room for the label so that it does not look cramped
# against the negative ordinate numeric labels.
cat >! Fig7_3.sty << EOF
DrawTitle=0
DrawDSB=0
Colour=Black
Size(NumLab)=1.2
Size(TextLab)=1.2
Width=$w
TextLab(1)=0
TextLab(2)=1
NumLabGap(2)=0.02
TextLabGap(2)=0.07
EOF

# Slow wiggle
picsel 3
linplot /jcmtdata/raw/acsis/spectra/20080821/00060/a20080821_00060_01_0001"(~90%,2,87)" ytop=4.5 \
        style=^Fig7_3.sty
linplot spectra/a20080821_00060_01_2_plus2 noclear noaxes style=+colour=red

# Convert to PDF and crop the PDF of whitespace.
ps2pdf pgplot.ps 
pdfcrop pgplot.pdf examples_non-linear_baselines.pdf
\rm pgplot.ps pgplot.pdf
