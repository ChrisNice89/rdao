#' Abstrakte Klasse implementiert Interface
#'
#'
#' @docType class
#' @importFrom R6 R6Class
#' @keywords data
#' @family sql
#'
#' @section Construction:
#' ```
#' xxxxxxxxxxxxxxxxxxxxxx
#' ```
#'
#' @return Object of \code{\link{R6Class}} xxxxxxxxxxxxxxxxxxxx (x)
#' @format \code{\link{R6Class}} object.
#' @examples
#' xxxxxxxxxxxxxxxxxxxxxx
#'
#'
#' @field x blabla.
#' @field y blabla.
#'
#' @section Methods:
#' \describe{
#'   \item{Documentation}{For full documentation of each method go to https://github.com/ChrisNice89/rdao}
#'   \item{\code{new()}}{xxx \code{Factory}.}
#'   \item{\code{xx(yy,yy="")}}{xx \code{zz}.}
#'   \item{\code{zz(yy,yy="")}}{xx \code{zz}.}}
#'
#' @include utils.R
#' @include sqlResult.R

sqlInterface <- R6::R6Class(
  classname = "Abstarkt SqlResult Interface",
  inherit = NULL,
  portable = TRUE,
  public = list(
    initialize = function() {
    }
  ),

  private = list(
    remove=function(fields){
      for (c in tools::toTitleCase(fields)) {
        mthd_name <- c
        mthd_set <-
          glue::glue("generics$public_methods$set{mthd_name}<-NULL")
        mthd_get <-
          glue::glue("generics$public_methods$get{mthd_name}<-NULL")

        eval(parse(text = mthd_get))
        eval(parse(text = mthd_set))
      }
    },

    sqlResult = function(connection,dataframe) {

      if (!private$.validator$isTrustedConnection(connection)) {
        if (!is.data.frame(dataframe)) {

        }
      }

      fields<-colnames(dataframe)
      obj<-generics

      obj$set("private", "access", function() private$e, overwrite = TRUE)
      obj$set("private", "e", new.env(), overwrite = TRUE)
      obj$set("private", "index", NULL, overwrite = TRUE)
      obj$set("private", "setIndex", function(i) private$index <- i, overwrite = TRUE)
      obj$set("private", "getIndex", function() private$index, overwrite = TRUE)

      obj$set("public", "initialize", function(df) {
        private$e$df<-df
        private$index <- 1
        invisible(self)
      }, overwrite = TRUE)

      # obj$set("public", "print", function()
      #   private$e$df[private$index,], overwrite = TRUE)

      for (c in fields) {
        mthd_name <- c
        mthd_set <-
          glue::glue("function(value) private$e$df[private$index,]${mthd_name} <-value")
        mthd_get <-
          glue::glue("function() private$e$df[private$index,]${mthd_name}")

        mthd_name <- tools::toTitleCase(c)
        obj$set("public",
                           paste("get", mthd_name, sep = ""),
                           eval(parse(text = mthd_get)),
                           overwrite = TRUE)
        obj$set("public",
                           paste("set", mthd_name, sep = ""),
                           eval(parse(text = mthd_set)),
                           overwrite = TRUE)
      }
      on.exit(private$remove(fields))
      return(sqlResult$new(connection ,dataframe))
    }
  )
)

generics <- R6::R6Class(
  classname = "Generics",
  inherit =NULL,
  portable = TRUE,
  private = list(),
  public = list(
    initialize = function(){
    }
  )
)




