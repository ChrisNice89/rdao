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
#'

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
      return(all(as.vector(private$.hash.contains(key, private$.hash))))
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
      cat("<",
          class(self)[1],
          "> with name: <",
          private$.name,
          "> created",
          "\n",
          sep = "")
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

  private = list(
    .name = "Default Dictionary",
    .hash = NULL,
    .hash.get = NULL,
    .hash.put = NULL,
    .hash.contains = NULL,
    .validator = NULL
  )
)
