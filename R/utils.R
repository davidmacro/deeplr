# ----------------------------------------------------------
# Filename: utils.R 
# ---------------------------------------------------------- 
#   Author: David Macro (david@dataim.nl)
#     Date: 2024-07-05
#            
# ----------------------------------------------------------
# 
# Note: using function factories saves a lot of duplication. 
#       especially when the only diff between translate_wh
#       and translate_wh2 is the apiURL 

# url1 <- "https://api.deepl.com/v2/translate"
# url2 <- "https://api-free.deepl.com/v2/translate"

#' @importFrom httr modify_url POST content
#' @importFrom tibble tibble
#' 
#' @noRd
ff_translate_wh <- function(apiURL){
    
    force(apiURL)
    
    return(
        function(text,
            target_lang         = "EN",
            source_lang         = NULL,
            split_sentences     = TRUE,
            preserve_formatting = FALSE,
            get_detect          = FALSE,
            auth_key            = "your_key"
        ){
            
            # Text prep
            text <- text_check(text)
            
            split_sentences     <- `if`(split_sentences,     "1", "0")
            preserve_formatting <- `if`(preserve_formatting, "1", "0")
            
            # DeepL API call
            response <- httr::POST(
                url  = apiURL,
                body = list(text                = text,
                            source_lang         = source_lang,
                            target_lang         = target_lang,
                            split_sentences     = split_sentences,
                            preserve_formatting = preserve_formatting),
                httr::add_headers("Authorization" = paste("DeepL-Auth-Key", auth_key))
            )
            
            # Check for HTTP error
            response_check(response)
            
            # Extract content
            translations <- httr::content(response)[["translations"]]
            
            if(get_detect){
                translation <- tibble::tibble(
                    translation = purrr::map_chr(translations, "text"),
                    source_lang = purrr::map_chr(translations, "detected_source_language")
                ) 
            } else { 
                translation <- purrr::map_chr(translations, "text") 
            } 
            return(translation)
        } 
    )
}

#' @noRd
translate_wh  <- ff_translate_wh("https://api.deepl.com/v2/translate") 
 
#' @noRd
translate2_wh <- ff_translate_wh("https://api-free.deepl.com/v2/translate") 

#' @importFrom utf8 utf8_valid as_utf8
#'
#' @noRd
text_check <- function(text) {
    
    # Check for text
    if (is.null(text)) stop("Text input is missing.")
    
    # Coerce non-character vectors to a character vector
    if (!is.character(text)) message("Text input had to be coerced to a character vector.")
    text <- as.character(text)
    
    # Check if text can be translated to valid UTF-8 string
    if (!utf8::utf8_valid(text)) stop("Text input cannot be translated to a valid UTF-8 string.")
    text <- utf8::as_utf8(text)
    
    return(text)
}

#' @importFrom httr status_code
#'
#' @noRd
response_check <- function(response) {
    status <- httr::status_code(response)
    if (status == 400) stop("Bad request. Please check error message and your parameters.")
    if (status == 403) stop("Authorization failed. Please supply a valid auth_key parameter.")
    if (status == 404) stop("The requested resource could not be found.")
    if (status == 413) stop("The request size exceeds the limit.")
    if (status == 414) stop("The request URL is too long. You can avoid this error by using a POST request instead of a GET request.")
    if (status == 429) stop("Too many requests. Please wait and resend your request.")
    if (status == 456) stop("Quota exceeded. The character limit has been reached.")
    if (status == 503) stop("Resource currently unavailable. Try again later.")
}

#' @importFrom tokenizers tokenize_sentences
#' @importFrom tibble tibble
#' @importFrom purrr map_chr
#'
#' @noRd
split_text_wh <- function(id, text, max_size_bytes, tokenize) {
    
    
    if (tokenize == "sentences") sentences <- tokenizers::tokenize_sentences(text)
    if (tokenize == "words") sentences <- tokenizers::tokenize_words(text)
    
    cnt <- tibble::tibble(
        sentence  = unlist(sentences),
        bytes     = nchar(sentence, type = "bytes"),
        bytes_sum = cumsum(bytes),
        batch     = ceiling(bytes_sum / max_size_bytes)
    )
    
    batches <- split(cnt, cnt$batch)
    
    batches <- tibble::tibble(
        text_id      = id,
        segment_id   = 1:length(batches),
        segment_text = purrr::map_chr(batches, function(x) paste0(x[["sentence"]], collapse = " "))
    )
    
    return(batches)
}
