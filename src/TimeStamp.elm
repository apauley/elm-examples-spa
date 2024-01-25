module TimeStamp exposing (TimeStamp, toString)

import Time exposing (..)


type alias TimeStamp =
    { zone : Time.Zone
    , time : Time.Posix
    }


toEnglishMonth : Month -> String
toEnglishMonth month =
    case month of
        Jan ->
            "January"

        Feb ->
            "February"

        Mar ->
            "March"

        Apr ->
            "April"

        May ->
            "May"

        Jun ->
            "June"

        Jul ->
            "July"

        Aug ->
            "August"

        Sep ->
            "September"

        Oct ->
            "October"

        Nov ->
            "November"

        Dec ->
            "December"


toEnglishWeekday : Weekday -> String
toEnglishWeekday weekday =
    case weekday of
        Mon ->
            "Monday"

        Tue ->
            "Tuesday"

        Wed ->
            "Wednesday"

        Thu ->
            "Thursday"

        Fri ->
            "Friday"

        Sat ->
            "Saturday"

        Sun ->
            "Sunday"


toString : TimeStamp -> String
toString timestamp =
    let
        year =
            String.fromInt (Time.toYear timestamp.zone timestamp.time)

        month =
            toEnglishMonth (Time.toMonth timestamp.zone timestamp.time)

        day =
            String.fromInt (Time.toDay timestamp.zone timestamp.time) |> String.padLeft 2 '0'

        weekday =
            toEnglishWeekday (Time.toWeekday timestamp.zone timestamp.time)

        hour =
            String.fromInt (Time.toHour timestamp.zone timestamp.time) |> String.padLeft 2 '0'

        minute =
            String.fromInt (Time.toMinute timestamp.zone timestamp.time) |> String.padLeft 2 '0'

        second =
            String.fromInt (Time.toSecond timestamp.zone timestamp.time) |> String.padLeft 2 '0'

        date =
            String.join " " [ month, day, year ]

        time =
            hour ++ ":" ++ minute ++ ":" ++ second
    in
    String.join " - " [ weekday, date, time ]
