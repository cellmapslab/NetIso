#!/bin/bash

Gene_Results_File="/grehawi/splice-reg-prj/new-data/MAGMA/output/PGC_ADHD.genes.raw"
Set_Annot_File="/grehawi/splice-reg-prj/new-data/MAGMA/set_annot_file_SuperMasterNode_neighborhood.txt"
Output_Prefix="/grehawi/splice-reg-prj/new-data/MAGMA/output/gene_set_analysis_SuperMasterNode_neighbors_output/ADHD_100k_20k_gene_set_results"

/grehawi/magma_v1.10_mac/magma \
	--gene-results $Gene_Results_File \
	--set-annot $Set_Annot_File col=3,2 \
	--out $Output_Prefix
