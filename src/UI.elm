module UI exposing (..)

import Element exposing (Color, Element, padding, text)
import Element.Background as Background
import Element.Border as Border
import Element.Events
import Element.Input as Input


button : msg -> String -> Element msg
button msg buttonText =
    Input.button
        [ Background.color darkGray
        , Element.focused
            [ Background.color lightGray ]
        , padding 10
        , Border.solid
        , Border.width 1
        , Border.rounded 5
        ]
        { onPress = Just msg
        , label = text buttonText
        }


lightGray =
    gray 220


darkGray =
    gray 200


gray : Int -> Color
gray shade =
    Element.rgb255 shade shade shade
