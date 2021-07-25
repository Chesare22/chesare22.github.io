module Main exposing (..)

import Browser
import Color
import Css exposing (..)
import FeatherIcons
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
        [ Attributes.css
            [ minWidth (vw 100)
            , minHeight (vh 100)
            , myMainBackground theme
            , displayFlex
            , justifyContent center
            ]
        ]
        [ div
            [ Attributes.css
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
                , Attributes.css [ cursor pointer ]
                ]
                [ switchThemeIcon 16 theme ]
            , ul
                [ Attributes.css
                    [ listStyle none
                    , color (hex "fff")
                    ]
                ]
                (List.map displayContact <| contactList 16)
            ]
        ]


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
            backgroundColor (hex "1c3049")

        Light ->
            backgroundColor (hex "FFFFFF")
