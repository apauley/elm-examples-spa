module Page.Home exposing (view)

import Element as E exposing (Element)
import Framework.Heading as Heading
import UI


view : ( String, Element msg )
view =
    ( "Home"
    , E.column [ E.width E.fill ]
        [ E.el (Heading.h1 ++ [ E.centerX ]) <| E.text "Elm Examples"
        , E.paragraph []
            [ E.text "An Elm single-page application with running examples from "
            , UI.externalLink "https://elm-lang.org/examples" "elm-lang.org"
            , E.text "."
            ]
        , E.paragraph []
            [ E.text "The structure is mostly based on "
            , UI.externalLink "https://github.com/rtfeldman/elm-spa-example/tree/master" "Richard Feldman's single-page example"
            , E.text "."
            ]
        , E.paragraph []
            [ E.text "Styling is done using "
            , UI.externalLink "https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/" "elm-ui"
            , E.text "."
            ]
        ]
    )
