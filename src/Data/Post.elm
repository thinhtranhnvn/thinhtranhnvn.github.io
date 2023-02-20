module Data.Post exposing (..)

import Json.Decode as Json exposing (Decoder, field, string, list)


-- Post - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Post =
   { slug : String
   , title : String
   , keywords : List String
   , description : String
   }


-- empty - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


empty : Post
empty =
   { slug = ""
   , title = ""
   , keywords = []
   , description = ""
   }


-- jsonDecoder - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


jsonDecoder : Decoder Post
jsonDecoder = Json.map4 Post
   ( field "slug" string )
   ( field "title" string )
   ( field "keywords" (list string) )
   ( field "description" string )


-- matchSlug - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


matchSlug : String -> Post -> Bool
matchSlug slug post =
   case ( compare (slug) (post.slug) ) of
      EQ -> True
      _  -> False


