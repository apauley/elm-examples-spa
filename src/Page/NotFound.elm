module Page.NotFound exposing (view)

import Html exposing (Html)


view : ( String, Html msg )
view =
    ( "•Not Found•"
    , Html.div [] [ Html.text "Page not found" ]
    )
