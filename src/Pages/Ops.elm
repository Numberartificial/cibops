module Pages.Ops exposing (..)

import Date exposing (Date)
import RemoteData exposing (RemoteData(..), WebData)
import I18n
import RemoteData.Http as Http
import Html exposing (..)
import Html.Attributes exposing (href, src)
import Html.Events exposing (..)
import Json.Decode exposing (..)

import Styles exposing (..)
import Types exposing (TacoUpdate(..), Taco, Person, People, Commit, Stargazer)
import Decoders
import Bootstrap.Button as Button

type alias Model =
    { commits : WebData (List Commit)
    , stargazers : WebData (List Stargazer)
    , people : WebData (People)
    }


type Msg
    = HandleCommits (WebData (List Commit))
    | HandleStargazers (WebData (List Stargazer))
    | HandlePeople (WebData (People))
    | ReloadData


init : ( Model, Cmd Msg )
init =
    ( { commits = Loading
      , stargazers = Loading
      , people = Loading
      }
    , fetchData
    )


fetchData : Cmd Msg
fetchData =
    Cmd.batch
        [ fetchCommits
        , fetchStargazers
        , fetchPeople
        ]

get : String -> (WebData success -> Msg) -> Json.Decode.Decoder success -> Cmd Msg
get =
    Http.getWithConfig Http.defaultConfig

        

fetchCommits : Cmd Msg
fetchCommits =
    get "https://api.github.com/repos/Numberartificial/cibops/commits"
        HandleCommits
        Decoders.decodeCommitList


fetchStargazers : Cmd Msg
fetchStargazers =
    get "https://api.github.com/repos/Numberartificial/cibops/stargazers"
        HandleStargazers
        Decoders.decodeStargazerList

fetchPeople : Cmd Msg
fetchPeople =
    get "http://168.35.6.12:8099/aic/api/people"

    -- get "http://localhost:8099/aic/api/people"
        HandlePeople
        Decoders.decodePeople


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReloadData ->
            ( { model
                | people = Loading
                , commits = Loading
                , stargazers = Loading
              }
            , fetchData
            )

        HandleCommits webData ->
            ( { model | commits = webData }
            , Cmd.none
            )

        HandleStargazers webData ->
            ( { model | stargazers = webData }
            , Cmd.none
            )

        HandlePeople webData ->
            ( { model | people = webData }
            , Cmd.none
            )


view : Taco -> Model -> Html Msg
view taco model =
    div []
        [
         Button.button [ Button.primary ] [ text "bootstrap" ]
        , Button.button [ Button.attrs [ styles actionButton, onClick ReloadData], Button.info ] [ text "info" ]
        , a
            [ styles appStyles
            , href "https://github.com/Numberartificial/cibops/"
            ]
            [ h2 [] [ text "Numberartificial/cibops" ] ]
        , div []
            [ button
                [ onClick ReloadData
                , styles actionButton
                ]
                [ text ("↻ " ++ I18n.get taco.translations "commits-refresh") ]
            ]
        , div [ styles (flexContainer ++ gutterTop) ]
            [ div [ styles (flex2 ++ gutterRight) ]
                [ h3 [] [ text "loaded people" ]
                , viewPeople taco model
                ]
            , div [ styles (flex2 ++ gutterRight) ]
                [ h3 [] [ text (I18n.get taco.translations "commits-heading") ]
                , viewCommits taco model
                ]
            , div [ styles flex1 ]
                [ h3 [] [ text (I18n.get taco.translations "stargazers-heading") ]
                , viewStargazers taco model
                ]
            ]
        ]


viewCommits : Taco -> Model -> Html Msg
viewCommits taco model =
    case model.commits of
        Loading ->
            text (I18n.get taco.translations "status-loading")

        Failure _ ->
            text (I18n.get taco.translations "status-network-error")

        Success commits ->
            commits
                |> List.sortBy (\commit -> -(Date.toTime commit.date))
                |> List.map (viewCommit taco)
                |> ul [ styles commitList ]

        _ ->
            text ""


viewCommit : Taco -> Commit -> Html Msg
viewCommit taco commit =
    li [ styles card ]
        [ h4 [] [ text commit.userName ]
        , em [] [ text (formatTimestamp taco commit.date) ]
        , p [] [ text commit.message ]
        ]

viewPeople : Taco -> Model -> Html Msg
viewPeople taco model =
    case model.people of
        Loading ->
            text "加载中"

        Failure _ ->
            text "加载失败"

        Success people ->
            people.content
                |> List.map (viewPerson taco)
                |> ul [styles commitList]

        _ ->
            text ""

viewPerson : Taco -> Person -> Html Msg
viewPerson taco person =
   li [ styles card ]
    [ h4 [] [ text person.name ]
    ]

formatTimestamp : Taco -> Date -> String
formatTimestamp taco date =
    let
        timeDiff =
            taco.currentTime - Date.toTime date

        minutes =
            floor (timeDiff / 1000 / 60)

        seconds =
            floor (timeDiff / 1000) % 60

        translate =
            I18n.get taco.translations
    in
        case minutes of
            0 ->
                translate "timeformat-zero-minutes"

            1 ->
                translate "timeformat-one-minute-ago"

            n ->
                translate "timeformat-n-minutes-ago-before"
                    ++ " "
                    ++ toString n
                    ++ " "
                    ++ translate "timeformat-n-minutes-ago-after"
                    ++ " (+"
                    ++ toString seconds
                    ++ "s)"


viewStargazers : Taco -> Model -> Html Msg
viewStargazers taco model =
    case model.stargazers of
        Loading ->
            text (I18n.get taco.translations "status-loading")

        Failure _ ->
            text (I18n.get taco.translations "status-network-error")

        Success stargazers ->
            stargazers
                |> List.reverse
                |> List.map viewStargazer
                |> ul [ styles commitList ]

        _ ->
            text ""


viewStargazer : Stargazer -> Html Msg
viewStargazer stargazer =
    li [ styles (card ++ flexContainer) 
        [ img
            [ styles avatarPicture
            , src stargazer.avatarUrl
            ]
            []
        , a
            [ styles stargazerName
            , href stargazer.url
            ]
            [ text stargazer.login ]
        ]
