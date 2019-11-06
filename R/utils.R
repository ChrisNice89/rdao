#' Validator für Checks und Fehlermeldungen.
#' Exemplarischd implementierung. Sollte weiter ausgebaut werden.
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

Validator = R6::R6Class(
  classname = "Validator",
  inherit = NULL,
  portable = TRUE,
  private = list(
    .parentClass = NULL,
    .parentName="",
    .errorMsg = "",
    .isDefined = NULL,
    .getObjName = function(x) {
      deparse(substitute(x))
    },

    .buildMessage = function(message, proc) {
      if (self$isCharacter(message, proc)) {
        prc <- paste("Proc: <", proc, ">", sep = "")
        dscr <- paste("Beschreibung: <", message, ">", sep = "")
      } else {
        prc <- paste("Proc: <", proc, ">", sep = "")
        dscr <- paste("Beschreibung: <", validatorMessage, ">", sep = "")
      }

      validatorMessage <- paste(prc, dscr, sep = "\n")

      if (self$isCharacter(private$.parentName)) {
        header <- paste("<", private$.parentName, ">", sep = "")
      } else{
        header <- "<Unbekannter Aufruf>"
      }

      validatorMessage <- paste(header, validatorMessage, sep = "\n")
      return(validatorMessage)
    },

    .throw = function(type, msg) {
      switch(type,
             error = {
               stop(msg, call. = FALSE)
             },
             warning = {
               warning(msg,call. = FALSE)
             })
    }
  ),

  public = list(
    initialize = function(parentClass = NULL) {
      if (self$isR6(parentClass)) {
        private$.parentClass <- parentClass
        private$.parentName <- class(parentClass)[1]
      } else{
        self$throwError(
          message = paste(
            "passed parentClass typeOf <",
            class(parentClass)[1],
            "> is invalid (R6 instance required)",
            sep = ""
          )
        )
      }

      private$.isDefined <- Vectorize(mode, vectorize.args = "x")
      self$print()
      invisible(self)
    },

    isNumeric = function(x, throwError = FALSE) {
      if (!all(is.numeric(x))) {
        if (throwError) {
          self$throwError(
            sprintf(
              "'%s' muss einem numerischen Wert entsprechen",
              private$.getObjName(x)
            ),
            "isNumeric()"
          )
        } else{
          return(FALSE)
        }
      } else {
        return(TRUE)
      }
    },

    isNullString = function(x, throwError = FALSE) {
      if (self$isCharacter(x, throwError)) {
        return(("" %in% x))
      } else {
        return(FALSE)
      }
    },

    isCharacter = function(x, throwError = FALSE) {
      if (!all(is.character(x))) {
        if (throwError) {
          self$throwError(
            sprintf(
              "'%s' muss einer Zeichenkette entsprechen",
              private$.getObjName(x)
            ),
            "isCharacter()"
          )
        } else{
          return(FALSE)
        }
      } else {
        return(TRUE)
      }
    },

    isDefined = function(x) {
      return(private$.isDefined(x) %in% c("logical", "numeric", "complex", "character"))
    },

    isTrustedConnection = function(obj) {
      if (self$isR6(obj)) {
        return (inherits(obj, "SqlConnection"))
      } else
        self$throwWarning("Connection ist ungültig", "isTrustedConnection()")
        return(FALSE)
    },

    isR6 = function(obj) {
      if (is.null(obj)) {
        return(FALSE)
      } else {
        cls <- class(obj)
        i <- length(cls)
        return(cls[i] == "R6")
      }
    },

    findClasses = function(x) {
      if (is.null(x)) {
        return(NULL)
      }
      parent <- x$get_inherit()
      return(c(x$classname, self$findClasses(parent)))
    },

    makeReadwrite = function(...) {
      for (class.attr in list(...)) {
        unlockBinding(sym = class.attr,  env =private$.parentClass)
      }
    },

    makeReadonly = function(...) {
      for (class.attr in list(...)) {
        lockBinding(sym = class.attr,  env = private$.parentClass)
      }
    },

    throwWarning  = function(message, proc) {
      private$.throw("warning", private$.buildMessage(message, proc))
    },

    throwError  = function(message, proc) {
      private$.throw("error", private$.buildMessage(message, proc))
    },

    print = function() {
      cat(
        "<",
        class(self)[1],
        "> for parent class: <",
        private$.parentName,
        "> created",
        "\n",
        sep = ""
      )
    }
    # foo<-c(1,2,3)
    # mode(foo) %in% c("logical","numeric","complex","character")
  )
)
