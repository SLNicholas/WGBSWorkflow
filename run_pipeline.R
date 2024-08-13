#' Run the Full Pipeline: Trimming, Alignment, and Analysis
#'
#' This function runs the full pipeline including trimming reads with Trimmomatic,
#' aligning with Bismark, and analyzing with CGMapTools.
#'
#' @param input_fastq Path to the input FASTQ file.
#' @param output_fastq_dir Directory to save the trimmed FASTQ file.
#' @param output_bismark_dir Directory to save the Bismark alignment output.
#' @param output_cgmap_dir Directory to save the CGMapTools analysis output.
#' @param trimmomatic_url URL to download the Trimmomatic zip file. Default is Trimmomatic v0.39.
#' @param jar_name Name of the Trimmomatic jar file. Default is "trimmomatic-0.39.jar".
#' @param adapter_url URL to download the TruSeq3-SE adapter sequences file. Default is the URL for TruSeq3-SE.fa.
#' @param leading Quality score threshold for trimming leading bases. Default is 3.
#' @param trailing Quality score threshold for trimming trailing bases. Default is 3.
#' @param slidingwindow Sliding window size and quality threshold. Default is "4:15".
#' @param minlen Minimum length of reads to keep. Default is 36.
#' @param phred The phred score type, either "phred33" or "phred64". Default is "phred33".
#' @param genome_folder Path to the Bismark-prepared reference genome folder.
#' @param bismark_dir Path to the Bismark installation directory.
#' @param bowtie2_dir Path to the Bowtie2 directory.
#' @param is_paired Boolean indicating paired-end sequencing. Default is FALSE.
#' @param mate_file Path to the mate file for paired-end sequencing. Default is NULL.
#' @param cgmaptools_dir Path to the CGMapTools installation directory.
#' @param genome_file Path to the reference genome FASTA file used for alignment.
#'
#' @return Path to the final output file from CGMapTools.
#' @export
#'
#' @examples
#' \dontrun{
#'   run_pipeline("/path/to/input.fastq", "/path/to/output/trimmed", "/path/to/output/bismark",
#'                "/path/to/output/cgmaptools", genome_folder = "/path/to/genome/folder",
#'                bismark_dir = "/path/to/bismark", bowtie2_dir = "/path/to/bowtie2",
#'                cgmaptools_dir = "/path/to/cgmaptools", genome_file = "/path/to/genome.fa")
#' }
run_pipeline <- function(input_fastq, output_fastq_dir, output_bismark_dir, output_cgmap_dir,
                         trimmomatic_url = "http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.39.zip",
                         jar_name = "trimmomatic-0.39.jar",
                         adapter_url = "https://github.com/timflutre/trimmomatic/blob/master/adapters/TruSeq3-SE.fa?raw=true",
                         leading = 3, trailing = 3, slidingwindow = "4:15", minlen = 36, phred = "phred33",
                         genome_folder, bismark_dir, bowtie2_dir, is_paired = FALSE, mate_file = NULL,
                         cgmaptools_dir, genome_file) {

  # Step 1: Trim reads using trim_reads function
  trimmed_fastq <- trim_reads(input_fastq, output_fastq_dir,
                              trimmomatic_url = trimmomatic_url, jar_name = jar_name,
                              adapter_url = adapter_url, leading = leading, trailing = trailing,
                              slidingwindow = slidingwindow, minlen = minlen, phred = phred)

  cat("Trimmed FASTQ file:", trimmed_fastq, "\n")

  # Step 2: Run Bismark alignment using run_bismark function
  bismark_output <- run_bismark(trimmed_fastq, genome_folder, output_bismark_dir,
                                is_paired = is_paired, mate_file = mate_file,
                                bismark_dir = bismark_dir, bowtie2_dir = bowtie2_dir)

  cat("Bismark output file:", bismark_output, "\n")

  # Step 3: Run CGMapTools analysis using the revised run_CGMapTools function
  cgmap_file <- run_CGMapTools(
    input_file = bismark_output,
    output_dir = output_cgmap_dir,
    cgmaptools_dir = cgmaptools_dir,
    genome_file = genome_file
  )

  cat("CGMapTools output file:", cgmap_file, "\n")

  # Return the final output file from CGMapTools
  return(cgmap_file)
}
