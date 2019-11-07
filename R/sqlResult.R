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

sqlResult <- R6::R6Class(
  classname = "SqlResult",
  inherit = sqlInterface,
  portable = TRUE,
  private = list(
    .validator = NULL,
    .df=NULL,
    .connection=NULL,
    .generics=NULL
    ),

  public = list(
    data = NULL,
    rows=function(){nrow(self$data)},
    columns=NULL,

    initialize = function(connection, data) {
      private$.validator <- Validator$new(self)

       if (private$.validator$isTrustedConnection(connection)) {
        if (is.data.frame(data)) {
          private$.df <- data
          private$.connection <- connection
        }else {
          private$.validator$throwWarning("Kein Dataframe","initialize()")
        }
      }else{
        private$.validator$throwError("Keine gültige Verbindung","initialize()")
      }

      self$data<-private$.df
      super$initialize(colnames(private$.df))
      self$loadGenerics()
      private$.validator$makeReadonly("data")
    },

    loadGenerics=function(){

      entities<-list()
      f<-super$implement()

      for(r in 1:nrow(private$.df)){
        entities[[r]]<-f$new(index=r)
      }

      super$remove()
      private$.generics<-entities

    },

    getRecord=function(i){
      return(private$.generics[[i]])
    },

    test=function(i){
      message(paste(private$.generics[[i]]$getRecord(),collapse = " "))
      message(paste(private$.df[i,],collapse = " "))
    }
  )
)

