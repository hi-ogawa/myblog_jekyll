---
layout: post
title: "? Javascript Basics: Interaction with HTML Documents"
description: ""
category: 
tags: [javascript]
---
{% include JB/setup %}

I finished going through core parts of javascript language written
in [the previous post]({% post_url 2015-07-21-javascript-basics %}).

I will take a look at the rest of parts
in [w3school](http://www.w3schools.com/js/default.asp).

I haven't used raw javascript functions so much to play with DOM elements because
I always be with jQuery.
But, sometimes I'm in trouble whether I'm using jQuery or primitives in javascript.
I hope this study could help me out that kind of troubles.


# DOM (Document Object Model)

This is a W3C standard which defines interface that allows programs
and scripts to dynamically access and update the content, structure, and style of a document.

- all HTML elements are defined as javascript `objects`.
- you can access values or actions of HTML elements via their objects' `properties`.

<a name='Q4'>Q4</a> How does `document` object come?
{% highlight javascript %}
document.getElementById('hoge')
{% endhighlight %}

<a name='Q5'>Q5</a> what the hell is `this`?
{% highlight html %}
<h1 onclick="this.innerHTML='Ooops!'">Click on this text!</h1>
{% endhighlight %}

- complete HTML DOM events list: <http://www.w3schools.com/jsref/dom_obj_event.asp>

## Event propagation

- _bubbling_:  from inner most element's event to the outer one. (this is default behaviour.)
- _capturing_: from outer most element's event to the inner one.

<http://www.w3schools.com/js/tryit.asp?filename=tryjs_addeventlistener_usecapture>



# BOM (Browser Object Model)

> The `window` object is supported by all browsers. It represents the browser's window.
 All global JavaScript objects, functions, and variables automatically become members
 of the `window` object.
 Global variables are properties of the `window` object.
 Global functions are methods of the window object.
 Even the document object (of the HTML DOM) is a property of the window object:

{% highlight javascript %}
window.document.getElementById("header");
// is same as
document.getElementById("header");
{% endhighlight %}

# Questions

- [Q4](#Q4): is this answer <http://www.w3schools.com/jsref/dom_obj_document.asp>
- [Q5](#Q5): 
