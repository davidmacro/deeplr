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

create_glossary <- ff_create_glossary(.f = create_glossary_wh)
create_glossary2 <- ff_create_glossary(.f = create_glossary2_wh)