module Data.Series exposing (..)

import Json.Decode as Json exposing (Decoder, field, string, list)


-- Series - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Series =
   { id : String
   , title : String
   , keywords : List String
   , description : String
   }


-- empty - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


empty =
   { id = ""
   , title = ""
   , keywords = []
   , description = ""
   }


-- jsonDecoder - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


jsonDecoder : Decoder Series
jsonDecoder = Json.map4 Series
   ( field "id" string )
   ( field "title" string )
   ( field "keywords" (list string) )
   ( field "description" string )


-- matchId - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


matchId : String -> Series -> Bool
matchId id series =
   case ( compare (id) (series.id) ) of
      EQ -> True
      _  -> False


