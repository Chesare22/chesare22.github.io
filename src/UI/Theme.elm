module UI.Theme exposing
    ( Theme(..)
    , themed
    )


type Theme
    = Light
    | Dark


themed : a -> a -> Theme -> a
themed darkElement lightElement theme =
    case theme of
        Dark ->
            darkElement

        Light ->
            lightElement
