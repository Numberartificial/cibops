-- Read more about this program in the official Elm guide:
-- https://guide.elm-lang.org/architecture/effects/random.html

import Html exposing (..)
import Html.Events exposing (..)
import Random
import RemoteData exposing (RemoteData(..), WebData)



main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { dieFace : Int
  , people : WebData (String)
  }


init : (Model, Cmd Msg)
init =
  ( {dieFace = 1, people = Loading }, Cmd.none)



-- UPDATE


type Msg
  = Roll
  | NewFace Int


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      (model, Random.generate NewFace (Random.int 1 6))

    NewFace newFace ->
      ( Model newFace Loading, Cmd.none)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h1 [] [ text (toString model.dieFace) ]
    , button [ onClick Roll ] [ text "Roll" ]
    ]
