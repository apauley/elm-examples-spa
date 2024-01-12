module Page.Counter exposing (Model, Msg, init, update, view)

import Element exposing (..)
import Element.Input as Input
import Element.Region as Region
import Html
import UI


type alias Model =
    Int


type Msg
    = Increment
    | Decrement
    | Reset


init : ( Model, Cmd Msg )
init =
    ( 0, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( model + 1, Cmd.none )

        Decrement ->
            ( model - 1, Cmd.none )

        Reset ->
            init


title : Model -> String
title model =
    String.join " " [ "Count:", String.fromInt model ]


view : Model -> ( String, Element Msg )
view model =
    ( title model
    , UI.column
        [ el [ Region.heading 1 ] <| Element.html <| Html.h1 [] [ Html.text "Counter" ]
        , UI.row
            [ UI.textButton Decrement "-"
            , text (String.fromInt model)
            , UI.textButton Increment "+"
            ]
        , UI.textButton Reset "Reset"
        ]
    )
