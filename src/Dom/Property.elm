module Dom.Property exposing
  ( bool, string, int, float )

{-|

Set the value of an
[IDL attribute](http://developer.mozilla.org/en-US/docs/Web/HTML/Attributes#Content_versus_IDL_attributes)
(a.k.a. "JavaScript property").

The functions in this module wrap `VirtualDom.property`.

See
[here](https://stackoverflow.com/questions/3919291/when-to-use-setattribute-vs-attribute-in-javascript)
for some background on when to use the functions in this module versus the
functions in `Dom.Attribute`.

@docs bool, string, int, float

-}

import VirtualDom
import Json.Encode


{-| Set a property that takes a boolean value; the first argument gives the
*value* and the second argument gives the *key*

    [ "controls"
      |> Dom.Property.bool True
    ]
      |> Dom.Node.leaf "video"

-}
bool : Bool -> String -> VirtualDom.Property msg
bool value key =
  value
    |> Json.Encode.bool
    |> VirtualDom.property key



{-| Set a property that takes a string value; the first argument gives the
*value* and the second argument gives the *key*

    "Hello World!"
      |> Dom.Element.textWrapper "p"
      |> Dom.Element.withAttributes
        [ "title"
          |> Dom.Property.string "Hello, again!"
        ]

-}
string : String -> String -> VirtualDom.Property msg
string value key =
  value
    |> Json.Encode.string
    |> VirtualDom.property key


{-| Set a property that takes an integer value; the first argument gives the
*value* and the second argument gives the *key*

    [ "rows"
      |> Dom.Property.int 10
    ]
      |> Dom.Node.leaf "textarea"


-}
int : Int -> String -> VirtualDom.Property msg
int value key =
  value
    |> Json.Encode.int
    |> VirtualDom.property key


{-| Set a property that takes a floating point value; the first argument gives
the *value* and the second argument gives the *key*

    [ "type"
      |> Dom.Property.string "number"
    , "min"
      |> Dom.Property.int 0
    , "max"
      |> Dom.Property.int 1
    , "step"
      |> Dom.Property.float 0.1
    ]
      |> Dom.Node.leaf "input"

-}
float : Float -> String -> VirtualDom.Property msg
float value key =
  value
    |> Json.Encode.float
    |> VirtualDom.property key
