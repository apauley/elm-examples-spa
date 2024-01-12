module Page.Quotes exposing (Model(..), Msg, init, update, view)

-- Press a button to send a GET request for random quotes.
--
-- Read how it works:
--   https://guide.elm-lang.org/effects/json.html
--

import Element exposing (..)
import Element.Border as Border
import Element.Input as Input
import Element.Region as Region
import Html exposing (Html)
import Http
import Json.Decode exposing (Decoder, field, int, map4, string)
import UI



-- MODEL


type Model
    = Failure
    | Loading
    | Success Quote


type alias Quote =
    { quote : String
    , source : String
    , author : String
    , year : Int
    }


init : ( Model, Cmd Msg )
init =
    ( Loading, getRandomQuote )



-- UPDATE


type Msg
    = MorePlease
    | GotQuote (Result Http.Error Quote)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        MorePlease ->
            ( Loading, getRandomQuote )

        GotQuote result ->
            case result of
                Ok quote ->
                    ( Success quote, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )



-- VIEW


view : Model -> ( String, Element Msg )
view model =
    ( "Random Quotes"
    , UI.column
        [ el [ Region.heading 1 ] <| Element.html <| Html.h1 [] [ Html.text "Random Quotes" ]
        , viewQuote model
        ]
    )


viewQuote : Model -> Element Msg
viewQuote model =
    case model of
        Failure ->
            UI.column
                [ text "I could not load a random quote for some reason. "
                , Input.button
                    []
                    { onPress = Just MorePlease
                    , label = text "Try Again!"
                    }
                ]

        Loading ->
            text "Loading..."

        Success quote ->
            renderQuote quote


renderQuote : Quote -> Element Msg
renderQuote quote =
    UI.column
        [ el [ padding 20 ] <| UI.textButton MorePlease "More Please!"
        , textColumn [ spacing 10, padding 10, Border.solid, Border.rounded 20, Border.width 2 ]
            [ paragraph []
                [ -- , blockquote [] [ text quote.quote ]
                  text quote.quote
                ]
            , el [ alignLeft ] none
            , paragraph [ alignRight ]
                [ text "— "

                -- , cite [] [ text quote.source ]
                , el [] (text quote.source)
                , text (" by " ++ quote.author ++ " (" ++ String.fromInt quote.year ++ ")")
                ]
            ]
        ]



-- HTTP


getRandomQuote : Cmd Msg
getRandomQuote =
    Http.get
        { url = "https://elm-lang.org/api/random-quotes"
        , expect = Http.expectJson GotQuote quoteDecoder
        }


quoteDecoder : Decoder Quote
quoteDecoder =
    map4 Quote
        (field "quote" string)
        (field "source" string)
        (field "author" string)
        (field "year" int)
