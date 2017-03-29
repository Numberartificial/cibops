module OrdinaryHttp exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Task exposing (Task)
import Json.Decode as Decode
import RemoteData exposing (WebData, RemoteData(..))

import Styles exposing (..)
import Types exposing (People, Person)
import Decoders exposing (decodePeople)


-- MODEL


type alias Model =
    { title : String
    , people : WebData People
    }


init : ( Model, Cmd Msg )
init =
    ( { title = "http chain"
      , people = NotAsked
      }
    , Cmd.none
    )



-- MESSAGES


{-| should use this kind of Msg, Task.attempt/perform only accept one
       parameter to represent a task's result and return a Msg which is dispatch from the result
-}
type Msg
    = Fetch
    | FetchMsg (Result Http.Error People)



-- | FetchSuccess String
-- | FetchError Http.Error
-- VIEW


view : Model -> Html Msg
view model =
    div []
        [button [ onClick Fetch ] [ text "Fetch" ]
        , div [] []
        , viewPeople model.people
        ]


viewPeople : WebData People -> Html Msg
viewPeople model =
    case model of
        Loading ->
            text "加载中"

        Failure _ ->
            text "加载失败"

        Success people ->
            people.content
                |> List.map (viewPerson )
                |> ul [styles commitList]

        _ ->
            text ""


viewPerson : Person -> Html Msg
viewPerson  person =
   li [ styles card ]
    [ h4 [] [ text person.name ]
    ]

decode : Decode.Decoder String
decode =
    -- Decode.at [ "name" ] Decode.string
    Decode.string


url : String
url =
    "https://www.sina.com.cn"


fetchTask : Task Http.Error People
fetchTask =
    Http.get url decodePeople |> Http.toTask


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
fetchCmd : Cmd Msg
fetchCmd =
    -- Task.perform FetchSuccess fetchTask
    Task.attempt FetchMsg
        (fetch0
            |> Task.andThen (\n -> fetch1)
        )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Fetch ->
            ( { model | people = Loading }, fetchCmd )

        FetchMsg (Ok res) ->
            ( { model | people = Success res}, Cmd.none )

        FetchMsg (Err error) ->
            ( { model | title = toString error }
            , Cmd.none
            )



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
