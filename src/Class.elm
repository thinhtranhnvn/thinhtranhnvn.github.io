module Class exposing (..)

import Browser exposing ( Document, UrlRequest )
import Browser.Navigation as Navigation exposing ( Key )
import Url exposing ( Url )
import Html exposing ( Html )


-- Element - - - - - - - - - - - - - - - - - - - - - - - - - - -

type alias Element flags model msg =
   { init : flags -> ( model, Cmd msg )
   , view : model -> Html msg
   , update : msg -> model -> ( model, Cmd msg )
   , subscriptions : model -> Sub msg
   }


-- Functor - - - - - - - - - - - - - - - - - - - - - - - - - - -

type alias Functor a b c d =
   { map : ( a -> b ) -> c -> d }


-- Applicative - - - - - - - - - - - - - - - - - - - - - - - - - - -

type alias Applicative a b c d e =
   { apply : a -> b -> c
   , map : ( d -> e ) -> b -> c
   }


-- Monad - - - - - - - - - - - - - - - - - - - - - - - - - - -

type alias Monad a b c d e x y =
   { bind : a -> ( b -> c ) -> d
   , apply : e -> a -> c
   , map : ( x -> y ) -> a -> c
   }


-- Monoid - - - - - - - - - - - - - - - - - - - - - - - - - - -

type alias Monoid a =
   { append : a -> a -> a
   , empty : a
   , concat : List a -> a
   }


