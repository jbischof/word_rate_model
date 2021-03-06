## Load helper functions
source("parse_aturk_functions.R")

infile <- comandArgs(TRUE)
infile.root <- strsplit(infile,".csv")[[1]][1]
outfile <- paste0(infile.root,"_checked.csv")

tab.res <- read.csv(infile,header=TRUE)

## Total number of jobs completed
njobs <- nrow(tab.res)

## Get appropriate cols of output for input/output parsing 
header <- colnames(tab.res)
pos.qid <- grep(pattern="Input.q[0-9]?id",x=header)
pos.qans <- grep(pattern="Answer.q[0-9]{1}$",x=header)


## Isolate the answer columns
tab.qans <- tab.res[,pos.qans]

tab.res$Approve <- apply(tab.qans,1,function(row){
  ifelse(all(!is.na(row)),"x","")})
tab.res$Reject <- apply(tab.qans,1,function(row){
  ifelse(any(is.na(row)),"Did not answer all questions.","")})

comments.raw <- as.character(tab.res$Answer.comment)
comments <- comments.raw[nchar(comments.raw) > 0]
print(as.matrix(comments))

write.csv(tab.res,file=outfile)
                                               
