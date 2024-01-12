module Page.NotFound exposing (view)

import Element exposing (..)


view : ( String, Element msg )
view =
    ( "Not Found"
    , el [ padding 200 ] <| text "Page not found"
    )
