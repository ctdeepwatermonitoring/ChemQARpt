# Water Chemistry QA Report
---

This project generates a technical report that covers selected lab accession numbers (first six digits) and runs several quality assurance tools on the data. The quality assurance tests are as follows:

*	Count N/A values
*	Flag Values compared to Milli-Q
*	Flag duplicate values compared to lab precision rate
*	Values entered as less than the minimum detection limit and not N/A
*	‘Total’ values against the sum of their component chemicals in the database
*	Values that are above the 95th percentile by basin
*	Values that are above the 95th percentile by impervious cover grouping

To use the QA report generator, run call-QA.R 
Note: If some of the R libraries used cannot be installed, it might be that your computer’s version of R is out of date.
If you would like to run the markdown file without the mentioned t_sites table generated in QGIS, just remove the Values Above 95th Percentile by IC Group code block.

Reports generated using R and R markdown.
