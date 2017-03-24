module Pages.Ops exposing (..)

import Bootstrap.Button as Button
import Bootstrap.Dropdown as Dropdown
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

-- .. etc

main : Program Never Model Msg
main = program {init=init, view=view, update=update, subscriptions=subscriptions}

-- Model
type alias Model =
    { myDrop1State : Dropdown.State
    , myDrop2State : Dropdown.State
    }

-- Msg
type Msg
    = MyDrop1Msg Dropdown.State
    | MyDrop2Msg Dropdown.State

-- init
init : (Model, Cmd Msg )
init =
    ( { myDrop1State = Dropdown.initialState
      , myDrop2State = Dropdown.initialState
      }
    , Cmd.none
    )

-- update
update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        MyDrop1Msg state ->
            ( { model | myDrop1State = state }
            , Cmd.none
            )

        MyDrop2Msg state ->
            ( { model | myDrop2State = state }
            , Cmd.none
            )

        -- ... and cases for the drop down actions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Dropdown.subscriptions model.myDrop1State MyDrop1Msg
        , Dropdown.subscriptions model.myDrop2State MyDrop2Msg
        ]


view : Model -> Html Msg
view model =
    div []
        [ Dropdown.dropdown
            model.myDrop1State
            { options = [ ]
            , toggleMsg = MyDrop1Msg
            , toggleButton =
                Dropdown.toggle [ ] [ text "MyDropdown1" ]
            , items =
                [ Dropdown.buttonItem [ onClick <| MyDrop1Msg model.myDrop1State] [ text "Item 1" ]
                , Dropdown.buttonItem [ onClick <| MyDrop2Msg model.myDrop2State] [ text "Item 2" ]
                , Dropdown.divider
                , Dropdown.header [ text "Silly items" ]
                , Dropdown.buttonItem [ class "disabled" ] [ text "DoNothing1" ]
                , Dropdown.buttonItem [] [ text "DoNothing2" ]
                ]
            }

        -- etc
        ]
