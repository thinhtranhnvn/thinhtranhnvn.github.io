module Data.Post exposing ( Post, empty )


-- Post - - - - - - - - -


type alias Post =
   { slug : String
   , title : String
   , keywords : List String
   , description : String
   , content : String
   }


-- empty - - - - - - - - -


empty : Post
empty =
   { slug = "empty"
   , title = "Empty"
   , keywords = ["empty"]
   , description = "Empty"
   , content = "Empty"
   }


