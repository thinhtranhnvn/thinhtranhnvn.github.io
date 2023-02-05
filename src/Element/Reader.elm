port module Element.Reader exposing ( Flags, Model, Msg (..), init, view, update, subscriptions )

import Browser
import Html exposing (.. )
import Html.Attributes as Attributes exposing (..)
import Html.Events as Events exposing (..)

import Markdown


-- main - - - - - - - - - - - - - - - - - - - - - - - - - - -


main : Program Flags Model Msg
main = Browser.element
   ( Reader ( init ) ( view ) ( update ) ( subscriptions ) )


-- Overview - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Reader =
   { init : Flags -> ( Model, Cmd Msg )
   , view : Model -> Html Msg
   , update : Msg -> Model -> ( Model, Cmd Msg )
   , subscriptions : Model -> Sub Msg
   }


-- Flags - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Flags =
   { topicId : String
   , markdown : String
   }

-- Model - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Model =
   { flags : Flags }


-- Msg - - - - - - - - - - - - - - - - - - - - - - - - - - -


type Msg = DataChanged String String
           --
         | PortJson String


-- init - - - - - - - - - - - - - - - - - - - - - - - - - - -


init : Flags -> ( Model, Cmd Msg )
init flags = ( Model flags, Cmd.none )


-- view - - - - - - - - - - - - - - - - - - - - - - - - - - -


view : Model -> Html Msg
view model =
   article [ class "Reader Base" ] [
      div [ class "Reader Container" ] [
         span [] [ text model.flags.topicId ],
         Markdown.toHtml [] model.flags.markdown
      ] -- div.Reader.Container
   ] -- article.Reader.Base


-- update - - - - - - - - - - - - - - - - - - - - - - - - - - -


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case msg of
   
   --
   DataChanged topicId markdown ->
      let updatedFlags = Flags ( topicId ) ( markdown )
          updatedModel = { model | flags = updatedFlags }
      in  ( updatedModel, Cmd.none )
   
   --
   PortJson _ -> ( model, Cmd.none )


-- subscriptions - - - - - - - - - - - - - - - - - - - - - - - - - - -


subscriptions : Model -> Sub Msg
subscriptions _ = listen PortJson


port export : String -> Cmd msg
port listen : (String -> msg) -> Sub msg


