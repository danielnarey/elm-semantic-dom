
# elm-semantic-dom: Syntactic sugar for cooking with Elm VirtualDom

### Why?

1. The code you use to generate your Elm program's view doesn't need to look
like HTML or SVG markup.
2. The functions in *elm-lang/html* and *elm-lang/svg* are just wrappers for
`VirtualDom` functions.
3. There's no reason why you shouldn't build abstractions for view components
directly on top of `VirtualDom` — it gives you more flexibility.
4. Because `VirtualDom` is intended for advanced use and customization, it's a
bare-bones package without helpers that would make it's functionality easier to
manipulate.
5. So: I created a set of helper functions for working with `VirtualDom` and put
them all in one package with semantically structured modules.
6. The package is intended as an infrastructure for building higher level
abstractions on top of `VirtualDom`, without the need to import `Html` or `Svg`.
7. All functions in this package are designed to be used in the "pipeline"
style, where data flows through a series of functions in an easily readable way,
from top to bottom and left to right.
8. Functions are also written to avoid unused arguments, with additional
"custom" functions available for rarely-used cases.
9. `DOM` is capitalized in the module naming scheme to avoid confusion with
*elm-lang/dom*
10. Constructive suggestions are welcome!


### Package Reference


| Module        | Types | Constructors | Modifiers | Rendering | Queries |
| --- | --- | --- | --- | --- | --- |
| DOM           | Node<br>Property<br>Element | | | | |
| DOM.Program   | Setup | setup | onLoad<br>update<br>updateWithCmds<br>subscribe<br> subscribeWithParams | run<br>runWithFlags<br>customWithFlags | |
| DOM.Node      | | leaf<br>textWrapper<br>container | | | |
| DOM.Element   | | leaf<br>textWrapper<br>container<br>wrapNodes | withClasses<br>addClass<br>removeClass<br>withAttributes<br>addAttribute<br>withText<br>appendText<br>prependText<br>withChildren<br>appendChild<br>prependChild<br>withChildNodes<br>setNamespace | toNode | hasChildren<br>hasText<br>hasClass
| DOM.Property  | | bool<br>string<br>int<br>float | | | |
| DOM.Attribute | | string<br>int<br>float<br>namespaced | | | |
| DOM.Event     | | action<br>capture<br>submit<br>custom<br> customWithOptions | | | |
| DOM.Style     | | toProperty | | | |
| DOM.Keyed     | | container<br>node | | | |
| DOM.Lazy      | | container | | toNode<br>eval | |
| DOM.Svg       | | leaf<br>textWrapper<br>container<br>element | | | |
| DOM.Text      | | node | | | | |
