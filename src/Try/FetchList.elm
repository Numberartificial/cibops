module FetchList exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Task exposing (Task)
import Json.Decode as Decode
import RemoteData exposing (WebData, RemoteData(..))
import Bootstrap.ListGroup as BList exposing (..)


-- Model


type alias Model a b =
    { viewPort : ViewPort b
    , list : WebData List a
    }

type alias ViewPort b =
    { content : b
    }


-- View


view : Model a b -> Html (Msg a)
view model =
    div []
        [Html.button [ onClick Fetch ] [ text "Fetch" ]
        , div [] []
        , viewPeople model.people
        , BList.ul []
        ]


viewList : WebData People -> Html Msg
viewList model =
    case model of
        Loading ->
            text "加载中"

        Failure _ ->
            text "加载失败"

        Success people ->
            people.content
                |> List.map (viewPerson )
                |> Html.ul [styles commitList]

        _ ->
            text ""



-- Update
type Msg a
    = Fetch
    | FetchMsg (Result Http.Error (WebData (List a)))


update : Msg a -> Model a b -> ( Model a b, Cmd Msg a)
update msg model =
    case msg of
        Fetch ->
            ( {model | list = Loading}, fetchCmd )

        FetchMsg (Ok res)
            ( {model | list = Success res}, Cmd.none)

        FetchMsg (Err error)
            ( { model | list = Failure error}, Cmd.none)


