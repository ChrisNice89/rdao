#' Class providing methods for building connection object
#'
#' @docType class
#' @importFrom R6 R6Class
#' @keywords data
#' @family sql
#' @return Object of \code{\link{R6Class}} with methods for communication with a database (server)
#' @format \code{\link{R6Class}} object.
#' @examples
#' b<-Builder$new(provider = "MySql")
#' cnn<-b$build()
#'
#' b<-Builder$new(provider = "MySql")
#' cnn<-b$addCredentials(username = "Admin",password = "SesameOpen")$build()
#'
#' @field serveraddress Stores address of your lightning server.
#' @field sessionid Stores id of your current session on the server.
#'
#' @section Methods:
#' \describe{
#'   \item{Documentation}{For full documentation of each method go to https://github.com/ChrisNice89/ORM}
#'   \item{\code{new(provider=c(MySql,TsQl,MsAccess), path,dbpassword="")}}{This method creates a builder \code{instance}.}
#'   \item{\code{addCredendials(username="",password="")}}{This method is used to create object of user specified credentials}
#'   \item{\code{build()}}{Creates specified connection to the database (server)}}
#'
#' @include sqlFactory.R

Builder <- R6Class(
  classname = "Builder",
  inherit = NULL,
  portable = TRUE,
  parent_env   = asNamespace("rdao"),
  cloneable    = FALSE,
  private = list(
    .validator = NULL,
    .dbiDriver = NULL,
    .dbpassword = ""
  ),

  public = list(
    builderProvider="",
    driver="",
    path="",
    dsn="",
    database="",
    server="",
    host="",
    port=0,
    credentials = NULL,

    initialize = function(provider){
      private$.validator <- Validator$new(self)

      self$builderProvider <- provider
      make.readonly(self,"builderProvider")

      invisible(self$print())
    },

    addCredentials = function(username = "",
                              password = "") {

      make.readwrite(self,"credentials")
      self$credentials <- Credentials$new(username = username, password = password)
      make.readonly(self,"credentials")
      invisible(self)
    },

    #actual implementation
    build = function() {
      prc<-"build()"

      if (!private$.validator.isNullString(self$path)){
        if (!file.exists(self$path)) {
          msg<- paste("Ungültiger Pfad",self$path)
          private$.validator$throwError(msg,prc)
        }
      }

      switch(
        self$builderProvider,
        msAccess = {

          dbq<- paste0("DBQ=", self$path)
          driver <- "Driver={Microsoft Access Driver (*.mdb, *.accdb)};"
          #.dbiDriver<-odbc::odbc()
          connectionstring<- paste0(driver, dbq)

        },

        sqlite= {

          .dbiDriver<-RSQLite::SQLite()
          connectionstring<-  ":memory:"
        },

        mySql = {

          connectionstring <- "MySql"
        },

        msSql = {

          connectionstring <- "msSql"
        },

        {
          msg<-paste("Provider: <",self$builderProvider,"> nicht implementiert",sep="")
          private$.validator$throwError(msg,prc)
        }
      )

       if (!is.function(private$.dbiDriver)){
         private$.validator$throwError("DBI driver nicht erkannt",prc)
       }

        return (sqlConnection$new(connectionstring))
      },

    print = function(...) {
      msg <- paste("<", class(self)[1], ">", sep = "")

      if (private$.validator$isCharacter(self$builderProvider)) {
        msg <-paste(msg, "> for provider: <", self$builderProvider, ">", sep = "")
      }

      cat(msg, " created", "\n", sep = "")
      invisible(self)
    }
  )
)





