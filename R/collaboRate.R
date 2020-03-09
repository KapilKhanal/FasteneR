#import git2r
#import usethis
library("git2r")

path <- file.path(tempfile(pattern="toyrepo"), "toyrepo")
dir.create(path, recursive=TRUE)

## Clone the git2r repository\

repo<- usethis::create_from_github("malcolmbarrett/toyrepo",
                                   destdir= path,
                                   fork = TRUE,
                                   protocol = "https",
                                   rstudio = FALSE,
                                   auth_token =  usethis::github_token()
                            )

path<-glue::glue("{path}/toyrepo")
setwd(path)
repo <- repository()
repo
config(repo,
       user.name = "KapilKhanal",
       user.email = "kkhanal16@winona.edu")
config(repo)

checkout(repo,"master")
repo
##adding remote

# Check our remotes

remotes(repo)

fetch(repo, name = "upstream")

## Create a new file
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



BRANCH <- "2020-03-10"                                         # 1
checkout(repo, BRANCH, create = TRUE)
checkout(repo, "2020-03-10")
push(repo, name = "origin", refspec = my_branch(BRANCH),credentials = cred) # 3

branch_set_upstream(repository_head(repo), my_origin(BRANCH))                           # 4
repo
checkout(repo,"2020-03-10")





