module DOM.Style exposing
  ( toProperty )

{-| Construct a `style` property from a list of style declarations

@docs toProperty

-}
import DOM
import VirtualDom


{-| Alias for `VirtualDom.style`
-}
toProperty : List (String, String) -> DOM.Property msg
toProperty =
  VirtualDom.style
