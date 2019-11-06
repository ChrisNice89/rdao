sqlInterface <- R6::R6Class(
  classname = "Abstarkt SqlResult Interface",
  inherit = NULL,
  portable = TRUE,
  public = list(
    initialize = function() {
      
    }
  ),
  private = list(
    implement = function(businessObject, df) {
      businessObject$set("private", ".df", NULL, overwrite = TRUE)
      businessObject$set("public", "index", NULL, overwrite = TRUE)
      
      businessObject$set("public", "initialize", function(index, df) {
        private$.df <- df
        self$index <- index
        invisible(self)
      }, overwrite = TRUE)
      
      businessObject$set("public", "getRecord", function()
        private$.df[self$index,], overwrite = TRUE)
      
      #Create setter und getter
      for (c in colnames(df)) {
        mthd_name <- c
        mthd_set <-
          glue::glue("function(x) private$.df[self$index,]${mthd_name} <-x")
        mthd_get <-
          glue::glue("function() private$.df[self$index,]${mthd_name}")
        #obj$set("private", glue::glue("private$.{mthd_name}"), c, overwrite = TRUE)
        
        mthd_name <- tools::toTitleCase(c)
        businessObject$set("public",
                           paste("get", mthd_name, sep = ""),
                           eval(parse(text = mthd_get)),
                           overwrite = TRUE)
        businessObject$set("public",
                           paste("set", mthd_name, sep = ""),
                           eval(parse(text = mthd_set)),
                           overwrite = TRUE)
      }
      return(businessObject)
    }
  )
)