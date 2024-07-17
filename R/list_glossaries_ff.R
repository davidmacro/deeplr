# ----------------------------------------------------------
# Filename: translate_ff.R 
# ---------------------------------------------------------- 
#   Author: David Macro (david@dataim.nl)
#     Date: 2024-07-05
#  Purpose: 
# ----------------------------------------------------------
# 
#  

ff_list_glossaries <- function(.f){
    function(auth_key, ...) {
        if(is.null(auth_key)) stop("auth_key is required")
        
        response <- .f(auth_key = auth_key, ...)
        
        return(response)
    }
}
#' List all DeepL Glossaries of an auth_key
#'
#' This function returns the glossaries in DeepL hosted on provided auth_key using the paid api.
#'
#' @param auth_key A character string with the DeepL authentication key.
#'
#' @return A named list with all glossaries
#' @export
#'
#' @examples
#' \dontrun{
#' glossaries <- list_glossaries(
#'   auth_key = "your_auth_key"
#' )
#' }
list_glossaries <- ff_list_glossaries(.f = list_glossaries_wh)
#' List all DeepL Glossaries of an auth_key
#'
#' This function returns the glossaries in DeepL hosted on provided auth_key using the free api.
#'
#' @param auth_key A character string with the DeepL authentication key.
#'
#' @return A named list with all glossaries
#' @export
#'
#' @examples
#' \dontrun{
#' glossaries <- list_glossaries2(
#'   auth_key = "your_auth_key"
#' )
#' }
list_glossaries2 <- ff_list_glossaries(.f = list_glossaries2_wh)
