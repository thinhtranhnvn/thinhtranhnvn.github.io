module Element.Indexer exposing (..)

import Route exposing (Route(..))
import Context
import Data.Series as Series exposing (Series)
import Data.Post as Post exposing (Post)

import Html exposing (..)
import Html.Attributes as Attributes exposing (..)
import Html.Events as Events exposing (..)


-- Indexer - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Indexer =
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
      topicId = Route.toTopicId (model.route)
      seriesId = Route.toSeriesId (model.route)
      --
      series =
         let
            matchedList = List.filter (Series.matchId seriesId) (model.seriesList)
         in
            case (matchedList) of
               []              -> Series.empty
               first::restList -> first
   --
   in
      main_ [ class "Indexer Base" ] [
         div [ class "Indexer Container" ] [
            span [] [ text (topicId) ],
            
            header [ class "Indexer Intro" ] [
               h1 [] [ text (series.title) ],
               p [] [ text (series.description) ]
            ], -- header.Indexer.Intro
            
            nav [ class "Indexer Content" ] 
               (List.map (idxLink model.route) (model.postList))
         ] -- div.Indexer.Container
      ] -- main.Indexer.Base

--
idxLink : Route -> Post -> Html Msg
idxLink route post =
   let
      postUrl = (Route.toSeriesUrl route) ++ "/" ++ post.slug
   in
      a [ class "Indexer Link", href (postUrl) ] [ text (post.title) ]


-- update - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case (msg) of
   --
   ContextChanged newCtx -> init (newCtx)


-- subscriptions - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none


