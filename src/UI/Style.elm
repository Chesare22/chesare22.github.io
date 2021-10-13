module UI.Style exposing
    ( centeredContent
    , displayGrid
    , roundBorder
    )

import Css exposing (..)


centeredContent : Style
centeredContent =
    batch
        [ displayGrid
        , property "place-items" "center"
        ]


displayGrid : Style
displayGrid =
    property "display" "grid"


roundBorder : Style
roundBorder =
    borderRadius (pct 50)
