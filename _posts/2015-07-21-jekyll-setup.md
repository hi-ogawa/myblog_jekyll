---
layout: post
title: "Jekyll Setup"
description: ""
category: 
tags: []
---
{% include JB/setup %}

**blog setup with jekyll bootstrap**

- learn jekyll, see:
  - <http://jekyllrb.com/docs/home/>
  - <http://jekyllbootstrap.com/usage/jekyll-quick-start.html>
  - ✓ the post in core-samples
- ✓ remove ad or some other bullshits
  - ✓ just commend out `comment:` in _config.yml

- consider a good practice to take a note about tips instead of 'mydoc/tips.org'
  - ex. overwriting css style: give a link to source code of phonecat sample.
- how to manage To-do in this blog
- configuration, index.html, about.html
- search function throughout my posts
- elisp shortcut to put highlight 

**how to get syntax highlight work in jekyll**

- see <https://truongtx.me/2012/12/28/jekyll-bootstrap-syntax-highlighting/>
- put syntax.css file (like [this](https://raw.githubusercontent.com/mojombo/tpw/master/css/syntax.css))
  in `<jekyll root>/css/syntax.css`
- put this code in `<jekyll root>/_includes/themes/bootstrap-3/default.html`:

	{% highlight html %}
		<link rel="stylesheet" href="/css/syntax.css">
	{% endhighlight %}

- markdown: redcarpet
