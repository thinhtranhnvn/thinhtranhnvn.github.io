port module Element.Overview exposing ( Flags, Model, Msg (..), init, view, update, subscriptions )

import Browser
import Html exposing (..)
import Html.Attributes as Attributes exposing (..)
import Html.Events as Events exposing (..)

import Data.Series as Series exposing ( Series )

import Extension.Url as Url
import Extension.Http.Error as HttpError


-- main - - - - - - - - - - - - - - - - - - - - - - - - - - -


main : Program Flags Model Msg
main = Browser.element
   ( Overview init view update subscriptions )


type alias Overview =
   { init : Flags -> ( Model, Cmd Msg )
   , view : Model -> Html Msg
   , update : Msg -> Model -> ( Model, Cmd Msg )
   , subscriptions : Model -> Sub Msg
   }


-- Flags - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Flags =
   { topicId : String
   , seriesList : List Series
   , seriesId : String
   }


-- Model - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Model =
   { flags : Flags }


-- Msg - - - - - - - - - - - - - - - - - - - - - - - - - - -


type Msg = DataChanged String ( List Series ) String
           --
         | PortJson String


-- init - - - - - - - - - - - - - - - - - - - - - - - - - - -


init : Flags -> ( Model, Cmd Msg )
init flags = ( Model flags, Cmd.none )


-- view - - - - - - - - - - - - - - - - - - - - - - - - - - -


view : Model -> Html Msg
view model =
   nav [ class "Overview Base" ]
      ( overviewLink model :: seriesLinkList model )


overviewLink : Model -> Html Msg
overviewLink model =
   let topicUrl = "/" ++ model.flags.topicId
       linkClass = if String.isEmpty ( model.flags.seriesId )
          then "Overview Link Current"
          else "Overview Link"
   in a [ class linkClass , href topicUrl ] [ text "Overview" ]


seriesLinkList : Model -> List ( Html Msg )
seriesLinkList model =
   List.map ( seriesLink model ) model.flags.seriesList


seriesLink : Model -> Series -> Html Msg
seriesLink model series =
   let seriesUrl = "/" ++ model.flags.topicId ++ "/" ++ series.id
       linkClass = case ( compare series.id model.flags.seriesId ) of
          EQ -> "Overview Link Current"
          _  -> "Overview Link"
   in a [ class linkClass, href seriesUrl ] [ text series.title ]


-- update - - - - - - - - - - - - - - - - - - - - - - - - - - -


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case msg of
   --
   DataChanged topicId seriesList seriesId ->
      let updatedFlags = Flags ( topicId ) ( seriesList ) ( seriesId )
          updatedModel = { model | flags = updatedFlags }
      in  ( updatedModel, Cmd.none )
   --
   PortJson _ -> ( model, Cmd.none )


-- subscriptions - - - - - - - - - - - - - - - - - - - - - - - - - - -


subscriptions : Model -> Sub Msg
subscriptions _ = listen PortJson


port export : String -> Cmd msg
port listen : (String -> msg) -> Sub msg


