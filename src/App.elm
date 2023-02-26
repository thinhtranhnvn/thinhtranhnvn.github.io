module App exposing (main)

import Route exposing (Route(..))
import Context
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
   , context : Context.Model
     --
   , navigator : Navigator.Model
   , overview  : Overview.Model
   , indexer   : Indexer.Model
   , reader    : Reader.Model
   , metadata  : Metadata.Model
   }


-- Msg - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type Msg = GotUrlRequest UrlRequest
         | UrlChanged Url
           --
         | CtxMsg Context.Msg
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
      ( ctxModel, ctxCmd ) = Context.init (Url.toString url)
      --
      ( navModel, _ ) = Navigator.init (ctxModel)
      ( ovrModel, _ ) = Overview.init  (ctxModel)
      ( idxModel, _ ) = Indexer.init   (ctxModel)
      ( rdrModel, _ ) = Reader.init    (ctxModel)
      ( mtdModel, _ ) = Metadata.init  (ctxModel)
      --
      model =
         { url = url
         , key = key
           --
         , route = route
         , context = ctxModel
           --
         , navigator = navModel
         , overview  = ovrModel
         , indexer   = idxModel
         , reader    = rdrModel
         , metadata  = mtdModel
         }
      cmd = Cmd.map (CtxMsg) (ctxCmd)
   --
   in
      ( model, cmd )


-- view - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


view : Model -> Document Msg
view model =
   let
      navHtml = Navigator.view (model.navigator)
      ovrHtml = Overview.view  (model.overview)
      idxHtml = Indexer.view   (model.indexer)
      rdrHtml = Reader.view    (model.reader)
      mtdHtml = Metadata.view  (model.metadata)
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
         ( ctxModel, ctxCmd ) = Context.update (Context.UrlChanged newUrlStr) (model.context)
         --
         updatedModel = { model | url = newUrl
                          --
                        , route = newRoute
                        , context = ctxModel
                        }
         cmd = Cmd.map (CtxMsg) (ctxCmd)
      --
      in
         ( updatedModel, cmd )
   
   --
   CtxMsg ctxMsg ->
      let
         ( ctxModel, ctxCmd ) = Context.update (ctxMsg) (model.context)
         --
         ( navModel, _ ) = Navigator.update (Navigator.ContextChanged ctxModel) (model.navigator)
         ( ovrModel, _ ) = Overview.update  (Overview.ContextChanged  ctxModel) (model.overview)
         ( rdrModel, _ ) = Reader.update    (Reader.ContextChanged    ctxModel) (model.reader)
         ( idxModel, _ ) = Indexer.update   (Indexer.ContextChanged   ctxModel) (model.indexer)
         ( mtdModel, _ ) = Metadata.update  (Metadata.ContextChanged  ctxModel) (model.metadata)
         --
         updatedAppModel = { model | context = ctxModel
                                     --
                                   , navigator = navModel
                                   , overview = ovrModel
                                   , reader = rdrModel
                                   , indexer = idxModel
                                   , metadata = mtdModel
                           }
         cmd = Cmd.map (CtxMsg) (ctxCmd)
      in
         ( updatedAppModel, cmd )
   
   --
   NavMsg navMsg ->
      let
         ( navModel, _ ) = Navigator.update (navMsg) (model.navigator)
         --
         updatedAppModel = { model | navigator = navModel }
      in
         ( updatedAppModel, Cmd.none )
   
   --
   _ -> ( model, Cmd.none )


-- subscriptions - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none


-- onUrlRequest - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


onUrlRequest : UrlRequest -> Msg
onUrlRequest req = GotUrlRequest (req)


-- onUrlChange - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


onUrlChange : Url -> Msg
onUrlChange newUrl = UrlChanged (newUrl)


