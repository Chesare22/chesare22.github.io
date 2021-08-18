module Language exposing (..)


type Language
    = Spanish
    | English


translated : a -> a -> Language -> a
translated onSpanish onEnglish language =
    case language of
        Spanish ->
            onSpanish

        English ->
            onEnglish


toValue : Language -> String
toValue =
    translated "es" "en"


fromValue : String -> Language
fromValue str =
    if str == "es" then
        Spanish

    else
        English


toggle : Language -> Language
toggle =
    translated English Spanish


type alias ValueWithLabel =
    { value : String
    , label : Language -> String
    }


valuesWithLabels : List ValueWithLabel
valuesWithLabels =
    [ ValueWithLabel
        (toValue Spanish)
        (translated "Español" "Spanish")
    , ValueWithLabel
        (toValue English)
        (translated "Inglés" "English")
    ]
