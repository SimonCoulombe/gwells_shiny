logical_to_character_icon <- function(x){
  dplyr::if_else(x == TRUE,
                 as.character(icon("ok-sign", lib = "glyphicon")),
                 as.character(icon("exclamation-sign", lib = "glyphicon"))
  )
}