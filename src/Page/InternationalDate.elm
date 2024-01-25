module Page.InternationalDate exposing (Model, Msg, init, update, view)

import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events
import Json.Decode as D
import UI



-- MODEL


type alias Model =
    { language : String
    , year : Int
    , month : Int
    }


init : Int -> Int -> ( Model, Cmd Msg )
init year month =
    ( { language = "sr-RS", year = year, month = month }
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


view : Model -> ( String, Html Msg )
view model =
    ( "•International Date•"
    , Html.div []
        [ explanation
        , widget model
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


widget model =
    Html.article []
        [ Html.p [] [ viewDate model.language model.year model.month ]
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


viewDate : String -> Int -> Int -> Html msg
viewDate lang year month =
    Html.node "intl-date"
        [ Attributes.attribute "lang" lang
        , Attributes.attribute "year" (String.fromInt year)
        , Attributes.attribute "month" (String.fromInt month)
        ]
        []


valueDecoder : D.Decoder String
valueDecoder =
    D.field "currentTarget" (D.field "value" D.string)
