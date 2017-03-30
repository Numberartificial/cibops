module Effects.Web exposing (..)

import Html exposing (..)
import Http
import Task exposing (Task)
import Types exposing (People, Person)
import Decoders exposing (decodePeople)


fetch1 : Task Http.Error People
fetch1 =
    Http.get "http://168.35.6.12:8099/aic/api/people?page=1" decodePeople
        |> Http.toTask


fetch0 : Task Http.Error People
fetch0 =
    Http.get "http://168.35.6.12:8099/aic/api/people?page=0" decodePeople
        |> Http.toTask


{-| Task.perform Never make a error of Result,opposite to it,
     attempt will handle a result of (Result error a) which may fail in
     elm runtime
-}
fetchCmd msg =
    -- Task.perform FetchSuccess fetchTask
    Task.attempt msg
        (fetch0
            |> Task.andThen (\n -> fetch1)
        )
