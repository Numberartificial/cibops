module OrdinaryHttp exposing (..)

import Html exposing (Html, div, button, text)
import Html.Events exposing (onClick)
import Http
import Task exposing (Task)
import Json.Decode as Decode

import Types exposing (People)
import Decoders exposing (decodePeople)


-- MODEL


type alias Model =
    String


init : ( Model, Cmd Msg )
init =
    ( "", Cmd.none )



-- MESSAGES

{-| should use this kind of Msg, Task.attempt/perform only accept one
       parameter to represent a task's result and return a Msg which is dispatch from the result-}
type Msg
    = Fetch
    | FetchMsg (Result Http.Error String)
    -- | FetchSuccess String
    -- | FetchError Http.Error



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Fetch ] [ text "Fetch" ]
        , text model
        ]


decode : Decode.Decoder String
decode =
    -- Decode.at [ "name" ] Decode.string
    Decode.string

url : String
url =
    "https://www.sina.com.cn"


fetchTask : Task Http.Error String
fetchTask =
    Http.get url decode |> Http.toTask

fetch1 : Task Http.Error String
fetch1 =
    Http.get "http://168.35.6.12:8099/aic/api/people?page=1" decode
        |> Http.toTask

fetch0 : Task Http.Error String
fetch0 =
    Http.get "http://168.35.6.12:8099/aic/api/people?page=0" decode
        |> Http.toTask

{-| Task.perform Never make a error of Result,opposite to it,
     attempt will handle a result of (Result error a) which may fail in
     elm runtime-}
fetchCmd : Cmd Msg
fetchCmd =
    -- Task.perform FetchSuccess fetchTask
    Task.attempt FetchMsg (fetch0
                          |> Task.andThen (\n -> fetch1))




-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Fetch ->
            ( model, fetchCmd )

        FetchMsg (Ok name) ->
            ( name, Cmd.none)

        FetchMsg (Err error) ->
            ( toString error, Cmd.none )
        -- FetchSuccess name ->
            -- ( name, Cmd.none )

        -- FetchError error ->
            -- ( toString error, Cmd.none )

-- MAIN


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = (always Sub.none)
        }
