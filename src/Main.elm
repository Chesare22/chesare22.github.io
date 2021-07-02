module Main exposing (..)

import Browser
import Color
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (..)
import Material.Icons as Filled
import Material.Icons.Types exposing (Coloring(..))
import Svg.Styled



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
view { theme } =
    div
        [ css
            [ minWidth (vw 100)
            , minHeight (vh 100)
            , myMainBackground theme
            ]
        ]
        [ span
            [ onClick ChangeTheme
            , css [ cursor pointer ]
            ]
            [ switchThemeIcon 16 theme ]
        ]


switchThemeIcon : Int -> Theme -> Svg.Styled.Svg msg
switchThemeIcon size theme =
    case theme of
        Dark ->
            Svg.Styled.fromUnstyled (Filled.dark_mode size (Color <| Color.rgb255 96 181 204))

        Light ->
            Svg.Styled.fromUnstyled (Filled.light_mode size (Color <| Color.rgb255 95 99 104))


myMainBackground : Theme -> Style
myMainBackground theme =
    case theme of
        Dark ->
            backgroundColor (hex "141414")

        Light ->
            backgroundColor (hex "ededed")
