module Main exposing (main)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import JSPorts
import Page.Counter
import Page.Home
import Page.ImagePreview
import Page.NotFound
import Page.Quotes
import Platform.Cmd as Cmd
import Route exposing (Route)
import UI
import Url


main : Program String Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }


type alias Preferences =
    { darkMode : Bool }


type alias Model =
    { navKey : Nav.Key
    , url : Url.Url
    , route : Maybe Route
    , preferences : Preferences
    , pagesState : PagesState
    }


type alias PagesState =
    { counter : Page.Counter.Model
    , imagePreview : Page.ImagePreview.Model
    , quotes : Page.Quotes.Model
    }


init : String -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init theme url navKey =
    let
        ( pagesState, cmd ) =
            pagesInit
    in
    ( { navKey = navKey
      , url = url
      , route = Route.fromUrl url
      , preferences = { darkMode = theme == "dark" }
      , pagesState = pagesState
      }
    , cmd
    )


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
      , quotes = quotesModel
      }
    , cmd
    )


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | ToggleDarkMode
    | GotCounterMsg Page.Counter.Msg
    | GotImagePreviewMsg Page.ImagePreview.Msg
    | GotQuotesMsg Page.Quotes.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.navKey (Url.toString url)
                    )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url, route = Route.fromUrl url }, Cmd.none )

        ToggleDarkMode ->
            let
                prefs =
                    model.preferences

                newPrefs =
                    { prefs | darkMode = not prefs.darkMode }
            in
            ( { model | preferences = newPrefs }, JSPorts.setDarkMode newPrefs.darkMode )

        GotCounterMsg subMsg ->
            updateCounter model subMsg

        GotImagePreviewMsg subMsg ->
            updateImagePreview model subMsg

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
        [ Html.header [] [ topBarNavLinks model.url ]
        , Html.main_ [ class "container" ] [ pageContent ]
        , Html.footer []
            [ UI.externalLink "https://github.com/apauley/elm-examples-spa" "GitHub"
            , if model.preferences.darkMode then
                UI.textButton ToggleDarkMode "To Light"

              else
                UI.textButton ToggleDarkMode "To Dark"
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

        Just Route.Quotes ->
            let
                ( title, content ) =
                    Page.Quotes.view model.pagesState.quotes
            in
            ( title, Html.map GotQuotesMsg content )


topBarNavLinks : Url.Url -> Html msg
topBarNavLinks url =
    Html.nav []
        [ Html.ul [] [ Html.li [] [ UI.appLink url Route.Home "Home" ] ]
        , Html.ul []
            [ Html.li [] [ UI.appLink url Route.Counter "Counter" ]
            , Html.li [] [ UI.appLink url Route.ImagePreview "Image Preview" ]
            , Html.li [] [ UI.appLink url Route.Quotes "Quotes" ]
            ]
        ]
