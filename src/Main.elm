module Main exposing (main)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import JSPorts
import Page.CodeMirror
import Page.Counter
import Page.Home
import Page.ImagePreview
import Page.InternationalDate
import Page.NotFound
import Page.Quotes
import Platform.Cmd as Cmd
import Route exposing (Route)
import Task
import Time
import TimeStamp exposing (TimeStamp)
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
    , timestamp : TimeStamp
    , preferences : Preferences
    , pagesState : PagesState
    }


type alias PagesState =
    { counter : Page.Counter.Model
    , imagePreview : Page.ImagePreview.Model
    , quotes : Page.Quotes.Model
    , intlDate : Page.InternationalDate.Model
    }


init : String -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init theme url navKey =
    let
        timestamp =
            TimeStamp Time.utc (Time.millisToPosix 0)

        ( pagesState, pagesCmd ) =
            pagesInit
    in
    ( { navKey = navKey
      , url = url
      , route = Route.fromUrl url
      , timestamp = timestamp
      , preferences = { darkMode = theme == "dark" }
      , pagesState = pagesState
      }
    , Cmd.batch [ Task.perform AdjustTimeZone Time.here, pagesCmd ]
    )


pagesInit : ( PagesState, Cmd Msg )
pagesInit =
    let
        ( quotesModel, quotesCmd ) =
            Page.Quotes.init

        ( counterModel, counterCmd ) =
            Page.Counter.init

        ( dateModel, dateCmd ) =
            Page.InternationalDate.init

        cmd =
            Cmd.batch
                [ Cmd.map GotCounterMsg counterCmd
                , Cmd.map GotQuotesMsg quotesCmd
                , Cmd.map GotDateMsg dateCmd
                ]
    in
    ( { counter = counterModel
      , imagePreview = Page.ImagePreview.init
      , quotes = quotesModel
      , intlDate = dateModel
      }
    , cmd
    )


type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | ToggleDarkMode
    | GotCounterMsg Page.Counter.Msg
    | GotImagePreviewMsg Page.ImagePreview.Msg
    | GotQuotesMsg Page.Quotes.Msg
    | GotDateMsg Page.InternationalDate.Msg
    | GotCodeMirrorMsg Page.CodeMirror.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( { model | timestamp = updateTime model.timestamp newTime }
            , Cmd.none
            )

        AdjustTimeZone newZone ->
            ( { model | timestamp = updateZone model.timestamp newZone }
            , Cmd.none
            )

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

        GotDateMsg subMsg ->
            updateInternationalDate model subMsg

        GotCodeMirrorMsg subMsg ->
            ( model, Cmd.none )


updateTime : TimeStamp -> Time.Posix -> TimeStamp
updateTime previous newTime =
    { previous | time = newTime }


updateZone : TimeStamp -> Time.Zone -> TimeStamp
updateZone previous newZone =
    { previous | zone = newZone }


updateInternationalDate : Model -> Page.InternationalDate.Msg -> ( Model, Cmd Msg )
updateInternationalDate model subMsg =
    let
        pageModels =
            model.pagesState

        previousPageModel =
            pageModels.intlDate

        ( newPageModel, pageCmd ) =
            Page.InternationalDate.update subMsg previousPageModel

        newPages =
            { pageModels | intlDate = newPageModel }

        newModel =
            { model | pagesState = newPages }
    in
    ( newModel, Cmd.map GotDateMsg pageCmd )


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



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Time.every 1000 Tick


view : Model -> Document Msg
view model =
    let
        ( pageTitel, pageContent ) =
            pageView model
    in
    { title = pageTitel
    , body =
        [ Html.main_ []
            [ Html.header [] [ topBarNavLinks model ]
            , Html.aside [] [ sideBarNavLinks model.url ]
            , Html.section [] [ pageContent ]
            , Html.footer [] [ footerBar model ]
            ]
        ]
    }


themeToggleButton darkMode =
    if darkMode then
        UI.textButton ToggleDarkMode "Light Mode"

    else
        UI.textButton ToggleDarkMode "Dark Mode"


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

        Just Route.InternationalDate ->
            let
                ( title, content ) =
                    Page.InternationalDate.view model.pagesState.intlDate model.timestamp
            in
            ( title, Html.map GotDateMsg content )

        Just Route.CodeMirror ->
            let
                ( title, content ) =
                    Page.CodeMirror.view Page.CodeMirror.initialModel
            in
            ( title, Html.map GotCodeMirrorMsg content )


topBarNavLinks : Model -> Html Msg
topBarNavLinks model =
    UI.navBar
        [ [ UI.appLink model.url Route.Home "Home" ]
        , [ themeToggleButton model.preferences.darkMode ]
        ]


sideBarNavLinks : Url.Url -> Html Msg
sideBarNavLinks url =
    UI.navBar
        [ [ UI.appLink url Route.Counter "Counter"
          , UI.appLink url Route.ImagePreview "Image Preview"
          , UI.appLink url Route.Quotes "Quotes"
          , UI.appLink url Route.InternationalDate "International Date"
          , UI.appLink url Route.CodeMirror "Code Mirror"
          ]
        ]


footerBar : Model -> Html Msg
footerBar model =
    UI.navBar
        [ [ UI.externalLink "https://github.com/apauley/elm-examples-spa" "GitHub" ]
        , [ viewTime model.timestamp ]
        ]


viewTime : TimeStamp -> Html Msg
viewTime timestamp =
    p [] [ TimeStamp.toString timestamp |> Html.text ]
