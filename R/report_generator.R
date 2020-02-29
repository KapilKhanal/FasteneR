fr_generate_report<-function(.data){
  rmarkdown::render("R/report.Rmd",
                    params = list(df = .data$data))
}
