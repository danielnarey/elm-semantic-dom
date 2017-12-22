module Dom.Svg exposing
  ( leaf, textWrapper, container, element, wrapNodes )

{-|

This module contains helper functions for constructing `Dom.Element`
records with the SVG namespace designation. Use these functions for any SVG
tags in your DOM.

# Dom.Node constructors
These constructors wrap `VirtualDom.node`, with the same pattern as the
functions in the Dom.Node module
@docs leaf, textWrapper, container

# Dom.Element constructors
@docs element, wrapNodes
-}

import VirtualDom
import Json.Encode
import Dom.Element
import Dom


{-| Construct a leaf node in the SVG namespace

-}
leaf : String -> List (Dom.Property msg) -> Dom.Node msg
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
textWrapper : String -> List (Dom.Property msg) -> String -> Dom.Node msg
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
container : String -> List (Dom.Property msg) -> List (Dom.Node msg) -> Dom.Node msg
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
string argument; same pattern as `Dom.Element.leaf`

    "circle"
      |> Dom.Svg.element

-}
element : String -> Dom.Element msg
element svgTag =
  { tag = svgTag
  , id = ""
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
      |> Dom.Svg.wrapNodes "g"

-}
wrapNodes : String -> List (Dom.Node msg) -> Dom.Element msg
wrapNodes htmlTag childNodes =
  { tag = htmlTag
  , id = ""
  , attributes = []
  , classes = []
  , children = childNodes
  , text = ""
  , namespace = "http://www.w3.org/2000/svg"
  , keys = []
  }
