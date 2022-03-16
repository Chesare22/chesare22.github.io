module UI.Style exposing
    ( centeredContent
    , coloredBlock
    , divider
    , ghost
    , paper
    , paragraph
    , round
    , subtitle
    , title
    )

import Css exposing (..)
import UI.Media
import UI.Palette
import UI.Size


centeredContent : Style
centeredContent =
    batch
        [ property "display" "grid"
        , property "place-items" "center"
        ]


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


title : UI.Palette.Theme -> Style
title theme =
    batch
        [ color (UI.Palette.title theme)
        , fontSize (Css.em 2)
        , UI.Media.onSmallScreen
            [ textAlign center
            ]
        ]


subtitle : UI.Palette.Theme -> Style
subtitle theme =
    batch
        [ color (UI.Palette.title theme)
        , fontSize (rem 1.4)
        , fontWeight (int 700)
        , marginBottom (Css.em 0.5)
        , marginTop (Css.em 0.85)
        ]


coloredBlock : UI.Palette.Theme -> Style
coloredBlock theme =
    batch
        [ borderRadius (px 4)
        , backgroundColor <|
            UI.Palette.themed
                (UI.Palette.changeOpacity
                    UI.Palette.primary.c400
                    0.1
                )
                UI.Palette.primary.c050
                theme
        , marginBottom (rem 1)
        , padding (rem 0.75)
        , paddingRight (rem 1)
        , borderLeft3
            (px 4)
            solid
            (UI.Palette.themed
                UI.Palette.primary.c400
                UI.Palette.primary.c600
                theme
            )
        ]


paper : UI.Palette.Theme -> Style
paper theme =
    batch
        [ maxWidth UI.Size.paperWidth
        , width (pct 100)
        , padding2
            UI.Size.paperPadding.vertical
            UI.Size.paperPadding.horizontal
        , backgroundColor <| UI.Palette.paperBackground theme
        , UI.Media.onPrint
            [ UI.Palette.themed
                (batch [])
                (backgroundColor (hex "fff"))
                theme
            , height UI.Size.paperHeight
            ]
        , UI.Media.onBigScreen
            [ margin2 (rem 2) (px 0)
            , UI.Palette.paperShadow theme
            , borderRadius (px 10)
            ]
        , UI.Media.belowBigScreen
            [ boxSizing borderBox
            , maxWidth (rem UI.Size.paperWidthInt)
            ]
        ]


divider : UI.Palette.Theme -> Style
divider theme =
    batch
        [ property "content" "\"\""
        , width (pct 100)
        , height (px 1)
        , position relative
        , top UI.Size.paperPadding.vertical
        , backgroundColor
            (UI.Palette.themed
                UI.Palette.grey.c050
                UI.Palette.grey.c500
                theme
            )
        ]
