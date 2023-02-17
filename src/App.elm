module App exposing (main)

import Route exposing (Route(..))
--
import Element.Navigator as Navigator
import Element.Overview as Overview
import Element.Indexer as Indexer
import Element.Reader as Reader
import Element.Metadata as Metadata

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Browser exposing (Key)
import Url exposing (Url)
import Html


-- main - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


main : Program () Model Msg
main =
   let
      spa = App (init) (view) (update) (subscriptions) (onUrlRequest) (onUrlChange)
   in
      Browser.application (spa)


-- App - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias App =
   { init : () -> Url -> Key -> ( Model, Cmd Msg )
   , view : Model -> Document Msg
   , update : Msg -> Model -> ( Model, Cmd Msg )
   , subscriptions : Model -> Sub Msg
   , onUrlRequest : UrlRequest -> Msg
   , onUrlChange : Url -> Msg
   }


-- Model - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Model =
   { url : Url
   , key : Key
     --
   , route : Route
     --
   , navigator : Navigator.Model
   , overview  : Overview.Model
   , indexer   : Indexer.Model
   , reader    : Reader.Model
   , metadata  : Metadata.Model
   }


-- Msg - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type Msg = PortJson String
           --
         | GotUrlRequest UrlRequest
         | UrlChanged Url
           --
         | NavMsg Navigator.Msg
         | OvrMsg Overview.Msg
         | IdxMsg Indexer.Msg
         | RdrMsg Reader.Msg
         | MtdMsg Metadata.Msg


-- init - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


init : () -> Url -> Key -> ( Model, Cmd Msg )
init _ url key =
   let
      route = Route.fromUrl (url)
      --
      ( navModel, navCmd ) = Navigator.init (Url.toString url)
      ( ovrModel, ovrCmd ) = Overview.init (Url.toString url)
      ( idxModel, idxCmd ) = Indexer.init (Url.toString url)
      ( rdrModel, rdrCmd ) = Reader.init (Url.toString url)
      ( mtdModel, mtdCmd ) = Metadata.init (Url.toString url)
      --
      model =
         { url = url
         , key = key
           --
         , route = route
           --
         , navigator = navModel
         , overview = ovrModel
         , indexer = idxModel
         , reader = rdrModel
         , metadata = mtdModel
         }
      --
      cmd =
         Cmd.batch [ Cmd.map (NavMsg) (navCmd)
                   , Cmd.map (OvrMsg) (ovrCmd)
                   , Cmd.map (IdxMsg) (idxCmd)
                   , Cmd.map (RdrMsg) (rdrCmd)
                   , Cmd.map (MtdMsg) (mtdCmd)
                   ]
   --
   in
      ( model, cmd )


-- view - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


view : Model -> Document Msg
view model =
   let
      navHtml = Navigator.view (model.navigator)
      ovrHtml = Overview.view (model.overview)
      idxHtml = Indexer.view (model.indexer)
      rdrHtml = Reader.view (model.reader)
      mtdHtml = Metadata.view (model.metadata)
      --
      pageHtml = case (model.route) of
         --
         SeriesPage _ _ ->
            [ Html.map (NavMsg) (navHtml)
            , Html.map (OvrMsg) (ovrHtml)
            , Html.map (IdxMsg) (idxHtml)
            , Html.map (MtdMsg) (mtdHtml)
            ]
         --
         _ -> [ Html.map (NavMsg) (navHtml)
              , Html.map (OvrMsg) (ovrHtml)
              , Html.map (RdrMsg) (rdrHtml)
              , Html.map (MtdMsg) (mtdHtml)
              ]
   --
   in
      { title = "Semi Dev_ 's Blog"
      , body = pageHtml
      }


-- update - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case (msg) of
   
   --
   PortJson _ -> ( model, Cmd.none )
   
   --
   GotUrlRequest req -> case (req) of
      --
      Browser.External href ->
         let
            cmd = Browser.load (href)
         in
            ( model, cmd )
      --
      Browser.Internal newUrl ->
         let
            appMsg = NavMsg (Navigator.CollapseFolder)
            ( updatedModel, cmd1 ) = update (appMsg) (model)
            --
            urlStr = Url.toString (newUrl)
            cmd2 = Browser.pushUrl (model.key) (urlStr) 
         in
            ( updatedModel, Cmd.batch [ cmd1, cmd2 ] )
   
   --
   UrlChanged newUrl ->
      let
         newRoute = Route.fromUrl (newUrl)
         --
         newUrlStr = Url.toString (newUrl)
         ( navModel, navCmd ) = Navigator.update (Navigator.UrlChanged newUrlStr) (model.navigator)
         ( ovrModel, ovrCmd ) = Overview.update (Overview.UrlChanged newUrlStr) (model.overview)
         ( idxModel, idxCmd ) = Indexer.update (Indexer.UrlChanged newUrlStr) (model.indexer)
         ( rdrModel, rdrCmd ) = Reader.update (Reader.UrlChanged newUrlStr) (model.reader)
         ( mtdModel, mtdCmd ) = Metadata.update (Metadata.UrlChanged newUrlStr) (model.metadata)
         --
         updatedModel = { model | url = newUrl
                        , route = newRoute
                          --
                        , navigator = navModel
                        , overview = ovrModel
                        , indexer = idxModel
                        , reader = rdrModel
                        , metadata = mtdModel
                        }
         cmd = Cmd.batch [ Cmd.map (NavMsg) (navCmd)
                         , Cmd.map (OvrMsg) (ovrCmd)
                         , Cmd.map (IdxMsg) (idxCmd)
                         , Cmd.map (RdrMsg) (rdrCmd)
                         , Cmd.map (MtdMsg) (mtdCmd)
                         ]
      --
      in
         ( updatedModel, cmd )
   
   --
   NavMsg navMsg ->
      let
         ( updatedNavModel, navCmd) = Navigator.update (navMsg) (model.navigator)
         --
         updatedAppModel = { model | navigator = updatedNavModel }
         cmd = Cmd.map (NavMsg) (navCmd)
      in
         ( updatedAppModel, cmd )
   
   --
   OvrMsg ovrMsg ->
      let
         ( updatedOvrModel, ovrCmd) = Overview.update (ovrMsg) (model.overview)
         --
         updatedAppModel = { model | overview = updatedOvrModel }
         cmd = Cmd.map (OvrMsg) (ovrCmd)
      in
         ( updatedAppModel, cmd )
   
   --
   IdxMsg idxMsg ->
      let
         ( updatedIdxModel, idxCmd) = Indexer.update (idxMsg) (model.indexer)
         --
         updatedAppModel = { model | indexer = updatedIdxModel }
         cmd = Cmd.map (IdxMsg) (idxCmd)
      in
         ( updatedAppModel, cmd )
   
   --
   RdrMsg rdrMsg ->
      let
         ( updatedRdrModel, rdrCmd ) = Reader.update (rdrMsg) (model.reader)
         --
         updatedAppModel = { model | reader = updatedRdrModel }
         cmd = Cmd.map (RdrMsg) (rdrCmd)
      in
         ( updatedAppModel, cmd )
         
   --
   MtdMsg mtdMsg ->
      let
         ( updatedMtdModel, mtdCmd ) = Metadata.update (mtdMsg) (model.metadata)
         --
         updatedAppModel = { model | metadata = updatedMtdModel }
         cmd = Cmd.map (MtdMsg) (mtdCmd)
      in
         ( updatedAppModel, cmd )


-- subscriptions - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none


-- onUrlRequest - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


onUrlRequest : UrlRequest -> Msg
onUrlRequest req = GotUrlRequest (req)


-- onUrlChange - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


onUrlChange : Url -> Msg
onUrlChange newUrl = UrlChanged (newUrl)


