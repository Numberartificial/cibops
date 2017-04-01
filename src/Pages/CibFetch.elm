module Pages.CibFetch exposing (..)

import Http
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Task exposing (Task)
import RemoteData.Http as Rest exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import Bootstrap.Button as Button exposing (..)
import Bootstrap.Dropdown as Dropdown exposing (..)
import Views.WebDataView as WebDataView
import Views.WebListView as ListView
import Effects.Web as Resource exposing (AuditList)


-- MODEL


type alias Model =
    { drop : Dropdown.State
    , people : ListView.Model Resource.Person
    , audit : WebData AuditList
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
          , audit = NotAsked
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
    | HandleAudit (WebData AuditList)


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


fetchCorporations url =
    getWithConfig defaultConfig
        url
        ((\wedata ->
            mapWebData
                (\res -> res.content)
                wedata
                |> ListView.FetchMsg
         )
        )
        Resource.decodeCorporations


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


fetchPage : String -> Int -> Int -> Task Never (WebData Resource.People)
fetchPage url page size =
    getTaskWithConfig defaultConfig
        (Rest.url url [ ( "page", toString page ), ( "size", toString size ) ])
        Resource.decodePeople


fetchAuditA : String -> AuditList -> Task Never (WebData AuditList)
fetchAuditA url audit =
    Task.map
        (\res ->
            mapWebData
                (\data ->
                    let
                        number =
                            List.length data.content
                    in
                        { audit
                            | total = audit.total + number
                            , number = number
                        }
                )
                res
        )
        (fetchPage url audit.page audit.size)


fetchAccumulate : String -> AuditList -> Task Never (WebData AuditList)
fetchAccumulate url audit =
    ((fetchAuditA url audit)
        |> Task.andThen
            (\webData ->
                case webData of
                    Success preAudit ->
                        if preAudit.number > 0 then
                            fetchAccumulate url { preAudit | page = preAudit.page + 1 }
                        else
                            Task.succeed webData

                    _ ->
                        Task.succeed webData
            )
    )


fetchCount : String -> Cmd Msg
fetchCount url =
    let
        audit =
            { total = 0, page = 0, size = 200, number = 0 }
    in
        Task.perform
            HandleAudit
        <|
            fetchAccumulate url audit


host : String
host =
    "http://168.35.6.12:8099"


makeUrl : String -> String -> String -> String
makeUrl host source data =
    String.join "/" [ host, source, "api", data ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DropMsg state ->
            -- Tuple.mapFirst (\model -> { model | drop = state }) <|
            -- updatePeople model ListView.Fetch
            ( { model | drop = state }
            , Cmd.none
            )

        FetchPeople ->
            updatePeople model ListView.Fetch

        PeopleMsg peopleMsg ->
            updatePeople model peopleMsg

        DropClick source data ->
            updateList host source data (model)

        HandleAudit webData ->
           ( { model | audit = webData}
              , Cmd.none
            )


updateList : String -> String -> String -> Model -> ( Model, Cmd Msg )
updateList host source data model =
    let
        url =
            (makeUrl host source data)

        ( nextModel, nextCmd ) =
            ListView.update (fetchPeople url) ListView.Fetch model.people

        countCmd =
            fetchCount url
    in
        ( { model | people = nextModel }
        , Cmd.batch
            [ Cmd.map PeopleMsg nextCmd
            , countCmd
            ]
        )


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
            [ text "reload" ]
        , WebDataView.simple (\audit -> text <| toString audit.total) model.audit
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
                    [ text <| String.join "/" [ "source", "resource" ]
                    ]
            , items =
                [ Dropdown.buttonItem [ onClick FetchPeople ] [ text "reload" ]
                , Dropdown.buttonItem [ onClick <| (DropClick "aic" "people") ] [ text "Item 2" ]
                , Dropdown.buttonItem [ onClick <| (DropClick "shixin" "people") ] [ text <| String.join "/" [ "shixin", "person" ] ]
                , Dropdown.buttonItem [ onClick <| (DropClick "shixin" "corporations") ] [ text <| String.join "/" [ "shixin", "corporation" ] ]
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
