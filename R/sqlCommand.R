#' SqlCommand
#' Führt Anweisungen, gespeicherte Prozeduren und Aktionsabfragen aus.
#' Dazu gehören unter anderem SELECT-,UPDATE- oder DELETE-Kommandos.
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
#'
sqlCommand <- R6::R6Class(
  classname = "Abstrakt SqlCommand",
  inherit = NULL,
  portable = TRUE,
  private = list(
    .validator = NULL,
    .connection = NULL,
    validator=function(){
      return(private$.validator)
    }
  ),

  public = list(
    provider = "",
    type = "",
    sql = "",

    initialize = function(connection, sql) {
      private$.validator <- Validator$new(self)

      if (private$.validator$isTrustedConnection(connection)) {
        private$.connection <- connection
        self$provider <- private$.connection$provider
      } else {
        private$.validator$throwError("Connection ist ungültig", "initialize()")
      }

      if (private$.validator$isCharacter(sql)) {
        self$sql <- sql
      } else {
        private$.validator$throwError("Sql statement ist ungültig", "initialize()")
      }

      private$.validator$makeReadonly("provider", "sql")
      invisible(self$print("created"))
    },

    fetch  = function(disconnect = TRUE) {
      self$type <- "fetch"
      return(private$.connection$execute(self,disconnect))
    },

    execute = function(disconnect = TRUE) {
      self$type <- "exec"
      return(private$.connection$execute(self,disconnect))
    },

    print = function(status="") {
      msg <- paste("<", class(self)[1], ">", sep = "")

      if (!private$.validator$isNullString(self$provider)) {
        msg <-
          paste(msg, " :: <", self$sql, ">", sep = "")
        msg <-
          paste(msg, paste("for provider: <", self$provider, ">",sep=""), sep = "\n")
      }
      cat(paste(msg, status), "\n", sep = " ")
      invisible(self)
    }
  )
)

# Konkrete interface Klassen
# Ermöglicht das implementieren von "views" auf dem Frontend
sqlQuery <- R6::R6Class(
  classname = "SqlCommand",
  inherit = sqlCommand,
  portable = TRUE,
  public = list(
    initialize = function(connection, sql) {
      super$initialize(connection, sql)
      invisible(self)
    }
  )
)


