#takes in an S3 class that builds sql query parameter and sql command.
#Analysts will be able to construct s3 objects as required and make fastener functions
# as required and make it available to the entire team
sql_fasteners<- function(sql_string = sql_string , parameters = list()){
structure(list(parameters = parameters,
               sql_string = sql_string), class = "sql_fasteners")
}

give_query<-function(sql_fasteners_obj){
  parameters<-sql_fasteners_obj$parameters
  query<-glue::glue("{sql_fasteners_obj$sql_string}")
  print(query)
  x<-parameters %>% glue::glue_data(query)
  print(x)
}

#param_list is an s3 class that analyst will develop with a constructor\
#which will help pass their query and information pertaining to the query
#like database name , whether to immediately store the table as temporary
#' @export
generate_fr_func<-function(query){
 function(.data){

   sql_query<- give_query(query)
   print(sql_query)
   conn <- .data$conn
   .data$data<-tbl(conn,sql(sql_query))
   return (.data)

 }
}
#
q = "SELECT {column} FROM {table} WHERE {filter_by} == {filter_value}"


#sql fasteners object
query_example<-sql_fasteners(sql_string = q,parameters = list(column = 'CustomerID',
                                                              table = 'customers',
                                                              filter_by ='Country',
                                                              filter_value = "\'US\'"))

fr_get_customers_from<-generate_fr_func(query = query_example)

k %>% fr_get_customers_from() %>%
  fr_get_transaction_after("2012-01-02") %>%
  fr_add_product("Milk") %>%
  fr_get_resulting_dataframe()




