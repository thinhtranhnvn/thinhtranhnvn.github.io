module Extension.Maybe exposing ( map, apply, bind )


-- map - - - - - - - - - - - - - - - - - - - - - - - - - - -

map : (a -> b) -> Maybe a -> Maybe b
map = map func maybe =
   case maybe of
      Nothing  -> Nothing
      Just any -> Just (func any)


-- apply - - - - - - - - - - - - - - - - - - - - - - - - - - -

apply : Maybe (a -> b) -> Maybe a -> Maybe b
apply maybeFunc maybeAny =
   case maybeFunc of
      Nothing   -> maybeAny
      Just func -> map func maybeAny


-- bind - - - - - - - - - - - - - - - - - - - - - - - - - - -

bind : Maybe a -> (a -> Maybe b) -> Maybe b
bind maybe func =
   case maybe of
      Nothing  -> Nothing
      Just any -> func any


