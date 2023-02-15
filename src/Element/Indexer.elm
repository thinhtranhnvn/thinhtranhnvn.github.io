port module Element.Indexer exposing ( Flags, Model, Msg (..), init, view, update, subscriptions )

import Browser
import Html exposing (..)
import Html.Attributes as Attributes exposing (..)
import Html.Events as Events exposing (..)

import Data.Series as Series exposing ( Series )
import Data.Post as Post exposing ( Post )

import Extension.Url as Url
import Extension.Http.Error as HttpError


-- main - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Indexer =
   { init : Flags -> ( Model, Cmd Msg )
   , view : Model -> Html Msg
   , update : Msg -> Model -> ( Model, Cmd Msg )
   , subscriptions : Model -> Sub Msg
   }


-- Flags - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Flags =
   { topicId : String
   , series : Series
   , postList : List Post 
   }


-- Model - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Model =
   { flags : Flags }


-- Msg - - - - - - - - - - - - - - - - - - - - - - - - - - -


type Msg = DataChanged String Series ( List Post )
           --
         | PortJson String


-- init - - - - - - - - - - - - - - - - - - - - - - - - - - -


init : Flags -> ( Model, Cmd Msg )
init flags = ( Model flags, Cmd.none )


-- view - - - - - - - - - - - - - - - - - - - - - - - - - - -


view : Model -> Html Msg
view model =
   main_ [ class "Indexer Base" ] [
      div [ class "Indexer Container" ] [
         span [] [ text model.flags.topicId ],
      
         header [ class "Indexer Intro" ] [
            h1 [] [ text model.flags.series.title ],
            p [] [ text model.flags.series.description ]
         ], -- header.Indexer.Intro
         
         nav [ class "Indexer Content" ]
            ( List.map (indexLink model) model.flags.postList )
      ] -- div.Indexer.Container
   ] -- main.Indexer.Base


indexLink : Model -> Post -> Html Msg
indexLink model post =
   let topicId = model.flags.topicId
       seriesId = model.flags.series.id
       postSlug = post.slug
       --
       linkUrl = "/" ++ topicId ++ "/" ++ seriesId ++ "/" ++ postSlug
       --
   in  a [ class "Indexer Link", href linkUrl ] [ text post.title ]


-- update - - - - - - - - - - - - - - - - - - - - - - - - - - -


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case msg of
   
   --
   DataChanged topicId series postList ->
      let updatedFlags = Flags ( topicId ) ( series ) ( postList )
          updatedModel = { model | flags = updatedFlags }
      in  ( updatedModel, Cmd.none )
   
   --
   PortJson _ -> ( model, Cmd.none )


-- subscriptions - - - - - - - - - - - - - - - - - - - - - - - - - - -


subscriptions : Model -> Sub Msg
subscriptions _ = listen PortJson


port export : String -> Cmd msg
port listen : (String -> msg) -> Sub msg


