module Dom.Event exposing
  ( action, capture, submit, custom, customWithOptions )

{-| The functions in this module may be used to construct event attributes,
as described [here](https://developer.mozilla.org/en-US/docs/Web/Events).

See the
[Elm Architecture](https://guide.elm-lang.org/architecture/)
documentation to find out more about how events are handled in Elm.

@docs action, capture, submit, custom, customWithOptions

-}

import VirtualDom
import Json.Decode
import Dict exposing (Dict)


{-| Let's define an *action* as an Dom event that triggers something else to
happen, but does not capture an input value. To handle an action on a Dom
element, we need to construct an attribute with an
[event name](https://developer.mozilla.org/en-US/docs/Web/Events) and a
message that will be sent to the Elm program's update function.

*How do we know what message to send?* The message will be one of a set of
values belonging to a programmer-defined type. Here's an abbreviated example:

    type Msg
      = Increment
      | Decrement

    plusButton =
      "+"
        |> Dom.Node.textWrapper "button"
          [ "click"
            |> Dom.Event.action Increment
          ]

See the
[Elm Architecture](https://guide.elm-lang.org/architecture/)
documentation for further explanation.

-}
action : msg -> String -> VirtualDom.Property msg
action msg event =
  msg
    |> Json.Decode.succeed
    |> VirtualDom.on event


{-| When we do want to capture an input value from the user, we need to set
things up a little differently. To send the message, the program needs to get
the input value first, so the first argument here is actually a function that
takes a string (the input value) and returns a programmer-defined message. In
most cases, the event name given in the second argument will be "input", because
the idea is to capture the value whenever it changes.

Again, the message will be handled by the Elm program's update function, which
will grab the current value of the element's `value` attribute.

Here's another abbreviated example:

    type Msg
      = Input String

    inputElement =
      [ "input"
        |> Dom.Event.capture Input
      ]
        |> Dom.Node.leaf "input"


See the
[Elm Architecture](https://guide.elm-lang.org/architecture/)
documentation for further explanation.

-}
capture : (String -> msg) -> String -> VirtualDom.Property msg
capture captureKey event =
  Json.Decode.string
    |> Json.Decode.at ["target", "value"]
    |> Json.Decode.map captureKey
    |> VirtualDom.on event


{-| Sometimes, instead of capturing input as the user enters it, it is
preferable to wait until a set of input fields have been completed, then
collect all of the input values at once. The `submit` event on an HTML `<form>`
provides an easy way to do this, but the Elm Architecture currently lacks a
standard approach to capturing input in response to a `submit` event. This
function offers one solution.

The function works by taking a list of id strings corresponding to the `id`
attributes of the form's input elements and constructing a decoder that will
capture input from all of the fields at once in response to a `submit` event.
The input is sent to the Elm program's update function as a `Dict` with the
id strings as the keys.

Here's another abbreviated example:

    type Msg
      = SubmitForm (Dict String String)

    formElementIds =
      [ "name"
      , "address"
      , "city"
      , "state"
      , "zip"
      , "email"
      ]

    myForm =
      formElements
        |> Dom.Element.container "form"
        |> Dom.Element.withAttributes
          [ formElementIds
            |> Dom.Event.submit SubmitForm
          ]

-}
submit : (Dict String String -> msg) -> List String -> VirtualDom.Property msg
submit captureKey idList =
  let
    inputDecoder idString =
      Json.Decode.string
        |> Json.Decode.at ["target", "elements", idString, "value"]

    mapDictInsert dict (key, value) =
      dict
        |> Json.Decode.map3 Dict.insert key value

    buildDecoder idList dictDecoder =
      case idList of
        [] ->
          dictDecoder

        first :: remaining ->
          ( first
            |> Json.Decode.succeed
          , first
            |> inputDecoder
          )
            |> mapDictInsert dictDecoder
            |> buildDecoder remaining

  in
    Dict.empty
      |> Json.Decode.succeed
      |> buildDecoder idList
      |> Json.Decode.map captureKey
      |> VirtualDom.onWithOptions "submit"
        { stopPropagation = False
        , preventDefault = True
        }


{-| Handle an event with a custom JSON decoder; alias for `VirtualDom.on` with
the arguments flipped

-}
custom : Json.Decode.Decoder msg -> String -> VirtualDom.Property msg
custom decoder string =
  decoder
    |> VirtualDom.on string


{-| Handle an event with a custom JSON decoder and specified options; alias for
`VirtualDom.onWithOptions` with the first and last arguments flipped

The `Options` argument is a record defined as follows:

    type alias Options =
      { stopPropagation : Bool
      , preventDefault : Bool
      }

Both values default to false where not specified.

-}
customWithOptions : Json.Decode.Decoder msg -> Options -> String -> VirtualDom.Property msg
customWithOptions decoder options string =
  decoder
    |> VirtualDom.onWithOptions string options


type alias Options =
  { stopPropagation : Bool
  , preventDefault : Bool
  }
