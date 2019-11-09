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
    .connection=NULL,
    .eod=FALSE,
    .shared=NULL
    ),

  public = list(
    initialize = function(connection, data) {
      private$.validator <- Validator$new(self)

       if (private$.validator$isTrustedConnection(connection)) {
        if (is.data.frame(data)) {
          super$initialize(data)
          private$.shared<-super$getPointer()
          private$.connection <- connection
        }else {
          private$.validator$throwWarning("Kein Dataframe","initialize()")
        }
      }else{
        private$.validator$throwError("Keine gültige Verbindung","initialize()")
      }
    },

    getRecords=function(){
      i<-private$.shared$index
      return(private$.shared$df$df[i,])
    },

    countRows=function(){
      return(nrow(private$.shared$df))
    },

    countColumns=function(){
      return(ncol(private$.shared$df))
    },

    read=function(){
      i<-private$.shared$index
      on.exit(self$row(i+1))
      return(!private$.eod)
    },

    row=function(i){
      if(i>self$countRows()){
        private$.eod<-TRUE
        private$.shared$index<-1
      }else{
        private$.eod<-FALSE
        private$.shared$index<-i
      }
      invisible(self)
    },

    toMatrix=function(){
      make_functor <- function(obj) {
        structure(
          function(i,j) {
            obj$matrixAccess(i,j)
          },
          class = "functor",
          obj = obj
        )
      }

      return(make_functor(super))
    },

    update=function(){

    },

    delete=function(rows){
      private$.shared$df <- super$getPointer()$df[-rows, ]
      invisible(self)
    },

    add=function(){

    }
  )
)
