# ----------------------------------------------------------
# Filename: translate_ff.R 
# ---------------------------------------------------------- 
#   Author: David Macro (david@dataim.nl)
#     Date: 2024-07-05
#  Purpose: 
# ----------------------------------------------------------
# 
#  

ff_list_glossaries <- function(.f){
    function(auth_key, ...) {
        if(is.null(auth_key)) stop("auth_key is required")
        
        response <- .f(auth_key = auth_key, ...)
        
        return(response)
    }
}

list_glossaries <- ff_list_glossaries(.f = list_glossaries_wh)
list_glossaries2 <- ff_list_glossaries(.f = list_glossaries2_wh)
