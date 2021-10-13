module UI.Media exposing
    ( aboveSmallScreen
    , belowBigScreen
    , notOnPrint
    , onAnyScreen
    , onBigScreen
    , onMediumScreen
    , onPrint
    , onSmallScreen
    )

import Css exposing (..)
import Css.Media as Media exposing (..)



-- MEDIA QUERIES


onAnyScreen : List Style -> Style
onAnyScreen =
    withMedia [ only screen [] ]


onSmallScreen : List Style -> Style
onSmallScreen =
    withMedia [ only screen [ Media.maxWidth smallScreen ] ]


aboveSmallScreen : List Style -> Style
aboveSmallScreen =
    withMedia [ only screen [ Media.minWidth smallScreen ] ]


onMediumScreen : List Style -> Style
onMediumScreen =
    withMedia
        [ only screen
            [ Media.minWidth smallScreen
            , Media.maxWidth mediumScreen
            ]
        ]


onBigScreen : List Style -> Style
onBigScreen =
    withMedia [ only screen [ Media.minWidth mediumScreen ] ]


belowBigScreen : List Style -> Style
belowBigScreen =
    withMedia
        [ only screen
            [ Media.maxWidth <|
                em (mediumScreen.numericValue - 1 / 16)
            ]
        ]


onPrint : List Style -> Style
onPrint =
    withMedia [ only print [] ]


notOnPrint : List Style -> Style
notOnPrint =
    withMedia [ Media.not print [] ]



-- BREAKPOINTS


smallScreen : Em
smallScreen =
    em 44


mediumScreen : Em
mediumScreen =
    em 56
