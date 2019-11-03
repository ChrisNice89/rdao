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
    .connectionstring=""
  ),

  public = list(
    provider = "",
    connectionstring = "",

    initialize = function(connection) {
      private$.validator <- Validator$new(self)
      print(class(connection))

      if(DBI::dbIsValid(connection)){
        private$.connection<-connection
      } else{
        msg<-paste("Invalid connection: <",class(connection[1],">",sep=""))
        private$.validator$throwError(msg,"initialize()")
      }

      make.readonly(self,"connectionstring", "provider")
      #invisible(self$print())
    },

    #methods
    connect = function() {
      if (!DBI::dbIsValid(private$.connection)) {
        dbConnect(private$.connection)
      }
      return(self$isConnected())
    },

    disconnect = function() {
      if (DBI::dbIsValid(private$.connection)) {
        DBI::dbDisconnect(private$.connection)
      }
      return(!self$isConnected())
    },

    finalize =function(){
        self$disconnect()
      },

    isConnected=function(){
      return(DBI::dbIsValid(private$.connection))
    },

    getTables=function(){

      dbListTables(private$.connection)
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




# b<-Builder$new("sqlite")
# b$path<-"/Users/cnitz/Dev/R/rdao/db files external/Diamonds.db"
# cnn<-b$build()
# cnn$connect()
# cnn$isConnected()
#
# cnn$disconnect()
