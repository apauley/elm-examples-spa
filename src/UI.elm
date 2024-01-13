module UI exposing (appLink, column, row, textButton)

import Element as E exposing (Element)
import Route exposing (Route)
import Widget
import Widget.Material as Material


textButton : msg -> String -> Element msg
textButton msg buttonText =
    Widget.textButton (Material.textButton Material.defaultPalette)
        { text = buttonText
        , onPress = Just msg
        }


appLink : Route -> String -> Element msg
appLink route txt =
    link (Route.toPath route) txt


link : String -> String -> Element msg
link path txt =
    E.link [] { url = path, label = E.text txt }


row : List (Element msg) -> Element msg
row elements =
    Widget.row Material.row elements


column : List (Element msg) -> Element msg
column elements =
    Widget.column Material.column elements
