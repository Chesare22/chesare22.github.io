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
            , displayFlex
            , justifyContent center
            ]
        ]
        [ div
            [ css
                [ maxWidth (rem 38.25)
                , width (pct 100)
                , height (rem 49.5)
                , borderRadius (px 10)
                , margin2 (rem 2) (px 0)
                , padding (rem 1)
                , myPaperBackground theme
                , paperShadow theme
                ]
            ]
            [ span
                [ onClick ChangeTheme
                , css [ cursor pointer ]
                ]
                [ switchThemeIcon 16 theme ]
            ]
        ]


smoothGrayShadow : Style
smoothGrayShadow =
    property "box-shadow"
        (String.concat
            [ "0 2.8px 2.2px rgba(0, 0, 0, 0.034),"
            , "0 6.7px 5.3px rgba(0, 0, 0, 0.048),"
            , "0 12.5px 10px rgba(0, 0, 0, 0.06),"
            , "0 22.3px 17.9px rgba(0, 0, 0, 0.072),"
            , "0 41.8px 33.4px rgba(0, 0, 0, 0.086),"
            , "0 100px 80px rgba(0, 0, 0, 0.12)"
            ]
        )


paperShadow : Theme -> Style
paperShadow theme =
    case theme of
        Dark ->
            batch []

        Light ->
            smoothGrayShadow


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
            backgroundColor (hex "121212")

        Light ->
            backgroundColor (hex "EEF2F7")


myPaperBackground : Theme -> Style
myPaperBackground theme =
    case theme of
        Dark ->
            backgroundColor (hex "2C2C2C")

        Light ->
            backgroundColor (hex "FFFFFF")
