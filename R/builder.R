#' Builder liefert die Bausteine zum erstellen einer Datenbankverbindung
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
#' @include credentials.R
#' @include sqlConnection.R

Connection.Builder <- R6::R6Class(
  classname = "ConnectionBuilder",
  inherit = NULL,
  portable = TRUE,
  # parent_env   = asNamespace("rdao"),
  cloneable    = FALSE,

  private = list(
    .validator = NULL,
    .factory=NULL
    ),

  public = list(
    credentials = NULL,

    initialize = function(factory) {
      private$.validator <- Validator$new(factory)
      private$.factory <- factory

      switch(
        class(private$.factory)[1],
             dbFile = {
               private$.factory$driver <-  RSQLite::SQLite
             },

             msAccess={
               private$.factory$driver <-  odbc::odbc
             }
      )

      private$.validator$makeReadonly("driver")
      invisible(self$print())
    },

    addCredentials = function(username = "",password = "") {
      private$.validator$makeReadwrite("credentials")
      self$credentials <-Credentials$new(username = username, password = password)
      private$.validator$makeReadonly("credentials")
      invisible(self)
    },

    #actual implementation
    build = function() {
      prc <- "build()"

      switch(class(private$.factory)[1],
             dbFile = {
               return (dbFileConnection$new(private$.factory$driver,private$.factory$path))
             },

             msAccess={

             }

      )

      if (!private$.validator$isNullString(self$path)) {
        if (!file.exists(self$path)) {
          msg <- paste("Ungültiger Pfad", self$path)
          private$.validator$throwError(msg, prc)
        }
      }

      switch(
        self$builderProvider,
        msAccess = {
          dbq <- paste0("DBQ=", self$path)
          driver <-
            "Driver={Microsoft Access Driver (*.mdb, *.accdb)};"
          dbiDriver <- odbc::odbc
          connectionstring <- paste0(driver, dbq)
          return (msAccessConnection$new(provider = self$builderProvider,dbiDriver,connectionstring))
        },

        dbFile = {
          dbiDriver <- RSQLite::SQLite
          return (dbFileConnection$new(provider = self$builderProvider, dbiDriver,self$path))
        },

        dataFrame = {
          dbiDriver <- RSQLite::SQLite
          return (sqliteConnection$new(provider = self$builderProvider, ":memory:",dbiDriver))
        },

        mySql = {
          msg <- paste("Noch nicht implementiert:", self$builderProvider)
          private$.validator$throwError(msg, prc)
        },

        msSql = {
          msg <- paste("Noch nicht implementiert:", self$builderProvider)
          private$.validator$throwError(msg, prc)
        },

        {
          msg <-
            msg <- paste("Noch nicht implementiert:", self$builderProvider)
          private$.validator$throwError(msg, prc)
        }
      )
    }
  ),

  print = function() {
    msg <- paste("<", class(self)[1], ">", sep = "")

    # if (private$.validator$isCharacter(self$builderProvider) ) {
    #   msg <-paste(msg, " for provider: <", self$builderProvider, ">", sep = "")
    # }

    cat(msg, " created", "\n", sep = "")
    invisible(self)
  }
)

dBFile <- R6::R6Class(
  classname = "ConnectionBuilder",
  inherit = Connection.Builder,
  portable = TRUE,
  # parent_env   = asNamespace("rdao"),
  cloneable    = FALSE,
  private = list(.validator = NULL,
                 .dbpassword = ""),

  public = list(
    driver = "",
    path = "",
    dsn = "",
    database = "",
    server = "",
    host = "",
    port = 0,
    credentials = NULL,

    initialize = function(path) {
      super$initialize(self)
      self$path<-path
      invisible(self)
    },

    print = function() {
      msg <- paste("<", class(self)[1], ">", sep = "")

      if (private$.validator$isCharacter(self$builderProvider) ) {
        msg <-
          paste(msg, " for provider: <", self$builderProvider, ">", sep = "")
      }

      cat(msg, " created", "\n", sep = "")
      invisible(self)
    }
  )
)
