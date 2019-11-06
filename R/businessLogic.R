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
    loadDiamonds=function(){
      createDiamonds = function(dataframe) {
        listOfDiamonds = list()
        for (r in 1:nrow(dataframe)) {
          row = dataframe[r, ]
          listOfDiamonds[[r]] <- diamond$new(
            row$carat,
            row$cut,
            row$color,
            row$clarity,
            row$depth,
            row$table,
            row$price,
            row$x,
            row$y,
            row$z)
        }
        return(listOfDiamonds)
      }
      return(createDiamonds(self$loadAll()$data))
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
  private = list(.validator = NULL),
  public = list(
    carat=NULL,
    cut=NULL,
    color=NULL,
    clarity=NULL,
    depth=NULL,
    table=NULL,
    price=NULL,
    x=NULL,
    y=NULL,
    z=NULL,

    initialize = function(carat,
                          cut,
                          color,
                          clarity,
                          depth,
                          table,
                          price,
                          x,
                          y,
                          z) {

      self$carat<-carat
      self$cut<-cut
      self$color<-color
      self$clarity<-clarity
      self$depth<-depth
      self$table<-table
      self$price<-price
      self$x<- x
      self$y<-y
      self$z<-z
      #private$.validator <- Validator$new(self)


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

# cnn <-factory()$dbFile("/Users/cnitz/Dev/R/rdao/db files external/Diamonds.db")$build()
# diamonds <- diamondsFactory(connection = cnn)
# #result <- diamonds$loadDiamonds()
# result <- diamonds$loadAll()$data
# head(result)
# head(result[[1]]$carat)
