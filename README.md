# WGBSWorkflow

**WGBSWorkflow** is an R package designed to streamline the analysis of Whole Genome Bisulfite Sequencing (WGBS) data. This package integrates several bioinformatics tools to facilitate the conversion of WGBS data into variant call format (VCF) files and supports subsequent epigenetic analysis.

## Overview

**WGBSWorkflow** provides a comprehensive pipeline for handling WGBS data, including read trimming, alignment, and SNP calling. This package is tailored for researchers in epigenetics and genomics, offering a seamless workflow for processing WGBS data and generating high-quality results.

**WGBSWorkflow** provides an integrated solution for processing WGBS data. The package includes functions to:

- **Trim Reads**: Use Trimmomatic to preprocess raw sequencing reads.
- **Align Reads**: Perform alignment with Bismark, utilizing Bowtie2 as the underlying aligner.
- **Convert Data**: Facilitate conversion of processed data into VCF format suitable for epigenetic analysis.

### Dependencies

- **Trimmomatic**: Automatically downloaded and used for trimming.
- **Bismark**: Requires installation for alignment.
- **Bowtie2**: Needed by Bismark for alignment.
- **R (>= 4.0)**: Ensures compatibility with the package functions.

### GitHub Page Structure

1. **Branches**:
   - `main`: The primary branch containing the stable version of the package.
   - `dev`: A development branch for ongoing work and feature additions.
   - `feature/<feature-name>`: Branches for specific features or updates.
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
Convets BAM, generated from previous Bismark or CGMap files and produces the vcf file for epignetic analysis. 

# Usage
```r
# Example usage with a BAM file
result_bam <- run_CGMapTools("path/to/alligned/file", "", is_bam = TRUE)
cat("Output saved to:", result_bam, "\n")
# Example usage with a Bismark BAM file
result_bismark_bam <- run_CGMapTools("path/to/bismark_aligned_reads.bam", "path/to/output_dir", is_bam = TRUE, is_bismark = TRUE)
cat("Output saved to:", result_bismark_bam, "\n")
# Example usage with a CGmap file
result_cgmap <- run_CGMapTools("/rds/projects/c/catonim-easyte/sarah.thesis/data/cgmaptools_test", "/rds/projects/c/catonim-easyte/sarah.thesis/results/cgmaptools_outputs")
cat("Output saved to:", result_cgmap, "\n")
```

# Dependencies
Trimmomatic: For read trimming.
Bismark: For alignment.
Bowtie2: Required by Bismark for alignment.
R (>= 4.0): For running the package functions.
Structure
R/: Contains R scripts with function definitions.
inst/: Includes configuration files and additional resources.
man/: Contains documentation files for the package functions.
DESCRIPTION: Package metadata and dependencies.
NAMESPACE: Lists the functions to be exported.
Contributing
Contributions are welcome! Please fork the repository and submit a pull request with your changes. For bug reports and feature requests, open an issue on the GitHub repository.

## License
This package is licensed under the MIT License. See the LICENSE file for more details.

## Contact
For any inquiries, please contact the package author:

Sarah Nicholas - sarah.nicholas@example.com









