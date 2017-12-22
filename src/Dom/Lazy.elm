module Dom.Lazy exposing
  ( toNode, container, eval )

{-| Support for the VirtualDom `lazy` optimization

From *elm-lang/html* documentation:

> Since all Elm functions are pure we have a guarantee that the same input
> will always result in the same output. This module gives us tools to be lazy
> about building `Html` that utilize this fact.
>
> Rather than immediately applying functions to their arguments, the `lazy`
> functions just bundle the function and arguments up for later. When diffing
> the old and new virtual Dom, it checks to see if all the arguments are equal.
> If so, it skips calling the function!
>
> This is a really cheap test and often makes things a lot faster, but definitely
> benchmark to be sure!"

@docs toNode, container, eval

-}

import Dom.Element
import Dom

import VirtualDom

{-| A lazy version of `Dom.Element.toNode`
-}
toNode : Dom.Element msg -> VirtualDom.Node msg
toNode =
  VirtualDom.lazy Dom.Element.toNode


{-| Apply `Dom.Lazy.toNode` to all of the child nodes when constructing an
element container
-}
container : String -> List (Dom.Element msg) -> Dom.Element msg
container htmlTag childList =
  { tag = htmlTag
  , id = ""
  , attributes = []
  , classes = []
  , children =
      childList
        |> List.map toNode
  , text = ""
  , namespace = ""
  , keys = []
  }


{-| Alias for `VirtualDom.lazy`
-}
eval : (a -> Dom.Node msg) -> a -> Dom.Node msg
eval =
  VirtualDom.lazy
