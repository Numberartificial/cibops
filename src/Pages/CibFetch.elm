module Pages.CibFetch exposing (..)

import Bootstrap.Button as Button 
import Bootstrap.Card as Card
import Bootstrap.Dropdown as Dropdown exposing (..)
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Checkbox as Checkbox
import Bootstrap.Form as Form
import Bootstrap.Badge as Badge
import Effects.Web as Resource exposing (AuditList)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import RemoteData exposing (RemoteData(..), WebData)
import RemoteData.Http as Rest exposing (..)
import Task exposing (Task)
import Views.WebDataView as WebDataView
import Views.WebListView as ListView


-- MODEL


type alias Model =
    { drop : Dropdown.State
    , people : ListView.Model Resource.Person
    , audit : WebData AuditList
    , filter : Filter
    , items : List Item
    }


type alias Item =
    { url : String
    , host : String
    , datasource : String
    , itemName : String
    , name : String
    }


type alias Filter =
    { loaded : Bool
    , lastUpdate : String
    }



-- INIT


initHost : String
initHost =
    "168.35.6.12:8099"


initItem : String -> String -> String -> Item
initItem host datasource itemName =
    let
        restName =
            String.join "/" [ datasource, "api", itemName ]
    in
        { url = "http://" ++ host ++ restName
        , host = host
        , datasource = datasource
        , itemName = itemName
        , name = restName
        }


peopleString : String
peopleString =
    "people"


corporationsString : String
corporationsString =
    "corporations"


init : ( Model, Cmd Msg )
init =
    let
        ( peopleModel, peopleCmd ) =
            ListView.init
    in
        ( { drop = Dropdown.initialState
          , people = peopleModel
          , audit = NotAsked
          , filter =
                { loaded = True
                , lastUpdate = ""
                }
          , items =
                [ initItem initHost "aic" peopleString
                , initItem initHost "aic" corporationsString
                , initItem initHost "cbrc" corporationsString
                , initItem initHost "shixin" peopleString
                , initItem initHost "shixin" corporationsString
                , initItem initHost "zhixing" peopleString
                , initItem initHost "zhixing" corporationsString
                , initItem initHost "zjcourt" corporationsString
                ]
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
    | FilterMsg FilterChange


type FilterChange
    = Loaded Bool
    | LastUpdate String


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
            ( { model | audit = webData }
            , Cmd.none
            )

        FilterMsg change ->
            case change of
                Loaded loaded ->
                    let
                        oldFilter =
                            model.filter

                        newFilter =
                            { oldFilter | loaded = loaded }
                    in
                        ( { model | filter = newFilter }
                        , Cmd.none
                        )

                LastUpdate date ->
                    let
                        oldFilter =
                            model.filter

                        newFilter =
                            { oldFilter | lastUpdate = date }
                    in
                        ( { model | filter = newFilter }
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
        ( { model
            | people = nextModel
            , audit = Loading
          }
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
        , viewFilter model
        , br [] []
        , Badge.badge []
            [ Button.button
                [ Button.primary
                , Button.attrs
                    [ onClick (FetchPeople) ]
                ]
                [ text "reload" ]
            ]
        , viewAudit model
        , ListView.custom viewPerson
            model.people
        ]


viewFilter : Model -> Html Msg
viewFilter model =
    Form.label []
        [ text "filters"
        , Checkbox.checkbox
            [ Checkbox.checked True
            , Checkbox.onCheck (FilterMsg << Loaded)
            ]
            "loaded"
        , Input.text
            [ Input.id "lastUpdate:"
            , Input.small
            , Input.defaultValue "2017/04/01T08:23:2324Z"
            , Input.onInput (FilterMsg << LastUpdate)
            ]
        ]


viewAudit : Model -> Html Msg
viewAudit model =
    Card.config [ Card.outlineInfo ]
        |> Card.headerH1 [] [ text "Audit Info" ]
        |> Card.footer [] [ text "End" ]
        |> Card.block []
            [ Card.titleH1 [] [ text "Block title" ]
            , Card.text []
                [ text "Total : "
                , WebDataView.simple (\audit -> text <| toString audit.total) model.audit
                ]
            , Card.link [ href "#" ] [ text "MyLink" ]
            ]
        |> Card.view


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
                ]
                    ++ (List.map
                            (\item ->
                                Dropdown.buttonItem
                                    [ onClick (DropClick item.datasource item.itemName) ]
                                    [ text <| item.name ]
                            )
                            model.items
                       )
                    ++ [ Dropdown.divider
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
