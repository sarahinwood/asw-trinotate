#!/usr/bin/env Rscript

library(data.table)
library(rtracklayer)

pepids <- fread("output/signalp/ids.csv")
setkey(pepids, "pepid")

sp_gff <- import.gff2("output/signalp/signalp.gff")
sp_dt <- data.table(data.frame(sp_gff))

merged_results <- merge(sp_dt,
      pepids,
      by.x = "seqnames",
      by.y = "pepid",
      all.x = TRUE)
merged_results[, seqnames := NULL]
setnames(merged_results, "id", "seqname")
colorder <- c("seqname", "source", "type", "start", "end", "score")
output_dt <- merged_results[,colorder, with=FALSE]
output_dt[,strand:="."]
output_dt[,phase:="."]
output_dt[,signal:="YES"]

fwrite(x=output_dt, file = "output/signalp/renamed_signalp_gff.gff2", sep = "\t", col.names = FALSE)