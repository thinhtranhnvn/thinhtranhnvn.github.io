module Data.Series exposing ( Series, empty, matchId )


-- Series - - - - - - - - - - - - - - - - - -


type alias Series =
   { id : String
   , title : String
   , keywords : List String
   , description : String
   }


-- empty - - - - - - - - - - - - - - - - - -


empty : Series
empty =
   { id = "empty"
   , title = "Empty"
   , keywords = []
   , description = "Empty"
   }


-- matchId - - - - - - - - - - - - - - - - - -


matchId : String -> Series -> Bool
matchId id series =
   case ( compare (id) (series.id) ) of
      EQ -> True
      _  -> False


