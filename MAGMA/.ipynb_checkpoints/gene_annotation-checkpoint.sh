#!/bin/bash

SNP_Loc_File="/grehawi/splice-reg-prj/new-data/MAGMA/g1000_eur/g1000_eur.bim"
Gene_Loc_File="/grehawi/splice-reg-prj/new-data/MAGMA/NCBI37.3/NCBI37.3.gene.loc"
Output_Prefix="/grehawi/splice-reg-prj/new-data/MAGMA/output/magma_GeneSNPAnnot_100k_20k"

/grehawi/magma_v1.10_mac/magma \
	--annotate window=100,20 \
	--snp-loc $SNP_Loc_File \
	--gene-loc $Gene_Loc_File \
	--out $Output_Prefix
