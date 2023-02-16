module Element.Metadata exposing (..)


-- main - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


main : Program String Model Msg
main =
   let 
      mtd = Metadata (init) (view) (update) (subscriptions)
   in
      Browser.element (mtd)


-- Metadata - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type alias Metadata =
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
   , seriesList : List Series
   , postList : List Post
   }


-- Msg - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


type Msg = UrlChanged String


-- init - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


init : String -> ( Model, Cmd Msg )
init urlStr =
   let
      model =
         { route = Route.fromUrlString (urlStr)
           --
         , topicList = []
         , seriesList = []
         , postList = []
         }
      cmd = Cmd.batch [ Cmd.none
                      ]
   in
      ( model, cmd )


-- view - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


view : Model -> Html Msg
view _ = text ""  


-- update - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


update : Msg -> Model -> ( Model, Cmd Msg )


-- subscriptions - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


subscriptions : Model -> Sub Msg
subscriptions _ -> Sub.none


