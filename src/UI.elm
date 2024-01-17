module UI exposing (appLink, column, externalLink, textButton)

import Html exposing (Html)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import Route exposing (Route)


textButton : msg -> String -> Html msg
textButton msg buttonText =
    Html.button [ onClick msg ] [ Html.text buttonText ]


appLink : Route -> String -> Html msg
appLink route txt =
    link (Route.toPath route) txt


externalLink : String -> String -> Html msg
externalLink url txt =
    link url txt


link : String -> String -> Html msg
link path txt =
    Html.a [ href path ] [ Html.text txt ]


column : List (Html msg) -> Html msg
column elements =
    Html.div [ class "grid" ] elements
