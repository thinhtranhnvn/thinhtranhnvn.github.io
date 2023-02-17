module Element.Reader exposing (..)

import Data.Post as Post exposing (Post)
import Route exposing (Route(..))
import Markdown

import Browser
import Http exposing (Error)
import Html exposing (..)
import Html.Attributes as Attributes exposing (..)
import Html.Events as Events exposing (..)

import Extension.Http.Error as HttpError


-- main - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


main : Program String Model Msg
main =
   let
      rdr = Reader (init) (view) (update) (subscriptions)
   in
      Browser.element (rdr)


-- Reader - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Reader =
   { init : String -> ( Model, Cmd Msg )
   , view : Model -> Html Msg
   , update : Msg -> Model -> ( Model, Cmd Msg )
   , subscriptions : Model -> Sub Msg
   }


-- Model - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Model =
   { route : Route
     --
   , markdown : String
   }


-- Msg - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type Msg = UrlChanged String
           --
         | GotMarkdownResponse (Result Http.Error String)


-- init - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


init : String -> ( Model, Cmd Msg )
init urlStr =
   let
      route = Route.fromUrlString (urlStr)
      markdown = ""
      --
      model = Model (route) (markdown)
      cmd = case (model.route) of
         SeriesPage _ _ -> Cmd.none
         _ -> getMarkdown (route)
   in
      ( model, cmd )

--
getMarkdown : Route -> Cmd Msg
getMarkdown route =
   Http.get { url = Route.toMarkdownFileUrl (route)
            , expect = Http.expectString (GotMarkdownResponse)
            }


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
   UrlChanged newUrlStr -> init (newUrlStr)
   
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


