module Extension.Url exposing ( toTopicId, toSeriesId, toPostSlug )

import Url exposing ( Url )

import Route exposing ( Route (..) )
import Config exposing ( defaultTopicId )


-- toTopicId - - - - - - - - - - - - - - - - - - - - - - - - - - -

toTopicId : Url -> String
toTopicId url = case ( Route.fromUrl url ) of
   HomePage -> defaultTopicId
   TopicPage topicId -> topicId  
   SeriesPage topicId _ -> topicId
   PostPage topicId _ _ -> topicId


-- toSeriesId - - - - - - - - - - - - - - - - - - - - - - - - - - -

toSeriesId : Url -> String
toSeriesId url = case ( Route.fromUrl url ) of
   HomePage -> ""
   TopicPage _ -> ""
   SeriesPage _ seriesId -> seriesId
   PostPage _ seriesId _ -> seriesId


-- toPostSlug - - - - - - - - - - - - - - - - - - - - - - - - - - -

toPostSlug : Url -> String
toPostSlug url = case ( Route.fromUrl url ) of
   HomePage -> ""
   TopicPage _ -> ""
   SeriesPage _ _ -> ""
   PostPage _ _ postSlug -> postSlug


