

.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    paste(
      "This package ist created,developed and copyrighted by Christoph Nitz.",
      "Interested parties may contact <Christoph.Nitz89@gmail.com>",
      sep = "\n"
    ),
    domain = NULL,
    appendLF = TRUE
  )
}

.onLoad <- function(libname, pkgname) {
  op <- options()
  op.devtools <- list(
    devtools.path = "~/R-dev",
    devtools.install.args = "",
    devtools.name = "Christoph Nitz",
    devtools.desc.author = "Christoph Nitz <Christoph.Nitz@gmail89.com> [aut, cre]",
    devtools.desc.license = "No license specified",
    devtools.desc.suggests = "NULL",
    devtools.desc = list()
  )
  toset <- !(names(op.devtools) %in% names(op))
  if (any(toset))
    options(op.devtools[toset])

  # helper
  installer <- function(pkg){
    new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
    if (length(new.pkg))
      install.packages(new.pkg, dependencies = TRUE)
    sapply(pkg, require, character.only = TRUE)
  }
  packages<- c("R6","DBI","ODCB")
  #installer(packages)

  functor <- function(obj) {
    structure(
      function(i,j) {
        obj$matrixAccess(i,j)
      },
      class = "functor",
      obj = obj
    )
  }

  `$.functor` <- function(x, name) {
    attr(x, "obj", exact = TRUE)[[name]]
  }

  `$<-.functor` <- function(x, name, value) {
    obj <- attr(x, "obj", exact = TRUE)
    obj[[name]] <- value
    x
  }

  `[[.functor` <- `$.functor`
  `[[<-.functor` <- `$<-.functor`

  invisible()
}
