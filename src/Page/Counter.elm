module Page.Counter exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Events exposing (..)


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


view : Model -> ( String, Html Msg )
view model =
    ( title model
    , div []
        [ h1 [] [ text "Counter" ]
        , br [] []
        , div []
            [ button [ onClick Decrement ] [ text "-" ]
            , text (String.fromInt model)
            , button [ onClick Increment ] [ text "+" ]
            ]
        , button [ onClick Reset ] [ text "Reset Counter" ]
        , hr [] []
        ]
    )
