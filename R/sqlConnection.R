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
    .validator= NULL,

    .make.readonly = function(...) {
      for (class.attr in list(...)) {
        lockBinding(sym = class.attr,  env = self)
      }
    },

    .make.readwrite = function(...) {
      for (class.attr in list(...)) {
        unlockBinding(sym = class.attr,  env = self)
      }
    },

    .validate = function(connectionstring) {
      if (!(missing(connectionstring))) {
        #stopifnot(is.character(connectionstring),length(connectionstring) == 1)
      } else{
        self$connectionstring
      }
    }
  ),

  # active = list(
  #   isconnect = function() {
  #     return(FALSE)
  #   }
  # ),

  public = list(
    provider = "",
    connectionstring = "",

    initialize = function(connectionstring){

      private$.validator<-Validator$new(self)
      private$.validate(connectionstring)

      self$connectionstring = connectionstring
      private$.make.readonly("connectionstring", "provider")

      invisible(self$print())
    },

    #methods
    connect = function() {
      invisible(self)
    },

    fields = function(...) {
      if (!tabname %in% self$tables())
        return(paste0("Table '", tabname, "' not found in database"))
      ##RSQLite::dbListFields(self$get_where()$data, tabname)
    },

    tables = function() {
      # out <- RSQLite::dbListTables(self$get_where()$data)
      # out <- out[out != "metadata"]
      # if (length(out) == 0) {
      #   return("")
      # } else {
      #   return(sort(out))
      # }
    },

    print = function(...) {
      cat("<",class(self)[1],"> created",  "\n",sep = "")
    }
  )
)

