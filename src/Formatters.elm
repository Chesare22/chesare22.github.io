module Formatters exposing (formatDateRange)

import Constants exposing (SimpleDate)
import Language exposing (Language(..))
import String.Extra
import Time


formatDateRange : Language -> SimpleDate -> Maybe SimpleDate -> String
formatDateRange language start end =
    String.Extra.toTitleCase
        (formatDate language start
            ++ " — "
            ++ (case end of
                    Just date ->
                        formatDate language date

                    Nothing ->
                        Language.translated "actual" "present" language
               )
        )


formatDate : Language -> SimpleDate -> String
formatDate language date =
    translateMonth language date.month
        ++ " "
        ++ String.fromInt date.year


translateMonth : Language -> Time.Month -> String
translateMonth =
    Language.translated monthsEs monthsEn


monthsEn : Time.Month -> String
monthsEn month =
    case month of
        Time.Jan ->
            "january"

        Time.Feb ->
            "february"

        Time.Mar ->
            "march"

        Time.Apr ->
            "april"

        Time.May ->
            "may"

        Time.Jun ->
            "june"

        Time.Jul ->
            "july"

        Time.Aug ->
            "august"

        Time.Sep ->
            "september"

        Time.Oct ->
            "october"

        Time.Nov ->
            "november"

        Time.Dec ->
            "december"


monthsEs : Time.Month -> String
monthsEs month =
    case month of
        Time.Jan ->
            "enero"

        Time.Feb ->
            "febrero"

        Time.Mar ->
            "marzo"

        Time.Apr ->
            "abril"

        Time.May ->
            "mayo"

        Time.Jun ->
            "junio"

        Time.Jul ->
            "julio"

        Time.Aug ->
            "agosto"

        Time.Sep ->
            "septiembre"

        Time.Oct ->
            "octubre"

        Time.Nov ->
            "noviembre"

        Time.Dec ->
            "diciembre"
