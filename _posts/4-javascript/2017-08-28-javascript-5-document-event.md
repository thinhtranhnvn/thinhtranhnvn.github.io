---
layout: post
style:
script:

category: javascript
featured:
permalink:

title: The object - document
short: Document & Event
description: In this tutorial, we'll talk about a built-in object which allows manipulating HTML document; <br>And get to know how to make our webpages become interactive. <br>Let's start with the object - document.
keywords: web development, beginner, non-coder, kei nart, free, tutorial, coding, programming, code nart, javascript, object, dom, document object model, document, event

date: 2017-08-28 05:20:00
---

Since the object is in-built, we don't have to care about how it was created and
our purpose is simply exploring how to use it to manipulate HTML document. Before
taking the discussion, please have a quick look at the following reference link
in which all the bundled stuff of the object `document` are fully listed:
[Document Object Reference](https://www.w3schools.com/jsref/dom_obj_document.asp "ext")

About manipulating HTML document, the object `document` provides some
possibilities as listed below:

1. Finding and modifying specific HTML elements
2. Creating new elements and altering document's structure
3. Binding event listeners (actions) to components to interact with user

Along with exploring the object `document`, we'll apply some of its features to
create a dropdown. So, I've prepared HTML and CSS code here; And we can just
start talking about JS stuff. Please copy the code snippets below to your sample
HTML document and CSS file; And create a blank JS file linked to the HTML
document.

`HTML code:`
<script src="https://gist.github.com/codenart/ef2d53f28af5dc19d7b6f96edfbbbebe.js">
</script>

`CSS code:`
[Click here to see CSS code](https://gist.github.com/codenart/e35ac23245ec8d2d506c280cd6751ef2 "ext")

And here is the expected result with the dropdown working properly.

<p data-height="500" data-theme-id="light"
   data-slug-hash="LrQXGj" data-default-tab="result" data-user="codenart"
   data-embed-version="2" data-pen-title="A weird dropdown :D" class="codepen">
   See the Pen <a href="https://codepen.io/codenart/pen/LrQXGj/">A weird dropdown :D</a>
   by Kei Nart (<a href="https://codepen.io/codenart">@codenart</a>) on
   <a href="https://codepen.io">CodePen</a>.
</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

You may notice that the dropdown is a little weird. Normally, a dropdown has only
1 button but the dropdown we're working with comes with 2 buttons. We'll talk
about this in a later section. And please don't peek in the JS source code on
CodePen. We're gonna make it from scratch. It's so simple and won't take much
time. :D

## 1. Finding & Modifying specific elements

The object `document` is actually a model of the root element of the HTML
document which is created by `<html></html>` tags. All of other nested elements
are also modeled by objects and nested inside the object `document` with the same
hierarchy as in the HTML document. So, to select an element, we can travel from
the object `document` following the HTML document's hierarchy. Let's get the 2
elements `<head>` and `<body>`.

`JS code:`
<script src="https://gist.github.com/codenart/657270bc00782b7f1a2d3b59b859c41b.js">
</script>

Nested objects like `head`, `body`, and other elements, are created from the same
class which is fully documented in the following reference link. -
[Element Reference](https://www.w3schools.com/jsref/dom_obj_all.asp "ext")

Start from one element, we can travel to its parent, sibling, and children
elements like this.

`JS code:`
<script src="https://gist.github.com/codenart/af4d7d421f7a2677d0bd0b7e9ebd7ab8.js">
</script>

Traversing among nested elements is a bit inconvenient when we want to select a
deeply nested one. So, the another way is looking up using bundled functions of
the object `document`. Here is how to look up an element using `id`.

`JS code:`
<script src="https://gist.github.com/codenart/5c3bd5136ef3e0074a93ddb29fc3786b.js">
</script>

Now we know how to find specific elements. Let's make some changes to an
element's text content and its attributes. An element's text content can be
accessed and changed through the variable `textContent`.

`JS code:`
<script src="https://gist.github.com/codenart/5aefa995ad4db72341142e857a06e35b.js">
</script>

Accessing and modifying attributes can also be done with the same approach. We
just need to find the related variables listed in the reference link or
`console.log` the element object to see the variables' names. In the example
below, the variable `className` is used to refer to the attribute `class` of the
dropdown list.

`JS code:`
<script src="https://gist.github.com/codenart/cc8882cafe26715010f90c794a28e3e0.js">
</script>

Now we also know how to hide the dropdown list. By toggling the attribute `class`
of the list between 2 pre-defined CSS classes `shown` and `hidden`, we can change
visibility state of the dropdown list. Let's get to know how to bind these
actions to the buttons and make the dropdown working properly. We're gonna save
talking about creating new elements for later.

## 3. Handling events to interact with user

When a click is performed on a button, web browser will dispatch an `event` and
trigger event listeners (if any). To bind an action to handle the event, the most
simple way is to store a function in the button's variable `onclick`.

`JS code:`
<script src="https://gist.github.com/codenart/a68864d2d46513e3b9bb96ccfc9b5029.js">
</script>

Yet, HTML elements can capture various types of event like: mouse events,
keyboard events, browser custom events, etc... You can try out some other event
types from the following reference link:
[Event Types Reference](https://www.w3schools.com/jsref/dom_obj_event.asp "ext")

About the unused variable `event` in the code snippet above; When an event is
dispatched, web browser will create an object to model the event and pass it into
the event listeners. This object provides some information which is helpful in
some situations. You can `console.log` to know more about the event object or use
the following reference link for further learning:
[Event Object Reference](https://www.w3schools.com/jsref/obj_events.asp "ext")

The most common use cases of the event object are to determine the target element
which directly captures the event; And to determine the pressed key when working
with keyboard events.

## 2. Creating elements & Altering HTML structure

You may notice that the dropdown in the expected result has few more items
compared to our HTML code snippet. They were created using JavaScript. Let's
create a function that helps to add some of your favorite things to the list.
We're gonna give the function a descriptive name `addNewItem` but you can choose
any other name that you want.

`JS code:`
<script src="https://gist.github.com/codenart/58c2120ccdc88ce9ceaab50c946728bc.js">
</script>

Here we're gonna discuss the function outside in. The function should be
re-use-able so we can add more and more items by simply calling it multiple times
with various `text`.

The first part of the function is about creating a new element object which
models an anchor element `<a href="#">`. The function `createElement` of the
object `document` take in an HTML tag's name to create the new element object.
Binding the new object's text content with given text and modifying its attribute
`href` are both done by using related variables.

The second part of the function is about attaching the new element object to the
dropdown list: Finding the list using its `id`; Then `appending` the new item to
the list.

So, we've known how to `edit` an item; how to `add` a new item; and maybe you
also want to know how to `delete` an item. To do so, you firstly need to find the
element that you want to remove; Then call the function `removeChild` of the
dropdown list object. It sounds simple, doesn't it? Just try it yourself! :D

References:

- [createElement](https://www.w3schools.com/jsref/met_document_createelement.asp "ext")
- [appendChild](https://www.w3schools.com/jsref/met_node_appendchild.asp "ext")
- [removeChild](https://www.w3schools.com/jsref/met_node_removechild.asp "ext")

# About the weird part of the dropdown

The main part of the tutorial has finished. Here we're gonna discuss a little
about the weird part of the dropdown.

Normally, a dropdown has only one single button to handle both of the two tasks:
showing and hiding the dropdown list. It means that we can only have one function
to handle the event which is occurred by user click. So, the behavior of the
function must be able to be switched based on visibility state of the dropdown
list. With all the tools we've met from the first tutorial, there's no chance to
make it work like so. That's why we have to consider making a weird dropdown with
two buttons.

The ability of switching a function's behavior will be available with a little
help from a new toolset: a type called `boolean` and a switching syntax which
takes advantage of the type to allow switching behavior of a code snippet.

In the next tutorial, we'll talk about the new toolset and practice using it to
normalize the dropdown with a single button. And now it's time for a break. See
you again.
