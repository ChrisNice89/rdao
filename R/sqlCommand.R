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
    },

    fetch  = function(disconnect = TRUE) {
      self$type <- "fetch"
      return(private$.connection$execute(self,disconnect))
    },

    execute = function(disconnect = TRUE) {
      self$type <- "exec"
      return(private$.connection$execute(self,disconnect))
    },

    executeBulk = function(df,disconnect=TRUE) {
      self$type <- "bulk"
      print(colnames(df))
      return(private$.connection$execute(self,disconnect,df))
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
# Ermöglicht das implementieren von "views" und "stored procedure" auf dem Frontend

sqlQuery <- R6::R6Class(
  classname = "SqlCommand",
  inherit = sqlCommand,
  portable = TRUE,
  public = list(
    initialize = function(connection, sql) {
      super$initialize(connection, sql)
      invisible(self)
    },

    fetch  = function(disconnect = TRUE) {
      return(super$fetch(disconnect))
    },

    execute = function(disconnect = TRUE) {
      return(super$execute(disconnect))
    }
  )
)

sqlUpdateQuery <- R6::R6Class(
  classname = "SqlCommand",
  inherit = sqlCommand,
  portable = TRUE,
  private=list(
    .df=NA
  ),
  public = list(
    initialize = function(connection, table,df) {

      fields<-colnames(df)
      params<-paste0(":",fields)
      kvp<-paste(fields,params,sep="=")
      # update.query <- paste0("UPDATE ",
      #                   table,
      #                   " SET ", paste(kvp,collapse = ","),
      #                   " WHERE ",
      #                   paste("ID", ":ID",sep = "="),";")

      update.query <- paste0("UPDATE ",
                        table,
                        " SET ", paste(kvp,collapse = ","),";")

      private$.df<-df
      super$initialize(connection, update.query)
      invisible(self)
    },

    execute = function(disconnect = TRUE) {
      return(super$executeBulk(private$.df,disconnect))
    }
  )
)

# sqlInsertQuery <- R6::R6Class(
#   classname = "SqlCommand",
#   inherit = sqlCommand,
#   portable = TRUE,
#   public = list(
#     initialize = function(connection, table,id,field,value) {
#       # Build the INSERT/UPDATE query
#       updatequery <- paste0("INSERT INTO ",
#                             table,
#                             "(", paste(col_names$Field, collapse = ", "), ") ", # column names
#                             "VALUES",
#                             "('", paste(values, collapse = "', '"), "') ", # new records
#                             "ON DUPLICATE KEY UPDATE ",
#                             paste(col_names$Field[-pri], values[-pri], sep = " = '", collapse = "', "), # everything minus primary keys
#                             "';")
#
#       # Show full query for clarity
#       cat("Performing query", i, "of", nrow(x), ":\n", myquery, "\n\n")
#
#
#       super$initialize(connection, sql)
#       invisible(self)
#     },

