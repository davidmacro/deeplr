
# Translate function factory
test_that("translate_ff", {
   
    `%||%` <- function(x,y){ `if`(is.null(x), y, x)}
  
    invisible({ 
        .API_KEY_DEEPL      <- Sys.getenv("API_KEY_DEEPL")      %||%  "[your_key]"
        .API_KEY_DEEPL_FREE <- Sys.getenv("API_KEY_DEEPL_FREE") %||%  "[your_free_key]"
        
    })  
   
    # FF Creation works
    testthat::expect_no_error({ 
        t1  <- ff_translate(.f = translate_wh) 
        t2  <- ff_translate(.f = translate2_wh) 
    })
    
    # These tests will be ignored if API keys are not set. Note: 
    if(!.API_KEY_DEEPL %in% c("", "[your_key]")){
         
        result <- translate("Dit is een test.", target_lang = "EN", source_lang = "NL", auth_key = .API_KEY_DEEPL)
        
        testthat::expect_equal(tolower(result), tolower("This is a test."))    
    }
    
    if(!.API_KEY_DEEPL_FREE %in% c("", "[your_free_key]")){
        
        result <- translate2("Dit is een test.", target_lang = "EN", source_lang = "NL", auth_key = .API_KEY_DEEPL_FREE)
    
        testthat::expect_equal(tolower(result), tolower("This is a test."))    
    }
     
})
