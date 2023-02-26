module Context exposing (..)

import Route exposing (Route(..))
import Data.Topic as Topic exposing (Topic)
import Data.Series as Series exposing (Series)
import Data.Post as Post exposing (Post)

import Browser
import Http exposing (Error)
import Json.Decode as Json
import Html exposing (..)

import Extension.Http.Error as HttpError


-- Context - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Context =
   { init : String -> ( Model, Cmd Msg )
   , view : Model -> Html Msg
   , update : Msg -> Model -> ( Model, Cmd Msg )
   , subscriptions : Model -> Sub Msg
   }


-- Model - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Model =
   { route : Route
     --
   , topicList  : List Topic
   , seriesList : List Series
   , postList   : List Post
   , markdown   : String
   }


-- Msg - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type Msg = UrlChanged String
           --
         | GotTopicListResponse (Result (Http.Error) (List Topic))
         | GotSeriesListResponse (Result (Http.Error) (List Series))
         | GotPostListResponse (Result (Http.Error) (List Post))
         | GotMarkdownResponse (Result (Http.Error) (String))


-- init - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


init : String -> ( Model, Cmd Msg )
init urlStr =
   let
      route = Route.fromUrlString (urlStr)
      --
      model =
         { route = route
           --
         , topicList  = []
         , seriesList = []
         , postList   = []
         , markdown   = ""
         }
      cmd = getData (route)
   in
      ( model, cmd )


getData : Route -> Cmd Msg
getData route = case (route) of
   SeriesPage _ _ -> Cmd.batch
      [ getTopicList (route)
      , getSeriesList (route)
      , getPostList (route)
      ]
   --
   _ -> Cmd.batch
      [ getTopicList (route)
      , getSeriesList (route)
      , getMarkdown (route)
      ]                    


getTopicList : Route -> Cmd Msg
getTopicList _ =
   Http.get { url = Route.toTopicListFileUrl ()
            , expect = Http.expectJson (GotTopicListResponse) (Json.list Topic.jsonDecoder)
            }


getSeriesList : Route -> Cmd Msg
getSeriesList route =
   Http.get { url = Route.toSeriesListFileUrl (route)
            , expect = Http.expectJson (GotSeriesListResponse) (Json.list Series.jsonDecoder)
            }


getPostList : Route -> Cmd Msg
getPostList route =
   Http.get { url = Route.toPostListFileUrl (route)
            , expect = Http.expectJson (GotPostListResponse) (Json.list Post.jsonDecoder)
            }


getMarkdown : Route -> Cmd Msg
getMarkdown route =
   Http.get { url = Route.toMarkdownFileUrl (route)
            , expect = Http.expectString (GotMarkdownResponse)
            }


-- view - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


view : Model -> Html Msg
view model = text ""


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
            errorTopic = { emptyTopic | title = "# " ++ (HttpError.toString error) }
            newTopicList = [ errorTopic, emptyTopic ]
            --
            updatedModel = { model | topicList = newTopicList }
         in
            ( updatedModel, Cmd.none )
      --
      (Ok data) ->
         let
            updatedModel = { model | topicList = data }
         in
            ( updatedModel, Cmd.none )

   --
   GotSeriesListResponse res -> case (res) of
      --
      (Err error) ->
         let 
            errMsg = HttpError.toString (error)
            emptySeries = Series.empty
            errorSeries = { emptySeries | title = errMsg }
            newSeriesList = [ errorSeries, emptySeries ]
            --
            updatedModel = { model | seriesList = newSeriesList } 
         in
            ( updatedModel, Cmd.none )
      --
      (Ok data) ->
         let
            updatedModel = { model | seriesList = data }
         in
            ( updatedModel, Cmd.none )
   
   --
   GotPostListResponse res -> case (res) of
      --
      (Err error) ->
         let
            emptyPost = Post.empty
            errorPost = { emptyPost | title = HttpError.toString error }
            newPostList = [ errorPost, emptyPost ]
            --
            updatedModel = { model | postList = newPostList }
         in
            ( updatedModel, Cmd.none )
      --
      (Ok data) ->
         let
            updatedModel = { model | postList = data }
         in
            ( updatedModel, Cmd.none )
   
   --
   GotMarkdownResponse res -> case (res) of
      --
      (Err error) ->
         let
            errMsg = HttpError.toString (error)
            content = "# " ++ errMsg
            --
            updatedModel = { model | markdown = content }
         in
            ( updatedModel, Cmd.none )
      --
      (Ok data) ->
         let
            updatedModel = { model | markdown = data }
         in
            ( updatedModel, Cmd.none )


-- subscriptions - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none


