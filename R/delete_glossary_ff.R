# ----------------------------------------------------------
# Filename: translate_ff.R 
# ---------------------------------------------------------- 
#   Author: David Macro (david@dataim.nl)
#     Date: 2024-07-05
#  Purpose: 
# ----------------------------------------------------------
# 
#  

ff_delete_glossaries <- function(.f){
    function(glossary_id,auth_key, ...) {
        if(is.null(auth_key)) stop("auth_key is required")
        if(is.null(glossary_id)) stop("glossary_id is required")
        
        response <- .f(glossary_id = glossary_id,auth_key = auth_key, ...)
        
        return(response)
    }
}

delete_glossary <- ff_delete_glossaries(.f = delete_glossary_wh)
delete_glossary2 <- ff_delete_glossaries(.f = delete_glossary2_wh)
