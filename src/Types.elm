module Types exposing (..)

import Dict exposing (Dict)
import Date exposing (Date)
import Time exposing (Time)


type alias Translations =
    Dict String String


type alias Taco =
    { currentTime : Time
    , translations : Translations
    }

type alias Person =
    { name : String
    }
type alias People =
    {
      content : List Person 
    , totalElements : Int
    }

type alias Commit =
    { userName : String
    , sha : String
    , date : Date
    , message : String
    }


type alias Stargazer =
    { login : String
    , avatarUrl : String
    , url : String
    }


type TacoUpdate
    = NoUpdate
    | UpdateTime Time
    | UpdateTranslations Translations


type Language
    = English
    | Finnish
    | FinnishFormal
