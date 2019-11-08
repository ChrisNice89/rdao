#' Aktuell wrapper um ein Dataframe aus einer Sql Abfrage
#' Könnte in der Zukunft um CRUD-Funktionalitäten erweitert werden.
#' Dataframe sollte komplett gekapselt werden um zb "AddColumn" zu verhindern.
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
#' @include sqlInterface.R

sqlResult<- R6::R6Class(
  classname = "SqlResult",
  inherit = generics,
  portable = TRUE,
  private = list(
    .validator = NULL,
    .connection=NULL
    ),

  public = list(
    initialize = function(connection, data) {
      private$.validator <- Validator$new(self)

       if (private$.validator$isTrustedConnection(connection)) {
        if (is.data.frame(data)) {
          print("hier")
          super$initialize(data)
          private$.connection <- connection
        }else {
          private$.validator$throwWarning("Kein Dataframe","initialize()")
        }
      }else{
        private$.validator$throwError("Keine gültige Verbindung","initialize()")
      }
    },

    getRecords=function(i){
      return(super$access()$df[i,])
    },

    row=function(index){
      super$index<-index
      invisible(self)
    },

    countRows=function(){
      return(nrow(super$access()$df))
    },

    countColumns=function(){
      return(ncol(super$access()$df))
    },

    update=function(){

    },

    delete=function(rows){
      e<-super$access()
      e$df <- e$df[-rows, ]
      invisible(self)
    },

    add=function(){

    }
  )
)

