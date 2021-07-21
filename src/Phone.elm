module Phone exposing (InternationalPhone, toString, toWhatsAppUrl)

import String exposing (..)


type alias InternationalPhone =
    { countryCode : Int
    , cityCode : Int
    , localPhoneNumber : Int
    }


toWhatsAppUrl : InternationalPhone -> String
toWhatsAppUrl { countryCode, cityCode, localPhoneNumber } =
    "https://wa.me/"
        ++ String.fromInt countryCode
        ++ String.fromInt cityCode
        ++ String.fromInt localPhoneNumber


toString : InternationalPhone -> String
toString =
    .localPhoneNumber >> String.fromInt >> formatString


formatString : String -> String
formatString str =
    "("
        ++ slice 0 3 str
        ++ ") "
        ++ slice 3 6 str
        ++ " "
        ++ slice 6 10 str
