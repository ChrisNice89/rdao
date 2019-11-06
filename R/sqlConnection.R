#' Abstrakte sqlConnection (wrapper um DBI)
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
#' @include sqlCommand.R

sqlConnection <- R6::R6Class(
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
    },

    validator = function() {
      return(private$.validator)
    }
  ),

  public = list(
    provider = "",

    initialize = function(..., provider) {
      private$.validator <- Validator$new(self)
      private$.credentials$params <- list(...)
      self$provider <- provider
      private$.validator$makeReadonly("provider")

      invisible(self$print())
    },

    createQuery = function(sql) {
      return(sqlQuery$new(connection =  self,
                          sql = sql))
    },

    execute = function(query, disconnectAfter = TRUE) {
      prc <- "execute()"

      if (inherits(query, "SqlCommand")) {
        switch(query$type,
               "fetch" = {
                 if (self$connect()) {
                   df <- DBI::dbGetQuery(conn = private$.connection,
                                         statement = query$sql)
                   result <-
                     sqlResult$new(self, df)
                 }
               },

               "exec" = {
                 if (self$connect()) {
                   result <-
                     DBI::dbExecute(conn = private$.connection,
                                    statement = query$sql)
                 }
               },
               {
                 msg <-
                   paste("Commantype: <",
                         query$type,
                         "> nicht implementiert",
                         sep = "")
                 private$.validator$throwError(msg, prc)
               })
      } else {
        private$.validator$throwError("Command ist vom falschen Datentyp", prc)
      }

      if (disconnectAfter) {
        self$disconnect()
      }
      query$print("ausgeführt")
      return(result)
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
      return(dbListTables(private$.connection))
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

# Konkrete interface Klassen ("Provider")
# Konstruktoren bieten schwache Typsicherheit für die aufrufende Klasse.
# Ermöglichen das bauen von Verbindungen (DBI) die heterogene Parameter (je nach Datenprovider) benötigen

dbFileConnection <- R6::R6Class(
  classname = "SqlConnection",
  inherit = sqlConnection,
  portable = TRUE,
  public = list(
    initialize = function(driverGenerator, path, provider = provider) {
      super$initialize(driverGenerator, path, provider = provider)
      invisible(self)
    }
  )
)

msAccessFileConnection <- R6::R6Class(
  classname = "SqlConnection",
  inherit = sqlConnection,
  portable = TRUE,
  public = list(
    initialize = function(provider = provider,
                          driverGenerator,
                          connectionstring) {
      super$initialize(driverGenerator, connectionstring, provider = provider)
      invisible(self)
    }
  )
)
