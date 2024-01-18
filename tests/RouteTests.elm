module RouteTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Route exposing (Route)
import Test exposing (..)
import Url exposing (Url)


suite : Test
suite =
    describe "The Route module"
        [ toPathTests, fromUrlTests ]


toPathTests : Test
toPathTests =
    let
        toExpectation ( url, route, path ) =
            test ("Route.toPath " ++ path) <|
                \_ -> Route.toPath url route |> Expect.equal path
    in
    describe "Route.toPath" <|
        List.map toExpectation
            [ ( homeWithoutSubPath, Route.Home, "/" )
            , ( homeWithSubPath, Route.Home, "/elm-examples-spa/" )
            , ( homeWithoutSubPath, Route.Counter, "/counter" )
            , ( homeWithSubPath, Route.Counter, "/elm-examples-spa/counter" )
            , ( homeWithoutSubPath, Route.ImagePreview, "/preview" )
            , ( homeWithSubPath, Route.ImagePreview, "/elm-examples-spa/preview" )
            , ( homeWithoutSubPath, Route.Quotes, "/quotes" )
            , ( homeWithSubPath, Route.Quotes, "/elm-examples-spa/quotes" )
            ]


fromUrlTests : Test
fromUrlTests =
    let
        toExpectation pathAndRoute =
            test ("Route.fromUrl " ++ Tuple.first pathAndRoute) <|
                \_ -> Route.fromUrl (Tuple.first pathAndRoute |> urlWithPath) |> Expect.equal (Just <| Tuple.second pathAndRoute)
    in
    describe "Route.fromUrl" <|
        List.map toExpectation
            [ ( "/", Route.Home )
            , ( "/elm-examples-spa", Route.Home )
            , ( "/elm-examples-spa/", Route.Home )
            , ( "/counter", Route.Counter )
            , ( "/counter/", Route.Counter )
            , ( "/elm-examples-spa/counter", Route.Counter )
            , ( "/elm-examples-spa/counter/", Route.Counter )
            , ( "/preview", Route.ImagePreview )
            , ( "/elm-examples-spa/preview", Route.ImagePreview )
            , ( "/quotes", Route.Quotes )
            , ( "/elm-examples-spa/quotes", Route.Quotes )
            ]


homeWithSubPath : Url
homeWithSubPath =
    urlWithPath "/elm-examples-spa"


homeWithoutSubPath : Url
homeWithoutSubPath =
    urlWithPath "/"


urlWithPath : String -> Url
urlWithPath path =
    { protocol = Url.Https
    , host = "test.com"
    , port_ = Nothing
    , path = path
    , query = Nothing
    , fragment = Nothing
    }
