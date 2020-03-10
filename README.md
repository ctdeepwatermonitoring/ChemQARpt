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

Reports generated using R 3.5.3 and R markdown 1.13.

### Description of data in DB Tables

chemdata 

* sta_seq – unique site identifier  (pk)
* lab_accession – accession number from the laboratory (pk)
* collect_date – data sample was collected
* chemparameter -  the chemical parameter that was collected (pk)
* value – the chemical parameter value
* uom – the chemical parameter value unit of measure
* relt_det_cond – the result detection condition (less than the minimum detection limit)
* method_det_limit – the method detection limit
* activity_type – activity type
* activity_name – activity name
* station_type – the type of station
* duplicate – 0 or 1 (no, yes) notes if it is a duplicate sample (sample taken for QA purposes) (pk)

sites

* sta_seq – unique site identifier (pk)
* name – name of waterbody
* descript – description of waterbody location
* town – town waterbody is located in
* adb_seq – assessment database segment number
* ylat – site latitude
* xlong – site longitude
* sbasn – subregional basin number

basin

* sbasn – subregional basin number (pk)
* subregion – subregional basin name
* rbasn -  regional basin number
* regional – regional basin name
* mbasn – major basin number
* major – major basin name

