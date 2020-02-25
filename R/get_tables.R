library(RSQLite)
library(magrittr)
library(DBI)
library(dbplyr)
library(dplyr)
library(ggplot2)
library(modeldb)
library(tidypredict)
library(config)
library(crayon)

#'A function to create the object of Type:FasteneR
#'
#' @param str name of database and the name of the particular project"
#' @import DBI
#' @import RSQLite
#' @return A vector contain all valid tokens in the original input string
#' @export
fastener<- function(db_name = db_name,project_name = project_name){
print(green((paste(glue::glue("=========================PROJECT {project_name}=======================")))))
  conn <- DBI::dbConnect(RSQLite::SQLite(), db_name)
  green(cat(paste0("connecting to database:",blue(db_name),"\n \n")))
  print(cat(green("Tables in the database \n")))
  print(DBI::dbListTables(conn))
  print(green("================================================"))
  return (structure(list(data = data,project = project_name,conn = conn,
                         db_name = db_name,events = list("process_started")), class = "fastener"))

  }


#' A Function to clean a single input string by removing punctuation and numbers and tokenizing it.
#'
#' @param str location"
#' @import dplyr
#' @import crayon
#' @return A vector contain all valid tokens in the original input string
#' @export
#'
fr_get_customer_from<-function(.data,location){
  customer_table <- tbl(.data$conn, "customers")
  result<-customer_table %>% filter(Country == location)
  .data$data <- collect(result)
  .data$events["customers_retrieved"] <- TRUE
  return (.data)

}

#' A Function to clean a single input string by removing punctuation and numbers and tokenizing it.
#'
#' @param str location"
#' @return A vector contain all valid tokens in the original input string
#' @import crayon
#' @import dbplyr
#' @export
#'
fr_get_product<-function(.data,description){
  items_table<-tbl(.data$conn,'items')
  items_table<- items_table %>% filter(Items==description)
  result<-.data$data %>% dplyr::inner_join(collect(items_table))
  .data$data <- collect(result)
  return(.data)
}

#' A Function to clean a single input string by removing punctuation and numbers and tokenizing it.
#'
#' @param str date"
#' @import dbplyr
#' @import dplyr
#' @return fastener object
#' @export
#'
fr_get_transaction<- function(.data,date){
  transaction<-tbl(.data$conn,"transactions")
  transaction<-transaction %>% filter(Date>=date)
  transaction<-collect(transaction)
  .data$data<- .data$data %>% dplyr::inner_join(transaction)

  return(.data)
}
#' A Function to disconnect to connection to database and returns resulting dataframe
#'
#' @param str date"
#' @import DBI
#' @import dplyr
#' @return resulting dataframe
#' @export
#'
fr_get_resulting_dataframe<-function(.data){
  print("DISCONNECTING from database")
  dbDisconnect(.data$conn)
  print("Returning the resulting dataframe")
  return (.data$data)
}
fr_calc_recency<-function(.data,date){

}
fr_calc_frequency<-function(.data){

}
fr_calc_monetary<-function(.data){

}

fr_calc_clusters<-function(.data){

}

fr_add_column<-function(.data){

}
#' @export
fr_end_project<-function(.data){
  print(glue::glue("wrapped {.data$project}: returning the end dataframe"))
  dbDisconnect(.data$conn)
  return (.data$data)
}

