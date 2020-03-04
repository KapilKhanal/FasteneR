fr_generate_report<-function(.data){
  cat(glue::glue("Report is rendering and is available at {getwd()}"))
  rmarkdown::render("R/report.Rmd",output_dir=getwd(),
                    params = list(df = collect(.data$data),name = .data$project))
  invisible(.data)
}
