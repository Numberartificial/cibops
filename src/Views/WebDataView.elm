module Views.WebDataView exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import RemoteData exposing (WebData, RemoteData(..))


-- View


custom : Html msg -> Html msg -> Html msg -> (a -> Html msg) -> WebData a -> Html msg
custom notAsked loading failure success webData =
    case webData of
        NotAsked ->
            notAsked

        Loading ->
            loading

        Failure err ->
            failure

        Success res ->
            success res


simple : (a -> Html msg) -> WebData a -> Html msg
simple success webData =
    custom init load fail success webData


init : Html msg
init =
    text "未加载"


load : Html msg
load =
    text "加载中"


fail : Html msg
fail =
    text "加载失败"
