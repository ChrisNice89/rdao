#' SqlFactory liefert mehoden zum erstellen eines builders (Entwurfsmuster)
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
#' @include builder.R
#' @export

connectionFactory<-function(){
  return (sqlFactory$new())
}

sqlFactory <- R6::R6Class(
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

    mySql= function(database="testDB",
                    uid = "mysql",
                    pwd = "password",
                    host = "localhost",
                    port = 5432){

      return(Builder$new(provider = "mySql"))
    },

    msAccess= function(path,dbpassword=""){
      b<-Builder$new(provider = "msAccess")
      b$path <- path
      return(b)
    },

    dbFile=function(path){
      b<-Builder$new(provider = "dbFile")
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


