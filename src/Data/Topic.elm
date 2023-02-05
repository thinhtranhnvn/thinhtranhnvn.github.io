module Data.Topic exposing ( Topic, empty )


-- Topic - - - - - - - - -


type alias Topic =
   { id : String
   , title : String
   , keywords : List String
   , description : String
   , overview : String
   }


-- empty - - - - - - - - -


empty : Topic
empty =
   { id = "empty"
   , title = "Empty"
   , keywords = ["empty"]
   , description = "Empty"
   , overview = "Empty"
   }


