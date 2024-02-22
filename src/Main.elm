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
    { preferredTheme : String
    , preferredLanguage : String
    , qrUrl : String
    , fonts : Fonts
    }


type alias Model =
    { theme : Theme
    , language : Language.Language
    , qrUrl : String
    , fonts : Fonts
    }


init : Flags -> ( Model, Cmd Msg )
init { fonts, preferredTheme, preferredLanguage, qrUrl } =
    ( { theme =
            if preferredTheme == "dark" then
                Dark

            else
                Light
      , language =
            if preferredLanguage |> String.startsWith "es" then
                Language.Spanish

            else
                Language.English
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
                , property "grid-template-columns" "1fr auto"
                , property "grid-template-areas"
                    """
                    "name contact-info"
                    "content content"
                    """
                , property "row-gap" "2rem"
                , property "align-content" "start"
                , UI.Media.onSmallScreen
                    [ property "grid-template-columns" "1fr"
                    , property "grid-template-areas"
                        """
                        "name"
                        "contact-info"
                        "content"
                        """
                    , property "row-gap" "1rem"
                    ]
                , UI.Media.belowBigScreen
                    [ paddingBottom (px 0)
                    ]
                ]
            ]
            [ styled div
                [ property "grid-area" "name" ]
                []
                [ styled h1
                    [ UI.Style.title model.theme
                    , marginBottom (Css.rem 0)
                    ]
                    []
                    [ text Constants.name ]
                , styled p
                    [ paddingLeft (Css.rem 0.25)
                    , UI.Media.onSmallScreen
                        [ textAlign center
                        ]
                    ]
                    []
                    [ text
                        (translated
                            "Desarrollador web Full-Stack"
                            "Full-Stack Web Developer"
                            model.language
                        )
                    ]
                ]
            , styled div
                [ property "grid-area" "contact-info" ]
                []
                [ ul
                    [ Attributes.css
                        [ listStyle none
                        , paddingLeft (px 0)
                        , textAlign right
                        , margin (px 0)
                        , UI.Media.onSmallScreen
                            [ textAlign left
                            ]
                        ]
                    ]
                    (List.map displayContact (Constants.contactList 16))
                ]
            , styled div
                [ property "grid-area" "content" ]
                []
                (List.concat
                    [ [ jobsSubtitle model.theme model.language ]
                    , Constants.jobs
                        |> List.map (displayJob model.language)
                    , [ educationSubtitle model.theme model.language ]
                    , Constants.education |> List.map (displayStudy model.language)
                    ]
                )
            ]

        -- Page 2
        , div
            [ Attributes.css
                [ UI.Style.paper model.theme
                , property "display" "grid"
                , property "align-content" "start"
                , UI.Media.belowBigScreen
                    [ paddingBottom (px 0)
                    , paddingTop (px 0)
                    ]
                ]
            ]
            (List.concat
                [ [ projectsSubtitle model.theme model.language ]
                , Constants.projects
                    |> List.map (displayProject model.language)
                , [ styled h2
                        [ UI.Style.subtitle model.theme ]
                        []
                        [ text
                            (Language.translated
                                "Otros Proyectos"
                                "Other Projects"
                                model.language
                            )
                        ]
                  , styled ul
                        [ property "padding-inline-start" "1.25rem"
                        , property "display" "grid"
                        , property "grid-gap" "0.32rem"
                        , marginTop (px 0)
                        , marginBottom (Css.em 2.5)
                        ]
                        []
                        (Constants.smallProjects |> List.map (displaySmallProject model.language))
                  ]
                ]
            )

        -- Page 3
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


projectsSubtitle : Theme -> Language -> Html msg
projectsSubtitle theme language =
    styled h2
        [ UI.Style.subtitle theme ]
        []
        [ text
            (Language.translated
                "Proyectos Principales"
                "Main Projects"
                language
            )
        ]


educationSubtitle : Theme -> Language -> Html msg
educationSubtitle theme language =
    styled h2
        [ UI.Style.subtitle theme ]
        []
        [ text
            (Language.translated
                "Educación"
                "Education"
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


displayJob : Language -> Constants.Job -> Html msg
displayJob lang job =
    div
        [ Attributes.css [ UI.Style.experienceContainer ] ]
        [ div
            [ Attributes.css [ property "grid-area" "title" ] ]
            [ h3
                [ Attributes.css [ UI.Style.experienceTitle ] ]
                [ text (job.title lang) ]
            , span [] [ text (", " ++ job.position lang) ]
            ]
        , span
            [ Attributes.css [ UI.Style.experienceDate ] ]
            [ text (Formatters.formatDateRange lang job.start job.end) ]
        , p
            [ Attributes.css [ UI.Style.experienceDescription ] ]
            [ text (job.description lang) ]
        ]


displayStudy : Language -> Constants.Study -> Html msg
displayStudy lang study =
    div
        [ Attributes.css
            [ property "display" "grid"
            , property "grid-template-columns" "1fr"
            , marginBottom (rem 0.5)
            , property "row-gap" "0.2rem"
            ]
        ]
        [ h3
            [ Attributes.css [ UI.Style.experienceTitle, margin (px 0) ] ]
            [ text (study.title lang) ]
        , span
            [ Attributes.css [ fontStyle italic ] ]
            [ text (Formatters.formatDateRange lang study.start (Just study.end)) ]
        , p
            [ Attributes.css [ UI.Style.paragraph ] ]
            [ text study.institution ]
        ]


displayProject : Language -> Constants.Project -> Html msg
displayProject lang project =
    div
        [ Attributes.css [ UI.Style.experienceContainer ] ]
        [ div
            [ Attributes.css [ property "grid-area" "title" ] ]
            [ h3
                [ Attributes.css [ UI.Style.experienceTitle ] ]
                [ text (project.title lang) ]
            , text " ("
            , a
                [ Attributes.href project.url
                , Attributes.target "_blank"
                , Attributes.css [ color inherit, property "word-break" "break-all" ]
                ]
                [ text project.url ]
            , text ")"
            ]
        , span
            [ Attributes.css [ UI.Style.experienceDate ] ]
            [ text (String.fromInt project.year) ]
        , p
            [ Attributes.css [ UI.Style.experienceDescription ] ]
            [ text (project.description lang) ]
        ]


displaySmallProject : Language -> Constants.SmallProject -> Html msg
displaySmallProject language project =
    li []
        [ span
            []
            [ text (project.name language) ]
        , styled span
            [ fontSize (Css.em 0.9) ]
            []
            [ text " ("
            , styled a
                [ color inherit, property "word-break" "break-all" ]
                [ Attributes.target "_blank"
                , Attributes.href project.url
                ]
                [ text project.url ]
            , text ")"
            ]
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
                , lineHeight (rem 1.365)
                , UI.Media.onSmallScreen
                    [ displayFlex
                    , flexDirection rowReverse
                    , justifyContent start
                    ]
                ]
            ]
            [ span [] [ text contact.text ]
            , span
                [ Attributes.css
                    [ position relative
                    , top (rem 0.12)
                    , UI.Media.onPrint
                        [ paddingLeft (rem 0.4) ]
                    , UI.Media.aboveSmallScreen
                        [ paddingLeft (rem 0.4) ]
                    , UI.Media.onSmallScreen
                        [ paddingRight (rem 0.4) ]
                    ]
                ]
                [ contact.icon ]
            ]
        ]
