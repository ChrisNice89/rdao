#' Class providing methods for creating a builder instance
#' Factory methodes are the access to the implementation (Builder class)
#'
#' @docType class
#' @importFrom R6 R6Class
#' @keywords data
#' @family sql
#'
#' @section Construction:
#' ```
#' f<-factory()
#' ```
#'
#' @return Object of \code{\link{R6Class}} with methods for communication with a database (server)
#' @format \code{\link{R6Class}} object.
#' @examples
#' f<-sqlFactory$new()
#' b<-f$mySql(path,dbpassword="")
#'
#' @field serveraddress Stores address of your lightning server.
#' @field sessionid Stores id of your current session on the server.
#'
#' @section Methods:
#' \describe{
#'   \item{Documentation}{For full documentation of each method go to https://github.com/ChrisNice89/ORM}
#'   \item{\code{new()}}{This method creates a instance \code{Factory}.}
#'   \item{\code{mySql(path,dbpassword="")}}{This method is used to create a builder instance for \code{sqlConnection}.}
#'   \item{\code{msAccess(path,dbpassword="")}}{This method is used to create a builder instance for \code{sqlConnection}.}}
#'
#' @include utils.R
#' @include zzz.R
#' @export

factory<-function(){
  return (sqlFactory$new())
}

sqlFactory <- R6Class(
  classname = "SqlFactory",
  inherit = NULL,
  portable = TRUE,
  private = list(
    .validator = NULL
  ),
  #constructor's
  public = list(
    initialize = function()
    {
      private$.validator<-Validator$new(self)
      invisible(self$print())
    },

    postgreSql= function(database = "test_db",
                            uid = "postgres",
                            pwd = "password",
                            host = "localhost",
                            port = 5432){

      dbiDriver<-"odbc::odbc()"
      driver <- "PostgreSQL Driver"



    },

    mySql= function(path,dbpassword=""){
      return(Builder$new(provider = "mySql",path = path))
    },

    msAccess= function(path,dbpassword=""){
      b<-Builder$new(provider = "msAccess")
      b$path <- path
      return(b)
    },

    dbFile=function(path){
      b<-Builder$new(provider = "msAccess")
      b$path <- path
      return(b)
    },

    oracle= function(path,dbpassword=""){
      return(Builder$new("oracle",path = path))
    },

    msSql=function(path,dbpassword=""){
      return(Builder$new("msSql",path = path))
    },

    print=function() {
      msg<-paste("<",class(self)[1],">",sep = "")
      cat(msg," created", "\n", sep = "")
      invisible(self)
    }
  )
)

