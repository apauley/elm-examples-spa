module Page.Home exposing (view)

import Element exposing (..)
import Framework.Group exposing (center)


view : ( String, Element msg )
view =
    ( "Home sweet home"
    , el [ padding 200 ] <| text "This is the home page. Click a link."
    )
