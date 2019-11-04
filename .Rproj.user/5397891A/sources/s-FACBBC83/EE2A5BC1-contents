#' Class providing some methods to for CRUD actions
#'
#' @docType class
#' @importFrom R6 R6Class
#' @keywords command
#' @section Construction:
#' ```
#' sqlConnection$new()
#' ```
#' @return Object of \code{\link{R6Class}} with methods for communication with a database (server)
#' @format \code{\link{R6Class}} object.
#' @examples
#' # cnn<-sqlConnection$new(connectionstring = "myconnectionstring")
#
#' @field
#'
#' @section Methods:
#' \describe{
#'   \item{Documentation}{For full documentation of each method go to https://github.com/ChrisNice89/ORM}
#'   \item{\code{new()}}{This method creates a sqlConnection \code{instance}.}
#'   \item{\code{isString((x, objnm = deparse(substitute(x))))}}{Check if x is numeric}
#'   \item{\code{isNumeric((x, objnm = deparse(substitute(x))))}}{Check if x is numeric}}
#' @family sql
#' @include utils.R
#' @include sqlConnection.R
#'
sqlCommand <- R6Class(
  classname = "Abstrakt SqlCommand",
  inherit = NULL,
  portable = TRUE,
  private = list(
    .validator = NULL,
    .connection = sqlConnection),

  public = list(
    provider = "",
    type = "",
    sql = "",

    initialize = function(connection, sql) {
      private$.validator <- Validator$new(self)

      if (inherits(connection, "SqlConnection")) {
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

      make.readonly(self, "provider", "sql")
      invisible(self$print())
    },

    fetch  = function(disconnect = TRUE) {
      self$type <- "fetch"
      return(private$.connection$execute(self,disconnect))
    },

    execute = function(disconnect = TRUE) {
      self$type <- "exec"
      return(private$.connection$execute(self,disconnect))
    },

    print = function(...) {
      msg <- paste("<", class(self)[1], ">", sep = "")

      if (!private$.validator$isNullString(self$provider)) {
        msg <-
          paste(msg, " :: <", self$sql, ">", sep = "")
        msg <-
          paste(msg, paste("for provider: <", self$provider, ">",sep=""), sep = "\n")
      }

      cat(msg, " created", "\n", sep = "")
      invisible(self)
    }
  )
)

sqlQuery <- R6Class(
  classname = "SqlCommand",
  inherit = sqlCommand,
  portable = TRUE,
  public = list(
    initialize = function(connection, sql) {
      private$.validator <- Validator$new(self)
      super$initialize(connection, sql)
      invisible(self)
    }
  )
  )


