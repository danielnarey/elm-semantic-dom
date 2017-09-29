module Dom.Text exposing
  ( node )

{-| Construct a text node
-}

import VirtualDom
import Dom


{-| Alias for `VirtualDom.text`
-}
node : String -> Dom.Node msg
node =
  VirtualDom.text
