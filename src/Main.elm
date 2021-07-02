module Main exposing (..)

import Browser
import Color
import Css exposing (..)
import Css.Global exposing (svg)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
import Material.Icons as Filled
import Material.Icons.Outlined as Outlined
import Material.Icons.Types exposing (Coloring(..))
import Svg



-- MAIN


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view >> toUnstyled
        }



-- MODEL


type Theme
    = Light
    | Dark


type Language
    = Spanish
    | English


type alias Model =
    { theme : Theme
    , language : Language
    }


init : Model
init =
    { theme = Dark
    , language = Spanish
    }



-- UPDATE


type Msg
    = ChangeTheme
    | ChangeLanguage Language


update : Msg -> Model -> Model
update msg model =
    case msg of
        ChangeTheme ->
            { model | theme = toggleTheme model.theme }

        ChangeLanguage newLang ->
            { model | language = newLang }


toggleTheme : Theme -> Theme
toggleTheme currentTheme =
    case currentTheme of
        Dark ->
            Light

        Light ->
            Dark



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ css
            [ minWidth (vw 100)
            , minHeight (vh 100)
            , myMainBackground model.theme
            ]
        ]
        [ svgToHtml (Filled.offline_bolt 16 (Color <| Color.rgb 96 181 204)) ]


myMainBackground : Theme -> Style
myMainBackground theme =
    case theme of
        Dark ->
            backgroundColor (hex "141414")

        Light ->
            backgroundColor (hex "ededed")


svgToHtml : Svg.Svg msg -> Html msg
svgToHtml svg =
    fromUnstyled (Svg.svg [] [ svg ])
