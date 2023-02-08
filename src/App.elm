port module App exposing (main)

import Browser exposing ( Document, UrlRequest )
import Browser.Navigation as Navigation exposing (Key)
import Url exposing (Url)
import Http exposing (Error)
import Json.Decode as Json
import Html exposing (Html)

import Route exposing (Route (..))
import Element.Navigator as Navigator
import Element.Overview as Overview
import Element.Reader as Reader
import Element.Indexer as Indexer

import Data.Topic as Topic exposing (Topic)
import Data.Series as Series exposing (Series)
import Data.Post as Post exposing (Post)

import Config
import Extension.Url as Url
import Extension.Http.Error as HttpError
import Extension.Json.Decode as Json


-- main - - - - - - - - - - - - - - - - - - - - - - - - - - -


main : Program () Model Msg
main = Browser.application
   ( App (init) (view) (update) (subscriptions) (onUrlRequest) (onUrlChange) )

type alias App =
   { init : () -> Url -> Key -> ( Model, Cmd Msg )
   , view : Model -> Document Msg
   , update : Msg -> Model -> ( Model, Cmd Msg )
   , subscriptions : Model -> Sub Msg
   , onUrlRequest : UrlRequest -> Msg
   , onUrlChange : Url -> Msg
   }


-- Model - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Model =
   { url : Url
   , key : Key
     --
   , route : Route
     --
   , navigator : Navigator.Model
   , overview : Overview.Model
   , reader : Reader.Model
   , indexer : Indexer.Model
     --
   , seriesList : List Series
   }


-- init - - - - - - - - - - - - - - - - - - - - - - - - - - -


init : () -> Url -> Key -> ( Model, Cmd Msg )
init _ url key =
   let route = Route.fromUrl (url)
       --
       ( navigator, _ ) = initNavigator
       ( overview, _ ) = initOverview
       ( reader, _ ) = initReader
       ( indexer, _ ) = initIndexer
       --
       seriesList = [ Series.empty ]
       --
       model = Model (url) (key) (route) (navigator) (overview) (reader) (indexer) (seriesList)
       cmd = Cmd.batch [ getTopicList (url)
                       , getSeriesList (url)
                       , getMarkdown (url)
                       , getPostList (url) 
                       ]
   in ( model, cmd )


initNavigator : ( Navigator.Model, Cmd Navigator.Msg )
initNavigator =
   let flags = 
          { topicList = [ Topic.empty ]
          , topicId = ""
            --
          , avatarUrl = Config.avatarUrl
          , avatarName = Config.siteAuthor 
          , gitHubUrl = Config.gitHubUrl
          }
   in  Navigator.init (flags)


initOverview : ( Overview.Model, Cmd Overview.Msg )
initOverview =
   let flags =
          { topicId = ""
          , seriesList = [ Series.empty ]
          , seriesId = ""
          }
   in  Overview.init (flags)


initReader : ( Reader.Model, Cmd Reader.Msg )
initReader =
   let flags = 
          { topicId = "empty"
          , markdown = "Empty"
          }
   in Reader.init (flags)


initIndexer : ( Indexer.Model, Cmd Indexer.Msg )
initIndexer =
   let flags =
          { topicId = "empty"
          , series = Series.empty
          , postList = [ Post.empty ]
          }
   in  Indexer.init (flags)


getTopicList : Url -> Cmd Msg
getTopicList _ =
   Http.get { url = Config.topicListFileUrl
            , expect = Http.expectJson (GotTopicListResponse) (Json.list Json.topic)
            }


getSeriesList : Url -> Cmd Msg
getSeriesList url =
   let topicId = Url.toTopicId url
   in  Http.get { url = Config.seriesListFileUrl (topicId)
                , expect = Http.expectJson (GotSeriesListResponse) (Json.list Json.series)
                }


getMarkdown : Url -> Cmd Msg
getMarkdown url =
   let route = Route.fromUrl (url)
   in  case route of
          HomePage -> getTopicOverview (url)
          TopicPage _ -> getTopicOverview (url)
          PostPage _ _ _ -> getPostContent (url)
          _ -> Cmd.none 


getTopicOverview : Url -> Cmd Msg
getTopicOverview url =
   let topicId = Url.toTopicId (url)
   in  Http.get { url = Config.topicOverviewFileUrl (topicId)
                , expect = Http.expectString (GotTopicOverviewResponse)
                }


getPostContent : Url -> Cmd Msg
getPostContent url =
   let topicId = Url.toTopicId (url)
       seriesId = Url.toSeriesId (url)
       postSlug = Url.toPostSlug (url)
       --
   in  Http.get { url = Config.postContentFileUrl (topicId) (seriesId) (postSlug)
                , expect = Http.expectString (GotPostContentResponse)
                }


getPostList : Url -> Cmd Msg
getPostList url =
   let topicId = Url.toTopicId (url)
       seriesId = Url.toSeriesId (url)
       --
   in  Http.get { url = Config.postListFileUrl (topicId) (seriesId)
                , expect = Http.expectJson (GotPostListResponse) (Json.list Json.post)
                }


-- Msg - - - - - - - - - - - - - - - - - - - - - - - - - - -


type Msg = NavigatorMsg Navigator.Msg
         | OverviewMsg Overview.Msg
         | ReaderMsg Reader.Msg
         | IndexerMsg Indexer.Msg
           --
         | GotTopicListResponse ( Result Http.Error (List Topic) )
         | GotSeriesListResponse ( Result Http.Error (List Series) )
         | GotPostListResponse ( Result Http.Error (List Post) )
         | GotTopicOverviewResponse ( Result Http.Error String )
         | GotPostContentResponse ( Result Http.Error String )
           --
         | GotUrlRequest UrlRequest
         | UrlChanged Url
           --
         | PortJson String


-- view - - - - - - - - - - - - - - - - - - - - - - - - - - -


view : Model -> Document Msg
view model =
   let navigatorHtml = Html.map (NavigatorMsg) ( Navigator.view model.navigator )
       overviewHtml = Html.map (OverviewMsg) ( Overview.view model.overview )
       readerHtml = Html.map (ReaderMsg) ( Reader.view model.reader )
       indexerHtml = Html.map (IndexerMsg) ( Indexer.view model.indexer )
       --
   in  { title = Config.siteTitle
       , body = case (model.route) of
            HomePage ->       [ navigatorHtml, overviewHtml, readerHtml ]
            TopicPage _ ->    [ navigatorHtml, overviewHtml, readerHtml ]
            SeriesPage _ _ -> [ navigatorHtml, overviewHtml, indexerHtml ]
            PostPage _ _ _ -> [ navigatorHtml, overviewHtml, readerHtml ]
       }


-- update - - - - - - - - - - - - - - - - - - - - - - - - - - -


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case msg of

   --
   NavigatorMsg navMsg ->
      let ( updatedNavigator, navCmd ) = Navigator.update (navMsg) ( model.navigator )
          updatedModel = { model | navigator = updatedNavigator }
          cmd = Cmd.map (NavigatorMsg) (navCmd)
      in  ( updatedModel, cmd )

   --
   OverviewMsg overMsg ->
      let ( updatedOverview, overCmd ) = Overview.update (overMsg) ( model.overview )
          updatedModel = { model | overview = updatedOverview }
          cmd = Cmd.map (OverviewMsg) (overCmd)
      in  ( updatedModel, cmd )

   --
   ReaderMsg readMsg ->
      let ( updatedReader, readCmd ) = Reader.update (readMsg) ( model.reader )
          updatedModel = { model | reader = updatedReader }
          cmd = Cmd.map (ReaderMsg) (readCmd)
      in  ( updatedModel, cmd )

   --
   IndexerMsg idxMsg ->
      let ( updatedIndexer, idxCmd ) = Indexer.update (idxMsg) ( model.indexer )
          updatedModel = { model | indexer = updatedIndexer }
          cmd = Cmd.map (IndexerMsg) (idxCmd)
      in  ( updatedModel, cmd )
      
   --
   GotTopicListResponse res -> case (res) of
      ( Ok topicList ) ->
          let topicId = Url.toTopicId ( model.url )
              --
              navMsg = Navigator.DataChanged (topicList) (topicId)
              ( updatedNavigator, _ ) = Navigator.update (navMsg) ( model.navigator )
              --
              updatedModel = { model | navigator = updatedNavigator }
          in  ( updatedModel, Cmd.none )
      --
      ( Err error ) ->
          let emptyTopic = Topic.empty
              errorTopic = { emptyTopic | title = HttpError.toString error }
              topicList = [ errorTopic ]
              topicId = "error"
              --
              navMsg = Navigator.DataChanged (topicList) (topicId)
              ( updatedNavigator, _ ) = Navigator.update (navMsg) ( model.navigator )
              --
              updatedModel = { model | navigator = updatedNavigator }
          in  ( updatedModel, Cmd.none )

   --
   GotSeriesListResponse res -> case (res) of
      --
      ( Ok newSeriesList ) ->
         let topicId = Url.toTopicId ( model.url )
             seriesId = Url.toSeriesId ( model.url )
             --
             overMsg = Overview.DataChanged (topicId) (newSeriesList) (seriesId)
             ( updatedOverview, _ ) = Overview.update (overMsg) ( model.overview )
             --
             updatedModel = { model | overview = updatedOverview
                                    , seriesList = newSeriesList
                            }
         in  ( updatedModel, Cmd.none )
      --
      ( Err error ) ->
         let topicId = "error"
             emptySeries = Series.empty
             errorSeries = { emptySeries | title = HttpError.toString error }
             seriesList = [ errorSeries, emptySeries ]
             seriesId = "error"
             --
             overMsg = Overview.DataChanged (topicId) (seriesList) (seriesId)
             ( updatedOverview, _ ) = Overview.update (overMsg) ( model.overview )
             --
             updatedModel = { model | overview = updatedOverview }
         in  ( updatedModel, Cmd.none )
   
   --
   GotPostListResponse res -> case (res) of
      ( Ok postList ) ->
         let topicId = Url.toTopicId ( model.url )
             --
             seriesId = Url.toSeriesId ( model.url )
             series = 
                let maybeSeries = List.head <| List.filter ( Series.matchId seriesId ) ( model.seriesList )
                in  case (maybeSeries) of
                       Nothing -> Series.empty
                       Just matched -> matched
             --
             idxMsg = Indexer.DataChanged (topicId) (series) (postList)
             ( updatedIndexer, _ ) = Indexer.update (idxMsg) ( model.indexer )
             --
             updatedModel = { model | indexer = updatedIndexer }
         in  ( updatedModel, Cmd.none )
      --
      ( Err error ) ->
         let topicId = Url.toTopicId ( model.url )
             --
             seriesId = Url.toSeriesId ( model.url )
             series = 
                let maybeSeries = List.head <| List.filter ( Series.matchId seriesId ) ( model.seriesList )
                in  case ( maybeSeries ) of
                       Nothing -> Series.empty
                       Just matched -> matched
             --
             emptyPost = Post.empty
             errorPost = { emptyPost | title = HttpError.toString error }
             postList = [ errorPost, emptyPost ]
             --
             idxMsg = Indexer.DataChanged (topicId) (series) (postList)
             ( updatedIndexer, _ ) = Indexer.update (idxMsg) ( model.indexer )
             updatedModel = { model | indexer = updatedIndexer }
         in  ( updatedModel, Cmd.none )
   
   --
   GotTopicOverviewResponse res -> case ( res ) of
      ( Ok markdown ) ->
         let topicId = Url.toTopicId ( model.url )
             --
             readMsg = Reader.DataChanged (topicId) (markdown)
             ( updatedReader, _ ) = Reader.update (readMsg) ( model.reader )
             updatedModel = { model | reader = updatedReader }
         in  ( updatedModel, Cmd.none )
      --
      ( Err error ) ->
         let topicId = Url.toTopicId ( model.url )
             errorMarkdown = "# Error" ++ HttpError.toString (error)
             --
             readMsg = Reader.DataChanged (topicId) (errorMarkdown)
             ( updatedReader, _ ) = Reader.update ( readMsg ) ( model.reader )
             --
             updatedModel = { model | reader = updatedReader }
         in  ( updatedModel, Cmd.none )

   --
   GotPostContentResponse res -> case res of
      ( Ok markdown ) ->
         let topicId = Url.toTopicId ( model.url )
             --
             readMsg = Reader.DataChanged (topicId) (markdown)
             ( updatedReader, _ ) = Reader.update (readMsg) ( model.reader )
             updatedModel = { model | reader = updatedReader }
         in  ( updatedModel, Cmd.none )
      --
      ( Err error ) ->
         let topicId = Url.toTopicId ( model.url )
             errorMarkdown = "# Error" ++ HttpError.toString (error)
             --
             readMsg = Reader.DataChanged (topicId) (errorMarkdown)
             ( updatedReader, _ ) = Reader.update (readMsg) ( model.reader )
             updatedModel = { model | reader = updatedReader }
         in  ( updatedModel, Cmd.none )

   --
   GotUrlRequest req -> case req of
      Browser.External href -> ( model, Navigation.load href )
      Browser.Internal newUrl ->
         let appMsg = NavigatorMsg ( Navigator.CollapseFolder )
             ( updatedModel, cmd1 ) = update (appMsg) (model)
             cmd2 = Navigation.pushUrl ( model.key ) ( Url.toString newUrl )
         in  ( updatedModel, Cmd.batch [ cmd1, cmd2 ] )

   --
   UrlChanged newUrl ->
      let newRoute = Route.fromUrl (newUrl)
          updatedModel = { model | url = newUrl, route = newRoute }
      in  updateElements ( updatedModel, Cmd.none )

   --
   PortJson _ -> ( model, Cmd.none )


updateElements : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
updateElements = updateNavigator
              >> updateOverview 
              >> updateReader
              >> updateIndexer


updateNavigator : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
updateNavigator model_cmd =
   let ( model, cmd ) = model_cmd
       topicId = Url.toTopicId ( model.url )
       --
       appMsg = Navigator.TopicChanged (topicId)
       ( updatedNavigator, _ ) = Navigator.update appMsg ( model.navigator )
       updatedModel = { model | navigator = updatedNavigator }
   in  ( updatedModel, cmd )


updateOverview : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
updateOverview model_cmd =
   let ( model, cmd ) = model_cmd
       newCmd = Cmd.batch [ cmd, getSeriesList model.url ]
   in  ( model, newCmd )


updateReader : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
updateReader model_cmd =
   let ( model, cmd ) = model_cmd
       newCmd = Cmd.batch [ cmd, getMarkdown model.url ]
   in  ( model, newCmd )


updateIndexer : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
updateIndexer model_cmd =
   let ( model, cmd ) = model_cmd
       newCmd = Cmd.batch [ cmd, getPostList model.url ]
   in  ( model, newCmd )


-- subscriptions - - - - - - - - - - - - - - - - - - - - - - - - - - -


subscriptions : Model -> Sub Msg
subscriptions _ = listen (PortJson)

port export : String -> Cmd msg
port listen : ( String -> msg ) -> Sub msg


-- onUrlRequest - - - - - - - - - - - - - - - - - - - - - - - - - - -


onUrlRequest : UrlRequest -> Msg
onUrlRequest req = GotUrlRequest (req)


-- onUrlChange - - - - - - - - - - - - - - - - - - - - - - - - - - -


onUrlChange : Url -> Msg
onUrlChange url = UrlChanged (url)


