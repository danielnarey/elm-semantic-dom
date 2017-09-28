module DOM.Element exposing
  ( leaf, textWrapper, container, wrapNodes
  , toNode
  , withClasses, addClass, removeClass
  , withAttributes, addAttribute
  , withText, appendText, prependText
  , withChildren, appendChild, prependChild, withChildNodes
  , setNamespace
  , hasChildren, hasText, hasClass
  )

{-|

This module contains functions for constructing, modifying, and rendering
`DOM.Element` records.

By using a record to temporarily store data about a node, we can partially
construct that node with some data, but delay building it until all of the data
has been assembled. In this way, all of a node's data is available to be
modified until it is either placed in a container element or passed as an
argument to the `DOM.Element.toNode` function.

The rendering function wraps up the data collected in the element record as
arguments to `VirtualDom.node`. There is minimal overhead with this approach,
but where performance or memory use is of particular concern, it will be better
to construct nodes directly with the functions in module `DOM.Node`, or by using
the standard *elm-lang/html* and *elm-lang/svg* packages.


# Constructors

@docs leaf, textWrapper, container, wrapNodes

# Rendering

@docs toNode

# Classes

@docs withClasses, addClass, removeClass

# Attributes

@docs withAttributes, addAttribute

# Text

@docs withText, appendText, prependText

# Children

@docs withChildren, appendChild, prependChild, withChildNodes

# Namespace

@docs setNamespace

# Queries

@docs hasChildren, hasText, hasClass

-}

import DOM

import VirtualDom
import Json.Encode


-- CONSTRUCTORS

{-| Construct a leaf element (an element without children), with the tag given
as a string argument

    DOM.Element.leaf "hr"

-}
leaf : String -> DOM.Element msg
leaf htmlTag =
  { tag = htmlTag
  , attributes = []
  , classes = []
  , children = []
  , text = ""
  , namespace = ""
  , keys = []
  }


{-| Construct an element that wraps text; the first argument gives the tag, and
the second argument gives the internal text

    "Hello World!"
      |> DOM.Element.textWrapper "p"

-}
textWrapper : String -> String -> DOM.Element msg
textWrapper htmlTag someText =
  { tag = htmlTag
  , attributes = []
  , classes = []
  , children = []
  , text = someText
  , namespace = ""
  , keys = []
  }


{-| Construct an element that contains other elements; the first argument gives
the tag, and the second argument gives a list of child elements

    [ "Hello World!"
      |> DOM.Element.textWrapper "p"
    ]
      |> DOM.Element.container "div"

-}
container : String -> List (DOM.Element msg) -> DOM.Element msg
container htmlTag childList =
  { tag = htmlTag
  , attributes = []
  , classes = []
  , children =
      childList
        |> List.map toNode
  , text = ""
  , namespace = ""
  , keys = []
  }


{-| Wrap a list of native `VirtualDom` nodes in a container element; the first
argument gives the tag, and the second argument gives a list of child nodes

    [ "Hello World!"
      |> DOM.Node.textWrapper "p" []
    ]
      |> DOM.Element.wrapNodes "div"

-}
wrapNodes : String -> List (DOM.Node msg) -> DOM.Element msg
wrapNodes htmlTag childNodes =
  { tag = htmlTag
  , attributes = []
  , classes = []
  , children = childNodes
  , text = ""
  , namespace = ""
  , keys = []
  }


-- RENDERING

{-| Generate a `VirtualDom.Node` from a `DOM.Type.Element` record

    [ "Hello World!"
      |> DOM.Element.textWrapper "p"
    ]
      |> DOM.Element.container "div"
      |> DOM.Element.toNode

-}
toNode : DOM.Element msg -> VirtualDom.Node msg
toNode element =
  let
    consClassName attributeList =
      case element.classes of
        [] ->
          attributeList

        _ ->
          ( element.classes
            |> String.join " "
            |> String.trim
            |> Json.Encode.string
            |> VirtualDom.property "className"
          )
            :: attributeList

    consNamespace attributeList =
      case element.namespace of
        "" ->
          attributeList

        _ ->
          ( element.namespace
            |> Json.Encode.string
            |> VirtualDom.property "namespace"
          )
            :: attributeList

    consText childList =
      case element.text of
          "" ->
            childList

          _ ->
            ( element.text
              |> VirtualDom.text
            )
              :: childList

    consTextKeyed keyedList =
      case element.text of
          "" ->
            keyedList

          _ ->
            ( element.text
              |> VirtualDom.text
              |> (,) ("internal-text")
            )
              :: keyedList

  in
    case element.keys of
      [] ->
        element.children
          |> consText
          |> VirtualDom.node element.tag
            ( element.attributes
              |> consClassName
              |> consNamespace
            )

      _ ->
        element.children
          |> List.map2 (,) element.keys
          |> consTextKeyed
          |> VirtualDom.keyedNode element.tag
            ( element.attributes
              |> consClassName
              |> consNamespace
            )


-- CLASSES


{-| Update an element's classes, replacing any existing classes; classes are
combined into a single `className` property when the rendering function is
called

    myElement =
      [ "Hello World!"
        |> DOM.Element.textWrapper "p"
        |> DOM.Element.withClasses
          [ "size-large"
          , "weight-bold"
          ]
      ]
        |> DOM.Element.container "div"

-}
withClasses : List String -> DOM.Element msg -> DOM.Element msg
withClasses classList n =
  { n
  | classes = classList
  }


{-| Add a new class to the existing classes of an element

    myElement
      |> DOM.Element.addClass "bordered-box"

-}
addClass : String -> DOM.Element msg -> DOM.Element msg
addClass newClass n =
  { n
  | classes =
      newClass :: n.classes
  }


{-| Remove a particular class from an element, retaining other assigned classes

    myElement
      |> DOM.Element.removeClass "bordered-box"

-}
removeClass : String -> DOM.Element msg -> DOM.Element msg
removeClass classToRemove n =
  { n
  | classes =
      n.classes
        |> List.filter ((/=) classToRemove)
  }



-- ATTRIBUTES

{-| Update an element's attributes, replacing any existing attributes

    (You get the pattern by this point...)
-}
withAttributes : List (VirtualDom.Property msg) -> DOM.Element msg -> DOM.Element msg
withAttributes attributeList n =
  { n
  | attributes = attributeList
  }


{-| Add a new attribute to the existing attributes of an element
-}
addAttribute : VirtualDom.Property msg -> DOM.Element msg -> DOM.Element msg
addAttribute newAttribute n =
  { n
  | attributes =
      [ newAttribute ]
        |> List.append n.attributes
  }


-- TEXT

{-| Update an element's text, replacing any existing text
-}
withText : String -> DOM.Element msg -> DOM.Element msg
withText someText n =
  { n
  | text = someText
  }


{-| Append new text to an element, after any existing text
-}
appendText : String -> DOM.Element msg -> DOM.Element msg
appendText moreText n =
  { n
  | text =
      moreText
        |> String.append n.text
  }


{-| Prepend new text to an element, before any existing text
-}
prependText : String -> DOM.Element msg -> DOM.Element msg
prependText moreText n =
  { n
  | text =
      n.text
        |> String.append moreText
  }


-- CHILDREN

{-| Update an element's children, replacing any existing children
-}
withChildren : List (DOM.Element msg) -> DOM.Element msg -> DOM.Element msg
withChildren childList n =
  { n
  | children =
      childList
        |> List.map toNode
  }


{-| Append a new child to an element, after any existing children
-}
appendChild : DOM.Element msg -> DOM.Element msg -> DOM.Element msg
appendChild newChild n =
  { n
  | children =
      [ newChild
        |> toNode
      ]
        |> List.append n.children
  }


{-| Prepend a new child to an element, before any existing children
-}
prependChild : DOM.Element msg -> DOM.Element msg -> DOM.Element msg
prependChild newChild n =
  { n
  | children =
      ( newChild
        |> toNode
      )
        :: n.children
  }


{-| Update an element's children, with a list of native `VirtualDom` nodes given
as the first argument in place of a list of element records
-}
withChildNodes : List (DOM.Node msg) -> DOM.Element msg -> DOM.Element msg
withChildNodes nodeList n =
  { n
  | children =
      nodeList
  }


-- NAMESPACE

{-| Set an element's XML namespace
-}
setNamespace : String -> DOM.Element msg -> DOM.Element msg
setNamespace url n =
  { n
  | namespace = url
  }


-- QUERIES

{-| Returns `True` if the element has children
-}
hasChildren : DOM.Element msg -> Bool
hasChildren element =
  case element.children of
    [] ->
      False

    _ ->
      True


{-| Returns `True` if the element has text
-}
hasText : DOM.Element msg -> Bool
hasText element =
  case element.text of
    "" ->
      False

    _ ->
      True


{-| Returns `True` if the element's class list contains the name given in the
first argument
-}
hasClass : String -> DOM.Element msg -> Bool
hasClass name element =
  element.classes
    |> List.member name
