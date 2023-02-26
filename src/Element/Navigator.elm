module Element.Navigator exposing (..)

import Route exposing (Route(..))
import Context
import Data.Topic as Topic exposing (Topic)

import Html exposing (..)
import Html.Attributes as Attributes exposing (..)
import Html.Events as Events exposing (..)


-- Navigator - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Navigator =
   { init : String -> ( Model, Cmd Msg )
   , view : Model -> Html Msg
   , update : Msg -> Model -> ( Model, Cmd Msg )
   , subscriptions : Model -> Sub Msg
   }


-- Model - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Model =
   { context : Context.Model
     --
   , collapsed : Bool
   }


-- Msg - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type Msg = ContextChanged (Context.Model)
           --
         | ToggleFolder
         | CollapseFolder


-- init - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


init : Context.Model -> ( Model, Cmd Msg )
init context =
   let
      model = 
         { context = context
         , collapsed = True
         }
   in
      ( model, Cmd.none )


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
               (List.map (navLink model.context.route) (model.context.topicList))
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
   ContextChanged newCtx -> init (newCtx)
   
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


