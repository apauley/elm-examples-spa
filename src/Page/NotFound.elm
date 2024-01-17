module Page.NotFound exposing (view)

import Html exposing (..)


view : ( String, Html msg )
view =
    ( "•Not Found•"
    , div [] [ text "Page not found" ]
    )
