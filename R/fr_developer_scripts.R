
#' A Function to clean a single input string by removing punctuation and numbers and tokenizing it.
#'
#' @param str location"
#' @import git2r
#' @import usethis
#' @return repo
#' @export
fr_fork_clone<-function(){

  fr_register_token<-function(){
    message("PLEASE COPY YOUR GITHUB TOKEN WHEN THE BROWSER OPENS")
    Sys.sleep(11)
    usethis::browse_github_pat(
           scopes = c("repo", "gist", "user:email"),
           description = "R:GITHUB_PAT",
           host = "https://github.com"
       )
    message("PLEASE PASTE YOUR GITHUB TOKEN .rENVIRONMENT FILES OPENS")
    Sys.sleep(15)
    usethis::edit_r_environ()
  }
  #calling after taking care of credentials stuff

  fr_register_token()

  path <- file.path(tempfile(pattern="FasteneR"), "FasteneR")
  dir.create(path, recursive=TRUE)

  ## Clone the git2r repository\

  repo<- usethis::create_from_github("KapilKhanal/FasteneR",
                                     destdir= path,
                                     fork = TRUE,
                                     protocol = "https",
                                     rstudio = FALSE,
                                     auth_token =  usethis::github_token()
  )

  path<-glue::glue("{path}/FasteneR")
  setwd(path)
  repo <- repository()

  if(UPDATE==TRUE){
    fetch(repo, name = "upstream")
  }
  config(repo,
         user.name = github_username,
         user.email = github_email)
  checkout(repo,"master")

  writeLines("Hello world!", file.path(path, "test2.txt"))

  ## Add file and commit
  add(repo, "test2.txt")
  status(repo)

  commit(repo, "Commit message")

  #some functions
  #R_environment



  # 2

  cred <- cred_token()
  push(repo, credentials = cred)



  my_branch <- function(x) paste0("refs/heads/", x)
  my_origin <- function(x) paste0("origin/", x)

  if(create==TRUE){
  checkout(repo, BRANCH, create = TRUE)
  }
  else{
  checkout(repo, BRANCH)
  }

  push(repo, name = "origin", refspec = my_branch(BRANCH),credentials = cred) # 3

  branch_set_upstream(repository_head(repo), my_origin(BRANCH))                           # 4
 repo


}
