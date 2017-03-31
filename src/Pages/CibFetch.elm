module Pages.CibFetch exposing(..)

import Http
import Html exposing (..)
import Html.Attributes exposing (href)
import Html.Events exposing (..)
import Task exposing (Task)

import RemoteData.Http exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import Bootstrap.Button as Button exposing (..)

import Views.WebListView as ListView
import Effects.Web as Resource exposing (..)


-- MODEL

type alias Model=
    { people : ListView.Model Person
    }


-- INIT


init : (Model , Cmd Msg)
init =
    let
        ( peopleModel, peopleCmd ) =
            ListView.init
    in
        ( { people = peopleModel }
        , Cmd.batch
           [ Cmd.map PeopleMsg peopleCmd ]
        )

-- UPDATE

type Msg =
    FetchPeople
    | PeopleMsg (ListView.Msg Person)

mapWebData : ( a -> b ) -> WebData a -> WebData b
mapWebData f webData =
    case webData of
        Success a -> Success (f a)
        Failure error -> Failure error
        NotAsked -> NotAsked
        Loading -> Loading



fetch =
    getWithConfig defaultConfig "http://168.35.6.12:8099/aic/api/people"
        (
        (\wedata ->
           mapWebData
             (\people -> people.content) wedata
            |> ListView.FetchMsg)
        )
        decodePeople

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        FetchPeople ->
            updatePeople model ListView.Fetch
        PeopleMsg peopleMsg ->
            updatePeople model peopleMsg

updatePeople : Model -> ListView.Msg Person -> ( Model, Cmd Msg)
updatePeople model msg =
    let
        ( nextModel, nextCmd ) =
            ListView.update fetch msg model.people
    in
        ( { model | people = nextModel
                }
          , Cmd.map PeopleMsg nextCmd )


-- VIEW


view : Model-> Html Msg
view model =
    div []
        [ Button.button
              [Button.primary,
              Button.attrs
                [ onClick (FetchPeople)]]
              [ text "fetch people"]
        ,
          ListView.custom viewPerson
              model.people
        ]


viewPerson : Person -> Html Msg
viewPerson person =
    div []
        [ text (toString person.name)]


-- MAIN


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = (always Sub.none)
        }
