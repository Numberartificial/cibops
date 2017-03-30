module Pages.CibFetch exposing(..)

import Views.WebListView as Wlv

-- MODEL


type alias Model a =
    { lists : List (Wlv.Model a)}

