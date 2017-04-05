module Routing.Router exposing (..)

import Bootstrap.Button as Button
import Html exposing (..)
import Html.Attributes exposing (href)
import Html.Events exposing (..)
import I18n
import Navigation exposing (Location)
import Pages.CibFetch as Cib
import Pages.Ops as Ops
import Pages.Home as Home
import Pages.Settings as Settings
import Routing.Helpers exposing (Route(..), parseLocation, reverseRoute)
import Styles exposing (..)
import Types exposing (TacoUpdate(..), Taco, Translations)
import Material
import Material.Layout as Layout

import Material.Scheme as Scheme
import Material.Color as Color

type alias Model =
    { cibModel : Cib.Model
    , opsModel : Ops.Model
    , homeModel : Home.Model
    , settingsModel : Settings.Model
    , route : Route
    , mdl : Material.Model
    }


type Msg
    = UrlChange Location
    | NavigateTo Route
    | CibMsg Cib.Msg
    | OpsMsg Ops.Msg
    | HomeMsg Home.Msg
    | SettingsMsg Settings.Msg
    | Mdl (Material.Msg Msg)


init : Location -> ( Model, Cmd Msg )
init location =
    let
        ( cibModel, cibCmd ) =
            Cib.init

        ( homeModel, homeCmd ) =
            Home.init

        ( opsModel, opsCmd ) =
            Ops.init

        settingsModel =
            Settings.initModel
    in
        ( { cibModel = cibModel
          , homeModel = homeModel
          , opsModel = opsModel
          , settingsModel = settingsModel
          , route = parseLocation location
          , mdl = Material.model
          }
        , Cmd.batch
            [ Cmd.map HomeMsg homeCmd
            , Cmd.map OpsMsg opsCmd
            , Cmd.map CibMsg cibCmd
            , Layout.sub0 Mdl
            ]
        )


update : Msg -> Model -> ( Model, Cmd Msg, TacoUpdate )
update msg model =
    case msg of
        UrlChange location ->
            ( { model | route = parseLocation location }
            , Cmd.none
            , NoUpdate
            )

        NavigateTo route ->
            ( model
            , Navigation.newUrl (reverseRoute route)
            , NoUpdate
            )

        HomeMsg homeMsg ->
            updateHome model homeMsg

        SettingsMsg settingsMsg ->
            updateSettings model settingsMsg

        OpsMsg msg ->
            updateOps msg model

        CibMsg msg ->
            updateCib msg model

        Mdl message_ ->
            let ( nmodel, ncmd) =
                    Material.update Mdl message_ model
             in
                 (nmodel, ncmd, NoUpdate)

updateHome : Model -> Home.Msg -> ( Model, Cmd Msg, TacoUpdate )
updateHome model homeMsg =
    let
        ( nextHomeModel, homeCmd ) =
            Home.update homeMsg model.homeModel
    in
        ( { model | homeModel = nextHomeModel }
        , Cmd.map HomeMsg homeCmd
        , NoUpdate
        )


updateOps : Ops.Msg -> Model -> ( Model, Cmd Msg, TacoUpdate )
updateOps msg model =
    let
        ( nextModel, cmd ) =
            Ops.update msg model.opsModel
    in
        ( { model | opsModel = nextModel }
        , Cmd.map OpsMsg cmd
        , NoUpdate
        )


updateCib : Cib.Msg -> Model -> ( Model, Cmd Msg, TacoUpdate )
updateCib msg model =
    let
        ( nextModel, cmd ) =
            Cib.update msg model.cibModel
    in
        ( { model | cibModel = nextModel }
        , Cmd.map CibMsg cmd
        , NoUpdate
        )


updateSettings : Model -> Settings.Msg -> ( Model, Cmd Msg, TacoUpdate )
updateSettings model settingsMsg =
    let
        ( nextSettingsModel, settingsCmd, tacoUpdate ) =
            Settings.update settingsMsg model.settingsModel
    in
        ( { model | settingsModel = nextSettingsModel }
        , Cmd.map SettingsMsg settingsCmd
        , tacoUpdate
        )


viewMaterial : Taco -> Model -> Html Msg
viewMaterial taco model =
   Scheme.topWithScheme Color.BlueGrey Color.DeepOrange
    (Layout.render Mdl
        model.mdl
        [
          -- Layout.selectedTab model.selectedTab
        -- , Layout.onSelectTab SelectTab
         Layout.fixedHeader
        ]
        { header = []
        , drawer = []
        , tabs = ( [ text "tab1" ], [] )
        , main = [ view1 taco model ]
        }
    )

view = viewMaterial



view1 : Taco -> Model -> Html Msg
view1 taco model =
    let
        buttonStyles route =
            if model.route == route then
                styles navigationButtonActive
            else
                styles navigationButton

        translate =
            I18n.get taco.translations
    in
        div [ styles (appStyles ++ wrapper) ]
            [ header [ styles headerSection ]
                [ h1 [] [ text (translate "site-title") ]
                ]
            , nav [ styles navigationBar ]
                [ button
                    [ onClick (NavigateTo HomeRoute)
                    , buttonStyles HomeRoute
                    ]
                    [ text (translate "page-title-home") ]
                , button
                    [ onClick (NavigateTo SettingsRoute)
                    , buttonStyles SettingsRoute
                    ]
                    [ text (translate "page-title-settings") ]
                , Button.button
                    [ Button.primary
                    , Button.attrs
                        [ onClick (NavigateTo OpsRoute)
                        , buttonStyles SettingsRoute
                        ]
                    ]
                    [ text "数据统计" ]
                , Button.button
                    [ Button.primary
                    , Button.attrs
                        [ onClick (NavigateTo CibRoute)
                        , buttonStyles SettingsRoute
                        ]
                    ]
                    [ text "Cib Fetch" ]
                ]
            , pageView taco model
            , footer [ styles footerSection ]
                [ text "Project homepage is : "
                , a
                    [ href "https://github.com/Numberartificial/cibops"
                    , styles footerLink
                    ]
                    [ text "Github" ]
                , text (translate "footer-github-after")
                ]
            ]


pageView : Taco -> Model -> Html Msg
pageView taco model =
    div [ styles activeView ]
        [ (case model.route of
            HomeRoute ->
                Home.view taco model.homeModel
                    |> Html.map HomeMsg

            SettingsRoute ->
                Settings.view taco model.settingsModel
                    |> Html.map SettingsMsg

            OpsRoute ->
                Ops.view taco model.opsModel
                    |> Html.map OpsMsg

            CibRoute ->
                Cib.view model.cibModel
                    |> Html.map CibMsg

            NotFoundRoute ->
                h1 [] [ text "404 :(" ]
          )
        ]



--SUBSCRIPTTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map CibMsg (Cib.sub model.cibModel)
        -- , Layout.subscriptions model.mdl
        -- , .mdl >> Layout.subs Mdl
        , Layout.subs Mdl model.mdl
        ]
