module Dom.Style exposing
  ( toProperty )

{-| Construct a `style` property from a list of style declarations

@docs toProperty

-}
import Dom
import VirtualDom


{-| Alias for `VirtualDom.style`
-}
toProperty : List (String, String) -> Dom.Property msg
toProperty =
  VirtualDom.style
