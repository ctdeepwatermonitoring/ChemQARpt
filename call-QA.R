#This script calls QA-by-lab V2.rmd
library('knitr')
library('markdown')
library('rmarkdown')
library('RSQLite')
library('DT')

# enter list of lab accession numbers
#labIDs <- c(unique(table_chem$lab_accession)) #all lab accession sequences
labIDs <- c('120156', '120274', '150413', '150459')


# perform all SQL queries
#open ODBC
db_path <- 'S:/J_Tonfa/5YrMonitoringRpt/' 
db <- dbConnect(SQLite(), dbname=paste(db_path,"monrpt.db",sep=''));

##take main table of chemical values along with mdl
# TAKE ONLY NON-DUPLICATE, RIVER/STREAM RECORDS
SQL<- "SELECT *
FROM 
  chemdata
WHERE
  station_type='River/Stream'
  and duplicate == 0;"

table_chem_base <-dbGetQuery(conn=db,SQL)
#take only first six digits of lab_accession
table_chem_base$lab_accession <- substr(table_chem_base$lab_accession, 1, 6)

SQL<-"SELECT
  sites.sta_seq,
  sites.name,
  sites.ylat,
  sites.xlong,
  sites.sbasn,
  basin.major,
  basin.mbasn
FROM 
  sites
JOIN 
  basin
ON
  sites.sbasn = basin.sbasn;"

sitebasin_base <- dbGetQuery(conn=db,SQL)

#get table of Milli-Q values, identified by chemparameter and collection date
SQL <- "select
  chemdata.lab_accession,
  chemdata.sta_seq,
  chemdata.chemparameter,
  chemdata.collect_date,
  chemdata.value as 'Milli_Q',
  mdl.MDL
from
  sites
join
  chemdata on chemdata.sta_seq = sites.sta_seq
left join
  mdl on chemdata.chemparameter = mdl.chemparameter
where
  sites.name like '%milli%'
;"

table_milliQ_base <- dbGetQuery(conn=db, SQL)
#take only first six digits of lab_accession
table_milliQ_base$lab_accession <- substr(table_milliQ_base$lab_accession, 1, 6)

#retrieve chemical quality assurance table
SQL <- "select *
from chemQA"

table_QA <- dbGetQuery(conn=db, SQL)

#get mdl (minimum detection limit) table
SQL <- "SELECT *
FROM mdl;"

table_mdl <- dbGetQuery(conn=db, SQL)

#retrieve basin table
SQL <- "SELECT *
FROM basin;"

table_basin_base <- dbGetQuery(conn=db, SQL)

#pair up duplicate values (it was simpler to perform the join in SQL)
SQL <- "
select distinct
  c.lab_accession,
  c.sta_seq,
  c.chemparameter,
  c.collect_date,
  sites.name,
  c.value as 'value_field',
  c2.value as 'value_duplicate'
from
  chemdata c,
  chemdata c2
left join
  sites on c.sta_seq = sites.sta_seq
where
  c.sta_seq = c2.sta_seq
  and c.collect_date = c2.collect_date
  and c.chemparameter = c2.chemparameter
  and c.duplicate = 0
  and c2.duplicate = 1
  and c.station_type='River/Stream'
  and c2.station_type='River/Stream'
group by
  c.sta_seq,
  c.chemparameter,
  c.collect_date
;"

table_pairs_base <- dbGetQuery(conn=db, SQL)
#take only first six digits of lab_accession
table_pairs_base$lab_accession <- substr(table_pairs_base$lab_accession, 1, 6)

dbDisconnect(db)
### END SQL QUERIES ###

### CREATE TABLES ###

## create table_sumOfParts with full join on chemical parameter
# keep only values with an associated mdl value
table_sumOfParts_base <- merge(x=table_chem_base, y=table_mdl, by="chemparameter")
# merge with sitebasin table
table_sumOfParts_base <- merge(x=table_sumOfParts_base, y=sitebasin_base)
# shorten lab accession sequence to first six digits
table_sumOfParts_base$lab_accession <- substr(table_sumOfParts_base$lab_accession, 1, 6)

## create table lessThanMDL with right outer join on chemical parameter
# keep only values with an associated mdl value
table_lessThanMDL_base <- merge(x=table_chem_base, y=table_mdl, by="chemparameter", all.y=TRUE)

#read site information from GIS tables
t_sites = read.csv("S:/J_Tonfa/5YrMonitoringRpt/map/sites_Joined.csv")  # read csv file 
#create table of just sta_seq and ICMetric
t_sites = t_sites[, c('sta_seq', 'ICMetric', 'IC_Avg', 'SqMi', 'StrMi')]


# for each lab accession number, create a report
# report names are specified by lab accession sequence
for (z in (1:length(labIDs))) {
  lab_sequence <- labIDs[z]
  
  rmarkdown::render('S:/J_Tonfa/AssessmentQATools/QA Tools Technical Report/QA-by-lab V2.Rmd',
                    output_file = paste("QAreport_", labIDs[z], "_", Sys.Date(), ".html", sep=''),
                    output_dir = 'S:/J_Tonfa/AssessmentQATools/QA Tools Technical Report/reports')
}

