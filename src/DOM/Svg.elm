module DOM.Svg exposing
  ( leaf, textWrapper, container, element, wrapNodes )

{-|

This module contains helper functions for constructing `DOM.Type.Element`
records with the SVG namespace designation. Use these functions for any SVG
tags in your DOM.

# DOM.Node constructors
These constructors wrap `VirtualDom.node`, with the same pattern as the
functions in the DOM.Node module
@docs leaf, textWrapper, container

# DOM.Element constructors
@docs element, wrapNodes
-}

import VirtualDom
import Json.Encode
import DOM.Element
import DOM


{-| Construct a leaf node in the SVG namespace

-}
leaf : String -> List (DOM.Property msg) -> DOM.Node msg
leaf htmlTag attributeList =
  []
    |> VirtualDom.node htmlTag
      ( ( "http://www.w3.org/2000/svg"
          |> Json.Encode.string
          |> VirtualDom.property "namespace"
        )
          :: attributeList
      )



{-| Construct a node with internal text in the SVG namespace

-}
textWrapper : String -> List (DOM.Property msg) -> String -> DOM.Node msg
textWrapper htmlTag attributeList someText =
  [ someText
    |> VirtualDom.text
  ]
    |> VirtualDom.node htmlTag
      ( ( "http://www.w3.org/2000/svg"
          |> Json.Encode.string
          |> VirtualDom.property "namespace"
        )
          :: attributeList
      )


{-| Construct a node in the SVG namespace that contains other nodes

-}
container : String -> List (DOM.Property msg) -> List (DOM.Node msg) -> DOM.Node msg
container htmlTag attributeList childList =
  childList
    |> VirtualDom.node htmlTag
      ( ( "http://www.w3.org/2000/svg"
          |> Json.Encode.string
          |> VirtualDom.property "namespace"
        )
          :: attributeList
      )


{-| Construct an element record in the SVG namespace, with the tag given as a
string argument; same pattern as `DOM.Element.leaf`

    "circle"
      |> DOM.Svg.element

-}
element : String -> DOM.Element msg
element svgTag =
  { tag = svgTag
  , attributes = []
  , classes = []
  , children = []
  , text = ""
  , namespace = "http://www.w3.org/2000/svg"
  , keys = []
  }


{-| Wrap a list of SVG nodes in an SVG container element; the first
argument gives the tag, and the second argument gives a list of child nodes

    myPolygonNodes
      |> DOM.Svg.wrapNodes "g"

-}
wrapNodes : String -> List (DOM.Node msg) -> DOM.Element msg
wrapNodes htmlTag childNodes =
  { tag = htmlTag
  , attributes = []
  , classes = []
  , children = childNodes
  , text = ""
  , namespace = "http://www.w3.org/2000/svg"
  , keys = []
  }
