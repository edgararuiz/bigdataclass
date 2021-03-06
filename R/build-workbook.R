#' Uses bookdown to build the workbook inside a specified folder
#' @param stage_folder The folder where the book will be compiled
#' @param source The path of the workbook 
#' @param db_folder Location of the source 'database' folder
#' @param file_folder Location of the source 'files' folder
#' @param book_folder Location of the source 'books' folder
#' @param db_connection The 'connections' code to connect to the database
#' @param dbi_connection The 'DBI' code to connect to the database
#' @export
bdc_build_workbook <- function(stage_folder = tempdir(),
                               source = system.file("workbook", package = "bigdataclass"),
                               db_folder = "database",
                               file_folder = "files",
                               book_folder = "books",
                               db_connection = "con <- connection_open(RSQLite::SQLite(), 'database/local.sqlite')",
                               dbi_connection = "con <- dbConnect(RSQLite::SQLite(), 'database/local.sqlite')"
                               ) {
  if (!dir.exists(stage_folder)) dir.create(stage_folder)
  unlink(file.path(stage_folder, "workbook"), recursive = TRUE, force = TRUE)
  file.copy(
    source, 
    stage_folder, 
    recursive = TRUE, 
    overwrite = TRUE
    )
  wb_path <- file.path(stage_folder, "workbook")
  if(!is.null(db_folder)) file.copy(db_folder, wb_path, recursive = TRUE)
  file.copy(file_folder, wb_path, recursive = TRUE)
  file.copy(book_folder, wb_path, recursive = TRUE)
  tag_replace(wb_path, "files", file_folder)
  tag_replace(wb_path, "books", book_folder)
  tag_replace(wb_path, "db_connection", db_connection)
  tag_replace(wb_path, "dbi_connection", dbi_connection)
  bookdown::serve_book(wb_path)
}

workbook_data <- function(wb_path = "inst/workbook",
                          db_folder = "database",
                          file_folder = "files",
                          book_folder = "books"
                          ) {
  file.copy(db_folder, wb_path, recursive = TRUE)
  file.copy(file_folder, wb_path, recursive = TRUE)
  file.copy(book_folder, wb_path, recursive = TRUE)
}

workbook_reset <- function(wb_path = "inst/workbook") {
  files <- c(
    "derby.log",
    "parsedmodel.csv",
    "_bookdown_files",
    "_main.Rmd",
    "saved_model",
    "saved_pipeline",
    "new_model",
    "books",
    "files",
    "database",
    "logs",
    "_book",
    "my_model.yml",
    "mydatabase.sqlite",
    list.files(pattern = "\\.md"),
    list.files(pattern = "\\.rds")
  )
  unlink(file.path(wb_path, files), recursive = TRUE, force = TRUE)
}

workbook_clean <- function(wb_path = "inst/workbook") {
  files <- c(
    "derby.log",
    "parsedmodel.csv",
    "_bookdown_files",
    "_main.Rmd",
    "saved_model",
    "saved_pipeline",
    "new_model",
    "logs",
    "_book",
    "my_model.yml",
    "mydatabase.sqlite",
    list.files(pattern = "\\.md"),
    list.files(pattern = "\\.rds")
  )
  unlink(file.path(wb_path, files), recursive = TRUE, force = TRUE)
}

workbook_build <- function(wb_path = "inst/workbook") {
  workbook_clean(wb_path = wb_path)
  bookdown::serve_book(here::here(wb_path))
  # .rs.removeAllObjects(TRUE, globalenv())
  # .rs.restartR(
  #   afterRestartCommand = "browseURL('_book/index.html'); setwd(here::here())"
  # )
}
