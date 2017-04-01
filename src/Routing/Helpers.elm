module Routing.Helpers exposing (..)

import Navigation exposing (Location)
import UrlParser as Url exposing ((</>))


type Route
    = HomeRoute
    | SettingsRoute
    | OpsRoute
    | CibRoute
    | NotFoundRoute


reverseRoute : Route -> String
reverseRoute route =
    case route of
        SettingsRoute ->
            "#/settings"

        HomeRoute ->
            "#/"

        OpsRoute ->
            "#/ops"

        CibRoute ->
            "#/cib"

        _ ->
            "#/"


routeParser : Url.Parser (Route -> c) c
routeParser =
    Url.oneOf
        [ Url.map HomeRoute Url.top
        , Url.map SettingsRoute (Url.s "settings")
        , Url.map OpsRoute (Url.s "ops" )
        , Url.map CibRoute (Url.s "cib" )
        ]


parseLocation : Location -> Route
parseLocation location =
    location
        |> Url.parseHash routeParser
        |> Maybe.withDefault NotFoundRoute
