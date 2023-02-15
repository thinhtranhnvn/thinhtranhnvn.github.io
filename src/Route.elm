module Route exposing (..)

import Url exposing (Url)
import Url.Parser as UrlParser exposing (Parser, parse, oneOf, string, top, (</>))


-- Url Example:
-- https://thinhtranhnvn.github.io/origin/heart-sutra/00-the-first-preface
-- topicId = origin
-- seriesId = heart-sutra
-- postSlug = 00-the-first-preface


-- Route - - - - - - - - - - - - - - - - - - - - - - - - - - -


type Route = HomePage
           | TopicPage  String
           | SeriesPage String String
           | PostPage   String String String


-- map - - - - - - - - - - - - - - - - - - - - - - - - - - -


map : (String -> String -> String -> a) -> Route -> a
map func route = case (route) of
   --
   HomePage   -> func "origin" "" ""
   --
   TopicPage  topicId -> func (topicId) "" ""
   --
   SeriesPage topicId seriesId -> func (topicId) (seriesId) ""
   --
   PostPage   topicId seriesId postSlug -> func (topicId) (seriesId) (postSlug)


-- toTopicId - - - - - - - - - - - - - - - - - - - - - - - - - - -


toTopicId : Route -> String
toTopicId route = case (route) of
   --
   HomePage   -> "origin"
   --
   TopicPage  topicId -> topicId
   --
   SeriesPage topicId _ -> topicId
   --
   PostPage   topicId _ _ -> topicId


-- toSeriesId - - - - - - - - - - - - - - - - - - - - - - - - - - -


toSeriesId : Route -> String
toSeriesId route = case (route) of
   --
   HomePage   -> ""
   --
   TopicPage  _ -> ""
   --
   SeriesPage _ seriesId -> seriesId
   --
   PostPage   _ seriesId _ -> seriesId


-- toPostSlug - - - - - - - - - - - - - - - - - - - - - - - - - - -


toPostSlug : Route -> String
toPostSlug route = case (route) of
   --
   HomePage   -> ""
   --
   TopicPage  _ -> ""
   --
   SeriesPage _ _ -> ""
   --
   PostPage   _ _ postSlug -> postSlug


-- parser - - - - - - - - - - - - - - - - - - - - - - - - - - -


parser : Parser (Route -> a) a
parser =
   oneOf [ UrlParser.map (HomePage)   (top)
         , UrlParser.map (TopicPage)  (string)
         , UrlParser.map (SeriesPage) (string </> string)
         , UrlParser.map (PostPage)   (string </> string </> string)
         ]


-- fromUrl - - - - - - - - - - - - - - - - - - - - - - - - - - -


fromUrl : Url -> Route
fromUrl url =
   let
      maybeRoute = UrlParser.parse (parser) (url)
   in
      Maybe.withDefault (HomePage) (maybeRoute)


-- fromUrlString - - - - - - - - - - - - - - - - - - - - - - - - - - -


fromUrlString : String -> Route
fromUrlString urlStr =
   case (Url.fromString (urlStr)) of
      Nothing -> HomePage
      Just url -> fromUrl (url) 


-- toTopicUrl - - - - - - - - - - - - - - - - - - - - - - - - - - -


toTopicUrl : Route -> String
toTopicUrl route =
   let
      topicId = map (\ tId _ _ -> tId) (route)
   in
      "/" ++ topicId


-- toSeriesUrl - - - - - - - - - - - - - - - - - - - - - - - - - - -


toSeriesUrl : Route -> String
toSeriesUrl route =
   let
      (topicId, seriesId) = map (\ tId sId _ -> (tId, sId)) (route)
   in
      "/" ++ topicId ++ "/" ++ seriesId


-- dataFolderUrl - - - - - - - - - - - - - - - - - - - - - - - - - - -


dataFolderUrl = "/" ++ "data"


-- toTopicListFileUrl - - - - - - - - - - - - - - - - - - - - - - - - - - -


toTopicListFileUrl : () -> String
toTopicListFileUrl _ = dataFolderUrl ++ "/" ++ "topic-list.json"


-- toSeriesListFileUrl - - - - - - - - - - - - - - - - - - - - - - - - - - -


toSeriesListFileUrl : Route -> String
toSeriesListFileUrl route =
   let
      topicId = map (\ tId _ _ -> tId) (route)
   in
      dataFolderUrl ++ "/" ++ topicId ++ "/" ++ "series-list" ++ ".json"


-- toPostListFileUrl - - - - - - - - - - - - - - - - - - - - - - - - - - -


toPostListFileUrl : Route -> String
toPostListFileUrl route =
   let
      (topicId, seriesId) = map (\ tId sId _ -> (tId, sId)) (route)
   in
      dataFolderUrl ++ "/" ++ topicId ++ "/" ++ seriesId ++ "/" ++ "post-list" ++ ".json"


-- toMarkdownFileUrl - - - - - - - - - - - - - - - - - - - - - - - - - - -


toMarkdownFileUrl : Route -> String
toMarkdownFileUrl route =
   let
      (topicId, seriesId, postSlug) = map (\ tId sId pSl -> (tId, sId, pSl)) (route)
   in
      if (String.isEmpty postSlug)
         then
            dataFolderUrl ++ "/" ++ topicId ++ "/" ++ "overview" ++ ".txt"
         else
            dataFolderUrl ++ "/" ++ topicId ++ "/" ++ seriesId ++ "/" ++ postSlug ++ ".txt"


