translate2(
    text="Hello2 World3",
    source_lang="EN",
    target_lang = "ES",
    auth_key = "your_api_key", 
    glossary_id = "205c687a-5be6-4eed-b010-c217d906904")

list_glossaries2(auth_key = "your_api_key")
create_glossary2(
    name = "Prueba 4",
    source_lang = "EN",
    target_lang = "ES",
    entries = list("Hello3" = "Que Pasa 2", "World3" = " En el Mundo 2"),
    auth_key = "your_api_key"
)

delete_glossary2(glossary_id = "b674ff04-3ed9-44e3-a1e9-eca5b2112174", auth_key = "your_api_key")