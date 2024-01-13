module Route exposing (Route(..), fromUrl, toPath)

import Url exposing (Url)
import Url.Builder
import Url.Parser as Parser exposing (Parser, oneOf, s)


type Route
    = Home
    | Counter
    | ImagePreview
    | Upload
    | Quotes


subPath =
    "elm-examples-spa"


toPath : Route -> String
toPath route =
    "/"
        ++ subPath
        ++ (case route of
                Home ->
                    "/"

                Counter ->
                    "/counter"

                ImagePreview ->
                    "/preview"

                Upload ->
                    "/upload"

                Quotes ->
                    "/quotes"
           )


parser : Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map Home Parser.top
        , Parser.map Counter (s "counter")
        , Parser.map ImagePreview (s "preview")
        , Parser.map Upload (s "upload")
        , Parser.map Quotes (s "quotes")
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
