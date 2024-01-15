module RouteTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Route exposing (Route)
import Test exposing (..)
import Url exposing (Url)


suite : Test
suite =
    describe "The Route module"
        [ describe "Route.toPath"
            [ test "Route.Home" <|
                \_ -> Route.toPath Route.Home |> Expect.equal "/elm-examples-spa/"
            , test "Route.Counter" <|
                \_ -> Route.toPath Route.Counter |> Expect.equal "/elm-examples-spa/counter"
            , test "Route.ImagePreview" <|
                \_ -> Route.toPath Route.ImagePreview |> Expect.equal "/elm-examples-spa/preview"
            , test "Route.Quotes" <|
                \_ -> Route.toPath Route.Quotes |> Expect.equal "/elm-examples-spa/quotes"
            ]
        , fromUrlTests
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


urlWithPath : String -> Url
urlWithPath path =
    { protocol = Url.Https
    , host = "test.com"
    , port_ = Nothing
    , path = path
    , query = Nothing
    , fragment = Nothing
    }
