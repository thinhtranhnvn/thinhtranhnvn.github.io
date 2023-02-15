module Data.Post exposing (..)

import Json.Decode as Json exposing (Decoder, field, string, list)


-- Post - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Post =
   { slug : String
   , title : String
   , keywords : List String
   , description : String
   , content : String
   }


-- jsonDecoder - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


jsonDecoder : Decoder Post
jsonDecoder = Json.map5 Post
   ( field "slug" string )
   ( field "title" string )
   ( field "keywords" (list string) )
   ( field "description" string )
   ( field "content" string )


