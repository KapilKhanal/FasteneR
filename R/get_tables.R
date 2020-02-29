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
  cat(green("Tables in the database \n"))
  print(DBI::dbListTables(conn))
  print(green("================================================"))
  return (structure(list(data = tibble(),project = project_name,conn = conn,
                         db_name = db_name,events = list("process_started")), class = "fastener"))

  }
fr_get_column_info<-function(.data,table_name){
  table <- tbl(.data$conn, table_name)
  table %>% glimpse()
  invisible(.data)
}

print.fastener<-function(obj){
  glue::glue("-------------------------------------{obj$project} REPORT-------------------------")
  paste0("number of rows: ",nrow(obj$data))
  dplyr::glimpse(obj$data)
  summary(obj$data)
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
fr_get_transaction_after<- function(.data,date){
  date = as.Date(date)
  print(class(date))
  transaction<-tbl(.data$conn,"transactions")
  transaction<-transaction %>% filter(Date>date)
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
fr_calc_recency<-function(.data,from_date = from_date){
  df_RFM <- .data$data %>%
    group_by(CustomerID) %>%
    summarise(recency=as.numeric(as.Date(from_date)-max(Date)))
  .data$data = df_RFM
  return(.data)
}
fr_calc_frequency<-function(.data){
df_freq<-.data$data %>%
  group_by(CustomerID) %>%
  summarise(
  frequency=n_distinct(InvoiceNo))
}
fr_calc_monetary<-function(.data){
  df_freq<-.data$data %>%
    group_by(CustomerID) %>%
    summarise(
  monetary= sum(total_dolar)/n_distinct(InvoiceNo))
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

