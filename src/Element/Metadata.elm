module Element.Metadata exposing (..)

import Route exposing (Route(..))
import Context
import Data.Topic as Topic exposing (Topic)
import Data.Series as Series exposing (Series)
import Data.Post as Post exposing (Post)

import Html exposing (..)
import Html.Attributes as Html exposing (..)
import Html.Events as Html exposing (..)


-- Indexer - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Metadata =
   { init : Context.Model -> ( Model, Cmd Msg )
   , view : Model -> Html Msg
   , update : Msg -> Model -> ( Model, Cmd Msg )
   , subscriptions : Model -> Sub Msg
   }


-- Model - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Model =
   { route : Route
     --
   , topic  : Topic
   , series : Series
   , post   : Post
   }


-- Msg - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type Msg = ContextChanged (Context.Model)


-- init - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


init : Context.Model -> ( Model, Cmd Msg )
init context =
   let
      model =
         { route = context.route
           --
         , topic  = getTopic (context)
         , series = getSeries (context)
         , post   = getPost (context)
         }
   in
      ( model, Cmd.none )


getTopic : Context.Model -> Topic
getTopic context =
   let
      topicId = Route.toTopicId (context.route)
      matchedList = List.filter (Topic.matchId topicId) (context.topicList)
   in
      case (matchedList) of
         first::restList -> first
         _               -> Topic.default


getSeries : Context.Model -> Series
getSeries context =
   let
      seriesId = Route.toSeriesId (context.route)
      matchedList = List.filter (Series.matchId seriesId) (context.seriesList)
   in
      case (matchedList) of
         first::restList -> first
         _               -> Series.empty


getPost : Context.Model -> Post
getPost context =
   let
      postSlug = Route.toPostSlug (context.route)
      matchedList = List.filter (Post.matchSlug postSlug) (context.postList)
   in
      case (matchedList) of
         first::restList -> first
         _               -> Post.empty


-- view - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


view : Model -> Html Msg
view model =
   let
      (title, keywords, description) = case (model.route) of
         --
         PostPage _ _ _ ->
            ( model.post.title
            , String.join "," (model.post.keywords)
            , model.post.description
            )
         --
         SeriesPage _ _ -> 
            ( model.series.title
            , String.join "," (model.series.keywords)
            , model.series.description
            )
         --
         _ -> ( model.topic.title
              , String.join  "," (model.topic.keywords)
              , model.topic.description
              )
   in
      node "meta-data"
         [ attribute "title" (title)
         , attribute "keywords" (keywords)
         , attribute "description" (description)
           --
         , attribute "style" "display: none"
         ] []


-- update - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case (msg) of
   --
   ContextChanged newCtx -> init (newCtx)


-- subscriptions - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none


