module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



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
view _ =
    div []
        []
