module Extension.Json.Decode exposing ( topic, series, post )

import Json.Decode as Json exposing ( Decoder, field, string, list )

import Data.Post as Post exposing ( Post )
import Data.Series as Series exposing ( Series )
import Data.Topic as Topic exposing ( Topic )


-- post - - - - - - - - - - - - - - - - - -


post : Decoder Post
post = Json.map5 Post
   ( field "slug" string )
   ( field "title" string )
   ( field "keywords" (list string) )
   ( field "description" string )
   ( field "content" string )


-- series - - - - - - - - - - - - - - - - - -


series : Decoder Series
series = Json.map4 Series
   ( field "id" string )
   ( field "title" string )
   ( field "keywords" (list string) )
   ( field "description" string )


-- topic - - - - - - - - - - - - - - - - - -


topic : Decoder Topic
topic = Json.map5 Topic
   ( field "id" string )
   ( field "title" string )
   ( field "keywords" (list string) )
   ( field "description" string )
   ( field "overview" string )


