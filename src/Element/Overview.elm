module Element.Overview exposing (..)

import Route exposing (Route(..))
import Context
import Data.Series as Series exposing (Series)

import Html exposing (..)
import Html.Attributes as Html exposing (..)
import Html.Events as Html exposing (..)


-- Overview - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Overview =
   { init : Context.Model -> ( Model, Cmd Msg )
   , view : Model -> Html Msg
   , update : Msg -> Model -> ( Model, Cmd Msg )
   , subscriptions : Model -> Sub Msg
   }


-- Model - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Model = Context.Model


-- Msg - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type Msg = ContextChanged (Context.Model)


-- init - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


init : Context.Model -> ( Model, Cmd Msg )
init context = ( context, Cmd.none )


-- view - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


view : Model -> Html Msg
view model =
   let
      seriesId = Route.toSeriesId (model.route)
      --
      linkClass = if (String.isEmpty seriesId)
         then "Overview Link Current"
         else "Overview Link"
      --
      topicUrl = "/" ++ Route.toTopicId (model.route)
   in
      nav [ class "Overview Base" ] (List.append
         [ a [ class (linkClass), href (topicUrl) ] [ text "Overview" ] ]
         (List.map (ovrLink model.route) (model.seriesList))
      ) -- nav.Overview.Base

--
ovrLink : Route -> Series -> Html Msg
ovrLink route series =
   let
      currentId = Route.toSeriesId (route)
      --
      linkClass = case (compare (series.id) (currentId)) of
         EQ -> "Overview Link Current"
         _  -> "Overview Link"
      --
      seriesUrl = (Route.toTopicUrl route) ++ "/" ++ series.id
   in
      a [ class (linkClass), href (seriesUrl) ] [ text (series.title) ]


-- update - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case (msg) of
   --
   ContextChanged newCtx -> init (newCtx)


-- subscriptions - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none


