fr_generate_report<-function(.data){
  cat(glue::glue("Report is rendering and is available at {getwd()}"))
  rmarkdown::render("R/report.Rmd",output_dir=getwd(),
                    params = list(df = collect(.data$data),name = .data$project))
  invisible(.data)
}



fr_apply_company_theme<-function(fr_plot){
  library(ggthemes)
  get_png <- function(filename) {
    grid::rasterGrob(png::readPNG(filename), interpolate = TRUE)
  }

  l <- get_png("R/logo.png")
  fr_plot<- fr_plot + theme_classic()
  (p3 <- ggplot(mapping = aes(x = 0:1, y = 1)) +
      theme_void() +
      annotation_custom(l, xmin = .9, xmax = 1))
  #Apply logo now
  gridExtra::grid.arrange(fr_plot, p3, heights = c(.94, .06))
}


fr_set_company_default<-function(){

}

