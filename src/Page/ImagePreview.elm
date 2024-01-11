module Page.ImagePreview exposing (Model, Msg, init, update, view)

import Element exposing (Element)
import File exposing (File)
import File.Select as Select
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as D
import Task


type alias Model =
    { hover : Bool
    , files : List File
    , previews : List String
    }


type Msg
    = Pick
    | DragEnter
    | DragLeave
    | GotFiles File (List File)
    | GotPreviews (List String)


init : Model
init =
    { hover = False, files = [], previews = [] }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Pick ->
            ( model
            , Select.files [ "image/*" ] GotFiles
            )

        DragEnter ->
            ( { model | hover = True }
            , Cmd.none
            )

        DragLeave ->
            ( { model | hover = False }
            , Cmd.none
            )

        GotFiles file files ->
            ( { model | hover = False, files = file :: files }
            , readAsUrl <| file :: files
            )

        GotPreviews previews ->
            ( { model | previews = previews }, Cmd.none )


view : Model -> ( String, Element Msg )
view model =
    ( "Image Preview", dragView model |> Element.html )


dragView : Model -> Html Msg
dragView model =
    div
        [ style "border"
            (if model.hover then
                "6px dashed purple"

             else
                "6px dashed #ccc"
            )
        , style "border-radius" "20px"
        , style "width" "600px"
        , style "height" "400px"
        , style "margin" "100px auto"
        , style "padding" "20px"
        , style "display" "flex"
        , style "flex-direction" "column"
        , style "justify-content" "center"
        , style "align-items" "center"
        , hijackOn "dragenter" (D.succeed DragEnter)
        , hijackOn "dragover" (D.succeed DragEnter)
        , hijackOn "dragleave" (D.succeed DragLeave)
        , hijackOn "drop" dropDecoder
        ]
        [ button [ onClick Pick ] [ text "Upload Images" ]
        , div
            [ style "display" "flex"
            , style "align-items" "center"
            , style "height" "60px"
            , style "padding" "20px"
            ]
            (List.map viewPreview model.previews)
        , hr [] []
        ]


viewPreview : String -> Html msg
viewPreview url =
    div []
        [ bgImg url
        , div [] [ String.join " " [ "Size:", String.length url |> String.fromInt, " " ] |> text ]
        ]


bgImg : String -> Html msg
bgImg url =
    div
        [ style "width" "150px"
        , style "height" "150px"
        , style "background-image" ("url('" ++ url ++ "')")
        , style "background-position" "center"
        , style "background-repeat" "no-repeat"
        , style "background-size" "contain"
        ]
        []


readAsUrl : List File -> Cmd Msg
readAsUrl files =
    Task.perform GotPreviews <| Task.sequence <| List.map File.toUrl files


dropDecoder : D.Decoder Msg
dropDecoder =
    D.at [ "dataTransfer", "files" ] (D.oneOrMore GotFiles File.decoder)


hijackOn : String -> D.Decoder msg -> Attribute msg
hijackOn event decoder =
    preventDefaultOn event (D.map hijack decoder)


hijack : msg -> ( msg, Bool )
hijack msg =
    ( msg, True )
