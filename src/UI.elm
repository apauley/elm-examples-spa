module UI exposing (appLink, column, externalLink, navBar, textButton)

import Html exposing (Html, col)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import Route exposing (Route)
import Url


textButton : msg -> String -> Html msg
textButton msg buttonText =
    Html.button [ onClick msg ] [ Html.text buttonText ]


appLink : Url.Url -> Route -> String -> Html msg
appLink url route txt =
    link (Route.toPath url route) txt


externalLink : String -> String -> Html msg
externalLink url txt =
    link url txt


link : String -> String -> Html msg
link path txt =
    Html.a [ href path ] [ Html.text txt ]


navBar : List (List (Html msg)) -> Html msg
navBar outerList =
    let
        toListItem html =
            Html.li [] [ html ]

        uls =
            List.map (\innerList -> Html.ul [] (List.map toListItem innerList)) outerList
    in
    Html.nav [ class "container-fluid" ] uls


column : List (Html msg) -> Html msg
column elements =
    Html.div [ class "grid" ] elements
