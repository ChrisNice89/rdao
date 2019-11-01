

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

  invisible()
}
