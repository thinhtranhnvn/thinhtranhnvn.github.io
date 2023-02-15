module Element.Indexer exposing (..)

import Data.Series as Series exposing (Series)
import Data.Post as Post exposing (Post)
import Route exposing (Route)

import Browser
import Http exposing (Error)
import Json.Decode as Json
import Html exposing (..)
import Html.Attributes as Attributes exposing (..)
import Html.Events as Events exposing (..)


-- main - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


main : Program String Model Msg
main =
   let
      idx = Indexer (init) (view) (update) (subscriptions)
   in
      Browser.element (idx)


-- Indexer - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Indexer =
   { init : String -> ( Model, Cmd Msg )
   , view : Model -> Html Msg
   , update : Msg -> Model -> ( Model, Cmd Msg )
   , subscriptions : Model -> Sub Msg
   }


-- Model - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Model =
   { route : Route
     --
   , seriesList : List Series
   , postList : List Post
   }


-- Msg - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type Msg = UrlChanged String
           --
         | GotSeriesListResponse (Result (Http.Error) (List Series))
         | GotPostListResponse (Result (Http.Error) (List Post))


-- init - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


init : String -> ( Model, Cmd Msg )
init urlStr =
   let
      route = Route.fromUrlString (urlStr)
      seriesList = []
      postList = []
      --
      model = Model (route) (seriesList) (postList)
      cmd = getPostList (route)
   in
      ( model, cmd )

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
      topicId = Route.toTopicId (model.route)
      seriesId = Route.toSeriesId (model.route)
      series = 
         let
            maybeSeries = List.head <| List.filter (Series.matchId seriesId) (model.seriesList)
         in
            case ( maybeSeries ) of
               Nothing -> Series.empty
               Just matched -> matched
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
   UrlChanged newUrlStr -> init (newUrlStr)
   
   --
   GotSeriesListResponse res -> case (res) of
      --
      (Err error) -> ( model, Cmd.none )
      --
      (Ok data) ->
         let
            updatedModel = { model | seriesList = data }
         in
            ( updatedModel, Cmd.none )
   
   --
   GotPostListResponse res -> case (res) of
      --
      (Err error) -> ( model, Cmd.none )
      --
      (Ok data) ->
         let
            updatedModel = { model | postList = data }
         in
            ( updatedModel, Cmd.none )


-- subscriptions - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none


