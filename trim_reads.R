#' Trim reads using Trimmomatic
#'
#' This function installs Trimmomatic, downloads the adapter sequences, and trims the reads in the input FASTQ file.
#'
#' @param input_fastq Path to the input FASTQ file.
#' @param output_fastq_dir Directory where the trimmed output FASTQ file will be saved.
#' @param trimmomatic_url URL to download the Trimmomatic zip file. Default is Trimmomatic v0.39.
#' @param jar_name Name of the Trimmomatic jar file. Default is "trimmomatic-0.39.jar".
#' @param adapter_url URL to download the TruSeq3-SE adapter sequences file. Default is the URL for TruSeq3-SE.fa.
#' @param leading Quality score threshold for trimming leading bases. Default is 3.
#' @param trailing Quality score threshold for trimming trailing bases. Default is 3.
#' @param slidingwindow Sliding window size and quality threshold. Default is "4:15".
#' @param minlen Minimum length of reads to keep. Default is 36.
#' @param phred The phred score type, either "phred33" or "phred64". Default is "phred33".
#'
#' @return The path to the trimmed FASTQ file.
#' @export
#'
#' @examples
#' \dontrun{
#'   trim_reads("/path/to/input.fastq", "/path/to/output/dir")
#' }
trim_reads <- function(input_fastq, output_fastq_dir,
                       trimmomatic_url = "http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.39.zip",
                       jar_name = "trimmomatic-0.39.jar",
                       adapter_url = "https://github.com/timflutre/trimmomatic/blob/master/adapters/TruSeq3-SE.fa?raw=true",
                       leading = 3, trailing = 3, slidingwindow = "4:15", minlen = 36, phred = "phred33") {

  # Define destination directory for Trimmomatic
  dest_dir <- tempdir()

  # Create the destination directory if it doesn't exist
  if (!dir.exists(dest_dir)) {
    dir.create(dest_dir, recursive = TRUE)
  }

  # Download Trimmomatic ZIP file
  zip_file <- file.path(dest_dir, basename(trimmomatic_url))
  download.file(trimmomatic_url, zip_file, mode = "wb")

  # Unzip Trimmomatic
  unzip(zip_file, exdir = dest_dir)

  # Remove the ZIP file
  file.remove(zip_file)

  # Download TruSeq3-SE adapter sequences file
  adapter_file <- file.path(dest_dir, "TruSeq3-SE.fa")
  download.file(adapter_url, adapter_file, mode = "wb")

  # Path to the Trimmomatic JAR file
  trimmomatic_jar <- file.path(dest_dir, "Trimmomatic-0.39", jar_name)

  # Ensure the output directory exists
  if (!dir.exists(output_fastq_dir)) {
    dir.create(output_fastq_dir, recursive = TRUE)
  }

  # Define the output file path
  output_fastq <- file.path(output_fastq_dir, basename(input_fastq))

  # Construct the Trimmomatic command
  cmd <- paste("java -jar", shQuote(trimmomatic_jar),
               "SE",
               paste0("-", phred),
               shQuote(input_fastq), shQuote(output_fastq),
               paste0("ILLUMINACLIP:", shQuote(adapter_file), ":2:30:10"),
               paste0("LEADING:", leading),
               paste0("TRAILING:", trailing),
               paste0("SLIDINGWINDOW:", slidingwindow),
               paste0("MINLEN:", minlen))

  # Print the command for debugging
  cat("Running command:\n", cmd, "\n")

  # Run the Trimmomatic command
  system(cmd)

  # Return the path to the trimmed FASTQ file
  return(output_fastq)
}


# Example usage:
# Define the destination directory for Trimmomatic installation
dest_dir <- "/rds/projects/c/catonim-easyte/sarah.thesis/R/helper_functions_R/trim_reads"

# Install Trimmomatic and download the TruSeq3-SE adapter sequences file
trimmomatic_jar <- install_trimmomatic(dest_dir = dest_dir)

# Example usage of trim_reads function
input_fastq <- "/rds/projects/c/catonim-easyte/sarah.thesis/data/raw_reads/SRR3300052.fastq"
output_fastq_dir <- "/rds/projects/c/catonim-easyte/sarah.thesis/R/helper_functions_R/trim_reads/trimmed_output"
adapters_file <- file.path(dest_dir, "TruSeq3-SE.fa")  # Using the downloaded adapter file

# Call trim_reads function with the specified parameters
trim_reads(input_fastq, output_fastq_dir, adapters_file)
