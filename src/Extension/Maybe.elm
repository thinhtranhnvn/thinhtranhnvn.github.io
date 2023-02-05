module Extension.Maybe exposing ( map, apply, bind )

import Class


instanceMonad : Class.Monad (Maybe a) a (Maybe b) (Maybe (a -> b)) a b
instanceMonad = Class.Monad bind apply map


-- map - - - - - - - - - - - - - - - - - - - - - - - - - - -

map : (a -> b) -> Maybe a -> Maybe b
map = Maybe.map


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


