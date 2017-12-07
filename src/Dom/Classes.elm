module Dom.Classes exposing
  ( toProperty )

{-| Construct a `className` property from a list of classes

@docs toProperty

-}
import Dom
import Json.Encode
import VirtualDom


{-| Bundles up a list of class names and returns a `Dom.Property`
-}
toProperty : List String -> Dom.Property msg
toProperty classList =
  classList
    |> String.join " "
    |> Json.Encode.string
    |> VirtualDom.property "className"
