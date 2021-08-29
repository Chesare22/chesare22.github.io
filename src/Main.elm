port module Main exposing (..)

import Browser
import Css exposing (..)
import Css.Global as Global
import Css.Media as Media exposing (only, print, screen, withMedia)
import FeatherIcons
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events exposing (..)
import Language exposing (Language)
import Material.Icons as Filled
import Material.Icons.Types exposing (Coloring(..), Icon)
import Phone
import QRCode
import Regex
import Svg.Attributes
import Svg.Styled
import Time



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
    , preferredTheme : String
    , qrUrl : String
    }


type alias Model =
    { theme : Theme
    , language : Language.Language
    , profilePicture : String
    , qrUrl : String
    }


init : Flags -> ( Model, Cmd Msg )
init { profilePicture, preferredTheme, qrUrl } =
    ( { theme =
            if preferredTheme == "dark" then
                Dark

            else
                Light
      , language = Language.Spanish
      , profilePicture = profilePicture
      , qrUrl = qrUrl
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
                , property "row-gap" "3rem"
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
                , title model.theme
                    []
                    [ text name ]
                , spaced_p []
                    [ text
                        (Language.translated
                            "Soy un estudiante de ingeniería de software con dos años de experiencia trabajando como desarrollador frontend. Estoy comprometido con la calidad del software en todas sus etapas, desde la planeación del producto hasta la correcta entrega y mantenimiento del mismo. A menudo intento hacer mi código lo más simple posible y disfruto aprender cosas nuevas."
                            "I'm a software engineering student with two years of experience working as a frontend developer. I am committed to software quality in all their stages, from the planning to the delivery and maintenance. I often try to make my code the simplest posible and I enjoy learning new stuff."
                            model.language
                        )
                    ]
                , subtitle model.theme
                    []
                    []
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
                , div
                    [ Attributes.css
                        [ width (px 150)
                        , withMedia [ Media.not print [] ]
                            [ display none
                            ]
                        ]
                    ]
                    [ fromUnstyled
                        (QRCode.fromString model.qrUrl
                            |> Result.map
                                (QRCode.toSvg
                                    [ Svg.Attributes.stroke "#000"
                                    ]
                                )
                            |> Result.withDefault (Html.text "")
                        )
                    ]
                ]

            -- Column 2
            , div []
                ([ subtitle model.theme
                    [ marginTop (px 0) ]
                    []
                    [ text
                        (Language.translated
                            "Habilidades técnicas"
                            "Hard skills"
                            model.language
                        )
                    ]
                 , coloredBlock
                    model.theme
                    (List.map (displaySkill 20 model.theme model.language) hardSkills)
                 , subtitle model.theme
                    []
                    []
                    [ text
                        (Language.translated
                            "Experiencia laboral"
                            "Work experience"
                            model.language
                        )
                    ]
                 ]
                    ++ List.map (displayExperience model.language) jobs
                    ++ subtitle model.theme
                        []
                        []
                        [ text (Language.translated "Estudios" "Studies" model.language)
                        ]
                    :: List.map (displayExperience model.language) studies
                )
            ]
        ]


displayExperience : Language -> Experience -> Html msg
displayExperience lang experience =
    div
        [ Attributes.css
            [ marginBottom (rem 1.5)
            ]
        ]
        [ h3
            [ Attributes.css
                [ display inline
                , fontSize (Css.em 1.17)
                , fontWeight (int 700)
                ]
            ]
            [ text (experience.title lang) ]
        , span [] [ text (", " ++ experience.position lang) ]
        , span
            [ Attributes.css
                [ display block
                , margin2 (rem 0.4) (px 0)
                , letterSpacing (Css.em 0.075)
                , fontSize (Css.em 0.8)
                ]
            ]
            [ text (formatDateRange lang experience.start experience.end) ]
        , spaced_p [] [ text (experience.description lang) ]
        ]


formatDateRange : Language -> SimpleDate -> Maybe SimpleDate -> String
formatDateRange language start end =
    String.toUpper
        (formatDate language start
            ++ " — "
            ++ (case end of
                    Just date ->
                        formatDate language date

                    Nothing ->
                        Language.translated "actual" "present" language
               )
        )


formatDate : Language -> SimpleDate -> String
formatDate language date =
    translateMonth language date.month
        ++ " "
        ++ String.fromInt date.year


translateMonth : Language -> Time.Month -> String
translateMonth =
    Language.translated monthsEs monthsEn


monthsEn : Time.Month -> String
monthsEn month =
    case month of
        Time.Jan ->
            "january"

        Time.Feb ->
            "february"

        Time.Mar ->
            "march"

        Time.Apr ->
            "april"

        Time.May ->
            "may"

        Time.Jun ->
            "june"

        Time.Jul ->
            "july"

        Time.Aug ->
            "august"

        Time.Sep ->
            "september"

        Time.Oct ->
            "october"

        Time.Nov ->
            "november"

        Time.Dec ->
            "december"


monthsEs : Time.Month -> String
monthsEs month =
    case month of
        Time.Jan ->
            "enero"

        Time.Feb ->
            "febrero"

        Time.Mar ->
            "marzo"

        Time.Apr ->
            "abril"

        Time.May ->
            "mayo"

        Time.Jun ->
            "junio"

        Time.Jul ->
            "julio"

        Time.Aug ->
            "agosto"

        Time.Sep ->
            "septiembre"

        Time.Oct ->
            "octubre"

        Time.Nov ->
            "noviembre"

        Time.Dec ->
            "diciembre"


displaySkill : Int -> Theme -> Language -> Skill -> Html Msg
displaySkill size theme skill language =
    starsContainer
        []
        (stars size theme skill language)


starsContainer : List (Attribute a) -> List (Html a) -> Html a
starsContainer =
    styled div
        [ displayGrid
        , property "grid-template-columns"
            ("6.75rem repeat("
                ++ String.fromInt maxSkillGrade
                ++ ", 1fr)"
            )
        , property "align-items" "center"
        , marginBottom (rem 0.2)
        , maxWidth (rem 20)
        ]


stars : Int -> Theme -> Language -> Skill -> List (Html msg)
stars size theme language skill =
    List.concat
        [ [ p
                [ Attributes.css [ margin (px 0) ] ]
                [ text (skill.name language) ]
          ]
        , List.repeat
            skill.grade
            (filledStar theme size)
        , List.repeat
            (maxSkillGrade - skill.grade)
            (outlinedStar theme size)
        ]


filledStar : Theme -> Int -> Html msg
filledStar theme =
    iconInDiv
        Filled.star
        (titleColor theme)


outlinedStar : Theme -> Int -> Html msg
outlinedStar theme =
    iconInDiv
        Filled.star_border
        (themed grey.c700 grey.c500 theme)


iconInDiv : Icon msg -> Color -> Int -> Html msg
iconInDiv icon colorValue size =
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
            , margin auto
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
    styled p
        [ lineHeight (Css.em 1.5)
        , marginBottom (Css.em 1)
        , marginTop (px 0)
        ]



-- THEMED ELEMENTS


title : Theme -> List (Attribute msg) -> List (Html msg) -> Html msg
title theme =
    styled h1
        [ color (titleColor theme)
        , fontSize (Css.em 2)
        ]


subtitle : Theme -> List Style -> List (Attribute msg) -> List (Html msg) -> Html msg
subtitle theme styles =
    styled h2
        ([ color (titleColor theme)
         , fontSize (rem 1.4)
         , fontWeight (int 700)
         , marginBottom (Css.em 0.5)
         , marginTop (Css.em 0.85)
         ]
            ++ styles
        )


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


type alias Skill =
    { name : Language.Language -> String
    , grade : Int -- From 1 to 7
    }


maxSkillGrade : Int
maxSkillGrade =
    7


hardSkills : List Skill
hardSkills =
    [ Skill (always "JavaScript") 6
    , Skill
        (Language.translated
            "HTML y CSS"
            "HTML and CSS"
        )
        5
    , Skill (always "React") 5
    , Skill (always "Vue") 4
    , Skill (always "Elm") 3
    ]


type alias Experience =
    { title : Language.Language -> String
    , start : SimpleDate
    , end : Maybe SimpleDate
    , position : Language.Language -> String
    , description : Language.Language -> String
    }


type alias SimpleDate =
    { month : Time.Month
    , year : Int
    }


jobs : List Experience
jobs =
    [ Experience (always "SoldAI")
        (SimpleDate Time.Jul 2019)
        (Just <| SimpleDate Time.Sep 2020)
        (Language.translated "Desarrollador Web Frontend" "Frontend Web Developer")
        (Language.translated
            "SoldAI es una empresa yucateca dedicada a la inteligencia artificial. Ayudé en pruebas, desarrollo, mantenimiento y documentación de varios proyectos, entre ellos un producto que permitía configurar chatbots."
            "SoldAI is a yucatecan company dedicated to the artificial intelligence. I helped in testing, developing, maintenance and documentation of various projects, among them a product that allowed to configure chat bots."
        )
    , Experience (always "Sumerian")
        (SimpleDate Time.Jun 2020)
        (Just <| SimpleDate Time.Jul 2021)
        (Language.translated "Ingeniero de Software" "Software Engineer")
        (Language.translated
            "Sumerian hace software a la medida, mayormente aplicaciones web. Involucramos mucho a los clientes y seguimos procesos de aseguramiento de la calidad."
            "Sumerian makes custom software, mostly web applications. We involve our clients and follow quality-assurance processes."
        )
    , Experience (always "Coatí Labs")
        (SimpleDate Time.Jan 2021)
        (Just <| SimpleDate Time.Apr 2021)
        (Language.translated "Desarrollador Web Frontend" "Frontend Web Developer")
        (Language.translated
            "Empresa de programación web donde me familiaricé con algunos eventos de scrum (sprints, stand ups diarios y revisión de código). Mi labor principal era el desarrollo de páginas web con React y TypeScript."
            "A web-programming company where I got familiarized with some scrum events (sprints, daily stand-ups and code reviews). My primary labour was to develop web pages with React and TypeScript."
        )
    ]


studies : List Experience
studies =
    [ Experience (Language.translated "Licenciatura en Ingeniería de Software" "Bachelor of Software Engineering")
        (SimpleDate Time.Aug 2017)
        Nothing
        (always "UADY")
        -- TODO: Add description
        (always "")
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
    { vertical = 2
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
