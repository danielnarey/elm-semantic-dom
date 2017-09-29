
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
9. Unfortunately, the module naming scheme I chose conflicts with
*elm-lang/dom* (I couldn't come up with an acceptable alternative), but I am
working on a separate package that will wrap *elm-lang/dom* in order to avoid
the conflict when there is a need to manage DOM effects.
10. Constructive suggestions are welcome!


### Package Reference


| Module        | Types | Constructors | Modifiers | Rendering | Queries |
| --- | --- | --- | --- | --- | --- |
| Dom           | Node<br>Property<br>Element | | | | |
| Dom.Program   | Setup | setup | onLoad<br>update<br>updateWithCmds<br>subscribe<br> subscribeWithParams | run<br>runWithFlags<br>customWithFlags | |
| Dom.Node      | | leaf<br>textWrapper<br>container | | | |
| Dom.Element   | | leaf<br>textWrapper<br>container<br>wrapNodes | withClasses<br>addClass<br>removeClass<br>withAttributes<br>addAttribute<br>withText<br>appendText<br>prependText<br>withChildren<br>appendChild<br>prependChild<br>withChildNodes<br>setNamespace | toNode | hasChildren<br>hasText<br>hasClass
| Dom.Property  | | bool<br>string<br>int<br>float | | | |
| Dom.Attribute | | string<br>int<br>float<br>namespaced | | | |
| Dom.Event     | | action<br>capture<br>submit<br>custom<br> customWithOptions | | | |
| Dom.Style     | | toProperty | | | |
| Dom.Keyed     | | container<br>node | | | |
| Dom.Lazy      | | container | | toNode<br>eval | |
| Dom.Svg       | | leaf<br>textWrapper<br>container<br>element<br>wrapNodes | | | |
| Dom.Text      | | node | | | | |
