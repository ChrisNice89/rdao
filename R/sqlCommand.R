sqlCommand <- R6Class(
  classname = "Abstrakt SqlCommand",
  inherit = NULL,
  portable = TRUE,
  private = list(.validator = NULL,
                 .connection = sqlConnection),

  public = list(
    provider = "",
    type = "",
    sql = "",

    initialize = function(caller, connection, sql) {
      private$.validator <- Validator$new(self)

      #print(caller)
      if (inherits(connection, "SqlConnection")) {
        private$.connection <- connection
        self$provider <- private$.connection$provider
      } else {
        private$.validator$throwError("Connection ist ungültig", "initialize()")
      }

      if (private$.validator$isCharacter(sql)) {
        self$sql <- sql
      } else {
        private$.validator$throwError("Sql statement ist ungültig", "initialize()")
      }

      make.readonly(self, "provider", "sql")
      invisible(self$print())
    },

    execute = function(closeAfter = TRUE) {
      self$type <- 1
      result <- private$.connection$execute(self, 1)

      if (closeAfter) {
        private$.connection$disconnect()
      }
      return(result)
    },

    print = function(...) {
      msg <- paste("<", class(self)[1], ">", sep = "")

      if (!private$.validator$isNullString(self$provider)) {
        msg <-
          paste(msg, "> for provider: <", self$provider, ">", sep = "")
      }

      cat(msg, " created", "\n", sep = "")
      invisible(self)
    }
  )
)

