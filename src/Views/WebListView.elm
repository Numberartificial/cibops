module Views.WebListView exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http


import Bootstrap.Card as Card
import Bootstrap.ListGroup as ListGroup
import RemoteData exposing (WebData, RemoteData(..))
import RemoteData.Http exposing (..)

import Views.WebDataView exposing (..)
import Effects.Web exposing (..)

--Model


type alias Model a =
    { list : WebList a
    }


type alias WebList a =
    WebData (List a)


--View

custom : (a -> Html msg) -> Model a -> Html msg
custom vi model =
    div []
        [ simple (viewList vi) model.list ]

view : Model a -> Html msg
view model =
    div []
        [ simple (viewList viewItem) model.list ]


viewList : (a -> Html msg) -> List a -> Html msg
viewList vi list =
    div []
        [ List.map
            (\a ->
                ListGroup.anchor
                    [ ListGroup.attrs []
                    , ListGroup.info
                    ]
                    [ vi a ]
            )
            list
            |> ListGroup.custom
        ]


viewItem : a -> Html msg
viewItem a =
    Card.config [ Card.outlineInfo ]
        |> Card.headerH1 [] [ text "My Card Info" ]
        |> Card.footer [] [ text "Some footer" ]
        |> Card.block []
            [ Card.titleH1 [] [ text "Block title" ]
            , Card.text [] [ text "Some block content" ]
            , Card.link [ href "#" ] [ text "MyLink" ]
            ]
        |> Card.view



--Update


type Msg a
    = Fetch
      | FetchMsg (WebData (List a))
    -- | FetchMsg (Result Http.Error (List a))


update : Cmd (Msg a) -> Msg a -> Model a -> ( Model a, Cmd (Msg a) )
update fetchCmd msg model =
    case msg of
        Fetch ->
            ( { model | list = Loading }, fetchCmd )

        FetchMsg webData ->
            ( { model | list = webData}, Cmd.none )


-- INIT


init : ( Model a, Cmd (Msg a) )
init =
    ( { list = NotAsked }
    , Cmd.none
    )

mapWebData : ( a -> b ) -> WebData a -> WebData b
mapWebData f webData =
    case webData of
        Success a -> Success (f a)
        Failure error -> Failure error
        NotAsked -> NotAsked
        Loading -> Loading

fetch : Cmd (Msg Person)
fetch =
    get "168.35.6.12:8099/aic/api/people"
        (
        (\wedata ->
           mapWebData
             (\people -> people.content) wedata
            |> FetchMsg)
        )
        decodePeople


-- MAIN


main : Program Never (Model Person) (Msg Person)
main =
    Html.program
        { init = init
        , view = view
        , update = update fetch
        , subscriptions = (always Sub.none)
        }
