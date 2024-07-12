library(testthat)

test_that("Glossary can be created and used", {
    skip_if_no_auth()  # Skip if no authentication key is available
    
    # Test creating a glossary
    test_glossary_name <- paste0("test_glossary_", as.integer(Sys.time()))
    test_entries <- list("Hello" = "Hola", "World" = "Mundo")
    
    glossary <- create_glossary(
        name = test_glossary_name,
        source_lang = "EN",
        target_lang = "ES",
        entries = test_entries,
        auth_key = Sys.getenv("DEEPL_AUTH_KEY")
    )
    
    expect_is(glossary, "list")
    expect_true("glossary_id" %in% names(glossary))
    
    # Test using the glossary
    test_text <- "Hello World!"
    translation <- translate(
        text = test_text,
        target_lang = "ES",
        source_lang = "EN",
        glossary_id = glossary$glossary_id,
        auth_key = Sys.getenv("DEEPL_AUTH_KEY")
    )
    
    expect_equal(translation, "Hola Mundo !")
    
    # Clean up: delete the test glossary
    delete_result <- delete_glossary(
        glossary_id = glossary$glossary_id,
        auth_key = Sys.getenv("DEEPL_AUTH_KEY")
    )
    
    expect_true(delete_result)
})

# Helper function to skip tests if no auth key is available
skip_if_no_auth <- function() {
    if (Sys.getenv("DEEPL_AUTH_KEY") == "") {
        skip("No DeepL authentication key available")
    }
}