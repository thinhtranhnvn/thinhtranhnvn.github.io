module Data.Topic exposing (..)

import Json.Decode as Json exposing (Decoder, field, string, list)


-- Topic - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Topic =
   { id : String
   , title : String
   , keywords : List String
   , description : String
   }


-- empty - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


empty : Topic
empty =
   { id = ""
   , title = ""
   , keywords = []
   , description = ""
   }


-- default - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


default : Topic
default =
   { id = "origin"
   , title = "Origin"
   , keywords = [ "Semi Dev_", "Blog", "Origin", "Buddhism", "Yoga", "Code", "General Computing" ]
   , description = "Semi Dev_ 's Blog - sharing knowledge of Buddhism, Yoga, Coding, Languist, and General Computing"
   }


-- jsonDecoder - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


jsonDecoder : Decoder Topic
jsonDecoder = Json.map4 Topic
   ( field "id" string )
   ( field "title" string )
   ( field "keywords" (list string) )
   ( field "description" string )


-- matchId - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


matchId : String -> Topic -> Bool
matchId id topic =
   case ( compare (id) (topic.id) ) of
      EQ -> True
      _  -> False


