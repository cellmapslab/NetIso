#!/bin/bash

mkdir /grehawi/splice-reg-prj/new-data/MAGMA/output/temp_annot # make a temporary directory to host the intermediate files

Data_File="/grehawi/splice-reg-prj/new-data/MAGMA/g1000_eur/g1000_eur"
Annot_File="/grehawi/splice-reg-prj/new-data/MAGMA/output/magma_GeneSNPAnnot_100k_20k.genes.annot"

#SCZ SNP_PVal file N=150064
#SNP_Pval_File="/grehawi/splice-reg-prj/new-data/MAGMA/PGC/SCZ2/ckqny.scz2snpres"

#PTSD SNP_PVal file N=200K
#SNP_Pval_File="/grehawi/splice-reg-prj/new-data/MAGMA/PGC/PTSD/Nievergelt_2019/pts_eur_freeze2_overall.results"

#Crossdisorder SNP_PVal file
#SNP_Pval_File="/grehawi/splice-reg-prj/new-data/MAGMA/PGC/Cross_Disorder2/pgc_cdg2_meta_no23andMe_oct2019_v2.txt.daner_withN.txt"

#MDD SNP_PVal file
#SNP_Pval_File="/grehawi/splice-reg-prj/new-data/MAGMA/PGC/MDD_2019/PGC_UKB_23andMe_depression_10000_withN.txt"

#BP SNP_PVal file N=16731
#SNP_Pval_File="/grehawi/splice-reg-prj/new-data/MAGMA/PGC/BP/pgc.bip.full.2012-04.txt_hg19.txt"

#ASD SNP_PVal file N=46350
#SNP_Pval_File="/grehawi/splice-reg-prj/new-data/MAGMA/PGC/ASD/Grove_2019/iPSYCHPGC_ASD_Nov2017.txt"

#ADHD SNP_PVal file N=55374
#SNP_Pval_File="/grehawi/splice-reg-prj/new-data/MAGMA/PGC/ADHD/Demontis_2019/daner_meta_filtered_NA_iPSYCH23_PGC11_sigPCs_woSEX_2ell6sd_EUR_Neff_70.meta"

#Height SNP_PVal file
SNP_Pval_File="/grehawi/splice-reg-prj/new-data/MAGMA/PGC/GIANT_HEIGHT_LangoAllen2010_publicrelease_HapMapCeuFreq.txt"

Output_Prefix="Height"

# run magma in parallel, 8 threads in this case
parallel /grehawi/magma_v1.10_mac/magma \
	--batch {} 8 \
	--bfile $Data_File \
	--gene-annot $Annot_File \
	--gene-model snp-wise=mean \
	--pval $SNP_Pval_File use= MarkerName,p ncol=N \
	--out /grehawi/splice-reg-prj/new-data/MAGMA/output/temp_annot/$Output_Prefix \
	::: {1..8}

# merge all intermediate files generated under the temp_annot files
# and send out for one single file set
/grehawi/magma_v1.10_mac/magma \
	--merge /grehawi/splice-reg-prj/new-data/MAGMA/output/temp_annot/$Output_Prefix \
	--out /grehawi/splice-reg-prj/new-data/MAGMA/output/temp_annot/$Output_Prefix

# extract merged files for subsequent analysis
cp /grehawi/splice-reg-prj/new-data/MAGMA/output/temp_annot/$Output_Prefix.genes.* /grehawi/splice-reg-prj/new-data/MAGMA/output/

# remove the temporary directory
rm -r /grehawi/splice-reg-prj/new-data/MAGMA/output/temp_annot
