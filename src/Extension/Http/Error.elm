module Extension.Http.Error exposing ( toString )

import Http exposing (..)


-- toString - - - - - - - - - - - - - - - - - -

toString : Error -> String
toString error = case error of
   BadUrl msg -> msg
   Timeout -> "Timeout"
   NetworkError -> "Network Error"
   BadStatus value -> "Bad Status: " ++ (String.fromInt value)
   BadBody msg -> msg

