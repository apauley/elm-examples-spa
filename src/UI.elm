module UI exposing (appLink, externalLink, textButton)

import Element as E exposing (Element)
import Element.Input as Input
import Framework.Button as Button
import Framework.Color as Color
import Route exposing (Route)


textButton : msg -> String -> Element msg
textButton msg buttonText =
    Input.button (Button.simple ++ Color.primary)
        { label = E.text buttonText
        , onPress = Just msg
        }


appLink : Route -> String -> Element msg
appLink route txt =
    link (Route.toPath route) txt


externalLink : String -> String -> Element msg
externalLink url txt =
    link url txt


link : String -> String -> Element msg
link path txt =
    E.link [] { url = path, label = E.text txt }
