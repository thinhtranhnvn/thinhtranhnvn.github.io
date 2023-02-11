port module Element.Navigator exposing ( Flags, Model, Msg (..), init, view, update, subscriptions )

import Browser
import Html exposing (.. )
import Html.Attributes as Attributes exposing (..)
import Html.Events as Events exposing (..)

import Data.Topic as Topic exposing ( Topic )


-- main - - - - - - - - - - - - - - - - - - - - - - - - - - -


main : Program Flags Model Msg
main = Browser.element
   ( Navigator init view update subscriptions )


type alias Navigator =
   { init : Flags -> ( Model, Cmd Msg )
   , view : Model -> Html Msg
   , update : Msg -> Model -> ( Model, Cmd Msg )
   , subscriptions : Model -> Sub Msg
   }


-- Flags - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Flags =
   { topicList : List Topic
   , topicId : String
     --
   , avatarUrl : String
   , avatarName : String
   , gitHubUrl : String
   }


-- Model - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Model =
   { collapsed : Bool
   , flags : Flags
   }


-- Msg - - - - - - - - - - - - - - - - - - - - - - - - - - -


type Msg = ToggleFolder
         | CollapseFolder
           --
         | DataChanged ( List Topic ) String
         | TopicChanged String
           --
         | PortJson String


-- init - - - - - - - - - - - - - - - - - - - - - - - - - - -


init : Flags -> ( Model, Cmd Msg )
init flags =
   let collapsed = True
   in  ( Model collapsed flags, Cmd.none )


-- view - - - - - - - - - - - - - - - - - - - - - - - - - - -


view : Model -> Html Msg
view model =
   --
   let togglerClass = if model.collapsed 
          then "Navigator Toggler"
          else "Navigator Toggler Active"
       folderClass = if model.collapsed
          then "Navigator Folder Collapsed"
          else "Navigator Folder"
   --
   in  nav [ class "Navigator Base" ] [
          a [ class "Navigator Avatar", href "/" ] [
             img [ src model.flags.avatarUrl ] [],
             text model.flags.avatarName
          ],
          --
          input [ class "Navigator Search", type_ "text",
                  placeholder "Search with Google..." ] [],
          --
          label [ class togglerClass, onClick ToggleFolder ] [ text "Topics" ],
          --
          div [ class folderClass ] [
             div [ class "Folder Container" ]
                ( List.map ( topicLink model.flags.topicId ) model.flags.topicList )
          ],
          --
          a [ class "Navigator GitHub", href model.flags.gitHubUrl, target "_blank" ] [
             text "GitHub"
          ]
       ] -- nav.Navigator.Base


topicLink : String -> Topic -> Html Msg
topicLink currentId topic =
   let linkClass = case ( compare topic.id currentId ) of
          EQ -> "Navigator Link Current" 
          _  -> "Navigator Link"
   in  a [ class linkClass, href ( "/" ++ topic.id ) ] [ 
          text topic.title 
       ] -- a.Navigator.Link


-- update - - - - - - - - - - - - - - - - - - - - - - - - - - -


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case msg of
   --
   ToggleFolder ->
      let updatedModel = { model | collapsed = not model.collapsed }
      in  ( updatedModel, Cmd.none )
   --
   CollapseFolder ->
      let updatedModel = { model | collapsed = True }
      in  ( updatedModel, Cmd.none )
   --
   DataChanged newTopicList newTopicId ->
      let flags = model.flags
          updatedFlags = { flags | topicList = newTopicList
                                 , topicId = newTopicId
                         }
          updatedModel = { model | flags = updatedFlags }
      in  ( updatedModel, Cmd.none )
   --
   TopicChanged newTopicId ->
      let flags = model.flags
          updatedFlags = { flags | topicId = newTopicId }
          updatedModel = { model | flags = updatedFlags }
      in  ( updatedModel, Cmd.none )
   --
   PortJson _ -> ( model, Cmd.none )


-- subscriptions - - - - - - - - - - - - - - - - - - - - - - - - - - -


subscriptions : Model -> Sub Msg
subscriptions _ = listen PortJson


port export : String -> Cmd msg
port listen : (String -> msg) -> Sub msg


