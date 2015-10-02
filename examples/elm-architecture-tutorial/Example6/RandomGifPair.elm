module Example6.RandomGifPair where

import Effects exposing (Effects)
import Html exposing (..)
import Html.Attributes exposing (..)

import Example6.RandomGif as RandomGif


-- MODEL

type alias Model =
    { left : RandomGif.Model
    , right : RandomGif.Model
    }


-- Rewrote to move initialization strings from Main.elm
init : (Model, Effects Action)
init =
  let
    leftTopic = "funny cats"
    rightTopic = "funny dogs"
    (left, leftFx) = RandomGif.init leftTopic
    (right, rightFx) = RandomGif.init rightTopic
  in
    ( Model left right
    , Effects.batch
        [ Effects.map Left leftFx
        , Effects.map Right rightFx
        ]
    )


-- UPDATE

type Action
    = Left RandomGif.Action
    | Right RandomGif.Action


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    Left act ->
      let
        (left, fx) = RandomGif.update act model.left
      in
        ( Model left model.right
        , Effects.map Left fx
        )

    Right act ->
      let
        (right, fx) = RandomGif.update act model.right
      in
        ( Model model.left right
        , Effects.map Right fx
        )


-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div [ style [ ("display", "flex") ] ]
    [ RandomGif.view (Signal.forwardTo address Left) model.left
    , RandomGif.view (Signal.forwardTo address Right) model.right
    ]


-- We add a separate function to get a title, which the ExampleViewer uses to
-- construct a table of contents. Sometimes, you might have a function of this
-- kind return `Html` instead, depending on where it makes sense to do some of
-- the construction. Or, you could track the title in the higher level module,
-- if you prefer that.
title : String
title = "Pair of Random Gifs"
