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
fastener<- function(db_name = db_name,project_name = project_name,plot_list){
print(green((paste(glue::glue("=========================PROJECT {project_name}=======================")))))
  conn <- DBI::dbConnect(RSQLite::SQLite(), db_name)
  green(cat(paste0("connecting to database:",blue(db_name),"\n \n")))
  cat(green("Tables in the database \n"))
  print(DBI::dbListTables(conn))
  print(green("================================================"))
  return (structure(list(data = tibble(),project = project_name,conn = conn,
                         db_name = db_name,events = list("process_started"),
                         query = NULL,
                         plots= plot_list), class = "fastener"))

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
  .data$data<-customer_table %>% filter(Country == location)
  glimpse(.data$data)
  .data$events["customers_retrieved"] <- TRUE
  invisible(.data)

}

#' A Function to clean a single input string by removing punctuation and numbers and tokenizing it.
#'
#' @param str location"
#' @return A vector contain all valid tokens in the original input string
#' @import crayon
#' @import dbplyr
#' @export
#'
fr_add_product<-function(.data,description){
  items_table<-tbl(.data$conn,'items')
  items_table<- items_table %>% filter(Items==description)
  .data$data<-items_table %>% dplyr::left_join(.data$data)
  invisible(.data)
}
fr_get_product<-function(.data,description){
  items_table<-tbl(.data$conn,'items')
  .data$data<- items_table %>% filter(Items==description)

  invisible(.data)
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
  #date = as.Date(lubridate::ymd(date))
  transaction<-tbl(.data$conn,"transactions") %>% filter(Date>date)
  glimpse(collect(transaction))
  .data$data<- .data$data %>% dplyr::left_join(transaction)

  invisible(.data)
}
#' A Function to disconnect to connection to database and returns resulting dataframe
#'
#' @param str date"
#' @import DBI
#' @import dplyr
#' @return resulting dataframe
#' @export

fr_get_resulting_dataframe<-function(.data){
  green(cat("DISCONNECTING from database"))
  green(cat("Returning the resulting dataframe"))
  return (collect(.data$data))
}
#' @export
fr_calc_metric_recency<-function(.data,from_date){
  glimpse(.data$data)
  df_RFM <- .data$data %>%
    group_by(CustomerID) %>%
    summarise(recency=(as.Date(from_date))-max((as.Date(Date))))
  .data$data = .data$data %>% left_join(df_RFM)
  invisible(.data)
}

#' @export
fr_calc_metric_frequency<-function(.data){
freq<-.data$data %>%
  group_by(CustomerID) %>%
  summarise(
  frequency=n_distinct(InvoiceNo))
.data$data<- .data$data %>% left_join(freq)

invisible(.data)
}

#' @export
fr_calc_metric_monetary<-function(.data){
  recency<-.data$data %>%
    group_by(CustomerID) %>%
    summarise(
  monetary= 500/n_distinct(InvoiceNo))
  .data$data<- .data$data %>% left_join(recency)
  invisible(.data)
}

fr_calc_clusters<-function(.data){

}


#' @export
fr_end_project<-function(.data){
  print(glue::glue("wrapped {.data$project}: returning the end dataframe"))
  dbDisconnect(.data$conn)
  return (.data$data)
}

