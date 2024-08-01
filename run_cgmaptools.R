#' Run CGMapTools Analysis with Specified Version
#'
#' This function runs CGMapTools version 0.1.0 for converting BAM files to CGmap files and performing CGmap analysis.
#'
#' @param input_file The path to the input file (BAM or CGmap).
#' @param output_dir The directory where the output will be saved.
#' @param tool The CGMapTools script to run (default: "CGmapStatMeth.py").
#' @param perl_path Path to the Perl executable (default: "perl").
#' @param python_path Path to the Python executable (default: "python").
#' @param cgmaptools_version The version of CGMapTools to download (default: "v0.1.0").
#' @param dest_dir Directory to download and unzip CGMapTools (default: "CGMapTools").
#' @param is_bam Logical. If TRUE, converts a BAM file to CGmap (default: FALSE).
#' @param is_bismark Logical. If TRUE, uses Bismark-specific conversion (default: FALSE).
#' @return Path to the output file.
#' @export
run_CGMapTools <- function(input_file, output_dir, tool = "CGmapStatMeth.py",
                           perl_path = "perl", python_path = "python",
                           cgmaptools_version = "v0.1.0",
                           dest_dir = "CGMapTools", is_bam = FALSE, is_bismark = FALSE) {

  # Construct the URL for the specified CGMapTools version
  cgmaptools_url <- paste0("https://github.com/guoweilong/cgmaptools/archive/refs/tags/", cgmaptools_version, ".zip")

  # Define paths
  cgmaptools_path <- file.path(dest_dir, paste0("cgmaptools-", gsub("v", "", cgmaptools_version)))

  # Install CGMapTools if necessary
  if (!dir.exists(dest_dir) || !dir.exists(cgmaptools_path)) {

    # Create the destination directory if it doesn't exist
    if (!dir.exists(dest_dir)) {
      dir.create(dest_dir, recursive = TRUE)
    }

    # Download CGMapTools ZIP file
    zip_file <- file.path(dest_dir, basename(cgmaptools_url))
    download.file(cgmaptools_url, zip_file, mode = "wb")

    # Unzip CGMapTools
    unzip(zip_file, exdir = dest_dir)

    # Remove the ZIP file
    file.remove(zip_file)
  }

  # Ensure the output directory exists
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }

  # Convert BAM to CGmap if necessary
  if (is_bam) {
    cgmap_file <- file.path(output_dir, "converted.CGmap")

    if (is_bismark) {
      # Use Bismark to CGmap conversion
      bam_to_cgmap_script <- file.path(cgmaptools_path, "src", "BismarkToCGmap.py")

      if (!file.exists(bam_to_cgmap_script)) {
        stop("The Bismark to CGmap conversion script does not exist in CGMapTools.")
      }

      convert_cmd <- paste(shQuote(python_path), shQuote(bam_to_cgmap_script), shQuote(input_file), ">", shQuote(cgmap_file))
    } else {
      # Use standard BAM to CGmap conversion
      bam_to_cgmap_script <- file.path(cgmaptools_path, "src", "CGmapFromBAM.c")

      if (!file.exists(bam_to_cgmap_script)) {
        stop("The BAM to CGmap conversion script does not exist in CGMapTools.")
      }

      convert_cmd <- paste(shQuote(python_path), shQuote(bam_to_cgmap_script), shQuote(input_file), ">", shQuote(cgmap_file))
    }

    # Print the command for debugging
    cat("Running BAM to CGmap conversion command:\n", convert_cmd, "\n")

    # Run the BAM to CGmap conversion command
    system(convert_cmd)

    # Use the converted CGmap file as the input for the next step
    input_file <- cgmap_file
  }

  # Define the output file path for the CGMapTools tool
  output_file <- file.path(output_dir, paste0(tools::file_path_sans_ext(basename(input_file)), "_", tool, "_output.txt"))

  # Path to the tool script
  tool_script <- file.path(cgmaptools_path, "src", tool)

  # Check if the tool script exists
  if (!file.exists(tool_script)) {
    stop(paste("The tool", tool, "does not exist in CGMapTools. Check the path:", tool_script))
  }

  # Construct the CGMapTools command
  cmd <- paste(shQuote(python_path), shQuote(tool_script), shQuote(input_file), ">", shQuote(output_file))

  # Print the command for debugging
  cat("Running command:\n", cmd, "\n")

  # Run the CGMapTools command
  system(cmd)

  # Return the path to the output file
  return(output_file)
}


# Example usage with a BAM file
result_bam <- run_CGMapTools("path/to/alligned/file", "", is_bam = TRUE)
cat("Output saved to:", result_bam, "\n")
# Example usage with a Bismark BAM file
result_bismark_bam <- run_CGMapTools("path/to/bismark_aligned_reads.bam", "path/to/output_dir", is_bam = TRUE, is_bismark = TRUE)
cat("Output saved to:", result_bismark_bam, "\n")
# Example usage with a CGmap file
result_cgmap <- run_CGMapTools("/rds/projects/c/catonim-easyte/sarah.thesis/data/cgmaptools_test", "/rds/projects/c/catonim-easyte/sarah.thesis/results/cgmaptools_outputs")
cat("Output saved to:", result_cgmap, "\n")
