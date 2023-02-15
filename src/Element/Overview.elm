module Element.Overview exposing (..)

import Data.Series as Series exposing (Series)
import Route exposing (Route)

import Browser
import Http exposing (Error)
import Url exposing (Url)
import Json.Decode as Json
import Html exposing (..)
import Html.Attributes as Html exposing (..)
import Html.Events as Html exposing (..)

import Extension.Http.Error as HttpError


-- main - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


main : Program String Model Msg
main =
   let
      ovr = Overview (init) (view) (update) (subscriptions)
   in
      Browser.element (ovr)


-- Overview - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Overview =
   { init : String -> ( Model, Cmd Msg )
   , view : Model -> Html Msg
   , update : Msg -> Model -> ( Model, Cmd Msg )
   , subscriptions : Model -> Sub Msg
   }


-- Model - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Model =
   { route : Route
     --
   , seriesList : List Series
   }


-- Msg - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type Msg = UrlChanged String
           --
         | GotSeriesListResponse (Result (Http.Error) (List Series))


-- init - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


init : String -> ( Model, Cmd Msg )
init urlStr =
   let
      route = Route.fromUrlString (urlStr)
      seriesList = []
      --
      model = Model (route) (seriesList)
      cmd = getSeriesList (route)
   in
      ( model, cmd )

--
getSeriesList : Route -> Cmd Msg
getSeriesList route =
   Http.get { url = Route.toSeriesListFileUrl (route)
            , expect = Http.expectJson (GotSeriesListResponse) (Json.list Series.jsonDecoder)
            }


-- view - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


view : Model -> Html Msg
view model =
   let
      seriesId = Route.toSeriesId (model.route)
      --
      linkClass = if (String.isEmpty seriesId)
         then "Overview Link Current"
         else "Overview Link"
      --
      topicUrl = "/" ++ Route.toTopicId (model.route)
   in
      nav [ class "Overview Base" ] (List.append
         [ a [ class (linkClass), href (topicUrl) ] [ text "Overview" ] ]
         (List.map (ovrLink model.route) (model.seriesList))
      ) -- nav.Overview.Base

--
ovrLink : Route -> Series -> Html Msg
ovrLink route series =
   let
      currentId = Route.toSeriesId (route)
      --
      linkClass = case (compare (series.id) (currentId)) of
         EQ -> "Overview Link Current"
         _  -> "Overview Link"
      --
      seriesUrl = (Route.toTopicUrl route) ++ "/" ++ series.id
   in
      a [ class (linkClass), href (seriesUrl) ] [ text (series.title) ]


-- update - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case (msg) of
   
   --
   UrlChanged newUrlStr ->
      let
         newRoute = Route.fromUrlString (newUrlStr)
         oldTopicId = Route.toTopicId (model.route)
         newTopicId = Route.toTopicId (newRoute)
      in
         case (compare (newTopicId) (oldTopicId)) of
            EQ ->
               let
                  updatedModel = { model | route = newRoute }
               in
                  ( updatedModel, Cmd.none )
            --
            _  ->
               init (newUrlStr)
   
   --
   GotSeriesListResponse res -> case (res) of
      --
      (Err error) ->
         let 
            errMsg = HttpError.toString (error)
            emptySeries = Series.empty
            errorSeries = { emptySeries | title = errMsg }
            newSeriesList = [ errorSeries, emptySeries ]
            --
            updatedModel = { model | seriesList = newSeriesList } 
         in
            ( updatedModel, Cmd.none )
      --
      (Ok data) ->
         let
            updatedModel = { model | seriesList = data }
         in
            ( updatedModel, Cmd.none )


-- subscriptions - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none


