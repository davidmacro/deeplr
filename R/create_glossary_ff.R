# ----------------------------------------------------------
# Filename: translate_ff.R 
# ---------------------------------------------------------- 
#   Author: David Macro (david@dataim.nl)
#     Date: 2024-07-05
#  Purpose: 
# ----------------------------------------------------------
# 
#  

ff_create_glossary <- function(.f){
    
    function(name, 
             source_lang, 
             target_lang, 
             entries, 
             auth_key,
             ...
    ) {
        
        if(is.null(source_lang)) stop("source_lang is required")
        if(is.null(target_lang)) stop("target_lang is required")
        
        commonArgs <- list(
            auth_key = auth_key,
            entries = entries
        )
        
        response <- purrr::pmap(
            list(name = name, 
                 target_lang = target_lang, 
                 source_lang = source_lang),
            ~ do.call(.f, c(list(name = ..1, target_lang = ..2, source_lang = ..3), commonArgs))
        ) 
        
        # Si solo hay un resultado, lo devolvemos directamente
        if(length(response) == 1) response <- response[[1]]
        
        return(response)
    }
}

#' Create a DeepL Glossary
#'
#' This function creates a new glossary in DeepL using the provided entries in a named list using the paid api.
#'
#' @param name A character string for the name of the glossary.
#' @param source_lang A character string for the source language code.
#' @param target_lang A character string for the target language code.
#' @param entries A named list of entries where names are source terms and values are target terms.
#' @param auth_key A character string with the DeepL authentication key.
#'
#' @return A list containing information about the created glossary, including its ID.
#' @export
#'
#' @examples
#' \dontrun{
#' glossary <- create_glossary(
#'   name = "my_glossary",
#'   source_lang = "EN",
#'   target_lang = "ES",
#'   entries = list("Hello" = "Hola", "World" = "Mundo"),
#'   auth_key = "your_auth_key"
#' )
#' }
create_glossary <- ff_create_glossary(.f = create_glossary_wh)
#' Create a DeepL Glossary
#'
#' This function creates a new glossary in DeepL using the provided entries in a named list using the free api.
#'
#' @param name A character string for the name of the glossary.
#' @param source_lang A character string for the source language code.
#' @param target_lang A character string for the target language code.
#' @param entries A named list of entries where names are source terms and values are target terms.
#' @param auth_key A character string with the DeepL authentication key.
#'
#' @return A list containing information about the created glossary, including its ID.
#' @export
#'
#' @examples
#' \dontrun{
#' glossary <- create_glossary2(
#'   name = "my_glossary",
#'   source_lang = "EN",
#'   target_lang = "ES",
#'   entries = list("Hello" = "Hola", "World" = "Mundo"),
#'   auth_key = "your_auth_free_key"
#' )
#' }
create_glossary2 <- ff_create_glossary(.f = create_glossary2_wh)