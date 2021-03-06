module Language exposing (Language(..), toSentence, translated)


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


toSentence : Language -> List (Language -> String) -> String
toSentence language =
    List.map ((|>) language)
        >> joinWithConjunction (translated "y" "and" language)


joinWithConjunction : String -> List String -> String
joinWithConjunction conjunction words =
    case List.reverse words of
        [] ->
            ""

        [ str ] ->
            str

        lastElement :: rest ->
            String.join " "
                [ rest
                    |> List.reverse
                    |> String.join ", "
                , conjunction
                , lastElement
                ]
