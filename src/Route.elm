module Route exposing (Route(..), fromUrl)

import Url exposing (Url)
import Url.Parser as Parser exposing (Parser, oneOf, s)


type Route
    = Home
    | Counter
    | ImagePreview
    | Upload
    | Quotes


parser : Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map Home Parser.top
        , Parser.map Counter (s "counter")
        , Parser.map ImagePreview (s "preview")
        , Parser.map Upload (s "upload")
        , Parser.map Quotes (s "quotes")
        ]


fromUrl : Url -> Maybe Route
fromUrl url =
    Parser.parse parser url
