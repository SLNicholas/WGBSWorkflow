#' Run Bismark alignment
#'
#' @param input_file Path to the input file (single-end or paired-end reads)
#' @param genome_folder Path to the Bismark-prepared reference genome folder
#' @param output_folder Path to the output folder
#' @param is_paired Boolean indicating paired-end sequencing (default: FALSE)
#' @param mate_file Path to the mate file for paired-end sequencing (default: NULL)
#' @param bismark_dir Path to the Bismark installation directory
#' @param bowtie2_dir Path to the Bowtie2 directory
#' @return Path to the Bismark output file
#' @export
run_bismark <- function(input_file, genome_folder, output_folder, is_paired = FALSE, mate_file = NULL,
                        bismark_dir = "/rds/projects/c/catonim-easyte/sarah.thesis/Bismark",
                        bowtie2_dir = "/rds/projects/c/catonim-easyte/sarah.thesis/bowtie2/bowtie2-2.4.4-linux-x86_64") {

  # Temporarily unset LD_PRELOAD
  original_ld_preload <- Sys.getenv("LD_PRELOAD")
  if (!is.null(original_ld_preload)) {
    Sys.unsetenv("LD_PRELOAD")
  }

  # Function to prepare the reference genome
  prepare_genome <- function(genome_dir) {
    if (!dir.exists(genome_dir)) {
      stop("Genome directory does not exist.")
    }

    prep_cmd <- sprintf("%s/bismark_genome_preparation --verbose %s",
                        bismark_dir, genome_dir)
    result <- system(prep_cmd, intern = TRUE)

    if (length(result) == 0 || any(grepl("error:", result)) || any(grepl("failed", result))) {
      stop("Genome preparation failed. Output: ", paste(result, collapse="\n"))
    } else {
      message("Genome preparation completed successfully.")
    }
  }

  # Prepare the reference genome
  prepare_genome(genome_folder)

  # Create output directory if it doesn't exist
  if (!dir.exists(output_folder)) {
    dir.create(output_folder, recursive = TRUE)
  }

  # Set Bowtie2 path
  bowtie2_path <- file.path(bowtie2_dir, "bowtie2-2.4.4-linux-x86_64")

  # Check if Bowtie2 binaries exist
  if (!file.exists(file.path(bowtie2_path, "bowtie2"))) {
    stop("Bowtie2 executable not found in the specified directory: ", bowtie2_path)
  }

  # Add Bowtie2 to PATH environment variable
  Sys.setenv(PATH = paste(bowtie2_path, Sys.getenv("PATH"), sep = ":"))

  # Construct Bismark command
  if (is_paired && !is.null(mate_file)) {
    bismark_cmd <- sprintf("%s/bismark %s --bowtie2 -o %s -1 %s -2 %s",
                           bismark_dir, genome_folder, output_folder, input_file, mate_file)
  } else {
    bismark_cmd <- sprintf("%s/bismark %s --bowtie2 -o %s %s",
                           bismark_dir, genome_folder, output_folder, input_file)
  }

  # Run Bismark
  result_bismark <- system(bismark_cmd, intern = TRUE)

  if (length(result_bismark) == 0 || any(grepl("error:", result_bismark)) || result_bismark != 0) {
    stop("Bismark alignment failed. Output: ", paste(result_bismark, collapse="\n"))
  }

  # Determine the output file path
  if (grepl("\\.bam$", input_file)) {
    bismark_output <- file.path(output_folder, paste0(basename(input_file), "_bismark.bam"))
  } else {
    bismark_output <- file.path(output_folder, paste0(basename(input_file), "_bismark_bt2.bam"))
  }

  # Print message indicating where the output file can be found
  message("Look for your file in this location: ", bismark_output)

  # Restore original LD_PRELOAD
  if (!is.null(original_ld_preload)) {
    Sys.setenv(LD_PRELOAD = original_ld_preload)
  }

  return(bismark_output)
}


#testing bismark

# Define file paths and parameters
input_file <- "/rds/projects/c/catonim-easyte/sarah.thesis/R/helper_functions_R/trim_reads/trimmed_output/SRR3300052.fastq"
#change the file
genome_folder <- "/rds/projects/c/catonim-easyte/sarah.thesis/data/references/"
#make deafault the user directory
output_folder <- "/rds/projects/c/catonim-easyte/sarah.thesis/R/helper_functions_R/align/reads/bismark_output/"
#set default to TRUE
is_paired <- FALSE  # Set to TRUE for paired-end reads
#default for the paired but with a 2 or 1, make it come up witha  error if there is no mate file
mate_file <- NULL  # Specify mate file if is_paired is TRUE

# Run Bismark
bismark_output <- run_bismark(input_file, genome_folder, output_folder, is_paired, mate_file)

# Print the output file path
print(bismark_output)
