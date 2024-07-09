# ----------------------------------------------------------
# Filename: usage_ff.R 
# ---------------------------------------------------------- 
#   Author: David Macro (david@dataim.nl)
#     Date: 2024-07-05
#  Purpose: Refactored using function factories to avoid 
#           duplication. 
# ----------------------------------------------------------
# 
#  

ff_usage <- function(apiURL) {
    
    force(apiURL)
    
    return(
        function(auth_key = "your_key") {
    
            # DeepL API call
            response <- httr::POST(
                url = apiURL,
                httr::add_headers("Authorization" = paste("DeepL-Auth-Key", auth_key))
            )
            response_check(response)
            httr::content(response)
        }
    )
}


#' Usage data of a DeepL API Pro account
#'
#' \code{usage} returns the character usage and the configured limit for the current period of
#'     a DeepL API Pro account.
#'
#' @importFrom httr POST content
#'
#' @param auth_key authentication key of the corresponding DeepL API Pro account.
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
#' usage(auth_key = "my_key")
#' }
#'
usage <- ff_usage(apiURL = "https://api.deepl.com/v2/usage")


#' Usage data of a DeepL API Free account
#'
#' \code{usage2} returns the character usage and the configured limit for the current period of
#'     a DeepL API Free account.
#'
#' @importFrom httr POST content
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
#' usage(auth_key = "my_key")
#' }
#'
usage2 <- ff_usage(apiURL = "https://api-free.deepl.com/v2/usage")