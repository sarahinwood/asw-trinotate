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

output_gff <- makeGRangesFromDataFrame(data.frame(merged_results),
                                       keep.extra.columns = TRUE)

##NOTE: output .gff is not the same format as signalp .gff
export.gff2(output_gff, "output/signalp/renamed_signalp_gff.gff2")