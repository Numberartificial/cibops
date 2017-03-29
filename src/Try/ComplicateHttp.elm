module Try.ComplicateHttp exposing (main)

import Html.Events exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import RemoteData exposing (RemoteData(..), WebData)
import RemoteData.Http as Http
import Types exposing (Person, People)
import Decoders


main =
    html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }


cib =
    "http://168.35.6.12:8099"


cib_aic =
    cib ++ "/aic/api"


cib_aic_people =
    cib_aic ++ "/people"


req_simple =
    Http.getWithConfig Http.defaultConfig cib_aic_people HandlePeople Decoders.decodePeople


{-| Store the data as a 'WebData a' type in Model
-}
type alias Model =
    { people : WebData People
    }


{-| Add a message with 'WebData a' parameter
-}
type Msg
    = HandlePeople (WebData People)
    | GetPeople


{-| initial for this elm
-}
init : ( Model, Cmd Msg )
init =
    ( { people = NotAsked }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HandlePeople data ->
            ( { model | people = data }
            , Cmd.none
            )

        GetPeople ->
            ( { model | people = Loading }
            , Http.getWithConfig Http.defaultConfig cib_aic_people HandlePeople Decoders.decodePeople
            )


view : Model -> Html Msg
view model =
    case model.people of
        Loading ->
            text "Loding~"

        Success people ->
            text ("Recieved:" ++ toString people)

        Failure error ->
            text ("error:" ++ toString error)

        NotAsked ->
            button [ onClick GetPeople ] [ text "Get People info" ]



-- Http.get << Http.url cib_aic_people [("page", "0"), ("size", "200")]
