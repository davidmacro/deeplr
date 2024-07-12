# ----------------------------------------------------------
# Filename: translate_ff.R 
# ---------------------------------------------------------- 
#   Author: David Macro (david@dataim.nl)
#     Date: 2024-07-05
#  Purpose: 
# ----------------------------------------------------------
# 
#  

ff_delete_glossaries <- function(.f){
    function(glossary_id,auth_key, ...) {
        if(is.null(auth_key)) stop("auth_key is required")
        if(is.null(glossary_id)) stop("glossary_id is required")
        
        response <- .f(glossary_id = glossary_id,auth_key = auth_key, ...)
        
        return(response)
    }
}

#' Delete a DeepL Glossary
#'
#' This function deletes a glossary in DeepL using the provided id using the paid api.
#'
#' @param glossary_id A named list of entries where names are source terms and values are target terms.
#' @param auth_key A character string with the DeepL authentication key.
#'
#' @return A boolean.
#' @export
#'
#' @examples
#' \dontrun{
#' glossary <- delete_glossary(
#'   glossary_id = "id_of_glossary_to_delete",
#'   auth_key = "your_auth_key"
#' )
#' }
delete_glossary <- ff_delete_glossaries(.f = delete_glossary_wh)
#' Delete a DeepL Glossary
#'
#' This function deletes a glossary in DeepL using the provided id using the free api.
#'
#' @param glossary_id A named list of entries where names are source terms and values are target terms.
#' @param auth_key A character string with the DeepL authentication key.
#'
#' @return A boolean.
#' @export
#'
#' @examples
#' \dontrun{
#' glossary <- delete_glossary2(
#'   glossary_id = "id_of_glossary_to_delete",
#'   auth_key = "your_auth_key"
#' )
#' }
delete_glossary2 <- ff_delete_glossaries(.f = delete_glossary2_wh)
