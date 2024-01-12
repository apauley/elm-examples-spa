module UI exposing (column, row, textButton)

import Element as E exposing (Element)
import Widget exposing (ItemStyle, Modal)
import Widget.Layout
import Widget.Material as Material


textButton : msg -> String -> Element msg
textButton msg buttonText =
    Widget.textButton (Material.textButton Material.defaultPalette)
        { text = buttonText
        , onPress = Just msg
        }


row : List (Element msg) -> Element msg
row elements =
    Widget.row Material.row elements


column : List (Element msg) -> Element msg
column elements =
    Widget.column Material.column elements
