module OrdinaryHttp exposing (..)

import Html exposing (Html, div, button, text)
import Html.Events exposing (onClick)
import Http
import Task exposing (Task)
import Json.Decode as Decode


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

{-| Task.perform Never make a error of Result,opposite to it,
     attempt will handle a result of (Result error a) which may fail in
     elm runtime-}
fetchCmd : Cmd Msg
fetchCmd =
    -- Task.perform FetchSuccess fetchTask
    Task.attempt FetchMsg fetchTask



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
