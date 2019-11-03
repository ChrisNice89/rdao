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
    .provider = NULL,
    .driver=NULL,
    .connectionstring="",
  ),

  public = list(
    provider = "",
    connectionstring = "",

    initialize = function(dbiDriver,connectionstring) {
      private$.validator <- Validator$new(self)
      print(class(dbidriver))

      if (!is.function(dbiDriver)){
        private$.validator$throwError("DBI driver nicht erkannt","initialize")
      } else {
        private$.driver<-dbiDriver
      }

      #private$.connection<-dbConnect(drv =driver, connectionstring)

      make.readonly("connectionstring", "provider")

      invisible(self$print())
    },

    #methods
    connect = function() {
      invisible(self)
    },

    disconnect = function() {
      invisible(self)
    },

    print = function(...) {
      msg <- paste("<", class(self)[1], ">", sep = "")

      if (private$.validator$isCharacter(private$.provider)) {
        msg <-paste(msg, "> for provider: <", private$.provider, ">", sep = "")
      }

      cat(msg, " created", "\n", sep = "")
      invisible(self)
    }
  )
)
