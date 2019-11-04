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
  classname = "Abstrakt SqlConnection",
  inherit = NULL,
  portable = TRUE,
  private = list(
    .validator = NULL,
    .connection = NULL,
    .driver = NULL,
    .credentials = list(),

    .dbiConnect = function(driverGenerator, ...) {
      if (is.function(driverGenerator)) {
        DBI::dbConnect(driverGenerator(), ...)
      } else {
        private$.validator$throwError("Driver generator ist ungültig", "connect()")
      }
    }
  ),

  public = list(
    provider = "",

    initialize = function(...,provider) {
      private$.validator <- Validator$new(self)
      private$.credentials$params <- list(...)
      self$provider <- provider
      make.readonly(self, "provider")

      invisible(self$print())
    },

    createCommand = function(sql) {
      return(sqlCommand$new(
        caller = "mother",
        connection =  self,
        sql = sql
      ))
    },

    execute = function(command) {
      prc <- "execute()"

      print(inherits(command, "SqlCommand"))
      if (TRUE) {
        print("hier")
        switch(command$type,
               "1" = {
                 if (self$connect()) {
                   print("hier")
                   return (DBI::dbGetQuery(private$.connection, command$sql))
                 }
               },

               {
                 msg <-
                   paste("Commantype: <",
                         command$type,
                         "> nicht implementiert",
                         sep = "")
                 private$.validator$throwError(msg, prc)
               })
      } else {
        print("error")
        private$.validator$throwError("Command ist vom falschen Datentyp", prc)
      }
    },

    connect = function() {
      if (!self$isConnected()) {
        private$.connection <-
          do.call(private$.dbiConnect, private$.credentials$params)
      }
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
      if (!is.null(private$.connection)) {
        return(DBI::dbIsValid(private$.connection))
      } else {
        return(FALSE)
      }
    },

    getTables = function() {
      dbListTables(private$.connection)
    },

    print = function() {
      msg <- paste("<", class(self)[1], ">", sep = "")

      if (!private$.validator$isNullString(self$provider)) {
        msg <-
          paste(msg, "> for provider: <", self$provider, ">", sep = "")
      }

      cat(msg, " created", "\n", sep = "")
      invisible(self)
    }
  )
)

# Provider interface
dbFileConnection <- R6Class(
  classname = "SqlConnection",
  inherit = sqlConnection,
  portable = TRUE,
  public = list(
    initialize = function(driverGenerator, path,provider = provider) {
      super$initialize(driverGenerator, path,provider = provider)
      invisible(self)
    }
    # CreateCommand=function(){
    #   return(sqlCommand$new(self))
    # }
  )
)

msAccessFileConnection <- R6Class(
  classname = "SqlConnection",
  inherit = sqlConnection,
  portable = TRUE,
  public = list(
    initialize = function(provider = provider,
                          driverGenerator,
                          connectionstring) {
      super$initialize(driverGenerator, connectionstring,provider = provider)
      invisible(self)
    }
  )
)




