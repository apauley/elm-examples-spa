module Page.NotFound exposing (view)

import Html exposing (Html, div, text)


view : ( String, Html msg )
view =
    ( "•Not Found•"
    , div [] [ text "Page not found" ]
    )
