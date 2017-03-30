module Views.WebListView exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Bootstrap.Card as Card
import Bootstrap.ListGroup as ListGroup
import RemoteData exposing (WebData, RemoteData(..))
import Views.WebDataView exposing (..)
import Effects.Web exposing (fetchCmd)
import Types exposing (People, Person)


--Model


type alias Model a =
    { list : WebList a
    }


type alias WebList a =
    WebData (List a)



--View


view : Model a -> Html (Msg a)
view model =
    div []
        [ simple viewList model.list ]


viewList : List a -> Html (Msg a)
viewList list =
    div []
        [ List.map
            (\a ->
                ListGroup.anchor
                    [ ListGroup.attrs []
                    , ListGroup.info
                    ]
                    [ viewItem a ]
            )
            list
            |> ListGroup.custom
        ]


viewItem : a -> Html (Msg a)
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
    | FetchMsg (Result Http.Error (List a))


update : Cmd (Msg a) -> Msg a -> Model a -> ( Model a, Cmd (Msg a) )
update fetchCmd msg model =
    case msg of
        Fetch ->
            ( { model | list = Loading }, fetchCmd )

        FetchMsg (Ok res) ->
            ( { model | list = Success res }, Cmd.none )

        FetchMsg (Err error) ->
            ( { model
                | list = Failure error
              }
            , Cmd.none
            )



-- INIT


init : ( Model a, Cmd (Msg a) )
init =
    ( { list = NotAsked }
    , Cmd.none
    )


fetch : Cmd (Msg Person)
fetch =
    ((Result.map
        (\result ->
            result.content
        )
        >> FetchMsg
     )
        |> fetchCmd
    )



-- MAIN


main : Program Never (Model Person) (Msg Person)
main =
    Html.program
        { init = init
        , view = view
        , update = update fetch
        , subscriptions = (always Sub.none)
        }
