module Route exposing ( Route (..), fromUrl )

import Url exposing ( Url )
import Url.Parser as Parser exposing ( Parser, parse, oneOf, string, top, (</>) )

import Config exposing ( defaultTopicId )


-- Url Example:
-- https://thinhtranhnvn.github.io/origin/heart-sutra/00-the-first-preface
-- topicId = origin
-- seriesId = heart-sutra
-- postSlug = 00-the-first-preface


-- Route - - - - - - - - - - - - - - - - - - - - - - - - - - -


type Route = HomePage
           | TopicPage String
           | SeriesPage String String
           | PostPage String String String


-- urlParser - - - - - - - - - - - - - - - - - - - - - - - - - - -


urlParser : Parser ( Route -> a ) a
urlParser = oneOf
   [ Parser.map HomePage ( top )
   , Parser.map TopicPage ( string )
   , Parser.map SeriesPage ( string </> string )
   , Parser.map PostPage ( string </> string </> string )
   ]


-- fromUrl - - - - - - - - - - - - - - - - - - - - - - - - - - -


fromUrl : Url -> Route
fromUrl url = Maybe.withDefault HomePage ( parse urlParser url )


