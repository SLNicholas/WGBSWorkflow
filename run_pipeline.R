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
#' @param tool The CGMapTools script to run. Default is "CGmapStatMeth.py".
#' @param perl_path Path to the Perl executable. Default is "perl".
#' @param python_path Path to the Python executable. Default is "python".
#' @param cgmaptools_version The version of CGMapTools to download. Default is "v0.1.0".
#' @param cgmaptools_dest_dir Directory to download and unzip CGMapTools. Default is "CGMapTools".
#' @param is_bam Logical. If TRUE, converts a BAM file to CGmap. Default is FALSE.
#' @param is_bismark Logical. If TRUE, uses Bismark-specific conversion. Default is FALSE.
#'
#' @return Path to the final output file from CGMapTools.
#' @export
#'
#' @examples
#' \dontrun{
#'   run_pipeline("/path/to/input.fastq", "/path/to/output/trimmed", "/path/to/output/bismark",
#'                "/path/to/output/cgmaptools", genome_folder = "/path/to/genome/folder",
#'                bismark_dir = "/path/to/bismark", bowtie2_dir = "/path/to/bowtie2")
#' }
run_pipeline <- function(input_fastq, output_fastq_dir, output_bismark_dir, output_cgmap_dir,
                         trimmomatic_url = "http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.39.zip",
                         jar_name = "trimmomatic-0.39.jar",
                         adapter_url = "https://github.com/timflutre/trimmomatic/blob/master/adapters/TruSeq3-SE.fa?raw=true",
                         leading = 3, trailing = 3, slidingwindow = "4:15", minlen = 36, phred = "phred33",
                         genome_folder, bismark_dir, bowtie2_dir, is_paired = FALSE, mate_file = NULL,
                         tool = "CGmapStatMeth.py", perl_path = "perl", python_path = "python",
                         cgmaptools_version = "v0.1.0", cgmaptools_dest_dir = "CGMapTools",
                         is_bam = FALSE, is_bismark = FALSE) {

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

  # Step 3: Run CGMapTools analysis using run_CGMapTools function
  cgmaptools_output <- run_CGMapTools(bismark_output, output_cgmap_dir,
                                      tool = tool, perl_path = perl_path, python_path = python_path,
                                      cgmaptools_version = cgmaptools_version,
                                      dest_dir = cgmaptools_dest_dir, is_bam = TRUE, is_bismark = TRUE)

  cat("CGMapTools output file:", cgmaptools_output, "\n")

  # Return the final output file from CGMapTools
  return(cgmaptools_output)
}
