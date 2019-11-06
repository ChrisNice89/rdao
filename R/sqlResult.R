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
#'

sqlResult <- R6::R6Class(
  classname = "SqlResult",
  inherit = NULL,
  portable = TRUE,
  private = list(
    .validator = NULL,
    .df=NULL,
    .connection=NULL
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
      private$.validator$makeReadonly("data")
    }
  )
)