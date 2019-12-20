#' Abstrakt business logic
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

businessLogic <- R6::R6Class(
  classname = "Abstrakt businessLogic",
  inherit = NULL,
  portable = TRUE,
  private = list(
    .validator = NULL,
    .connection = NULL,
    .columns = c(
      "carat",
      "cut",
      "color",
      "clarity",
      "depth",
      "table",
      "price",
      "x",
      "y",
      "z"
    ),
    .quality =c("Fair", "Good", "Very Good", "Premium", "Ideal"),
    .columnMap = NULL,
    .qualityMap = NULL,

    availableQuality = function() {
      return(c("Fair", "Good", "Very Good", "Premium", "Ideal"))
    },

    .columnCheck = function(c) {
      if (!private$.columnMap$contains(c)) {
        private$.validator$throwWarning(paste(
          "Nur folgende Spalten können abgefragt werden:",
          paste(private$.columnMap$getKeys(), collapse = ";")
        ),
        "loadColumns()")
        return(FALSE)
      } else{
        return(TRUE)
      }
    }
  ),

  public = list(
    initialize = function(connection) {
      private$.validator <- Validator$new(self)

      if (private$.validator$isTrustedConnection(connection)) {
        private$.connection <- connection
      } else {
        private$.validator$throwError("Connection ist ungültig", "initialize()")
      }

      private$.columnMap = HashMap$new()
      private$.columnMap$put(private$.columns)
      private$.columnMap$getKeys()
      private$.qualityMap = HashMap$new()
      private$.qualityMap$put(private$.quality)

    },

    loadAll = function() {
      sql <- "SELECT * FROM diamonds"
      return(private$.connection$createQuery(sql = sql)$fetch())
    },

    loadQuality = function(...) {
      quality<-unlist(...)

      if (!private$.qualityMap$contains(quality)) {
        private$.validator$throwWarning(paste(
          "Nur folgende Qualitäten können abgefragt werden:",
          paste(private$.qualityMap$getKeys(), collapse = ";")
        ),
        "loadQuality()")
      } else{
        sql.raw <- "SELECT * FROM diamonds WHERE cut IN (%s)"
        sql <- sprintf(sql.raw, paste0("\"",paste(quality,collapse=","), "\"", collapse = ","))
        return(private$.connection$createQuery(sql = sql)$fetch())
    }

    },

    load=function(obj){
      Ibusiness<-self$loadAll()$Override(obj)
      return(Ibusiness)
    },

    loadBestQuality = function() {
      sql <- "SELECT * FROM diamonds WHERE cut = 'Very Good'"
      return(private$.connection$createQuery(sql = sql)$fetch())
    },

    loadColumns = function(...) {
      columns<-unlist(...)

      if (private$.columnCheck(columns)){
        sql <- paste("SELECT" , paste(columns,collapse=","), "FROM diamonds")
        return(private$.connection$createQuery(sql = sql)$fetch())
      }
    }
    )
)

#' business entity
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
#'
diamond <- R6::R6Class(
  classname = "Diamond",
  inherit =NULL,
  portable = TRUE,
  private = list(),
  public = list(
    initialize = function(){
    }
  )
)

#' business interface
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
#'

IDiamonds <- R6::R6Class(
  classname = "Diamonds interface",
  inherit = businessLogic,
  portable = TRUE,
  private = list(.validator = NULL,
                 .diamonds = NULL),
  public = list(
    initialize = function(connection) {
      private$.validator <- Validator$new(self)
      super$initialize(connection)
    }
  )
)

#' Factory function liefert konkretes Interface zum Frontend
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
#' @export
#'
diamondsFactory = function(connection) {
  return(IDiamonds$new(connection))
}

