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
#'

sqlInterface <- R6::R6Class(
  classname = "Abstarkt SqlResult Interface",
  inherit = NULL,
  portable = TRUE,
  public = list(
    initialize = function(fields) {
      private$.fields<-fields
    }
  ),

  private = list(
    implement = function() {
      fields<-private$.fields
      obj<-generics

      obj$set("private", "shared", new.env(), overwrite = TRUE)
      #obj$set("private", ".df", NULL, overwrite = TRUE)
      obj$set("public", "index", NULL, overwrite = TRUE)

      obj$set("public", "initialize", function(index,df) {
        private$shared$df<-df
        self$index <- index
        invisible(self)
      }, overwrite = TRUE)

      obj$set("public", "getRecord", function()
        private$shared$df[self$index,], overwrite = TRUE)
      print(class(obj))

       #Create setter und getter
      for (c in fields) {
        mthd_name <- c
        mthd_set <-
          glue::glue("function(x) private$shared$df[self$index,]${mthd_name} <-x")
        mthd_get <-
          glue::glue("function() private$shared$df[self$index,]${mthd_name}")

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
      return(obj)
    },

    remove=function(){
      fields<-private$.fields

      for (c in tools::toTitleCase(fields)) {
        mthd_name <- c
        mthd_set <-
          glue::glue("generics$public_methods$set{mthd_name}<-NULL")
        mthd_get <-
          glue::glue("generics$public_methods$get{mthd_name}<-NULL")

        eval(parse(text = mthd_get))
        eval(parse(text = mthd_set))
      }
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




