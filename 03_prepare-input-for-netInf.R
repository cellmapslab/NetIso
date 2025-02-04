library(dplyr)
library(tidyr)
library(data.table)

# read files
genes.count = read.table("/grehawi/splice-reg-prj/new-data/PreNet_processing/gene_count_final.matrix")
trx.count = read.table("/grehawi/splice-reg-prj/new-data/PreNet_processing/IR_final.matrix")
gencode.annotation = rtracklayer::import("/grehawi/splice-reg-prj/data/Homo_sapiens.GRCh38.97.gtf")

# read pheno data
samples.info = read.table("/grehawi/splice-reg-prj/new-data/PreNet_processing/combined_pheno_withCT_Outfiltered.csv")

# get names instead of Ids
gencode.annotation.df = as.data.frame(gencode.annotation)
gene.names.ids = gencode.annotation.df[gencode.annotation.df$type=="gene", colnames(gencode.annotation.df) %in% c("gene_id", "gene_name")]
gene.names.ids = gene.names.ids[gene.names.ids$gene_id %in% row.names(genes.count),]

trx.names.ids = gencode.annotation.df[gencode.annotation.df$type=="transcript", colnames(gencode.annotation.df) %in% c("transcript_id", "transcript_name")]
trx.names.ids = trx.names.ids[trx.names.ids$transcript_id %in% row.names(trx.count),]

#some genes have duplicate names, remove those genes
gene.names.ids.non.dupl = gene.names.ids[! duplicated(gene.names.ids$gene_name), ]
genes.count.no.dupl = genes.count[rownames(genes.count) %in% gene.names.ids.non.dupl$gene_id, ]

#bind both transcript and gene name<-->Id mapping tables
genes.ids.names = gene.names.ids.non.dupl %>% dplyr::rename(id = gene_id) %>% dplyr::rename(name = gene_name)
trx.names.ids = trx.names.ids %>% dplyr::rename(id = transcript_id) %>% dplyr::rename(name = transcript_name)
ids.names.combined = rbind(genes.ids.names, trx.names.ids)

#now map to names 
# first concatenate the two count files
gene.and.trx = rbind(genes.count.no.dupl, trx.count)
idorder <- as.character(rownames(gene.and.trx))
names.ids.ordered <- ids.names.combined[match(idorder, ids.names.combined$id),]

gene.and.trx.withNames = as.matrix(gene.and.trx)
row.names(gene.and.trx.withNames) = names.ids.ordered$name

#split to cases and controls
samples.info.cases = samples.info %>% filter(ltany_di == 1)
samples.info.controls = samples.info %>% filter(ltany_di == 0)

# Concatenate genes and trx tables into one (ARACNE expects rows as samples and columns as genes/IR)
gene.and.trx.withNames.t = t(gene.and.trx.withNames)
gene.and.trx.withNames.t = gene.and.trx.withNames.t[row.names(gene.and.trx.withNames.t) %in% samples.info$combined_id,]
gene.and.trx.cases = gene.and.trx.withNames.t[row.names(gene.and.trx.withNames.t) %in% samples.info.cases$combined_id,]
gene.and.trx.controls = gene.and.trx.withNames.t[row.names(gene.and.trx.withNames.t) %in% samples.info.controls$combined_id,]

gene.and.trx.withNames.t = as.data.frame(gene.and.trx.withNames.t)
gene.and.trx.cases = as.data.frame(gene.and.trx.cases)
gene.and.trx.controls = as.data.frame(gene.and.trx.controls)

gene.and.trx.withNames.t$samples = rownames(gene.and.trx.withNames.t)
gene.and.trx.cases$samples = rownames(gene.and.trx.cases)
gene.and.trx.controls$samples = rownames(gene.and.trx.controls)


dim(gene.and.trx.withNames.t)
dim(gene.and.trx.cases)
dim(gene.and.trx.controls)

fwrite(gene.and.trx.withNames.t, "/grehawi/splice-reg-prj/new-data/ARACNE/total_and_ratios.txt", sep="\t")
fwrite(gene.and.trx.cases, "/grehawi/splice-reg-prj/new-data/ARACNE/total_and_ratios_cases.txt", sep="\t")
fwrite(gene.and.trx.controls, "/grehawi/splice-reg-prj/new-data/ARACNE/total_and_ratios_controls.txt", sep="\t")

write.table(gene.names.ids.non.dupl, "/grehawi/splice-reg-prj/new-data/ARACNE/gene_names_ids_table.txt")
write.table(trx.names.ids, "/grehawi/splice-reg-prj/new-data/ARACNE/trxs_names_ids_table.txt")
write.table(ids.names.combined ,"/grehawi/splice-reg-prj/new-data/ARACNE/genes_trxs_ids_names_map.txt")
