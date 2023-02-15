module Extension.Http.Error exposing (..)
import Http exposing (Error(..))


-- toString - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


toString : Http.Error -> String
toString error = case (error) of
   BadUrl detail  -> detail 
   Timeout        -> "Timeout Request"
   NetworkError   -> "Network Error"
   BadStatus stt  -> "Bad Status: " ++ String.fromInt (stt)
   BadBody detail -> detail


