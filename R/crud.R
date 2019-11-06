#create read update delete
sqlCRUD <- R6::R6Class(
  classname = "Abstrakt CRUD",
  inherit = NULL,
  portable = TRUE,
  private = list(
    .validator = NULL,
    .df = NULL,
    .id = NULL,
    .connection = NULL,
    validator=function(){
      return(private$.validator)
    }
  ),

  public = list(
    create = "",
    read = "",
    update = "",
    delete = "",
    initialize = function(connection, data) {
      private$.validator <- Validator$new(self)
      if (private$.validator$isTrustedConnection(connection)) {
        if (is.data.frame(data)) {
          private$.df <- data
          private$.connection <- connection
        }else {
          private$.validator$throwWarning("Kein Dataframe","initialize()")
        }
      }else{
        private$.validator$throwError("Keine gültige Verbindung","initialize()")
      }

     }
  )
)


