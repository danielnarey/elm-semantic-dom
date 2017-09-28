module DOM.Attribute exposing
  ( string, int, float, namespaced )

{-|

Set the value of a
[content attribute](http://developer.mozilla.org/en-US/docs/Web/HTML/Attributes#Content_versus_IDL_attributes)

The functions in this module wrap `VirtualDom.attribute`, which should always
be used when setting attributes on SVG nodes and may also be used to set
nonstandard HTML attributes.

See
[here](https://stackoverflow.com/questions/3919291/when-to-use-setattribute-vs-attribute-in-javascript)
for some background on when to use the functions in this module versus the
functions in `DOM.Property`.

@docs string, int, float, namespaced

-}

import VirtualDom
import Json.Encode


{-| Set an attribute by giving its value as a string; the first argument gives
the *value* and the second argument gives the *key*

    myGraphics
      |> DOM.Svg.container "svg"
        [ "viewbox"
          |> DOM.Attribute.string "0 0 400 400"
        ]

-}
string : String -> String -> VirtualDom.Property msg
string value key =
  value
    |> VirtualDom.attribute key


{-| Set an attribute by giving its value as an integer, which will be converted
to a string; the first argument gives the *value* and the second argument gives
the *key*

    "Hello World!"
      |> DOM.Svg.textWrapper "text"
        [ "x"
          |> DOM.Attribute.int 200
        , "y"
          |> DOM.Attribute.int 200
        ]

-}
int : Int -> String -> VirtualDom.Property msg
int value key =
  value
    |> toString
    |> VirtualDom.attribute key


{-| Set an attribute by giving its value as a floating point number, which will
be converted to a string; the first argument gives the *value* and the second
argument gives the *key*

    myShapeElement
      |> DOM.Element.addAttribute
        ( "stroke-width"
          |> DOM.Attribute.float 0.5
        )

-}
float : Float -> String -> VirtualDom.Property msg
float  value key =
  value
    |> toString
    |> VirtualDom.attribute key


{-| Set an attribute in a given namespace; the first argument gives the
namespace prefix and URL, the second argument is the value, and the third
argument is the key

    "script"
      |> DOM.Element.leaf
      |> DOM.Element.withAttributes
        [ "href"
          |> DOM.Attribute.namespaced ("xlink", "http://www.w3.org/1999/xlink") "cool-script.js"
        , "type"
          |> DOM.Attribute.string "text/ecmascript"
        ]

See
[here](https://developer.mozilla.org/en-US/docs/Web/SVG/Namespaces_Crash_Course)
for an explanation of the use of namespaces in XML generally, and in SVG more
specifically.

-}
namespaced : (String, String) -> String -> String -> VirtualDom.Property msg
namespaced (prefix, url) value key =
  value
    |> VirtualDom.attributeNS url (prefix ++ ":" ++ key)
