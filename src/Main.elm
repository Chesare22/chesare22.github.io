port module Main exposing (..)

import Browser
import Css exposing (..)
import Css.Global as Global
import Css.Media as Media exposing (only, print, screen, withMedia)
import FeatherIcons
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events exposing (..)
import Language
import Material.Icons as Filled
import Material.Icons.Types exposing (Coloring(..), Icon)
import Phone
import Regex
import Svg.Styled



-- MAIN


main : Program Flags Model Msg
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



-- PORTS


port printPage : () -> Cmd msg



-- MODEL


type Theme
    = Light
    | Dark


type alias Flags =
    { profilePicture : String
    }


type alias Model =
    { theme : Theme
    , language : Language.Language
    , profilePicture : String
    }


init : Flags -> ( Model, Cmd Msg )
init { profilePicture } =
    ( { theme = Dark
      , language = Language.Spanish
      , profilePicture = profilePicture
      }
    , Cmd.none
    )



-- CASE EXPRESSIONS OF MODEL


themed : a -> a -> Theme -> a
themed darkElement lightElement theme =
    case theme of
        Dark ->
            darkElement

        Light ->
            lightElement



-- UPDATE


type Msg
    = ChangeTheme
    | ChangeLanguage String
    | Print


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeTheme ->
            ( { model | theme = toggleTheme model.theme }
            , Cmd.none
            )

        ChangeLanguage value ->
            ( { model | language = Language.fromValue value }
            , Cmd.none
            )

        Print ->
            ( model
            , printPage ()
            )


toggleTheme : Theme -> Theme
toggleTheme =
    themed Light Dark



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ Attributes.css
            [ minHeight (vh 100)
            , paperBackground model.theme
            , displayFlex
            , justifyContent center
            , paragraphColor model.theme
            , onlyScreen
                [ paddingTop optionsBarHeight
                ]
            , onlyBigScreen
                [ mainBackground model.theme
                ]
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
                , zIndex (int 100)
                , top (px 0)
                , backgroundColor almostBlack
                , hiddenOnPrint
                , property "transition" "all .3s ease"
                , centeredContent
                , paragraphColor Dark
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
                    [ text (Language.translated "Lenguaje:" "Language:" model.language)
                    ]
                , select
                    [ Attributes.id "language-select"
                    , onInput ChangeLanguage
                    ]
                    (List.map (displayLangOptions model.language) Language.valuesWithLabels)
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
                , padding2 paperPadding.vertical paperPadding.horizontal
                , paperBackground model.theme
                , displayGrid
                , property "grid-template-columns" "3fr 5fr"
                , property "column-gap" "2rem"
                , property "align-content" "start"
                , printOrBigScreen
                    [ height paperHeight
                    ]
                , onlyBigScreen
                    [ margin2 (rem 2) (px 0)
                    , paperShadow model.theme
                    , borderRadius (px 10)
                    ]
                , onlySmallScreen
                    [ property "grid-template-columns" "1fr"
                    ]
                ]
            ]
            -- Column 1
            [ div
                []
                [ roundImg profilePictureSize
                    [ Attributes.src model.profilePicture
                    , Attributes.alt
                        (Language.translated
                            "Foto de César con lentes"
                            "Photo of César with glasses"
                            model.language
                        )
                    ]
                , h1
                    [ Attributes.css
                        [ color (titleColor model.theme)
                        ]
                    ]
                    [ text name ]
                , spaced_p []
                    [ text
                        (Language.translated
                            "Soy un estudiante de ingeniería de software con dos años de experiencia trabajando como desarrollador frontend. Estoy comprometido con la calidad del software en todas sus etapas, desde la planeación del producto hasta la correcta entrega y mantenimiento del mismo. A menudo intento hacer mi código lo más simple posible y disfruto aprender cosas nuevas."
                            "I'm a software engineering student with two years of experience working as a frontend developer. I am committed to software quality in all their stages, from the planning to the delivery and maintenance. I often try to make my code the simplest posible and I enjoy learning new stuff."
                            model.language
                        )
                    ]
                , p
                    [ Attributes.css
                        [ color (titleColor model.theme)
                        , fontSize (rem 1.4)
                        , fontWeight (int 700)
                        , marginBottom (Css.em 0.3)
                        , marginTop (Css.em 1.5)
                        ]
                    ]
                    [ text
                        (Language.translated
                            "Me puedes encontrar en"
                            "You can find me on"
                            model.language
                        )
                    ]
                , coloredBlock model.theme
                    [ ul
                        [ Attributes.css
                            [ listStyle none
                            , paddingLeft (px 0)
                            , margin (px 0)
                            ]
                        ]
                        (List.map displayContact <| contactList 16)
                    ]
                ]

            -- Column 2
            , div []
                [ p [] [ text "Litter kitter kitty litty little kitten big roar roar feed me. I could pee on this if i had the energy purr purr purr until owner pets why owner not pet me hiss scratch meow your pillow is now my pet bed show belly sit in window and stare oooh, a bird, yum and scream for no reason at 4 am so plays league of legends. Bite nose of your human is good you understand your place in my world poop in the plant pot small kitty warm kitty little balls of fur for the cat was chasing the mouse. Bring your owner a dead bird. Stare at owner accusingly then wink lick yarn hanging out of own butt friends are not food. I can haz please stop looking at your phone and pet me yet jump off balcony, onto stranger's head." ]
                , coloredBlock
                    model.theme
                    (List.map (displaySkill 20 model.theme) hardSkills)
                ]
            ]
        ]


displaySkill : Int -> Theme -> SkillExperience -> Html Msg
displaySkill size theme skill =
    starsContainer
        []
        (stars size theme skill)


starsContainer : List (Attribute a) -> List (Html a) -> Html a
starsContainer =
    styled div
        [ displayGrid
        , property "grid-template-columns"
            ("5.5rem repeat("
                ++ String.fromInt maxStars
                ++ ", 1fr)"
            )
        , property "align-items" "center"
        , marginBottom (rem 0.2)
        , maxWidth (rem 20)
        ]


stars : Int -> Theme -> SkillExperience -> List (Html msg)
stars size theme { skillName, experience } =
    List.concat
        [ [ p
                [ Attributes.css [ margin (px 0) ] ]
                [ text skillName ]
          ]
        , List.repeat
            experience
            (filledStar theme size)
        , List.repeat
            (maxStars - experience)
            (outlinedStar theme size)
        ]


maxStars : Int
maxStars =
    7


filledStar : Theme -> Int -> Html msg
filledStar theme =
    experienceStat
        Filled.star
        (titleColor theme)


outlinedStar : Theme -> Int -> Html msg
outlinedStar theme =
    experienceStat
        Filled.star_border
        (themed grey.c700 grey.c500 theme)


experienceStat : Icon msg -> Color -> Int -> Html msg
experienceStat icon colorValue size =
    div
        [ Attributes.css [ color colorValue ] ]
        [ Svg.Styled.fromUnstyled (icon size Inherit) ]



-- ATOMS


ghostRoundButton : List (Attribute msg) -> List (Html msg) -> Html msg
ghostRoundButton =
    styled button
        [ roundBorder
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


roundImg : LengthOrAuto compatible -> List (Attribute msg) -> Html msg
roundImg size attributes =
    div
        [ Attributes.css
            [ width size
            , height size
            , roundBorder
            , overflow hidden
            , position relative
            , margin2 (rem 1) auto
            ]
        ]
        [ styled img
            [ width (pct 100)
            , height auto
            , position absolute
            , bottom (pct -10)
            ]
            attributes
            []
        ]


spaced_p : List (Attribute msg) -> List (Html msg) -> Html msg
spaced_p =
    styled p [ lineHeight (Css.em 1.5) ]



-- THEMED ELEMENTS


switchThemeIcon : Int -> Theme -> Svg.Styled.Svg msg
switchThemeIcon size =
    themed
        (Svg.Styled.fromUnstyled (Filled.dark_mode size Inherit))
        (Svg.Styled.fromUnstyled (Filled.light_mode size Inherit))


coloredBlock : Theme -> List (Html msg) -> Html msg
coloredBlock theme content =
    styled div
        -- Main container
        [ overflow hidden
        , borderRadius (px 4)
        , backgroundColor (themed secondary.c900 primary.c50 theme)
        , position relative
        , displayFlex
        , borderLeft3
            (px 4)
            solid
            (themed primary.c400 primary.c600 theme)
        ]
        []
        [ styled div
            -- Filter overlay
            [ position absolute
            , zIndex (int 30)
            , width (pct 100)
            , height (pct 100)
            , backgroundColor primary.c400
            , opacity (themed (num 0.1) (num 0) theme)
            ]
            []
            []
        , styled div
            -- Padding
            [ width (pct 100)
            , position relative
            , zIndex (int 50)
            , padding (rem 0.75)
            , paddingRight (rem 1)
            ]
            []
            content
        ]



-- VIEW OF CUSTOM DATA


displayLangOptions : Language.Language -> Language.ValueWithLabel -> Html Msg
displayLangOptions language { value, label } =
    option [ Attributes.value value ] [ text (label language) ]


displayContact : ContactInfo Msg -> Html Msg
displayContact contact =
    li []
        [ a
            [ Attributes.href contact.href
            , Attributes.target "_blank"
            , Attributes.css
                [ color inherit
                , textDecoration none
                , lineHeight (rem 1.365)
                ]
            ]
            [ span
                [ Attributes.css
                    [ paddingRight (rem 0.4)
                    , position relative
                    , top (rem 0.12)
                    ]
                ]
                [ contact.icon ]
            , span [] [ text contact.text ]
            ]
        ]



-- CUSTOM DATA


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


type alias SkillExperience =
    { skillName : String
    , experience : Int -- From 1 to 7
    }


hardSkills : List SkillExperience
hardSkills =
    [ SkillExperience "JavaScript" 6
    , SkillExperience "HTML" 5
    , SkillExperience "CSS" 5
    , SkillExperience "Elm" 3
    ]



-- STYLES


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


roundBorder : Style
roundBorder =
    borderRadius (pct 50)


smoothGrayShadow : Style
smoothGrayShadow =
    property "box-shadow" <|
        removeExtraWhitespaces """
            0 2.8px 2.2px rgba(0, 0, 0, 0.034),
            0 6.7px 5.3px rgba(0, 0, 0, 0.048),
            0 12.5px 10px rgba(0, 0, 0, 0.06),
            0 22.3px 17.9px rgba(0, 0, 0, 0.072),
            0 41.8px 33.4px rgba(0, 0, 0, 0.086),
            0 100px 80px rgba(0, 0, 0, 0.12)
        """


removeExtraWhitespaces : String -> String
removeExtraWhitespaces =
    Regex.replace
        multipleWhitespaces
        (always " ")
        >> String.trim


multipleWhitespaces : Regex.Regex
multipleWhitespaces =
    Maybe.withDefault Regex.never <|
        Regex.fromString "\\s\\s+"



-- THEMED STYLES


mainBackground : Theme -> Style
mainBackground =
    themed
        (paperBackground Dark)
        (backgroundColor grey.c200)


paperBackground : Theme -> Style
paperBackground =
    themed
        (backgroundColor secondary.c900)
        (backgroundColor grey.c50)


paragraphColor : Theme -> Style
paragraphColor =
    themed
        (color grey.c50)
        (color grey.c900)


titleColor : Theme -> Color
titleColor =
    themed
        primary.c300
        primary.c600


paperShadow : Theme -> Style
paperShadow =
    themed
        (border3 (px 1) solid grey.c50)
        (batch
            [ smoothGrayShadow
            , border3 (px 1) solid transparent
            ]
        )



-- MEDIA QUERIES


onlyScreen : List Style -> Style
onlyScreen =
    withMedia [ only screen [] ]


onlySmallScreen : List Style -> Style
onlySmallScreen =
    withMedia [ only screen [ Media.maxWidth smallScreen ] ]


onlyBigScreen : List Style -> Style
onlyBigScreen =
    withMedia [ only screen [ Media.minWidth mediumScreen ] ]


printOrBigScreen : List Style -> Style
printOrBigScreen =
    withMedia
        [ only screen [ Media.minWidth mediumScreen ]
        , only print []
        ]


onlyPrint : List Style -> Style
onlyPrint =
    withMedia [ only print [] ]



-- COLORS


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


transparent : Color
transparent =
    hex "00000000"


almostBlack : Color
almostBlack =
    hex "121212"



-- DIMENTIONS


paperWidthInt : number
paperWidthInt =
    51


paperHeightInt : number
paperHeightInt =
    66


paperPaddingInt : { vertical : Float, horizontal : Float }
paperPaddingInt =
    { vertical = 1
    , horizontal = 2.5
    }


optionsBarHeightInt : number
optionsBarHeightInt =
    4


paperWidth : Rem
paperWidth =
    rem (paperWidthInt - 2 * paperPaddingInt.horizontal)


paperHeight : Rem
paperHeight =
    rem (paperHeightInt - 2 * paperPaddingInt.vertical)


paperPadding : { vertical : Rem, horizontal : Rem }
paperPadding =
    { vertical = rem paperPaddingInt.vertical
    , horizontal = rem paperPaddingInt.horizontal
    }


optionsBarHeight : Rem
optionsBarHeight =
    rem optionsBarHeightInt


profilePictureSize : Rem
profilePictureSize =
    rem 15



-- BREAKPOINTS


smallScreen : Em
smallScreen =
    Css.em 44


mediumScreen : Em
mediumScreen =
    Css.em 56
