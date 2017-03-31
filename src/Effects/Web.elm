module Effects.Web exposing (..)

import Html exposing (..)
import Http
import Task exposing (Task)

import Json.Decode exposing (Decoder, field, at, string, int, float, dict)
import Json.Decode.Pipeline exposing (decode, required, requiredAt, optional)

import Types exposing (People, Person)
import Decoders exposing (decodePeople)
import RemoteData.Http exposing (..)


configPeople : Config
configPeople =
    { headers = []
    , withCredentials = False
    , timeout = Nothing
    }


type alias Person =
    { name : String
    }

type alias Corporation =
    { name : String
    }

type alias People =
    { page : Int
    , size : Int
    , content : List Person
    }


decodePerson : Decoder Person
decodePerson =
    decode Person
        |> required "name" string




decodePeople : Decoder People
decodePeople =
    decode People
        |> optional "page" int 0
        |> optional "size" int 20
        |> optional "content" (Json.Decode.list decodePerson) []


decodeCorporation : Decoder Corporation
decodeCorporation =
    decode Corporation
        |> required "name" string


type alias AuditList =
    { total : Int }
