# FasteneR

Suppose you have a hypothetical company with customers from different regions. You have in-house data uses that usually follow a buffet style data pulling from the database and calculations we need. 

```get_data >> add_purchase >> calc_interest >> calc_recency >> plot >>report``` 

This kind of workflow can be vastly improved using piping in R and database instead of having each individual analyst write disparate SQL queries. 
This package solves exactly the similar kind of problems in *internal data tooling* of the companies. FasteneR uses **fastener-functions** like above to build the workflow.
<br>
**fastener-functions** are the custom functions that have predefined usage.We know exactly what they fit into(our database and tables) and what they hold(our reporting workflow).<br>

Internal Data Tooling:
Different department are well aware of the table names in the databases. The function names right now assumes such. But these functions can be made general which might affect the readability of the code for common workflow. `dbplyr` already does this.

The same workflow can give you reports and plots along with database queries. Since, its an R-script, whole bunch of goodies that come with R/Rstudio is now available including automation of common reports , composing different R-scripts for projects that span across the department.

Below, the code is querying from database , applying filters and calculating metrics. 

```#demo
project_sales_us<- fastener("../sales.db","sales_from_us")
project_sales_us %>%
            fr_get_customer_from("US") %>%
            fr_get_transaction(1) %>% fr_end_project()
```
**At any moment in piping , one can use `project_sales_us$data` to get the dataframe nice and formatted, ready to use ggplot2 and rmarkdown for report. All the goodies in Rstudio**

Features to be added
* A logging mechanism of what fasteneR functions were used to make the project object
* A rich color display in the console printing on what is happening like what table is being queried, number of rows and columns
* Using dbplyr to figure out to show/print the query in SQL 
* Include workflowR automatically to make a rich project

**To Install and Try**
`devtools::install_github('KapilKhanal/FasteneR')`


inspiration: <p><a href="https://resources.rstudio.com/rstudio-conf-2020/flatironkitchen-how-we-overhauled-a-frankensteinian-sql-workflow-with-the-tidyverse-nathaniel-phillips?wvideo=7mp0kqqdte"><img src="https://embedwistia-a.akamaihd.net/deliveries/11d7a43ff9a4bcaa41f76c93736f718d.jpg?image_play_button_size=2x&amp;image_crop_resized=960x540&amp;image_play_button=1&amp;image_play_button_color=4287c7e0" width="400" height="225" style="width: 400px; height: 225px;"></a></p><p><a href="https://resources.rstudio.com/rstudio-conf-2020/flatironkitchen-how-we-overhauled-a-frankensteinian-sql-workflow-with-the-tidyverse-nathaniel-phillips?wvideo=7mp0kqqdte">FlatironKitchen: How we overhauled a Frankensteinian SQL workflow with the tidyverse - Nathaniel Phillips</a></p>
