# ----------------------------------------------------------
# Filename: testYago.R 
# ---------------------------------------------------------- 
#   Author: David Macro (david@dataim.nl)
#     Date: 2024-07-17
#  Purpose: 
# ----------------------------------------------------------
# 
#  
rm(list=ls())

devtools::load_all()

# Translating without glossary still works
translate(
    text        = "Hello2 World3",
    source_lang = "EN",
    target_lang = "ES",
    auth_key    = Sys.getenv("DEEPL_API_KEY")
)
 
list_glossaries(
    auth_key = Sys.getenv("DEEPL_API_KEY")
)

create_glossary(
    name        = "Spanish TestGlossary",
    source_lang = "EN",
    target_lang = "ES",
    entries     = list("Hello2" = "Que Pasa 2", "World3" = " En el Mundo 2"),
    auth_key    = Sys.getenv("DEEPL_API_KEY")
)

glossaries <- list_glossaries(
    auth_key = Sys.getenv("DEEPL_API_KEY")
)

test.glossary.id <- purrr::keep(glossaries, ~.x$name == "Spanish TestGlossary")[[1]]$glossary_id

# Translating without glossary still works
translate(
    text        = "Hello2 World3",
    source_lang = "EN",
    target_lang = "ES",
    auth_key    = Sys.getenv("DEEPL_API_KEY"),
    glossary_id = test.glossary.id
)


delete_glossary(glossary_id = test.glossary.id, auth_key = Sys.getenv("DEEPL_API_KEY"))