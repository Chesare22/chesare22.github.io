port module Main exposing (..)

import Browser
import Constants exposing (Highlight(..))
import Css exposing (..)
import Css.Global as Global
import Formatters
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attributes
import Html.Styled.Events exposing (..)
import Language exposing (Language(..), translated)
import Material.Icons as Filled
import Material.Icons.Types exposing (Coloring(..), Icon)
import QRCode
import Svg.Attributes
import Svg.Styled
import UI.Media
import UI.Palette exposing (Theme(..), themed)
import UI.Size
import UI.Style



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


type alias Fonts =
    { renogare : String
    , trajanPro : String
    }


type alias Flags =
    { profilePicture : String
    , preferredTheme : String
    , qrUrl : String
    , fonts : Fonts
    }


type alias Model =
    { theme : Theme
    , language : Language.Language
    , profilePicture : String
    , qrUrl : String
    , fonts : Fonts
    }


init : Flags -> ( Model, Cmd Msg )
init { profilePicture, fonts, preferredTheme, qrUrl } =
    ( { theme =
            if preferredTheme == "dark" then
                Dark

            else
                Light
      , language = Language.English
      , profilePicture = profilePicture
      , qrUrl = qrUrl
      , fonts = fonts
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = ChangeTheme
    | ChangeLanguage Language
    | Print


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeTheme ->
            ( { model | theme = toggleTheme model.theme }
            , Cmd.none
            )

        ChangeLanguage language ->
            ( { model | language = language }
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
            , maxWidth (vw 100)
            , property "display" "grid"
            , property "grid-template-columns" "1fr"
            , property "justify-items" "center"
            , color <| UI.Palette.paragraph model.theme
            , UI.Media.onAnyScreen
                [ paddingTop UI.Size.optionsBarHeight
                ]
            ]
        ]
        [ Global.global
            [ Global.selector "#options-bar.hidden"
                [ top (rem (negate UI.Size.optionsBarHeightInt))
                ]
            , Global.body
                [ backgroundColor <| UI.Palette.paperBackground model.theme
                , UI.Media.onBigScreen
                    [ backgroundColor <| UI.Palette.mainBackground model.theme
                    ]
                ]
            , Global.class "tooltip"
                [ position relative
                ]
            , Global.selector ".tooltip:hover .tooltip-text"
                [ visibility visible
                ]
            , Global.class "tooltip-text"
                [ visibility hidden
                , backgroundColor UI.Palette.grey.c900
                , color UI.Palette.grey.c050
                , textAlign center
                , borderRadius (px 6)
                , padding2 (rem 0.32) (rem 1)
                , position absolute
                , top (pct 150)
                , left (pct 50)
                , transform <| translateX (pct -50)
                , minWidth (rem 10)
                ]
            , Global.selector ".tooltip-text::after"
                [ property "content" "\"\""
                , position absolute
                , bottom (pct 100)
                , left (pct 50)
                , marginLeft (rem -0.32)
                , borderWidth (rem 0.32)
                , borderStyle solid
                , borderColor4 transparent transparent UI.Palette.grey.c900 transparent
                ]
            , Global.selector "@font-face"
                [ fontFamilies [ "Renogare" ]
                , property "src"
                    ("local(\"Renogare\"),"
                        ++ "url(\""
                        ++ model.fonts.renogare
                        ++ "\") format(\"opentype\")"
                    )
                ]
            , Global.selector "@font-face"
                [ fontFamilies [ "Trajan Pro" ]
                , property "src"
                    ("local(\"Trajan Pro\"),"
                        ++ "url(\""
                        ++ model.fonts.trajanPro
                        ++ "\") format(\"truetype\")"
                    )
                ]
            ]

        -- Options bar
        , div
            [ Attributes.id "options-bar"
            , Attributes.css
                [ height UI.Size.optionsBarHeight
                , width (pct 100)
                , position fixed
                , zIndex (int 100)
                , top (px 0)
                , backgroundColor UI.Palette.almostBlack
                , property "transition" "all .3s ease"
                , UI.Style.centeredContent
                , color <| UI.Palette.paragraph Dark
                , property "display" "grid"
                , property "grid-template-columns" "repeat(3, auto)"
                , property "grid-gap" "1.5rem"
                , justifyContent center
                , UI.Media.onPrint
                    [ display none
                    ]
                ]
            ]
            -- Radio buttons
            [ div
                []
                [ input
                    [ Attributes.type_ "radio"
                    , Attributes.id "en"
                    , Attributes.checked (model.language == English)
                    , onCheck (always (ChangeLanguage English))
                    ]
                    []
                , label [ Attributes.for "en" ]
                    [ text "English"
                    ]
                , input
                    [ Attributes.type_ "radio"
                    , Attributes.id "es"
                    , Attributes.css [ marginLeft (rem 0.8) ]
                    , Attributes.checked (model.language == Spanish)
                    , onCheck (always (ChangeLanguage Spanish))
                    ]
                    []
                , label
                    [ Attributes.for "es"
                    ]
                    [ text "Español"
                    ]
                ]
            , button
                [ onClick ChangeTheme
                , Attributes.css
                    [ UI.Style.ghost
                    , UI.Style.round
                    , position relative
                    , left (rem 0.25)
                    ]
                ]
                [ switchThemeIcon 20 model.theme ]
            , button
                [ onClick Print
                , Attributes.class "tooltip"
                , Attributes.css
                    [ UI.Style.ghost
                    , UI.Style.round
                    ]
                ]
                [ Svg.Styled.fromUnstyled <| Filled.print 20 Inherit
                , span
                    [ Attributes.class "tooltip-text"
                    ]
                    [ text <|
                        Language.translated
                            "Funciona mejor en Google Chrome para escritorio"
                            "Works better in Google Chrome for desktop"
                            model.language
                    ]
                ]
            ]

        -- Page 1
        , div
            [ Attributes.css
                [ UI.Style.paper model.theme
                , property "display" "grid"
                , property "grid-template-columns" "3fr 5fr"
                , property "column-gap" "2rem"
                , property "align-content" "start"
                , UI.Media.onSmallScreen
                    [ property "grid-template-columns" "1fr"
                    ]
                , UI.Media.belowBigScreen
                    [ paddingBottom (px 0)
                    ]
                ]
            ]
            -- Column 1
            [ div
                []
                [ roundImg UI.Size.profilePicture
                    [ Attributes.src model.profilePicture
                    , Attributes.alt
                        (Language.translated
                            "Foto de César con lentes"
                            "Photo of César with glasses"
                            model.language
                        )
                    ]
                , styled h1
                    [ UI.Style.title model.theme ]
                    []
                    [ text Constants.name ]
                , p
                    [ Attributes.css
                        [ UI.Style.paragraph
                        , textAlign justify
                        ]
                    ]
                    [ text
                        (Language.translated
                            "Soy un estudiante de ingeniería de software con 2 años de experiencia trabajando como desarrollador frontend. Estoy comprometido con la calidad del software en todas sus etapas, desde la planeación hasta la entrega del producto. A menudo intento hacer mi código lo más simple posible y disfruto aprender cosas nuevas. Actualmente la programación funcional me llama la atención."
                            "I'm a software engineering student with two years of experience working as a frontend developer. I am committed to software quality in all their stages, from the planning to the delivery and maintenance. I often try to make my code the simplest possible and I enjoy learning new stuff. Currently I'm really interested in functional programming."
                            model.language
                        )
                    ]
                , styled h2
                    [ UI.Style.subtitle model.theme
                    , marginBottom (rem 1)
                    ]
                    []
                    [ text
                        (Language.translated
                            "Me puedes encontrar en"
                            "You can find me on"
                            model.language
                        )
                    ]
                , styled div
                    [ UI.Style.coloredBlock model.theme
                    , marginBottom (rem 1)
                    ]
                    []
                    [ ul
                        [ Attributes.css
                            [ listStyle none
                            , paddingLeft (px 0)
                            , margin (px 0)
                            ]
                        ]
                        (List.map displayContact <| Constants.contactList 16)
                    ]
                , qrCode model.qrUrl
                , a
                    [ Attributes.href model.qrUrl
                    , Attributes.css
                        [ display block
                        , margin auto
                        , textAlign center
                        , color UI.Palette.grey.c500
                        , textDecoration none
                        , fontStyle italic
                        , fontSize (rem 0.8)
                        , UI.Media.notOnPrint
                            [ display none
                            ]
                        ]
                    ]
                    [ text
                        (Language.translated
                            ("Este documento es una página web impresa " ++ model.qrUrl)
                            ("This document is a printed web page " ++ model.qrUrl)
                            model.language
                        )
                    ]
                ]

            -- Column 2
            , div [] <|
                List.concat
                    [ [ styled h2
                            [ UI.Style.subtitle model.theme
                            , UI.Media.aboveSmallScreen [ marginTop (px 0) ]
                            , UI.Media.onPrint [ marginTop (px 0) ]
                            ]
                            []
                            [ text
                                (Language.translated
                                    "Habilidades técnicas"
                                    "Hard skills"
                                    model.language
                                )
                            ]
                      , styled div
                            [ UI.Style.coloredBlock model.theme
                            , property "display" "grid"
                            , property "grid-template-columns" "auto 1fr"
                            , property "column-gap" "1rem"
                            , property "row-gap" "1rem"
                            ]
                            []
                            [ skillSubtitle [] [ text (translated "Competente" "Proficient" model.language) ]
                            , span [] [ text (Language.toSentence model.language Constants.proficientSkills) ]
                            , skillSubtitle [] [ text (always "Familiar" model.language) ]
                            , span [] [ text (Language.toSentence model.language Constants.familiarSkills) ]
                            , skillSubtitle [] [ text (translated "Aprendiendo" "Learning" model.language) ]
                            , span [] [ text (Language.toSentence model.language Constants.learningSkills) ]
                            ]
                      ]
                    , [ jobsSubtitle model.theme model.language ]
                    , Constants.jobs
                        |> List.map (displayExperience model.language)
                    , [ studiesSubtitle model.theme model.language ]
                    , Constants.studies
                        |> List.map (displayExperience model.language)
                    ]
            ]

        -- Page 2
        , div
            [ Attributes.css
                [ UI.Style.paper model.theme
                , property "display" "grid"
                , property "align-content" "start"
                , UI.Media.belowBigScreen
                    [ after
                        [ UI.Style.divider model.theme
                        ]
                    , paddingTop (px 0)
                    ]
                ]
            ]
            [ booksSubtitle model.theme model.language
            , div
                [ Attributes.css
                    [ property "display" "grid"
                    , property "grid-template-columns" "1fr 1fr"
                    , property "column-gap" "1rem"
                    , property "row-gap" "0.85rem"
                    , property "align-content" "start"
                    , UI.Media.onSmallestScreen
                        [ property "grid-template-columns" "1fr"
                        ]
                    ]
                ]
                (Constants.books
                    |> List.map (displayBook model.language model.theme)
                )
            , div
                [ Attributes.css
                    [ property "justify-self" "center"
                    , margin2 (rem 4) (rem 0)
                    , maxWidth (rem 20)
                    , fontSize (Css.em 1)
                    , textAlign center
                    ]
                ]
                [ span
                    [ Attributes.css
                        [ fontWeight (int 700)
                        ]
                    ]
                    [ text "Fun fact: " ]
                , text
                    (translated "mis lenguajes de programación favoritos son Elm y Elixir"
                        "my favorite programming languages are Elm and Elixir"
                        model.language
                    )
                ]
            ]

        -- Footnote
        , div
            [ Attributes.css
                [ padding2 (rem 5) (px 0)
                , boxSizing borderBox
                , width (pct 100)
                , property "display" "grid"
                , property "grid-template-columns" "auto auto"
                , property "grid-gap" "2rem"
                , property "justify-content" "center"
                , UI.Media.onPrint
                    [ display none
                    ]
                ]
            ]
            [ span [] [ text "© 2021 César González" ]
            , a
                [ Attributes.href "https://github.com/Chesare22/chesare22.github.io"
                , Attributes.target "_blank"
                , Attributes.css
                    [ color currentColor
                    , textDecoration none
                    , hover [ textDecoration underline ]
                    ]
                ]
                [ text
                    (Language.translated
                        "Código fuente"
                        "Site source"
                        model.language
                    )
                ]
            ]
        ]


jobsSubtitle : Theme -> Language -> Html msg
jobsSubtitle theme language =
    styled h2
        [ UI.Style.subtitle theme ]
        []
        [ text
            (Language.translated
                "Experiencia laboral"
                "Work experience"
                language
            )
        ]


studiesSubtitle : Theme -> Language -> Html msg
studiesSubtitle theme language =
    styled h2
        [ UI.Style.subtitle theme ]
        []
        [ text
            (Language.translated
                "Estudios"
                "Studies"
                language
            )
        ]


booksSubtitle : Theme -> Language -> Html msg
booksSubtitle theme language =
    h2
        [ Attributes.css
            [ UI.Style.subtitle theme
            ]
        ]
        [ text
            (translated
                "Libros leídos"
                "Books I've read"
                language
            )
        ]


displayBook : Language -> Theme -> Constants.Book -> Html msg
displayBook lang theme book =
    div
        [ Attributes.css
            [ bookHighlight book.highlight theme
            ]
        ]
        [ h3
            [ Attributes.css
                [ display inline
                , fontSize (Css.em 1.17)
                , fontWeight (int 700)
                ]
            ]
            [ text book.title ]
        , span
            [ Attributes.css [ display block ]
            ]
            [ text book.author ]
        , span
            [ Attributes.css
                [ display block
                , margin2 (rem 0.2) (px 0)
                , letterSpacing (Css.em 0.075)
                , fontSize (Css.em 0.8)
                ]
            ]
            [ text (Formatters.formatBookCompletion lang book.completion) ]
        ]


bookHighlight : Constants.Highlight -> Theme -> Style
bookHighlight highlight =
    case highlight of
        Regular ->
            always (batch [])

        Highlighted ->
            UI.Style.coloredBlock


displayExperience : Language -> Constants.Experience -> Html msg
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
            [ text (Formatters.formatDateRange lang experience.start experience.end) ]
        , p
            [ Attributes.css [ UI.Style.paragraph ] ]
            [ text (experience.description lang) ]
        ]


skillSubtitle =
    styled span
        [ fontWeight (int 700)
        ]


qrCode : String -> Html msg
qrCode url =
    a
        [ Attributes.href url
        , Attributes.css
            [ width (rem 5)
            , margin auto
            , marginBottom (rem 0.5)
            , property "display" "grid"
            , border3 (rem 0.3) solid UI.Palette.grey.c900
            , borderRadius (rem 0.5)
            , textDecoration none
            , color currentColor
            , backgroundColor (hex "fff")
            , color UI.Palette.grey.c900
            , UI.Media.notOnPrint
                [ display none
                ]
            ]
        ]
        [ fromUnstyled
            (QRCode.fromString url
                |> Result.map
                    (QRCode.toSvg
                        [ Svg.Attributes.stroke "currentColor"
                        ]
                    )
                |> Result.withDefault (Html.text "")
            )
        , styled div
            [ color UI.Palette.grey.c050
            , backgroundColor UI.Palette.grey.c900
            , textAlign center
            , paddingTop (rem 0.3)
            , fontSize (rem 0.8)
            , property "box-shadow"
                ("2px 0 0 0 "
                    ++ UI.Palette.grey.c900.value
                    ++ ", -2px 0 0 0 "
                    ++ UI.Palette.grey.c900.value
                )
            ]
            []
            [ text "Click or Scan" ]
        ]



-- ATOMS


roundImg : LengthOrAuto compatible -> List (Attribute msg) -> Html msg
roundImg size attributes =
    div
        [ Attributes.css
            [ width size
            , height size
            , UI.Style.round
            , overflow hidden
            , margin auto
            ]
        ]
        [ styled img
            [ width (pct 100)
            , height (pct 100)
            ]
            attributes
            []
        ]



-- THEMED ELEMENTS


switchThemeIcon : Int -> Theme -> Svg.Styled.Svg msg
switchThemeIcon size =
    themed
        (Svg.Styled.fromUnstyled (Filled.dark_mode size Inherit))
        (Svg.Styled.fromUnstyled (Filled.light_mode size Inherit))



-- VIEW OF CUSTOM DATA


displayContact : Constants.ContactInfo Msg -> Html Msg
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
