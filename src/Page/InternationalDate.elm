module Page.InternationalDate exposing (Model, Msg, init, update, view)

import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events
import Json.Decode as D
import Time
import TimeStamp exposing (TimeStamp)
import UI



-- MODEL


type alias Model =
    { language : String }


init : ( Model, Cmd Msg )
init =
    ( { language = "sr-RS" }
    , Cmd.none
    )



-- UPDATE


type Msg
    = LanguageChanged String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LanguageChanged language ->
            ( { model | language = language }
            , Cmd.none
            )



-- VIEW


view : Model -> TimeStamp -> ( String, Html Msg )
view model timestamp =
    ( "•International Date•"
    , Html.div []
        [ explanation
        , widget model timestamp
        ]
    )


explanation : Html msg
explanation =
    Html.article []
        [ Html.p []
            [ Html.text "An example of "
            , UI.externalLink "https://guide.elm-lang.org/interop/custom_elements.html" "custom"
            , Html.text " "
            , UI.externalLink "https://github.com/elm-community/js-integration-examples/tree/master/internationalization" "elements"
            , Html.text "."
            ]
        , Html.p []
            [ Html.text "Also - "
            , UI.externalLink "https://www.youtube.com/watch?v=tyFe9Pw6TVE" "watch the talk"
            , Html.text "."
            ]
        ]


widget : Model -> TimeStamp -> Html Msg
widget model timestamp =
    let
        year =
            timestamp |> TimeStamp.toYear

        month =
            timestamp |> TimeStamp.toMonth |> monthNumber

        day =
            timestamp |> TimeStamp.toDay
    in
    Html.article []
        [ Html.p [] [ viewDate model.language year month day ]
        , Html.select
            [ Events.on "change" (D.map LanguageChanged valueDecoder)
            ]
          <|
            List.map
                (\lang -> Html.option [ Attributes.value lang ] [ Html.text lang ])
                languages
        ]


languages =
    [ "sr-RS", "af-ZA", "nl-NL", "en-GB", "en-US" ]



-- Use the Custom Element defined in custom.js
--


viewDate : String -> Int -> Int -> Int -> Html msg
viewDate lang year month day =
    Html.node "intl-date"
        [ Attributes.attribute "lang" lang
        , Attributes.attribute "year" (String.fromInt year)
        , Attributes.attribute "month" (String.fromInt month)
        , Attributes.attribute "day" (String.fromInt day)
        ]
        []


valueDecoder : D.Decoder String
valueDecoder =
    D.field "currentTarget" (D.field "value" D.string)


monthNumber : Time.Month -> Int
monthNumber month =
    case month of
        Time.Jan ->
            0

        Time.Feb ->
            1

        Time.Mar ->
            2

        Time.Apr ->
            3

        Time.May ->
            4

        Time.Jun ->
            5

        Time.Jul ->
            6

        Time.Aug ->
            7

        Time.Sep ->
            8

        Time.Oct ->
            9

        Time.Nov ->
            10

        Time.Dec ->
            11
