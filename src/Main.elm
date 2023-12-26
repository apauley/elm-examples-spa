module Main exposing (main)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Page.Counter
import Page.Home
import Page.ImagePreview
import Page.NotFound
import Page.Quotes
import Page.Upload
import Platform.Cmd as Cmd
import Route exposing (Route)
import Url


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }


type alias Model =
    { navKey : Nav.Key
    , route : Maybe Route
    , pagesState : PagesState
    }


type alias PagesState =
    { counter : Page.Counter.Model
    , imagePreview : Page.ImagePreview.Model
    , upload : Page.Upload.Model
    , quotes : Page.Quotes.Model
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url navKey =
    let
        ( pagesState, cmd ) =
            pagesInit
    in
    ( { navKey = navKey, route = Route.fromUrl url, pagesState = pagesState }, cmd )


pagesInit : ( PagesState, Cmd Msg )
pagesInit =
    let
        ( quotesModel, quotesCmd ) =
            Page.Quotes.init

        ( counterModel, counterCmd ) =
            Page.Counter.init

        cmd =
            Cmd.batch [ Cmd.map GotCounterMsg counterCmd, Cmd.map GotQuotesMsg quotesCmd ]
    in
    ( { counter = counterModel
      , imagePreview = Page.ImagePreview.init
      , upload = Page.Upload.init
      , quotes = quotesModel
      }
    , cmd
    )


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | GotCounterMsg Page.Counter.Msg
    | GotImagePreviewMsg Page.ImagePreview.Msg
    | GotUploadMsg Page.Upload.Msg
    | GotQuotesMsg Page.Quotes.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.navKey (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | route = Route.fromUrl url }, Cmd.none )

        GotCounterMsg subMsg ->
            updateCounter model subMsg

        GotImagePreviewMsg subMsg ->
            updateImagePreview model subMsg

        GotUploadMsg subMsg ->
            updateUpload model subMsg

        GotQuotesMsg subMsg ->
            updateQuotes model subMsg


updateQuotes : Model -> Page.Quotes.Msg -> ( Model, Cmd Msg )
updateQuotes model subMsg =
    let
        pageModels =
            model.pagesState

        previousPageModel =
            pageModels.quotes

        ( newPageModel, pageCmd ) =
            Page.Quotes.update subMsg previousPageModel

        newPages =
            { pageModels | quotes = newPageModel }

        newModel =
            { model | pagesState = newPages }
    in
    ( newModel, Cmd.map GotQuotesMsg pageCmd )


updateCounter : Model -> Page.Counter.Msg -> ( Model, Cmd Msg )
updateCounter model subMsg =
    let
        pageModels =
            model.pagesState

        previousPageModel =
            pageModels.counter

        ( newPageModel, pageCmd ) =
            Page.Counter.update subMsg previousPageModel

        newPages =
            { pageModels | counter = newPageModel }

        newModel =
            { model | pagesState = newPages }
    in
    ( newModel, Cmd.map GotCounterMsg pageCmd )


updateImagePreview : Model -> Page.ImagePreview.Msg -> ( Model, Cmd Msg )
updateImagePreview model subMsg =
    let
        pageModels =
            model.pagesState

        previousPageModel =
            pageModels.imagePreview

        ( newPageModel, pageCmd ) =
            Page.ImagePreview.update subMsg previousPageModel

        newPages =
            { pageModels | imagePreview = newPageModel }

        newModel =
            { model | pagesState = newPages }
    in
    ( newModel, Cmd.map GotImagePreviewMsg pageCmd )


updateUpload : Model -> Page.Upload.Msg -> ( Model, Cmd Msg )
updateUpload model subMsg =
    let
        pageModels =
            model.pagesState

        previousPageModel =
            pageModels.upload

        ( newPageModel, pageCmd ) =
            Page.Upload.update subMsg previousPageModel

        newPages =
            { pageModels | upload = newPageModel }

        newModel =
            { model | pagesState = newPages }
    in
    ( newModel, Cmd.map GotUploadMsg pageCmd )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Document Msg
view model =
    let
        ( pageTitel, pageContent ) =
            pageView model
    in
    { title = pageTitel
    , body =
        [ div []
            [ navLinkView
            , pageContent
            ]
        ]
    }


pageView : Model -> ( String, Html Msg )
pageView model =
    case model.route of
        Nothing ->
            Page.NotFound.view

        Just Route.Home ->
            Page.Home.view

        Just Route.Counter ->
            let
                ( title, content ) =
                    Page.Counter.view model.pagesState.counter
            in
            ( title, Html.map GotCounterMsg content )

        Just Route.ImagePreview ->
            let
                ( title, content ) =
                    Page.ImagePreview.view model.pagesState.imagePreview
            in
            ( title, Html.map GotImagePreviewMsg content )

        Just Route.Upload ->
            let
                ( title, content ) =
                    Page.Upload.view model.pagesState.upload
            in
            ( title, Html.map GotUploadMsg content )

        Just Route.Quotes ->
            let
                ( title, content ) =
                    Page.Quotes.view model.pagesState.quotes
            in
            ( title, Html.map GotQuotesMsg content )


navLinkView : Html msg
navLinkView =
    div []
        [ span []
            [ div [] [ navLink "/" "Home" ]
            , div [] [ navLink "/counter" "Counter" ]
            , div [] [ navLink "/preview" "Image Preview" ]
            , div [] [ navLink "/upload" "File Upload" ]
            , div [] [ navLink "/quotes" "Quotes" ]
            ]
        , hr [] []
        ]


navLink : String -> String -> Html msg
navLink path txt =
    a [ href path ] [ text txt ]
