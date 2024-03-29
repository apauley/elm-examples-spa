module Route exposing (Route(..), fromUrl, toPath)

import Url exposing (Url)
import Url.Builder
import Url.Parser as Parser exposing (Parser, oneOf, s)


type Route
    = Home
    | Counter
    | ImagePreview
    | Quotes
    | InternationalDate
    | CodeMirror


subPath =
    "elm-examples-spa"


toPath : Url.Url -> Route -> String
toPath url route =
    let
        subPathOrNot =
            if String.contains subPath url.path then
                [ subPath ]

            else
                []

        pathSegments =
            subPathOrNot
                ++ [ case route of
                        Home ->
                            ""

                        Counter ->
                            "counter"

                        ImagePreview ->
                            "preview"

                        Quotes ->
                            "quotes"

                        InternationalDate ->
                            "intl-date"

                        CodeMirror ->
                            "code"
                   ]

        queryParameters =
            []
    in
    Url.Builder.absolute pathSegments queryParameters


parser : Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map Home Parser.top
        , Parser.map Counter (s "counter")
        , Parser.map ImagePreview (s "preview")
        , Parser.map Quotes (s "quotes")
        , Parser.map InternationalDate (s "intl-date")
        , Parser.map CodeMirror (s "code")
        ]


normalizePath : String -> String
normalizePath path =
    let
        -- Github pages doesn't serve the site under the root of the domain, but under a path named after the project: https://domain/elm-examples-spa/
        -- Make it work when served under either the root or the path
        pathSegments =
            String.split "/" path
                |> List.filter (\x -> not (List.member x [ subPath, "" ]))

        queryParameters =
            []
    in
    Url.Builder.absolute pathSegments queryParameters


normalizeUrl : Url -> Url
normalizeUrl url =
    { url | path = normalizePath url.path }


fromUrl : Url -> Maybe Route
fromUrl url =
    Parser.parse parser <| normalizeUrl url
