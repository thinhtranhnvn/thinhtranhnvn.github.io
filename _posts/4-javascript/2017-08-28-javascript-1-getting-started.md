---
layout: post
style:
script: /js/greet.js

category: javascript
featured: bingo
permalink: /smart/

title: What is JavaScript?
short: Getting Started
description: Unlike HTML and CSS, JavaScript is not a simplified version of English. :D <br>It is one of the most popular programming languages. <br>With JS, you can create ANYthing. :D
keywords: web development, beginner, non-coder, kei nart, free, tutorial, coding, programming, code nart, javascript, getting started

date: 2017-08-28 05:00:00
---

Unlike [HTML](https://thinhtranhnvn.github.io/begin/ "ext") and
[CSS](https://thinhtranhnvn.github.io/beauty/ "ext"), JavaScript is a programming
language. With JavaScript, you can teach the computer to think and make decision
based on certain situation.

> JavaScript can make your website smart.  
> \_\_A simple & happy Mind

For example, you want to place a button on your webpage to greet user when he/she
clicks on it. HTML can help to make the button show up. CSS can help to make the
button look nice. But, none of those two languages can tell web browser `what to
do` when user clicks on the button. This is the point where JavaScript gets in.
Let's see.

`HTML code:`
<script src="https://gist.github.com/codenart/6f9e3ffa365cc5d5e7a4147fe7da72b1.js">
</script>

`CSS code:`
<script src="https://gist.github.com/codenart/29260f45e473a95af07f688cc16c6276.js">
</script>

`JS code:`
<script src="https://gist.github.com/codenart/4257b651828fc6afb5c3c13bc9134f1a.js">
</script>

`Result:`

<button class="btn btn-success" id="greet">
   Click me! I'll greet you. :D
</button>

Well, actually, that was not how JavaScript looks like. Because the language is
quite flexible and there are so many stuff that may confuse you at the first
look; I just put there some words to describe what to do in JS file. :D

So, the another important thing that I want you to take note in this section
is... JavaScript code can be placed in a separated file `.js` and linked to the
HTML document using `<script>` tags.

## What can JavaScript actually do on the web?

Firstly, JavaScript is a programming language so it can serve calculations and
allows us to teach the computer to think. :D

Secondly, it allows us manipulate the HTML document for various purposes:

- Change content of a specific element
- Change styles of a specific element
- Add event listeners to interact with user

Lastly, JavaScript also allows us to interact with web browser window as we can
do with mouse/keyboard and even more:

- Close window or open a new one
- Resize or move the window around user's screen
- Scroll the document by lines or by pages
- Send request to a server or redirect user to another address

Wew... We're gonna have to learn a lot.  
But, don't worry. The only important part is the first one: learning basic
programming concepts and getting familiar with the language. Once you handled
fundamental stuff, learning the next two parts is just easy as eating cake. So,
let's get it started. :D

## The baby first JavaScript statements

Ok, here we go. The very first JavaScript statement.

`HTML code:`
<script src="https://gist.github.com/codenart/4cd2f722a5c8730491a7665bc8fd5ec9.js">
</script>

`JS code:`
<script src="https://gist.github.com/codenart/9d732bc040dff82251fe856d741d8bfa.js">
</script>

`Result:`
![console](/images/javascript/1/console.jpg)

Since we're gonna dive into fundamental programming concepts and not yet to touch
the tools to manipulate the HTML document, we need to see the output somewhere
else; And the statement above will just print any thing we put between the
parentheses `()` to console window of the web browser. To open console window,
you can press `F12` or right click on the webpage and choose `Inspect..` then
choose `Console` tab.

So, let's have a closer look at our very first statement. It looks quite clear
and understandable, right? We're telling the `console` window to `log` the number
`2018`. So, there're 3 small things left for us to care about their meanings:

- The first one is a semi-colon `;` at the end of the statement. I guess you've
got familiar with it since CSS time. It's not mandatory to end a JavaScript
statement using a semi-colon but it's a good habit for start time. You should
always end a JavaScript statement with a semi-colon until your love of JavaScript
grows big enough. :D
- The next two `strange` things are the parentheses `()` that we mentioned above;
and a dot `.` which stands between the two words `console` and `log`. They're the
most beautiful tiny things in programming world; And it takes some more tutorials
for us to be available to their meanings. So, for now, please consider them as
simple separators which help to make the statement look clearer. :D

Can we just end our first JavaScript tutorial with wonders? :D

## Writing comment in JavaScript

Oh. Excuse me! There's one more little thing I need to tell you.

As any other coding languages, JavaScript allows us to write comments in the code.
There are 2 ways to write a comment in JavaScript:

- Start your comment with two slashes `//` and all the characters afterward to
the end of the line will be ignored.
- If you want to write a multi-lines comment, you can enclose text using a pair
of `/*` and `*/` like we do in `/* CSS */`.

That's it. Good bye!
