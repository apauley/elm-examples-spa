module TimeStamp exposing (TimeStamp, toDay, toHour, toMinute, toMonth, toSecond, toString, toYear)

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


toYear : TimeStamp -> Int
toYear timestamp =
    Time.toYear timestamp.zone timestamp.time


toMonth : TimeStamp -> Month
toMonth timestamp =
    Time.toMonth timestamp.zone timestamp.time


toDay : TimeStamp -> Int
toDay timestamp =
    Time.toDay timestamp.zone timestamp.time


toHour : TimeStamp -> Int
toHour timestamp =
    Time.toHour timestamp.zone timestamp.time


toMinute : TimeStamp -> Int
toMinute timestamp =
    Time.toMinute timestamp.zone timestamp.time


toSecond : TimeStamp -> Int
toSecond timestamp =
    Time.toSecond timestamp.zone timestamp.time


toString : TimeStamp -> String
toString timestamp =
    let
        year =
            timestamp |> toYear |> String.fromInt

        month =
            timestamp |> toMonth |> toEnglishMonth

        day =
            timestamp |> toDay |> String.fromInt |> String.padLeft 2 '0'

        weekday =
            toEnglishWeekday (Time.toWeekday timestamp.zone timestamp.time)

        hour =
            timestamp |> toHour |> String.fromInt |> String.padLeft 2 '0'

        minute =
            timestamp |> toMinute |> String.fromInt |> String.padLeft 2 '0'

        second =
            timestamp |> toSecond |> String.fromInt |> String.padLeft 2 '0'

        date =
            String.join " " [ month, day, year ]

        time =
            hour ++ ":" ++ minute ++ ":" ++ second
    in
    String.join " - " [ weekday, date, time ]
