module Data.Topic exposing (..)

import Json.Decode as Json exposing (Decoder, field, string, list)


-- Topic - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Topic =
   { id : String
   , title : String
   , keywords : List String
   , description : String
   , overview : String
   }


-- empty - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


empty : Topic
empty =
   { id = ""
   , title = ""
   , keywords = []
   , description = ""
   , overview = ""
   }


-- jsonDecoder - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


jsonDecoder : Decoder Topic
jsonDecoder = Json.map5 Topic
   ( field "id" string )
   ( field "title" string )
   ( field "keywords" (list string) )
   ( field "description" string )
   ( field "overview" string )


