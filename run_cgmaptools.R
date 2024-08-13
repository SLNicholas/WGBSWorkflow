#' Run CGmapTools to Convert BAM to CGmap Format
#'
#' This function runs the `CGmapFromBAM` tool to convert a BAM file to CGmap format.
#'
#' @param input_file A string specifying the path to the input BAM file.
#' @param output_dir A string specifying the directory where the output CGmap file will be saved.
#' @param cgmaptools_dir A string specifying the path to the directory where `CGmapTools` is installed.
#' @param genome_file A string specifying the path to the reference genome FASTA file. The corresponding `.fai` index file should be present.
#'
#' @return A string with the path to the generated CGmap file.
#' @export
#'
#' @examples
#' \dontrun{
#' input_bam_file <- "/path/to/sorted_output.bam"
#' output_directory <- "/path/to/output_directory"
#' cgmaptools_dir <- "/path/to/cgmaptools_directory"
#' genome_file <- "/path/to/genome_fasta_file.fa"
#'
#' cgmap_file <- run_CGMapTools(input_file = input_bam_file,
#'                              output_dir = output_directory,
#'                              cgmaptools_dir = cgmaptools_dir,
#'                              genome_file = genome_file)
#'
#' cat("CGmap file created at:", cgmap_file, "\n")
#' }
run_CGMapTools <- function(input_file, output_dir, cgmaptools_dir, genome_file = NULL) {
  # Define the path for the CGmapFromBAM tool
  conversion_tool <- file.path(cgmaptools_dir, "bin", "CGmapFromBAM")

  # Define the prefix for the output CGmap file
  output_prefix <- file.path(output_dir, "converted")

  # Check if the conversion tool exists
  if (!file.exists(conversion_tool)) {
    stop("The CGmapFromBAM tool does not exist at ", conversion_tool)
  }

  # Check if the genome file is provided and exists
  if (is.null(genome_file) || !file.exists(genome_file)) {
    stop("Genome file is not specified or does not exist at ", genome_file)
  }

  # Print the command for debugging
  cat("Running BAM to CGmap conversion command:\n")
  cat(sprintf('"%s" -b "%s" -g "%s" -o "%s"\n', conversion_tool, input_file, genome_file, output_prefix))

  # Run the conversion tool and capture both standard output and standard error
  conversion_command <- sprintf('"%s" -b "%s" -g "%s" -o "%s"', conversion_tool, input_file, genome_file, output_prefix)
  conversion_output <- system(conversion_command, intern = TRUE, ignore.stderr = FALSE)
  conversion_error <- system(conversion_command, intern = TRUE, ignore.stdout = TRUE)

  # Print the output of the conversion
  cat("Conversion command output:\n")
  cat(conversion_output, sep = "\n")

  if (length(conversion_error) > 0) {
    cat("Conversion command errors:\n")
    cat(conversion_error, sep = "\n")
  }

  # Define the path for the CGmap file
  cgmap_file <- paste0(output_prefix, ".CGmap")

  # Check if the CGmap file was created
  if (!file.exists(cgmap_file)) {
    stop("CGmap file was not created. Check the conversion command and input file.")
  }

  # Return the path to the CGmap file
  return(cgmap_file)
}


