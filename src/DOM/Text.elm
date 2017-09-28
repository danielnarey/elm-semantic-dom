module DOM.Text exposing
  ( node )

{-| Construct a text node
-}

import VirtualDom
import DOM


{-| Alias for `VirtualDom.text`
-}
node : String -> DOM.Node msg
node =
  VirtualDom.text
