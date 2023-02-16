module Element.Navigator exposing (..)

import Data.Topic as Topic exposing (Topic)
import Json.Decode as Json
import Route exposing (Route)

import Browser
import Url exposing (Url)
import Http exposing (Error)
import Html exposing (..)
import Html.Attributes as Attributes exposing (..)
import Html.Events as Events exposing (..)

import Extension.Http.Error as HttpError


-- main - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


main : Program String Model Msg
main =
   let
      nav = Navigator (init) (view) (update) (subscriptions)
   in
      Browser.element (nav)


-- Navigator - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Navigator =
   { init : String -> ( Model, Cmd Msg )
   , view : Model -> Html Msg
   , update : Msg -> Model -> ( Model, Cmd Msg )
   , subscriptions : Model -> Sub Msg
   }


-- Model - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Model =
   { route : Route
     --
   , topicList : List Topic
     --
   , collapsed : Bool
   }


-- Msg - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type Msg = UrlChanged String
           --
         | GotTopicListResponse (Result (Http.Error) (List Topic))
           --
         | ToggleFolder
         | CollapseFolder


-- init - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


init : String -> ( Model, Cmd Msg )
init urlStr =
   let
      route = Route.fromUrlString (urlStr)
      --
      topicList = []
      collapsed = True
      --
      model = Model (route) (topicList) (collapsed)
      cmd = getTopicList
   in
      ( model, cmd )

--
getTopicList : Cmd Msg
getTopicList =
   Http.get { url = Route.toTopicListFileUrl ()
            , expect = Http.expectJson (GotTopicListResponse) (Json.list Topic.jsonDecoder)
            }


-- view - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


view : Model -> Html Msg
view model =
   let
      togglerClass = if (model.collapsed)
         then "Navigator Toggler"
         else "Navigator Toggler Active"
      --
      folderClass = if (model.collapsed)
         then "Navigator Folder Collapsed"
         else "Navigator Folder"
   --
   in
      nav [ class "Navigator Base" ] [
         a [ class "Navigator Avatar", href "/" ] [
            img [ src "/mockup/Element/Navigator/avatar.jpg"
                , alt "Semi Dev_ 's Avatar" ] [],
            text "Semi Dev_"
         ], -- a.Navigator.Avatar
      
         input [ class "Navigator Search", id "search"
               , type_ "text", placeholder "Search with Google..." ] [],
      
         label [ class (togglerClass), onClick (ToggleFolder) ] [ text "Topics" ],
      
         div [ class (folderClass) ] [
            div [ class "Folder Container" ]
               (List.map (navLink model.route) (model.topicList))
            -- div.Folder.Container
         ], -- div.Navigator.Folder
      
         a [ class "Navigator GitHub"
           , href "https://github.com/thinhtranhnvn"
           , target "_blank"
           ] [ text "GitHub" ] 
      ] -- nav.Navigator.Base

--
navLink : Route -> Topic -> Html Msg
navLink route topic =
   let
      currentId = Route.toTopicId (route)
      --
      linkClass = case (compare (topic.id) (currentId)) of
         EQ -> "Navigator Link Current"
         _  -> "Navigator Link"
      --
      topicUrl = "./" ++ topic.id
   in
      a [ class (linkClass), href (topicUrl) ] [ text (topic.title) ]


-- update - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case (msg) of
   
   --
   UrlChanged newUrlStr ->
      let
         newRoute = Route.fromUrlString (newUrlStr)
         --
         updatedModel = { model | route = newRoute }
      in
         ( updatedModel, Cmd.none )
   
   --
   GotTopicListResponse res -> case (res) of
      --
      (Err error) ->
         let
            emptyTopic = Topic.empty
            errorTopic = { emptyTopic | title = "# " ++ (HttpError.toString error) }
            newTopicList = [ errorTopic, emptyTopic ]
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
   ToggleFolder ->
      let
         updatedModel = { model | collapsed = not (model.collapsed) }
      in
         ( updatedModel, Cmd.none )
   
   --
   CollapseFolder ->
      let
         updatedModel = { model | collapsed = True }
      in
         ( updatedModel, Cmd.none )


-- subscriptions - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none


