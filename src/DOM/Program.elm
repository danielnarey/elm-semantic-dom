module DOM.Program exposing
  ( setup, onLoad
  , update, updateWithCmds
  , subscribe, subscribeWithParams
  , run, runWithFlags, customWithFlags
  , Setup
  )

{-|

This module contains pipeline functions that can be helpful when setting up an
Elm program for initial testing and adding features as you go.

Construct a static program with just `setup` and `run` to test your initial
model and view. Then add interaction with `update`. Add DOM effects, HTTP
requests, and so on with `onLoad` and `updateWithCmds`. Add ports with
`subscribe` or `subscribeWithParams`. Use `runWithFlags` to pass data to your
initial model.

The `DOM.Program.run` function is an alias for `VirtualDom.program`, so just use
that if you want to set up a program in the standard way.

# Basic
@docs setup, update, run

# Commands
@docs onLoad, updateWithCmds

# Subscriptions
@docs subscribe, subscribeWithParams

# Flags
@docs runWithFlags

# Type alias
@docs Setup

-}

import VirtualDom
import DOM


{-| Type alias for arguments to `VirtualDom.program`
-}
type alias Setup model msg =
  { init : (model, Cmd msg)
  , update : msg -> model -> (model, Cmd msg)
  , subscriptions : model -> Sub msg
  , view : model -> DOM.Node msg
  }


{-| Generate a record that describes the setup of an Elm program; the first
argument is a function that takes a model and generates a view, and the second
argument is an initial model to pass to that function

These two function calls will setup and run a static program (a program where
the view doesn't update):

    main =
      initialModel
        |> Elm.Program.setup view
        |> Elm.Program.run

-}
setup : (model -> DOM.Node msg) -> model -> Setup model msg
setup viewFunction initialModel =
  { init = (initialModel, Cmd.none)
  , update = always (flip (,) Cmd.none)
  , subscriptions = always Sub.none
  , view = viewFunction
  }



{-| Route messages generated in the program to a function that will update the
initial model; the first argument is the update function, and the second
argument is the setup record
-}
update : (msg -> model -> model) -> Setup model msg -> Setup model msg
update updateFunction programSetup =
  { programSetup
  | update =
      ( \msg model ->
        model
          |> updateFunction msg
          |> flip (,) Cmd.none
      )
  }


{-| Tell the Elm compiler to generate a program from your setup

Alias for `VirtualDom.program`

-}
run : Setup model msg -> Program Never model msg
run =
  VirtualDom.program


{-| Modify your program setup to perform a list of commands when the program
loads

See the
[Elm Architecture](https://guide.elm-lang.org/architecture/)
documentation to find out more about commands.

-}
onLoad : List (Cmd msg) -> Setup model msg -> Setup model msg
onLoad cmds programSetup =
  { programSetup
  | init =
      programSetup.init
        |> Tuple.first
        |> flip (,) (cmds |> Cmd.batch)
  }


{-| Handle updates in a with a function that can also produce commands in
response to messages

See the
[Elm Architecture](https://guide.elm-lang.org/architecture/)
documentation to find out more about commands.

-}
updateWithCmds : (msg -> model -> (model, Cmd msg)) -> Setup model msg -> Setup model msg
updateWithCmds updateFunction programSetup =
  { programSetup
  | update = updateFunction
  }


{-| Receive data from ports

See the
[Elm Architecture](https://guide.elm-lang.org/architecture/)
documentation to find out more about ports and subscriptions.

-}
subscribe : List (Sub msg) -> Setup model msg -> Setup model msg
subscribe subs programSetup =
  { programSetup
  | subscriptions = always (subs |> Sub.batch)
  }


{-| Apply a custom function to control data flow from ports

See the
[Elm Architecture](https://guide.elm-lang.org/architecture/)
documentation to find out more about ports and subscriptions.

-}
subscribeWithParams : (model -> Sub msg) -> Setup model msg -> Setup model msg
subscribeWithParams subFunction programSetup =
  { programSetup
  | subscriptions = subFunction
  }


{-| Generate your initial model with data passed to your Elm program from the
JavaScript side, with the initial model specified in your setup as a fallback
if anything goes wrong

See the
[Elm Architecture](https://guide.elm-lang.org/architecture/)
documentation to find out more about flags.

-}
runWithFlags : (flags -> Maybe model) -> Setup model msg -> Program flags model msg
runWithFlags initializer programSetup =
  let
    (initialModel, loadCmd) =
      programSetup.init

  in
    { init =
        initializer
          >> Maybe.withDefault initialModel
          >> flip (,) loadCmd

    , update = programSetup.update
    , subscriptions = programSetup.subscriptions
    , view = programSetup.view
    }
      |> VirtualDom.programWithFlags


{-| Alias for `VirtualDom.programWithFlags`
-}
customWithFlags : { init : flags -> (model, Cmd msg), update : msg -> model -> (model, Cmd msg), subscriptions : model -> Sub msg, view : model -> DOM.Node msg } -> Program flags model msg
customWithFlags =
  VirtualDom.programWithFlags
