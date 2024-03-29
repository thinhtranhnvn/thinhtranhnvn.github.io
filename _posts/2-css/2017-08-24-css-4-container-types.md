---
layout: post
style:
script:

category: css
featured:
permalink:

title: Common container-types in CSS
short: Container Types
description: We've known that every HTML element is a container that hold some contents. <br>We've also set size of some containers in the previous tutorial. <br>Let's talk a little bit more about containers.
keywords: web development, beginner, non-coder, kei nart, free, tutorial, coding, programming, code nart, css, display, property

date: 2017-08-24 05:15:00
---

In the previous tutorial, we've set size of some `div` containers using `width`
and `height` properties. But if you try to do the same thing with an element
created by `<a></a>` tags, you will see that it just doesn't work. It's because
the default `container type` of the `<a></a>` element does not allow us to set
size of the container.

There are 3 common `container types`:

- `block` containers
- `inline` containers
- `inline-block` containers

`block` containers take 100% width of their parent containers by default.  
We can set size of these containers using `width` and `height` properties.  
Ex: headings, paragraphs, div, nav, etc...

`inline` containers won't take space. They keep their size as small as possible
(just wrapping around the content inside). Web browsers treat these containers
as text contents (words).  
We can NOT set size of these containers.  
Ex: links, span, etc...

`inline-block` containers are special. Web browsers treat them as text contents
but also allow us set size of these containers using `width` and `height` properties.  
Ex: buttons, images, etc...

## Changing type of a container

Sometimes we want to provide better experience to mobile users by making size of
anchor elements a little bit bigger than default to make sure that people don't
have to tap few times to hit a link.

There is a CSS property called `display` which can help us to change type of
containers. Let's create some look-like-button links. :D  

`HTML code:`
<script src="https://gist.github.com/codenart/6c2bbe34a1aa628ea3ed8f95af208d04.js">
</script>

`CSS code:`
<script src="https://gist.github.com/codenart/b2587f37a88d04ea92a337e5c327f706.js">
</script>

`Result:`

<p data-height="500" data-theme-id="light" data-slug-hash="yzLRmE"
   data-default-tab="result" data-user="codenart" data-embed-version="2"
   data-pen-title="Which is Which?" class="codepen">
   See the Pen <a href="https://codepen.io/codenart/pen/yzLRmE/">Which is Which?</a>
   by Kei Nart (<a href="https://codepen.io/codenart">@codenart</a>) on
   <a href="https://codepen.io">CodePen</a>.
</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

Besides 3 common values `block`, `inline`, and `inline-block`; The `display`
property can be used with various values which are useful in some ways. Some of
them will require up-to-date web browsers. Here is the reference link in case
you want to go further:
[The display Property](https://www.w3schools.com/cssref/pr_class_display.asp "ext").

## Writing comments in CSS

Just like HTML, We can write comments in CSS code. Comments will be ignored when
web browsers process CSS code.

A comment in CSS can be written by using a pair of `/*` and `*/` to enclose
`/* something */`.

We can also use comments to quickly cancel some CSS code blocks without deleting
or moving them to another temporary place.

Our tutorial about [container-types](https://codenart.github.io{{ page.url }})
has finished. In the next tutorial, we'll talk about `background properties`.
