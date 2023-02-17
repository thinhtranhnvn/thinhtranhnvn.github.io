module Element.Metadata exposing (..)

import Route exposing (Route(..))
--
import Data.Topic as Topic exposing (Topic)
import Data.Series as Series exposing (Series)
import Data.Post as Post exposing (Post)

import Browser exposing (Document, UrlRequest)
import Http
import Json.Decode as Json exposing (..)
import Html exposing (..)
import Html.Attributes as Html exposing (..)
import Html.Events as Html exposing (..)

import Extension.Http.Error as HttpError


-- main - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


main : Program String Model Msg
main =
   let
      mtd = Metadata (init) (view) (update) (subscriptions)
   in
      Browser.element (mtd)


-- Indexer - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Metadata =
   { init : String -> ( Model, Cmd Msg )
   , view : Model -> Html Msg
   , update : Msg -> Model -> ( Model, Cmd Msg )
   , subscriptions : Model -> Sub Msg
   }


-- Model - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Model =
   { route : Route
     --
   , topic : Topic
   , series : Series
   , post : Post
   }


-- Msg - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type Msg = UrlChanged String
           --
         | GotTopicListResponse (Result (Http.Error) (List Topic))
         | GotSeriesListResponse (Result (Http.Error) (List Series))
         | GotPostListResponse (Result (Http.Error) (List Post))


-- init - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


init : String -> ( Model, Cmd Msg )
init urlStr =
   let
      model =
         { route = Route.fromUrlString (urlStr)
           --
         , topic = Topic.empty
         , series = Series.empty
         , post = Post.empty
         }
      cmd = Cmd.batch [ getTopicList
                      , getSeriesList (model.route)
                      , getPostList (model.route)
                      ]
   --
   in
      ( model, cmd )

--
getTopicList : Cmd Msg
getTopicList =
   Http.get { url = Route.toTopicListFileUrl ()
            , expect = Http.expectJson (GotTopicListResponse) (Json.list Topic.jsonDecoder)
            }

--
getSeriesList : Route -> Cmd Msg
getSeriesList route =
   Http.get { url = Route.toSeriesListFileUrl (route)
            , expect = Http.expectJson (GotSeriesListResponse) (Json.list Series.jsonDecoder)
            }

--
getPostList : Route -> Cmd Msg
getPostList route =
   Http.get { url = Route.toPostListFileUrl (route)
            , expect = Http.expectJson (GotPostListResponse) (Json.list Post.jsonDecoder)
            }


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
   UrlChanged newUrlStr -> init (newUrlStr)
      
   --
   GotTopicListResponse res -> case (res) of
      --
      (Err error) ->
         let
            emptyTopic = Topic.empty
            errorTopic = { emptyTopic | title = HttpError.toString (error) }
            updatedModel = { model | topic = errorTopic }
         in
            ( updatedModel, Cmd.none )
      --
      (Ok topicList) ->
         let
            topicId = Route.toTopicId (model.route)
            matchedList = List.filter (Topic.matchId topicId) (topicList)
            matchedTopic = case (matchedList) of
               first::restList -> first
               _ -> Topic.default
            --
            updatedModel = { model | topic = matchedTopic }
         in
            ( updatedModel, Cmd.none )
   
   --
   GotSeriesListResponse res -> case (res) of
      --
      (Err error) ->
         let 
            emptySeries = Series.empty
            errorSeries = { emptySeries | title = HttpError.toString (error) }
            --
            updatedModel = { model | series = errorSeries } 
         in
            ( updatedModel, Cmd.none )
      --
      (Ok seriesList) ->
         let
            seriesId = Route.toSeriesId (model.route)
            matchedList = List.filter (Series.matchId seriesId) (seriesList)
            matchedSeries = case (matchedList) of
               first::restList -> first
               _ -> Series.empty
            --
            updatedModel = { model | series = matchedSeries }
         in
            ( updatedModel, Cmd.none )
   
   --
   GotPostListResponse res -> case (res) of
      --
      (Err error) ->
         let
            emptyPost = Post.empty
            errorPost = { emptyPost | title = HttpError.toString (error) }
            updatedModel = { model | post = errorPost }
         in
            ( updatedModel, Cmd.none )
      --
      (Ok postList) ->
         let
            postSlug = Route.toPostSlug (model.route)
            matchedList = List.filter (Post.matchSlug postSlug) (postList)
            matchedPost = case (matchedList) of
               first::restList -> first
               _ -> Post.empty
            --
            updatedModel = { model | post = matchedPost }
         in
            ( updatedModel, Cmd.none )


-- subscriptions - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none


