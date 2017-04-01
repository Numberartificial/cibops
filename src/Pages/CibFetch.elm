module Pages.CibFetch exposing (..)

import Http
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Task exposing (Task)

import RemoteData.Http exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import Bootstrap.Button as Button exposing (..)
import Bootstrap.Dropdown as Dropdown exposing (..)

import Views.WebListView as ListView
import Effects.Web as Resource 


-- MODEL


type alias Model =
    { drop : Dropdown.State
    , people : ListView.Model Resource.Person
    }



-- INIT


init : ( Model, Cmd Msg )
init =
    let
        ( peopleModel, peopleCmd ) =
            ListView.init
    in
        ( { drop = Dropdown.initialState
          , people = peopleModel
          }
        , Cmd.batch
            [ Cmd.map PeopleMsg peopleCmd ]
        )


-- UPDATE


type Msg
    = DropMsg Dropdown.State
    | FetchPeople
    | PeopleMsg (ListView.Msg Resource.Person)
    | DropClick String String


mapWebData : (a -> b) -> WebData a -> WebData b
mapWebData f webData =
    case webData of
        Success a ->
            Success (f a)

        Failure error ->
            Failure error

        NotAsked ->
            NotAsked

        Loading ->
            Loading


fetchPeople url =
    getWithConfig defaultConfig
        url
        ((\wedata ->
            mapWebData
                (\people -> people.content)
                wedata
                |> ListView.FetchMsg
         )
        )
        Resource.decodePeople
fetch =
    getWithConfig defaultConfig
        "http://168.35.6.12:8099/aic/api/people"
        ((\wedata ->
            mapWebData
                (\people -> people.content)
                wedata
                |> ListView.FetchMsg
         )
        )
        Resource.decodePeople


host : String
host = "http://168.35.6.12:8099"


makeUrl : String -> String -> String -> String
makeUrl host source data =
    String.join "/" [ host, source, "api", data  ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DropMsg state ->
            -- Tuple.mapFirst (\model -> { model | drop = state }) <|
                -- updatePeople model ListView.Fetch
            ( {model | drop = state }
            , Cmd.none )

        FetchPeople ->
            updatePeople model ListView.Fetch

        PeopleMsg peopleMsg ->
            updatePeople model peopleMsg

        DropClick source data ->
            updateList (makeUrl host source data)  (model)


updateList : String -> Model -> ( Model, Cmd Msg )
updateList url model =
    let
        ( nextModel, nextCmd ) =
            ListView.update (fetchPeople url) ListView.Fetch model.people
    in
        ( { model | people = nextModel }
        , Cmd.map PeopleMsg nextCmd )


updatePeople : Model -> ListView.Msg Resource.Person -> ( Model, Cmd Msg )
updatePeople model msg =
    let
        ( nextModel, nextCmd ) =
            ListView.update fetch msg model.people
    in
        ( { model
            | people = nextModel
          }
        , Cmd.map PeopleMsg nextCmd
        )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ viewDrop model
        , Button.button
            [ Button.primary
            , Button.attrs
                [ onClick (FetchPeople) ]
            ]
            [ text "fetch people" ]
        , ListView.custom viewPerson
            model.people
        ]


viewDrop : Model -> Html Msg
viewDrop model =
    div []
        [ Dropdown.dropdown
            model.drop
            { options = [ Dropdown.alignMenuRight ]
            , toggleMsg = DropMsg
            , toggleButton =
                Dropdown.toggle [ Button.roleLink ]
                    [ text <| String.join "/" ["source", "resource"]
                    ]
            , items =
                [ Dropdown.buttonItem [ onClick FetchPeople ] [ text "fetch people" ]
                , Dropdown.buttonItem [ onClick <| (DropClick "aic" "people") ] [ text "Item 2" ]
                , Dropdown.buttonItem [ onClick <| (DropClick "shixin" "people") ] [ text <| String.join "/"["shixin" , "person"]]
                , Dropdown.divider
                , Dropdown.header [ text "Silly items" ]
                , Dropdown.buttonItem [ class "disabled" ] [ text "DoNothing1" ]
                , Dropdown.buttonItem [] [ text "DoNothing2" ]
                ]
            }
          -- etc
        ]


viewPerson : Resource.Person -> Html Msg
viewPerson person =
    div []
        [ text (toString person.name) ]



-- SUBSCRIPTIONS


sub : Model -> Sub Msg
sub model =
    Sub.batch
        [ Dropdown.subscriptions
            model.drop
            DropMsg
        ]



-- MAIN


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = sub
        }
