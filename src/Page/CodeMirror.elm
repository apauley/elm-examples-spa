module Page.CodeMirror exposing (Model, Msg, initialModel, update, view)

import Html exposing (Html)
import Html.Attributes
import Html.Events
import Json.Decode
import Json.Encode
import UI


type alias Model =
    { code : String }


elmCode : String
elmCode =
    """view : Model -> Html Msg
view model =
    Html.node "code-editor"
        [ Html.Attributes.property "editorValue" <|
            Json.Encode.string model.code
        , Html.Events.on "editorChanged" <|
            Json.Decode.map CodeChanged <|
                Json.Decode.at [ "target", "editorValue" ] <|
                    Json.Decode.string
        ]
        []"""


initialModel : Model
initialModel =
    { code = elmCode }


type Msg
    = CodeChanged String


update : Msg -> Model -> Model
update msg model =
    case msg of
        CodeChanged value ->
            { model | code = value }


view : Model -> ( String, Html Msg )
view model =
    ( "•Code Mirror•", Html.div [] [ explanation, customEditorNode model ] )


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


customEditorNode : Model -> Html Msg
customEditorNode model =
    Html.node "code-editor"
        [ Html.Attributes.property "editorValue" <|
            Json.Encode.string model.code
        , Html.Events.on "editorChanged" <|
            Json.Decode.map CodeChanged <|
                Json.Decode.at [ "target", "editorValue" ] <|
                    Json.Decode.string
        ]
        []
