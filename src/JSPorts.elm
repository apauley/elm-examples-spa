port module JSPorts exposing (setDarkMode)


setDarkMode : Bool -> Cmd msg
setDarkMode darkMode =
    let
        theme =
            if darkMode then
                "dark"

            else
                "light"
    in
    setTheme theme


port setTheme : String -> Cmd msg
