#' Class providing some methods to manage db connection
#'
#' @docType class
#' @importFrom R6 R6Class
#' @keywords connectoion
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

sqlConnection <- R6Class(
  classname = "SqlConnection",
  inherit = NULL,
  portable = TRUE,
  private = list(
    .validator = NULL,
    .connection = NULL,
    .driver = NULL,
    .credentials = list(),
    .checkConnection = function(proc) {
      if (is.null(private$.connection)) {
        private$.validator.throwError(
          paste(
            "Connection ist NULL und kann in <",
            proc,
            "> nicht verwendet werden",
            sep = ""
          ),
          "checkConnection()"
        )
      }
    }
  ),

  public = list(
    provider = "",

    initialize = function(provider, ...) {
      private$.validator <- Validator$new(self)
      private$.credentials$params <- list(...)
      self$provider <- provider
      make.readonly(self, "provider")
      invisible(self$print())
    },

    connect = function() {
      dbiConnect <- function(driverGenerator, ...) {
        if (is.function(driverGenerator)) {
          DBI::dbConnect(driverGenerator(), ...)
        } else {
          private$.validator$throwError("Driver generator ist ungültig", "connect()")
        }
      }

      private$.connection <-
        do.call(dbiConnect, private$.credentials$params)

      return(self$isConnected())
    },

    disconnect = function() {
      if (self$isConnected()) {
        DBI::dbDisconnect(private$.connection)
      }
      return(!self$isConnected())
    },

    finalize = function() {
      self$disconnect()
    },

    isConnected = function() {
      private$.checkConnection("isConnected()")
      return(DBI::dbIsValid(private$.connection))
    },

    getTables = function() {
      dbListTables(private$.connection)
    },

    print = function(...) {
      msg <- paste("<", class(self)[1], ">", sep = "")

      if (private$.validator$isCharacter(private$.provider)) {
        msg <-
          paste(msg, "> for provider: <", private$.provider, ">", sep = "")
      }

      cat(msg, " created", "\n", sep = "")
      invisible(self)
    }
  )
)

# b <- Builder$new("sqlite")
# b$path <- "/Users/cnitz/Dev/R/rdao/db files external/Diamonds.db"
# cnn <- b$build()
# cnn$connect()
# cnn$getTables()
# cnn$isConnected()
# cnn$disconnect()
# cnn$isConnected()
# cnn$connect()
# cnn$isConnected()
# cnn$disconnect()
# cnn$isConnected()
