module DOM.Keyed exposing
  ( container, node )

{-| Support for the VirtualDom `keyedNode` optimization

From the *elm-lang/html* documentation:

> A keyed node helps optimize cases where children are getting added, moved,
> removed, etc. Common examples include:
>
>  - The user can delete items from a list.
>  - The user can create new items in a list.
>  - You can sort a list based on name or date or whatever.
>
> When you use a keyed node, every child is paired with a string identifier. This
> makes it possible for the underlying diffing algorithm to reuse nodes more
> efficiently."

@docs container, node

-}

import VirtualDom
import DOM
import DOM.Element
import DOM.Lazy


{-| Construct a container element where the child nodes are keyed with unique
identifiers in order to optimize updates to the DOM; the first argument gives
the tag, the second argument is a boolean indicating whether the `lazy`
optimization should also be applied to the keyed children, and the third
argument is a list of keyed element records.

-}
container : String -> Bool -> List (String, DOM.Element msg) -> DOM.Element msg
container htmlTag lazyChildren keyedList =
  let
    (ids, elements) =
      keyedList
        |> List.unzip

    renderer =
      case lazyChildren of
        True ->
          DOM.Lazy.toNode

        False ->
          DOM.Element.toNode

  in
    { tag = htmlTag
    , attributes = []
    , classes = []
    , children =
        elements
          |> List.map renderer
    , text = ""
    , namespace = ""
    , keys = ids
    }


{-| Alias for `VirtualDom.keyedNode`
-}
node : String -> List (DOM.Property msg) -> List (String, DOM.Node msg) -> DOM.Node msg
node =
  VirtualDom.keyedNode
