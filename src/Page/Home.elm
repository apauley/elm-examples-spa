module Page.Home exposing (view)

import Html exposing (..)


view : ( String, Html msg )
view =
    ( "Home sweet home"
    , div []
        [ text "This is the home page. Click a link." ]
    )
