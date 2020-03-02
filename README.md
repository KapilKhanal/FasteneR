# FasteneR

Suppose you have a hypothetical company with customers from different regions. You have in-house data uses that usually follow a buffet style data pulling from the database and calculations we need. 

```get_data >>(__and__then) add_purchase >> calc_interest >> calc_recency >> plot >>report``` 

## Why have internal package? 
The package will be developed for four main components:<br>
(i) data pipeline API optimized for the company<br>
(ii)Company brand visualization themes for ggplot2<br>
(iii)R Markdown templates for different types of reports for each department,<br>
(iv) Vignettes and documentation for all SQL queries and one centralized repo of queries<br>
(v)Custom functions to optimize different parts of our workflow.<br>


**What is Buffet style data workflow?**
> Buffet style workflow usually save a lot on analyst's time because it’s much easier to continually document r functions of the same table and database than to let each analyst write their own sql queries and arrange different tables.This is automating the repetitive data workflow. Data changes but code remains centralized and well managed and documented by few maintainer.<br>
This kind of workflow can be vastly improved using piping in R and database instead of having each individual analyst write disparate SQL queries. 
This package solves exactly the similar kind of problems in *internal data tooling* of the companies. FasteneR uses **fastener-functions** like above to build the workflow.
<br>

**fastener-functions** are the custom functions that have predefined usage.We know exactly what they fit into(our database and tables) and what they hold(our reporting workflow).<br>

Internal Data Tooling:
Different department are well aware of the table names in the databases. The function names right now assumes such. But these functions can be made general which might affect the readability of the code for common workflow. `dbplyr` already does this.

The same workflow can give you reports and plots along with database queries. Since, its an R-script, whole bunch of goodies that come with R/Rstudio is now available including automation of common reports , composing different R-scripts for projects that span across the department.This workflow Increase the frequency of analysis and reportings.It encourages analysis.

Below, the code is querying from database , applying filters and calculating metrics. 

```#demo
project_sales_us<- fastener("../sales.db","sales_from_us")
project_sales_us %>%
            fr_get_customer_from("US") %>%
            fr_get_transaction(1) %>%
            fr_calc_metric_recency() %>%
            fr_calc_metric_frequency() %>%
            fr_calc_metric_monetary() %>%
            fr_generate_cluster()%>%
            fr_plot() %>%
            fr_generate_pdf_report() %>%
            fr_end_project()
```
**At any moment in piping , one can use `project_sales_us$data` to get the dataframe nice and formatted, ready to use ggplot2 and rmarkdown for report. All the goodies in Rstudio** like 
  -vignettes, 
  -help documentation,
  -testing 
  -git
  
  

Features to be added
* A logging mechanism of what fasteneR functions were used to make the project object
* A rich color display in the console printing on what is happening like what table is being queried, number of rows and columns
* Using dbplyr to figure out to show/print the query in SQL 
* Include workflowR automatically to make a rich project

**To Install and Try**
`devtools::install_github('KapilKhanal/FasteneR')`


inspiration: <p><a href="https://resources.rstudio.com/rstudio-conf-2020/flatironkitchen-how-we-overhauled-a-frankensteinian-sql-workflow-with-the-tidyverse-nathaniel-phillips?wvideo=7mp0kqqdte"><img src="https://embedwistia-a.akamaihd.net/deliveries/11d7a43ff9a4bcaa41f76c93736f718d.jpg?image_play_button_size=2x&amp;image_crop_resized=960x540&amp;image_play_button=1&amp;image_play_button_color=4287c7e0" width="400" height="225" style="width: 400px; height: 225px;"></a></p><p><a href="https://resources.rstudio.com/rstudio-conf-2020/flatironkitchen-how-we-overhauled-a-frankensteinian-sql-workflow-with-the-tidyverse-nathaniel-phillips?wvideo=7mp0kqqdte">FlatironKitchen: How we overhauled a Frankensteinian SQL workflow with the tidyverse - Nathaniel Phillips</a></p>
