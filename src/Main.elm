port module Main exposing (..)

import Browser
import Css exposing (..)
import Css.Global as Global
import Css.Media exposing (only, print, screen, withMedia)
import FeatherIcons
import Html.Attributes exposing (value)
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events exposing (..)
import Material.Icons as Filled
import Material.Icons.Types exposing (Coloring(..))
import Phone
import Svg.Styled



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view >> toUnstyled
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



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


init : () -> ( Model, Cmd Msg )
init _ =
    ( { theme = Dark
      , language = Spanish
      }
    , Cmd.none
    )



-- PORTS


port printPage : () -> Cmd msg



-- UPDATE


type Msg
    = ChangeTheme
    | ChangeLanguage String
    | Print


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeTheme ->
            ( { model | theme = toggleTheme model.theme }, Cmd.none )

        ChangeLanguage newLang ->
            let
                language =
                    if newLang == "es" then
                        Spanish

                    else
                        English
            in
            ( { model | language = language }, Cmd.none )

        Print ->
            ( model, printPage () )


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
        [ Attributes.css
            [ minHeight (vh 100)
            , getMainBackground model.theme
            , displayFlex
            , justifyContent center
            , getParagraphColor model.theme
            , onlyScreen [ paddingTop optionsBarHeight ]
            ]
        ]
        [ Global.global
            [ Global.selector "#options-bar.hidden"
                [ top (rem (negate optionsBarHeightInt))
                ]
            ]

        -- Options bar
        , div
            [ Attributes.id "options-bar"
            , Attributes.css
                [ height optionsBarHeight
                , width (pct 100)
                , position fixed
                , top (px 0)
                , optionsBarBg
                , hiddenOnPrint
                , property "transition" "all .3s ease"
                , centeredContent
                , getParagraphColor Dark
                , displayGrid
                , property "grid-template-columns" "repeat(3, auto)"
                , property "grid-gap" "1.5rem"
                , justifyContent center
                ]
            ]
            [ div
                [ Attributes.css
                    [ displayGrid
                    , property "grid-template-columns" "repeat(2, auto)"
                    , property "grid-gap" "0.3rem"
                    ]
                ]
                [ label [ Attributes.for "language-select" ]
                    [ text (translatedText "Lenguaje:" "Language:" model.language)
                    ]
                , select
                    [ Attributes.id "language-select"
                    , onInput ChangeLanguage
                    ]
                    (List.map (displayLangOptions model.language) langOptions)
                ]
            , ghostRoundButton
                [ onClick ChangeTheme
                , Attributes.css
                    [ position relative
                    , left (rem 0.25)
                    ]
                ]
                [ switchThemeIcon 20 model.theme ]
            , ghostRoundButton
                [ onClick Print
                ]
                [ Svg.Styled.fromUnstyled <| Filled.print 20 Inherit ]
            ]

        -- Paper
        , div
            [ Attributes.css
                [ maxWidth paperWidth
                , width (pct 100)
                , height paperHeight
                , padding paperPadding
                , getPaperBackground model.theme
                , onlyScreen
                    [ margin2 (rem 2) (px 0)
                    , borderRadius (px 10)
                    , paperShadow model.theme
                    ]
                ]
            ]
            [ ul
                [ Attributes.css
                    [ listStyle none
                    ]
                ]
                (List.map displayContact <| contactList 16)
            ]
        ]


displayLangOptions : Language -> LangOption -> Html Msg
displayLangOptions language { value, label } =
    option [ Attributes.value value ] [ text (label language) ]


displayContact : ContactInfo Msg -> Html Msg
displayContact contact =
    li []
        [ a
            [ Attributes.href contact.href
            , Attributes.target "_blank"
            , Attributes.css [ color inherit ]
            ]
            [ span
                []
                [ contact.icon ]
            , span [] [ text contact.text ]
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
            border3 (px 1) solid grey.c50

        Light ->
            smoothGrayShadow


switchThemeIcon : Int -> Theme -> Svg.Styled.Svg msg
switchThemeIcon size theme =
    case theme of
        Dark ->
            Svg.Styled.fromUnstyled (Filled.dark_mode size Inherit)

        Light ->
            Svg.Styled.fromUnstyled (Filled.light_mode size Inherit)



-- CONSTATNS


name : String
name =
    "César Alejandro González Ortega"


email : String
email =
    "chesarglez429@gmail.com"


phone : Phone.InternationalPhone
phone =
    Phone.InternationalPhone
        52
        1
        9993912495


type alias ContactInfo msg =
    { href : String
    , text : String
    , icon : Svg.Styled.Svg msg
    }


contactList : Int -> List (ContactInfo Msg)
contactList iconSize =
    [ { href = "mailto:" ++ email
      , text = email
      , icon = Svg.Styled.fromUnstyled <| Filled.email iconSize Inherit
      }
    , { href = Phone.toWhatsAppUrl phone
      , text = Phone.toString phone
      , icon =
            Svg.Styled.fromUnstyled
                (FeatherIcons.smartphone
                    |> FeatherIcons.withSize (toFloat iconSize)
                    |> FeatherIcons.toHtml []
                )
      }
    , { href = "https://github.com/Chesare22"
      , text = "/Chesare22"
      , icon =
            Svg.Styled.fromUnstyled
                (FeatherIcons.github
                    |> FeatherIcons.withSize (toFloat iconSize)
                    |> FeatherIcons.toHtml []
                )
      }
    , { href = "https://gitlab.com/Chesare22"
      , text = "/Chesare22"
      , icon =
            Svg.Styled.fromUnstyled
                (FeatherIcons.gitlab
                    |> FeatherIcons.withSize (toFloat iconSize)
                    |> FeatherIcons.toHtml []
                )
      }
    , { href = "https://www.linkedin.com/in/cgonzalez22/"
      , text = "/cgonzalez22"
      , icon =
            Svg.Styled.fromUnstyled
                (FeatherIcons.linkedin
                    |> FeatherIcons.withSize (toFloat iconSize)
                    |> FeatherIcons.toHtml []
                )
      }
    ]


translatedText : String -> String -> Language -> String
translatedText onSpanish onEnglish language =
    case language of
        Spanish ->
            onSpanish

        English ->
            onEnglish


type alias LangOption =
    { value : String
    , label : Language -> String
    }


langOptions : List LangOption
langOptions =
    [ LangOption "es" (translatedText "Español" "Spanish")
    , LangOption "en" (translatedText "Inglés" "English")
    ]



-- REUSABLE STYLES


onlyScreen : List Style -> Style
onlyScreen =
    withMedia [ only screen [] ]


onlyPrint : List Style -> Style
onlyPrint =
    withMedia [ only print [] ]


hiddenOnPrint : Style
hiddenOnPrint =
    onlyPrint [ display none ]


centeredContent : Style
centeredContent =
    batch
        [ displayGrid
        , property "place-items" "center"
        ]


displayGrid : Style
displayGrid =
    property "display" "grid"


ghostRoundButton : List (Attribute msg) -> List (Html msg) -> Html msg
ghostRoundButton =
    styled button
        [ borderRadius (pct 50)
        , padding (rem 0.5)
        , backgroundColor transparent
        , color inherit
        , cursor pointer
        , border (px 0)
        , property "transition" "background-color .25s ease"
        , hover
            [ backgroundColor grey.c800
            ]
        , active
            [ backgroundColor grey.c700
            ]
        ]



-- COLOR PALETTE


type alias Palette =
    { c50 : Color
    , c100 : Color
    , c200 : Color
    , c300 : Color
    , c400 : Color
    , c500 : Color
    , c600 : Color
    , c700 : Color
    , c800 : Color
    , c900 : Color
    }


primary : Palette
primary =
    Palette
        (hex "f9e6f0")
        (hex "f2c0db")
        (hex "ec97c3")
        (hex "e870ab")
        (hex "e45397")
        (hex "e43c83")
        (hex "d2397e")
        (hex "bb3676")
        (hex "a5336f")
        (hex "7d2d61")


secondary : Palette
secondary =
    Palette
        (hex "e5eeff")
        (hex "c4d8f2")
        (hex "a9bcdb")
        (hex "8ba1c4")
        (hex "748db2")
        (hex "5d79a1")
        (hex "4e6b8f")
        (hex "3e5778")
        (hex "2f4561")
        (hex "1c3049")


grey : Palette
grey =
    Palette
        (hex "fafafa")
        (hex "f5f5f5")
        (hex "eeeeee")
        (hex "e0e0e0")
        (hex "bdbdbd")
        (hex "9e9e9e")
        (hex "757575")
        (hex "616161")
        (hex "424242")
        (hex "212121")


getMainBackground : Theme -> Style
getMainBackground theme =
    case theme of
        Dark ->
            getPaperBackground Dark

        Light ->
            backgroundColor grey.c200


getPaperBackground : Theme -> Style
getPaperBackground theme =
    case theme of
        Dark ->
            backgroundColor secondary.c900

        Light ->
            backgroundColor grey.c50


optionsBarBg : Style
optionsBarBg =
    backgroundColor (hex "121212")


getParagraphColor : Theme -> Style
getParagraphColor theme =
    case theme of
        Dark ->
            color grey.c50

        Light ->
            color grey.c900


transparent : Color
transparent =
    hex "00000000"



-- Dimentions


paperWidthInt : number
paperWidthInt =
    51


paperHeightInt : number
paperHeightInt =
    66


paperPaddingInt : number
paperPaddingInt =
    1


optionsBarHeightInt : number
optionsBarHeightInt =
    4


paperWidth : Rem
paperWidth =
    rem (paperWidthInt - 2 * paperPaddingInt)


paperHeight : Rem
paperHeight =
    rem (paperHeightInt - 2 * paperPaddingInt)


paperPadding : Rem
paperPadding =
    rem paperPaddingInt


optionsBarHeight : Rem
optionsBarHeight =
    rem optionsBarHeightInt
