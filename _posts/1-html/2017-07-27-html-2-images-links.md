---
layout: post
style:
script:

category: html
featured:
permalink:

title: How to add images into a webpage?
short: Images & Links
description: I've missed something in the first tutorial, so they're flying over here. <br>Adding images into a webpage, creating links. <br>And... see Atom in action.
keywords: web development, beginner, non-coder, kei nart, free, tutorial, coding, programming, code nart, html, image, link

date: 2017-07-27 05:05:00
---

[Atom](https://codenart.github.io/begin/#how-to-have-fun-doing-a-boring-task "ext")
first! I love `magic` and Atom has it:

- Open Atom.
- Choose `File` option from menu panel, then `New File`.
- Save file and give it a nice name as you want.
- In the editor, type `im` then press `Enter`.

`Screenshot:`
![atom editor](/images/html/2/atom.jpg)

That is Magic!  
We've just put there `2 letters` and Atom knows that we want to add an
[image](https://www.w3schools.com/tags/tag_img.asp "ext") into the webpage. Now,
we only need to tell web browsers `where` to get the image:

- Copy/Paste this url
[https://s19.postimg.cc/9zaosqzdf/trees.jpg](https://s19.postimg.cc/9zaosqzdf/trees.jpg "ext")
into the `src`.
- Save file again and open the document using your web browser.

`Screenshot:`
![img tag](/images/html/2/trees.jpg)
> Image - credit to [Psyperl](https://github.com/psyperl)

We've used an image stored on
[postimg.org](https://postimg.org/image/5dekkedu7/ "ext"). You can create a free
account to upload and use your own image. After uploading an image, just `right
click` on the image and choose `Copy Image Location` then paste into the `src`.

`Screenshot:`
![postimage.org](/images/html/2/postimage.jpg)

<span id="simple"></span>
In case you don't want to store your image on another website, you can create a
folder named something like `images` and put all image-files there. In the
`src`, type `the folder's name` followed by a slash `/` and `image's filename`.
Web browsers will start at the folder contains the `HTML document` and follow
the `path` to look for the `image`.

`Screenshot:`
![using an image stored locally](/images/html/2/relative.jpg)

Reference:
[Supported Image-Formats](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/img#Supported_image_formats "ext")

## Single HTML tags

You may notice that there are something `strange` in the previous example. We've
only seen HTML tags come in pairs, but the
[img tag](https://www.w3schools.com/tags/tag_img.asp "ext") stands alone.

Yes, there are some HTML tags designed to stand alone. They're called `single tags`.
There's nothing special. It just means that none of them need a `closing tag` to
pair with.

Another example of single tags is
[br tag](https://www.w3schools.com/tags/tag_br.asp "ext"), this tag will insert
a `line br`  
`eak` and commonly used in paragraphs when you want to write poetry.

> Code is Poet  
> ry.  
> \_\_quote by WordPress.org

Let's talk about the next `strange` thing.

## HTML attributes

[Attributes](https://developer.mozilla.org/en-US/docs/Web/HTML/Attributes "ext")
help us to describe some related information about HTML tags. As you see that
we've given a location to tell web browsers about the image `source` in the
previous example using the [src attribute](https://www.w3schools.com/tags/att_img_src.asp "ext").

The [alt attribute](https://www.w3schools.com/tags/att_img_alt.asp "ext") stands
for `alternative`, you can put there some words to describe the image in case
your neighbor's web browser cannot find the image (slow connection, image has
been removed, etc...).

## How to add links into a webpage?

Yes! It's time for `magic` again:

- In the
[Atom](https://codenart.github.io/begin/#how-to-have-fun-doing-a-boring-task "ext")
editor, the second line, type `a` then press `Enter`.
- I guess you'll see this pair `<a href="#"></a>` show up.
- Replace the hash `#` with this url
[https://en.wikipedia.org/wiki/List_of_oldest_trees](https://en.wikipedia.org/wiki/List_of_oldest_trees "ext").
- Move the [img tag](https://www.w3schools.com/tags/tag_img.asp "ext") into the
position between the [anchor tags](https://www.w3schools.com/tags/tag_a.asp "ext").
- Save file and refresh your web browser.
- Click on the image
- Then read about the wisest masters of the world.

`Sample code:`
<script src="https://gist.github.com/codenart/52baa4b077a7d30928c7019fdf357a7e.js">
</script>

Have you found some wise messages from them? Wanna be
<a style="color: #009900" href="https://www.youtube.com/watch?v=rRZ-IxZ46ng">green</a>?

Actually, we can use [anchor tags](https://www.w3schools.com/tags/tag_a.asp "ext")
to wrap anything like text, images, a block of content include headings and
paragraphs, etc... to create a
[clickable area](https://www.youtube.com/watch?v=zsCD5XCu6CM "ext") that link to
[somewhere](https://www.youtube.com/watch?v=zsCD5XCu6CM "ext").

Oh, and now we know that HTML elements can be `nested`. We've just put an HTML
element inside another. It means that we're freely to compose our documents to
fulfill our needs.

## What if... ?

Do you wonder `what if` we want to create links between our webpages but not to
other websites?

It's ~~not~~ `easy`. (I'm sorry. There's a typo here. :D)  
Just do the same thing as we've done in examples about
[img tag](#simple "int"):

- Put all your webpages in the same folder.
- In the [href](https://www.w3schools.com/tags/att_a_href.asp), just point to
the document which you want to link to.

`Screenshot:`
![link to local webpage](/images/html/2/link.jpg)

<span id="id"></span>
Do you wonder `what if` we want to creates a link to move to a specific part of
the webpage like the
[Start Reading ;](#display "int") button
on the top of my website?

It's `not` not easy. (This is double negative in my English, not a typo. :D)  
There is an HTML attribute called
[id](https://www.w3schools.com/tags/att_id.asp "ext"). You can use it to give
any HTML element a unique identity, then use
[the id](https://www.w3schools.com/tags/att_id.asp "ext") as an url (forwarded
by a hash `#`).

`Sample code:`
<script src="https://gist.github.com/codenart/18129eafaa4f82931c6aa5fcee4ac443.js">
</script>

Does it work? If it doesn't, so you need a longer text which can make your
website scrollable (vertically).

Oooops. I've not noticed that our tutorial is too loooong now. Let's take a
break. In the next tutorial, we'll talk about
[embedded content](https://codenart.github.io{{ page.next.url }} "ext").

And now, it's time for music. :D

<div class="embed">
   <iframe width="560" height="315"
           src="https://www.youtube.com/embed/z4ZxxHbJGbY"
           frameborder="0" allowfullscreen>
   </iframe>
</div>

> "What if being green is not easy?"  
> "How about being blue or yellow instead?"  
> "But green is beautiful."  
> "Then why wonder?"  
> \_\_A simple & happy Mind
