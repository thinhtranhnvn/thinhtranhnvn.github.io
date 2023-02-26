module Element.Reader exposing (..)

import Route exposing (Route(..))
import Context
import Data.Post as Post exposing (Post)

import Html exposing (..)
import Html.Attributes as Attributes exposing (..)
import Html.Events as Events exposing (..)

import Markdown


-- Reader - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Reader =
   { init : Context.Model -> ( Model, Cmd Msg )
   , view : Model -> Html Msg
   , update : Msg -> Model -> ( Model, Cmd Msg )
   , subscriptions : Model -> Sub Msg
   }


-- Model - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Model = Context.Model


-- Msg - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type Msg = ContextChanged (Context.Model)


-- init - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


init : Context.Model -> ( Model, Cmd Msg )
init context = ( context, Cmd.none )


-- view - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


view : Model -> Html Msg
view model =
   let
      topicId = Route.toTopicId (model.route)
   in
      article [ class "Reader Base" ] [
         div [ class "Reader Container" ] [
            span [] [ text (topicId) ],
            Markdown.toHtml [] (model.markdown)
         ] -- div.Reader.Container
      ] -- article.Reader.Base


-- update - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case (msg) of
   --
   ContextChanged newCtx -> init (newCtx)


-- subscriptions - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none


