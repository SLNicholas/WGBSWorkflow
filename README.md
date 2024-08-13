# WGBSWorkflow

**WGBSWorkflow** is an R package designed to streamline the analysis of Whole Genome Bisulfite Sequencing (WGBS) data. This package integrates several bioinformatics tools to facilitate the conversion of WGBS data into variant call format (VCF) files and supports subsequent epigenetic analysis.

## Overview

**WGBSWorkflow** provides a comprehensive pipeline for handling WGBS data, including read trimming, alignment, and SNP calling. This package is tailored for researchers in epigenetics and genomics, offering a workflow for processing WGBS data and generating high-quality results.

**WGBSWorkflow** provides an integrated solution for processing WGBS data. The package includes functions to:

- **Trim Reads**: Use Trimmomatic to preprocess raw sequencing reads.
- **Align Reads**: Perform alignment with Bismark, utilizing Bowtie2 as the underlying aligner.
- **Convert Data**: Facilitate conversion of processed data into format suitable for epigenetic analysis.

### Dependencies

- **Trimmomatic**: Automatically downloaded and used for trimming.
- **Bismark**: Automatically downloaded. Requires installation for alignment.
- **Bowtie2**: Needed by Bismark for alignment.
- **CGMaptools**: Automatically downloaded. Needed for conversion 
- **R (>= 4.0)**: Ensures compatibility with the package functions.

### GitHub Page Structure

1. **Branches**:
   - `main`: The primary branch containing the stable version of the package.
   - `dev`: A development branch for ongoing work and feature additions.
   - `functions`: Branches for specific functions features or updates.
   - `bugfix/<issue-number>`: Branches for fixing bugs.

2. **Directory Structure**:
   - `README.md`: Main documentation file.
   - `DESCRIPTION`: Contains package metadata.
   - `NAMESPACE`: Lists exported functions.
   - `R/`: Folder with R scripts and functions.
   - `man/`: Documentation files for package functions.
   - `inst/`: Additional resources and configuration files.
   - `tests/`: Unit tests for package functions (if applicable).

## Installation

To install the **WGBSWorkflow** package from GitHub, use the following commands:

```r
# Install the devtools package if not already installed
install.packages("devtools")

# Install WGBSWorkflow from GitHub
devtools::install_github("SLNicholas/WGBSWorkflow")
```

## Functions
trim_reads()
Trims raw FASTQ reads using Trimmomatic. This function handles the installation of Trimmomatic and performs read trimming according to specified parameters.

# Usage
```r
trim_reads(input_fastq, output_fastq_dir, trimmomatic_url, jar_name, adapter_url, leading, trailing, slidingwindow, minlen, phred)
```

# Arguments
input_fastq: Path to the input FASTQ file.
output_fastq_dir: Directory to save the trimmed FASTQ file.
trimmomatic_url: URL to download Trimmomatic (default: Trimmomatic v0.39).
jar_name: Name of the Trimmomatic jar file (default: "trimmomatic-0.39.jar").
adapter_url: URL to download the adapter sequences file (default: TruSeq3-SE.fa).
leading, trailing, slidingwindow, minlen, phred: Trimming parameters.

run_bismark()
Aligns trimmed reads using Bismark, a tool for bisulfite sequencing data analysis.

Usage
```r
run_bismark(input_file, genome_folder, output_folder, is_paired, mate_file, bismark_dir, bowtie2_dir)
```

# Arguments
input_file: Path to the input file (single-end or paired-end).
genome_folder: Path to the Bismark-prepared reference genome folder.
output_folder: Directory to save the alignment results.
is_paired: Boolean indicating paired-end sequencing (default: FALSE).
mate_file: Path to the mate file for paired-end sequencing (if applicable).
bismark_dir: Path to the Bismark installation directory.
bowtie2_dir: Path to the Bowtie2 directory.

run_cgmaptools()
Convets BAM, generated from previous Bismark or CGMap files and produces the file for epignetic analysis. 

# Usage
```r
# Define the paths to the input files and directories
input_bam_file <- "path/to/input/file"
output_directory <- "path/to/output/directory"
cgmaptools_dir <- "path/to/cgmaptools/on/local/drive"
genome_file <- "path/to/reference/fasta/file"

# Run the CGmapTools conversion
cgmap_file <- run_CGMapTools(
  input_file = input_bam_file,
  output_dir = output_directory,
  cgmaptools_dir = cgmaptools_dir,
  genome_file = genome_file
)

# Print the path to the generated CGmap file
cat("CGmap file created at:", cgmap_file, "\n

```
run_pipeline
Run's the entire pipeline from trimming to conversion.
# Usage 
```r
# Example usage of the run_pipeline function

# Define the paths to the input files and directories
input_fastq <- "path/to/input/fastq/file"
output_fastq_dir <- "path/to/output/directory"
output_bismark_dir <- "path/to/bismark/on/local/drive"
output_cgmap_dir <- "path/to/output/directory"
genome_folder <- "path/to/reference/genome"
bismark_dir <- "path/to/bismark/on/local/drive"
bowtie2_dir <- "path/to/bowtie2/on/local/drive"
cgmaptools_dir <- "path/to/cgmaptools/on/local/drive"
genome_file <- "path/to/reference/file/for/cgmaptools"

# Run the full pipeline
cgmap_file <- run_pipeline(
  input_fastq = input_fastq,
  output_fastq_dir = output_fastq_dir,
  output_bismark_dir = output_bismark_dir,
  output_cgmap_dir = output_cgmap_dir,
  genome_folder = genome_folder,
  bismark_dir = bismark_dir,
  bowtie2_dir = bowtie2_dir,
  cgmaptools_dir = cgmaptools_dir,
  genome_file = genome_file
)

# Output the final CGmap file path
cat("Final CGmap file created at:", cgmap_file, "\n")
```

# Dependencies
Trimmomatic: For read trimming.
Bismark: For alignment.
Bowtie2: Required by Bismark for alignment.
R (>= 4.0): For running the package functions.

# Structure
R/: Contains R scripts with function definitions.
inst/: Includes configuration files and additional resources.
man/: Contains documentation files for the package functions.
DESCRIPTION: Package metadata and dependencies.
NAMESPACE: Lists the functions to be exported.

## Contact
For any inquiries, please contact the package author:

Sarah Nicholas - sarahlnicholas21@gmail.com









