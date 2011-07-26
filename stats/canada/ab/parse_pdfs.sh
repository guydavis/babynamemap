#!/bin/bash
# Uses rpdf2txt from http://raa.ruby-lang.org/project/rpdf2txt/
# to parse out the data for Alberta from http://www.servicealberta.gov.ab.ca/vs/top10_names.cfm
# into loadable data files.
#
#  NOTE: This choked on the PDFs from 2000-2004, so I copy/pasted the text from these by hand.
#


for file in *.pdf
do
  rpdf2txt $file | grep "^[0-9].*$" > $file.txt
done