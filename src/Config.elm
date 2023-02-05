module Config exposing (..)

import Data.Topic as Topic exposing (Topic)


-- - - - - - - - - - - - - - - - - - - - - - - - - - - -


siteTitle : String
siteTitle = "Semi Dev_ 's Blog"


siteAuthor : String
siteAuthor = "Semi Dev_"


siteUrl : String
siteUrl = "https://thinhtranhnvn.github.io"


avatarUrl : String
avatarUrl = "/mockup/Element/Navigator/avatar.jpg"


gitHubUrl : String
gitHubUrl = "https://github.com/thinhtranhnvn"


dataFolderUrl : String
dataFolderUrl = "/data"


topicListFileUrl : String
topicListFileUrl =
   dataFolderUrl ++ "/" ++ "topic-list.json"


seriesListFileUrl : String -> String
seriesListFileUrl topicId =
  dataFolderUrl ++ "/" ++ topicId ++ "/" ++ "series-list.json"


postListFileUrl : String -> String -> String
postListFileUrl topicId seriesId = 
   dataFolderUrl ++ "/" ++ topicId ++ "/" ++ seriesId ++ "/" ++ "post-list.json"


topicOverviewFileUrl : String -> String
topicOverviewFileUrl topicId =
   dataFolderUrl ++ "/" ++ topicId ++ "/" ++ "overview.txt"


postContentFileUrl : String -> String -> String -> String
postContentFileUrl topicId seriesId postSlug =
   dataFolderUrl ++ "/" ++ topicId ++ "/" ++ seriesId ++ "/" ++ postSlug ++ ".txt"


defaultTopicId : String
defaultTopicId = "origin" 


defaultTopic : Topic
defaultTopic =
   { id = "origin"
   , title = "Semi Dev_ 's Blog"
   , keywords = [ "coding", "software", "learning", "language", "blog", "tutorial" ]
   , description = "Semi Dev_ 's personal blog powered by GitHub Pages - sharing knowledge related to coding and human language in a natural learning progress."
   , overview = "None"
   }

