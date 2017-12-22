module Dom exposing
  ( Node, Property, Element )

{-| Type declarations

@docs Node, Property, Element

-}

import VirtualDom


{-| Alias for `VirtualDom.Node` — the native data structure Elm uses to
represent HTML, SVG, and potentially other namespaced elements

-}
type alias Node msg =
  VirtualDom.Node msg


{-| Alias for `VirtualDom.Property` — the native data structure Elm uses to
represent both
[content attributes](http://developer.mozilla.org/en-US/docs/Web/HTML/Attributes#Content_versus_IDL_attributes)
and
[IDL attributes](http://developer.mozilla.org/en-US/docs/Web/HTML/Attributes#Content_versus_IDL_attributes)
(a.k.a. "JavaScript properties")


-}
type alias Property msg =
  VirtualDom.Property msg


{-| An Elm record that contains all of the data needed to construct a
`VirtualDom.Node`

By using a record to temporarily store data about a node, we can partially
construct that node with some data, but delay building it until all of the data
has been assembled. In this way, all of a node's data is available to be
modified until it is either placed in a container element or passed as an
argument to the `Dom.Element.toNode` function.

-}
type alias Element msg =
  { tag : String
  , id : String
  , attributes : List (Property msg)
  , classes : List String
  , children : List (Node msg)
  , text : String
  , namespace : String
  , keys : List String
  }
