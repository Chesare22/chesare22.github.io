module Phone exposing (..)


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
    .localPhoneNumber >> String.fromInt
