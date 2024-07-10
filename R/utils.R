 
# Note: using function factories saves a lot of duplication. 
#       especially when the only diff between translate_wh
#       and translate_wh2 is the apiURL 

# url1 <- "https://api.deepl.com/v2/translate"
# url2 <- "https://api-free.deepl.com/v2/translate"

#' Factory function for translate using glossary also
#'
#' @param apiURL The base URL for the DeepL API
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
            auth_key            = "your_key",
            glossary_id         = NULL,
            ...
        ){
            print(auth_key)
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
                            preserve_formatting = preserve_formatting,
                            glossary_id         = glossary_id),
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

#' Factory function for creating a glossary
#'
#' @param apiURL The base URL for the DeepL API
#' @return A function that creates a glossary
#' @noRd
ff_create_glossary <- function(apiURL) {
    force(apiURL)
    
    function(
        name, 
        source_lang, 
        target_lang, 
        entries, 
        auth_key,
        ...) {
        clean_entries <- lapply(entries, trimws)  # Remove leading and trailing whitespace
        entries_str <- paste(names(clean_entries), clean_entries, sep = "\t", collapse = "\n")
        
        body <- list(
            name = name,
            source_lang = source_lang,
            target_lang = target_lang,
            entries = entries_str,
            entries_format = "tsv"
        )
        
        cat("API URL:", apiURL, "\n")
        cat("Request body:\n")
        print(body)
        
        response <- httr::POST(
            url = paste0(apiURL, "/v2/glossaries"),
            body = body,
            httr::add_headers("Authorization" = paste0("DeepL-Auth-Key ", auth_key)),
            encode = "form"
        )
        
        cat("Response status:", httr::status_code(response), "\n")
        cat("Response content:\n")
        print(httr::content(response, "text"))
        
        response_check(response)
        
        httr::content(response)
    }
}

#' Factory function for deleting a glossary
#'
#' @param apiURL The base URL for the DeepL API
#' @return A function that deletes a glossary
#' @noRd
ff_delete_glossary <- function(apiURL) {
    force(apiURL)
    
    function(glossary_id, auth_key) {
        
        cat("API URL:", apiURL, "\n")
        cat("Request glossary:\n")
        print(glossary_id)
        
        response <- httr::DELETE(
            url = paste0(apiURL, "/v2/glossaries/", glossary_id),
            httr::add_headers("Authorization" = paste0("DeepL-Auth-Key ", auth_key))
        )
        
        response_check(response)
        
        httr::status_code(response) == 204
    }
}

#' Factory function for listing glossaries
#'
#' @param apiURL The base URL for the DeepL API
#' @return A function that lists all glossaries
#' @noRd
ff_list_glossaries <- function(apiURL) {
    force(apiURL)
    
    function(auth_key) {
        response <- httr::GET(
            url = paste0(apiURL, "/v2/glossaries"),
            httr::add_headers("Authorization" = paste0("DeepL-Auth-Key ", auth_key))
        )
        
        response_check(response)
        
        httr::content(response)$glossaries
    }
}

# Create the actual functions for both API versions
create_glossary_wh  <- ff_create_glossary("https://api.deepl.com")
create_glossary2_wh  <- ff_create_glossary("https://api-free.deepl.com")

delete_glossary_wh  <- ff_delete_glossary("https://api.deepl.com")
delete_glossary2_wh  <- ff_delete_glossary("https://api-free.deepl.com")

list_glossaries_wh  <- ff_list_glossaries("https://api.deepl.com")
list_glossaries2_wh  <- ff_list_glossaries("https://api-free.deepl.com")



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
