#' Class providing some methods to validate data
#'
#' @docType class
#' @importFrom R6 R6Class
#' @keywords checks
#'
#' @section Construction:
#' ```
#' Validator$new()
#' ```
#'
#' @return Object of \code{\link{R6Class}} with methods for communication with a database (server)
#' @format \code{\link{R6Class}} object.
#' @examples
#' validate<-Validator$new()
#' validate$isNumerix("1") -> throws error
#'
#' @field sessionid Stores id of your current session on the server.
#'
#' @section Methods:
#' \describe{
#'   \item{Documentation}{For full documentation of each method go to https://github.com/ChrisNice89/ORM}
#'   \item{\code{new()}}{This method creates a validator \code{instance}.}
#'   \item{\code{isString((x, objnm = deparse(substitute(x))))}}{Check if x is numeric}
#'   \item{\code{isNumeric((x, objnm = deparse(substitute(x))))}}{Check if x is numeric}}
#' @family utils
#' @export
Validator = R6::R6Class(
  classname = "Validator",
  inherit = NULL,
  portable = TRUE,
  private = list(
    .parentClass = "",
    .errorMsg = "",
    .isDefined = NULL,
    .getObjName=function(x){deparse(substitute(x))}
    ),

  public = list(
    initialize = function(parentClass = NULL) {
      if (self$isR6(parentClass)) {
        private$.parentClass <- class(parentClass)[1]
      } else{
        self$throwError(
          message = paste("passed parentClass typeOf <",
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

    isNumeric = function(x, throwError=FALSE) {
      if (!all(is.numeric(x))) {
        if(throwError){
          self$throwError(sprintf("'%s' muss einem numerischen Wert entsprechen", private$.getObjName(x)), "isNumeric()")
        } else{
          return(FALSE)
        }
      } else {
        return(TRUE)
      }
    },

    isNullString=function(x,throwError=FALSE){
      if(self$isCharacter(x,throwError)){
        return(("" %in% x))
      } else {
        return(FALSE)
      }
    },

    isCharacter = function(x,throwError=FALSE) {
      if (!all(is.character(x))) {
        if(throwError){
          self$throwError(sprintf("'%s' muss einer Zeichenkette entsprechen", private$.getObjName(x)), "isCharacter()")
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

    throwError = function(message="", proc) {

      if (self$isCharacter(message,proc)) {
        prc<-paste("Proc: <",proc,">",sep="")
        dscr<-paste("Beschreibung: <",message,">",sep="")
      } else {
        prc<-paste("Proc: <",proc,">",sep="")
        dscr<-paste("Beschreibung: <",private$.errorMsge,">",sep="")
      }

      private$.errorMsg <- paste(prc,dscr,sep="\n")

      if (self$isCharacter(private$.parentClass)) {
        header<-paste( "<",private$.parentClass,">",sep="")
      } else{
        header<-"<Unbekannter Aufruf>"
      }

      private$.errorMsg <-paste(header, private$.errorMsg, sep = "\n")
      stop(private$.errorMsg, call. = FALSE)
    },

    isR6 = function(obj) {
      if (is.null(obj)) {
        return(FALSE)
      } else {
        cls<-class(obj)
        i<-length(cls)
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

    print=function(){
      cat("<",class(self)[1],"> for parent class: <",  private$.parentClass,"> created","\n", sep = "")
    },

    inherits = function(class = NULL, parent = "")
      return(inherits(class, parent))
    # foo<-c(1,2,3)
    # mode(foo) %in% c("logical","numeric","complex","character")
  )
)

#' Class providing some methods to store data into a hashtable and access stored items via key
#'
#'R lists with named elements are not hashed.
#'Hash lookups are O(1), because during insert the key is converted to an integer using a hash function,
#'and then the value put in the space hash(key) % num_spots of an array num_spots long
#'(this is a big simplification and avoids the complexity of dealing with collisions).
#'Lookups of the key just require hashing the key to find the value's position
#'(which is O(1), versus a O(n) array lookup).
#'R lists use name lookups which are O(n).
#'
#' @docType class
#' @importFrom R6 R6Class
#' @keywords mapping
#'
#' @section Construction:
#' ```
#' HashMap$new()
#' ```
#' @return Object of \code{\link{R6Class}} with methods for key-value mapping
#' @format \code{\link{R6Class}} object.
#' @examples
#' hm<-HashMap$new()
#' keys<- c("tic", "tac", "toe")
#' values <- c(1, 22, 333)
#'
#' hm$put("key",1)
#' hm$put(key = keys,value = values)
#' hm$get(keys)
#' hm$get("tic")
#' hm$size()
#' hm
#' hm$remove("tic")
#' hm$get("tic")
#' hm$size()
#' hm$getKeys()[1]
#' hm$getValues()
#'
#' @field field(s) access all via ()
#' @section Methods:
#' \describe{
#'   \item{Documentation}{For full documentation of each method go to https://github.com/ChrisNice89/ORM}
#'   \item{\code{new()}}{This method creates a HashMap \code{instance}.}
#'   \item{\code{put(key = "", value = NA)}}{store key-value pair(s)}
#'   \item{\code{get(key,unname=TRUE)}}{access item(s) with associated key(s)}}
#' @family utils
#' @export

HashMap <- R6::R6Class(
  classname = "HashMap",
  inherit = NULL,
  portable = TRUE,
  public = list(
    #constructor
    initialize = function(name = "Default Dictionary", capacity = 100L) {
      private$.validator <- Validator$new(self)

      private$.name <- name
      private$.hash <- new.env(hash = TRUE,
                               parent = emptyenv(),
                               size = capacity)
      private$.hash.put <-
        Vectorize(assign, vectorize.args = c("x", "value"))
      private$.hash.get <- Vectorize(get, vectorize.args = "x")
      private$.hash.contains <-
        Vectorize(exists, vectorize.args = "x")

      invisible(self)
    },

    put = function(key = "", value = NA) {
      ##private$.validator.isString(key)
      #private$.hash[[key]] <- value

      private$.hash.put(key, value, private$.hash)
      invisible(self)
    },

    get = function(key, unname = TRUE) {
      if (unname) {
        return(setNames(private$.hash.get(key,  private$.hash), NULL))
      } else{
        return(private$.hash.get(key,  private$.hash))
      }
    },

    contains = function(key) {
      return(as.vector(private$.hash.contains(key, private$.hash)))
    },

    remove = function(key) {
      rm(list = key, envir = private$.hash)
      invisible(self)
    },

    getKeys = function() {
      return(ls(private$.hash))
    },

    getValues = function() {
      return(setNames(private$.hash.get(ls(hash), private$.hash)), NULL)
    },

    size = function() {
      return(length(private$.hash))
    },

    print = function(...) {
      cat("<",class(self)[1],"> with name: <",  private$.name,"> created","\n", sep = "")
      cat("", "<key-value-pairs> ", "\n", sep = "\t")

      if (self$size() > 0) {
        x <- self$getKeys()
        e <- private$.hash
        for (i in 1:length(x)) {
          if (x[i] %in% ls(envir = e)) {
            cat(paste("    ", x[i] , " :: ", get(ls(envir = e)[which(ls(envir = e) %in% x[i])], envir = e)), sep =
                  "\n")
          }
        }
      } else {
        cat("", "<Empty> ", "\n", sep = "\t")
      }
    }
  ),

  # active = list(
  #   getKeys =function(){
  #     return(ls(private$.hash))
  #   },
  #
  #   size=function(){
  #     return(length(private$.hash))
  #   }
  # ),

  private = list(
    .name = "Default Dictionary",
    .hash = NULL,
    .hash.get = NULL,
    .hash.put = NULL,
    .hash.contains = NULL,
    .validator = NULL
  )
)

make.readwrite = function(env,...) {
  for (class.attr in list(...)) {
    unlockBinding(sym = class.attr,  env = env)
  }
}

make.readonly = function(env,...) {
  for (class.attr in list(...)) {
    lockBinding(sym = class.attr,  env = env)
  }
}

# foo <- c(1, 1)
# isDefined <- Vectorize(mode, vectorize.args = "x")
# isDefined(foo)
# all(isDefined(foo)) %in% c("logical", "numeric", "complex", "character")
#
# mode(foo) %in% c("logical", "numeric", "complex", "character")
#
# hm <- HashMap$new()
# validate <- Validator$new(hm)
# is(validate, "R6")
# class(validate)[2]
#
# validate$isNumeric(c(1, 1))
# foo <- NA
# validate$isDefined(foo)
#
# foo <- 1.55555
# mode(foo)
# mode(foo) %in% c("logical", "numeric", "complex", "character")
# A <- R6::R6Class("Base",NULL)
# B <- R6::R6Class("Middle", inherit = A)
# C <- R6::R6Class("Top", inherit = B)
#
# v<- Validator$new()
# v$findClasses(C)
# v$inherits(C,"Middle")

