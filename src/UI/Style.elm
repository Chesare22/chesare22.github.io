module UI.Style exposing
    ( centeredContent
    , coloredBlock
    , displayGrid
    , ghost
    , paragraph
    , round
    , subtitle
    , title
    )

import Css exposing (..)
import UI.Media
import UI.Palette
import UI.Theme exposing (..)


centeredContent : Style
centeredContent =
    batch
        [ displayGrid
        , property "place-items" "center"
        ]


displayGrid : Style
displayGrid =
    property "display" "grid"


round : Style
round =
    borderRadius (pct 50)


paragraph : Style
paragraph =
    batch
        [ lineHeight (Css.em 1.5)
        , marginBottom (Css.em 1)
        , marginTop (px 0)
        , UI.Media.onPrint
            [ lineHeight (Css.em 1.35)
            ]
        ]


ghost : Style
ghost =
    batch
        [ padding (rem 0.5)
        , backgroundColor transparent
        , color inherit
        , cursor pointer
        , border (px 0)
        , property "transition" "background-color .25s ease"
        , hover
            [ backgroundColor UI.Palette.grey.c800
            ]
        , active
            [ backgroundColor UI.Palette.grey.c700
            ]
        ]


title : Theme -> Style
title theme =
    batch
        [ color (UI.Palette.title theme)
        , fontSize (Css.em 2)
        , UI.Media.onSmallScreen
            [ textAlign center
            ]
        ]


subtitle : Theme -> Style
subtitle theme =
    batch
        [ color (UI.Palette.title theme)
        , fontSize (rem 1.4)
        , fontWeight (int 700)
        , marginBottom (Css.em 0.5)
        , marginTop (Css.em 0.85)
        ]


coloredBlock : Theme -> Style
coloredBlock theme =
    batch
        [ borderRadius (px 4)
        , backgroundColor <|
            themed
                (UI.Palette.changeOpacity
                    UI.Palette.primary.c400
                    0.1
                )
                UI.Palette.primary.c50
                theme
        , marginBottom (rem 1)
        , padding (rem 0.75)
        , paddingRight (rem 1)
        , borderLeft3
            (px 4)
            solid
            (themed
                UI.Palette.primary.c400
                UI.Palette.primary.c600
                theme
            )
        ]
