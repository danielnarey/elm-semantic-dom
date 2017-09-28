module DOM.Node exposing
  ( leaf, textWrapper, container )

{-| Construct native `VirtualDom` nodes

Using the constructors in this module is the more efficient way of building your
Elm program's DOM, but unlike DOM.Element records, native `VirtualDom` nodes
cannot be modified (within an Elm program) after they are constructed.

@docs leaf, textWrapper, container

-}

import DOM
import VirtualDom


{-| Construct a leaf node (a node without children); the first argument gives
the tag and the second argument gives a list of attributes

This function is an alias for `VirtualDom.node` with an empty list of child
nodes.

    DOM.Node.leaf "hr" []

-}
leaf : String -> List (DOM.Property msg) -> DOM.Node msg
leaf htmlTag attributeList =
  []
    |> VirtualDom.node htmlTag attributeList


{-| Construct a node that wraps text; the first argument gives the tag, the
second argument gives a list of attributes, and the third argument gives the
internal text

This function is an alias for `VirtualDom.node` with a single text node as the
only child.

    "Hello World!"
      |> DOM.Node.textWrapper "p" []

-}
textWrapper : String -> List (DOM.Property msg) -> String -> DOM.Node msg
textWrapper htmlTag attributeList someText =
  [ someText
    |> VirtualDom.text
  ]
    |> VirtualDom.node htmlTag attributeList


{-| Construct a node that contains other nodes; the first argument gives the
tag, the second argument gives a list of attributes, and the third argument
gives a list of child nodes

This function is just an alias for `VirtualDom.node`.

    [ "Hello World!"
      |> DOM.Node.textWrapper "p" []
    ]
      |> DOM.Node.container "div" []

-}
container : String -> List (DOM.Property msg) -> List (DOM.Node msg) -> DOM.Node msg
container =
  VirtualDom.node
