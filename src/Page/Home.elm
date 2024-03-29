module Page.Home exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import UI


view : ( String, Html msg )
view =
    ( "•Home•"
    , homeView
    )


homeView : Html msg
homeView =
    Html.div []
        [ Html.p []
            [ Html.text "An Elm single-page application with running examples from "
            , UI.externalLink "https://elm-lang.org/examples" "elm-lang.org"
            , Html.text "."
            ]
        , Html.p []
            [ Html.text "The structure is mostly based on "
            , UI.externalLink "https://github.com/rtfeldman/elm-spa-example/tree/master" "Richard Feldman's single-page example"
            , Html.text "."
            ]
        ]
