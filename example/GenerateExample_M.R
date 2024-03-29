dir <- gsub("example", "", getwd())

vcf_list <- data.frame(
  "name" = paste0("chr", 1:22),
  "path" = paste0(dir, "data/vcf/vcf_file", 1:22, ".vcf.gz")
)
write.table(vcf_list, "../data/vcf_list.csv", sep = ",", row.names = F, col.names = F)

writeLines(paste0('includeConfig \'', dir, '/configs/local.config\'

params.outdir = "$PWD/ExampleResults_M"
params.datdir = "', dir, '/data"
params.pipeline_engine = "matrixeqtl"
params.model_type = "linear"
params.interaction_cvrt = "age"

// Genotype data input:
params.genodat_format = "vcf"
params.vcf_list = "${params.datdir}/vcf_list.csv"
params.gds_list = "${params.outdir}/1_data/gds_list.csv"
params.genotype_or_dosage = "DS"

// Phenotype input:
params.phenotype_file = "${params.datdir}/pheno_file.csv"
params.phenotype_names = "${params.datdir}/pheno_name.txt"

// Covariates:
params.covariates_file = "${params.phenotype_file}"
params.covariates = "age,sex,PC1,PC2,PC3,PC4"
params.covariates_factor = "sex"

// PCs and GRM input:
params.PC_rds = "${params.outdir}/1_data/PCs.rds"
params.GRM_rds = "${params.outdir}/1_data/GRM.rds"

// Specific SNPs and Samples to analyze:
params.snpset_assoc_txtfile = "NA"
params.userdef_sampleid_txtfile = "NA"

// optional workflow for PCA and GRM:
params.start_PC = true
params.snpset_PCA_txtfile = "NA"
params.pcair_kinthresh = 11
params.pcair_divthresh = 11

// Pipeline setups:
params.max_forks_parallel = 100
params.max_pheno_parallel = 100
params.pval_cutoff = 1
params.output_result_csv = "true"

// Plotting parameters:
params.draw_genopheno_boxplot = "true"
params.boxplot_p_cutoff = 5e-8
params.plot_mac = 3 
params.plot_resolution = 100 
params.plot_size = 400 
'),
  con = "ExampleConfig_M.config"
)

writeLines('
../nextflow -c ExampleConfig_M.config run ../Prepare.nf 
../nextflow -c ExampleConfig_M.config run ../Analysis.nf 
../nextflow -c ExampleConfig_M.config run ../Report.nf 
',
  con = "Example_M.sh"
)
