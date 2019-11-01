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
#' @include utils.R

Builder <- R6Class(
  classname = "Builder",
  inherit = NULL,
  portable = TRUE,
  private = list(
    .provider = "",
    .path = "",
    .dbpassword = "",
    .credentials = NULL
  ),

  public = list(
    initialize = function(provider, path, dbpassword = "")
    {
      private$.path <- path
      private$.provider <- provider
      private$.dbpassword <- dbpassword
      invisible(self$print())
    },

    intialCatalog = "",

    addCredentials = function(username = "",
                              password = "") {
      private$.credentials = Credentials$new(username = username, password = password)
      invisible(self)
    },

    #actual implementation
    build = function() {
      switch(
        private$.provider,
        msAccess = {
          connectionstring <- "MsAccess"
        },

        mySql = {
          connectionstring <- "MySql"
        },

        msSql = {
          connectionstring <- "msSql"
        },

        {
          stop(paste(
            "Error in connection builder :: ",
            private$.provider,
            " not implemented"
          ))
        }
      )

      if (!self$intialCatalog != "") {

      } else {
        stop("intialCatalog must be a string", call. = FALSE)
      }
      return (sqlConnection$new(connectionstring))
    },

    print = function(...) {
      msg <- paste("<", class(self)[1], ">", sep = "")

      # if(private$.validator$isCharacter(private$.provider) && private$.provider!=""){
      #   msg<-paste(msg,"> for provider: <",private$.provider,">",sep = "")
      # }

      cat(msg, " created", "\n", sep = "")
      invisible(self)
    }
  )
)
