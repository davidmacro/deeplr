# ----------------------------------------------------------
# Filename: available_languages_ff.R 
# ---------------------------------------------------------- 
#   Author: David Macro (david@dataim.nl)
#     Date: 2024-07-05
#  Purpose: Refactored using a function factory
# ----------------------------------------------------------
# 
#   

ff_available_languages <- function(apiURL){
    
    force(apiURL)
    
    return(
        
        function(auth_key = "your_key"){
     
            response <- httr::POST(url = apiURL,
                httr::add_headers("Authorization" = paste("DeepL-Auth-Key", auth_key))
            ) %>T% 
            
            response_check(response)
            
            tibble::tibble(
                language = purrr::map_chr(httr::content(response), "language"),
                name = purrr::map_chr(httr::content(response), "name")
            ) 
        }
    )
}


#' List supported languages of DeepL API Pro
#'
#' \code{available_languages} list all supported languages of DeepL API Pro.
#'
#' @importFrom httr POST content
#' @importFrom purrr map_chr
#' @importFrom tibble tibble
#'
#' @param auth_key authentication key.
#'
#' @details To get an authentication key, you need to register for a DeepL API Pro
#'     account (\url{https://www.deepl.com/pro#developer}).
#'
#' @references \href{https://www.deepl.com/pro#developer}{DeepL API documentations}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' available_languages(auth_key = "my_key")
#' }
#'
available_languages <- ff_available_languages("https://api.deepl.com/v2/languages")


#' List supported languages of DeepL API Free
#'
#' \code{available_languages2} list all supported languages of DeepL API Free.
#'
#' @importFrom httr POST content
#' @importFrom purrr map_chr
#' @importFrom tibble tibble
#'
#' @param auth_key authentication key.
#'
#' @details To get an authentication key, you need to register for a DeepL API Free
#'     account (\url{https://www.deepl.com/pro#developer}).
#'
#' @references \href{https://www.deepl.com/pro#developer}{DeepL API documentations}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' available_languages2(auth_key = "my_key")
#' }
#'
available_languages2 <- ff_available_languages("https://api-free.deepl.com/v2/languages")