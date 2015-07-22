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
  - just commend out `comment:` in _config.yml

- consider a good practice to take a note about tips instead of 'mydoc/tips.org'
  - ex. overwriting css style: give a link to source code of phonecat sample.
- how to manage To-do in this blog
- configuration, index.html, about.html
- search function throughout my posts
  - <http://thornelabs.net/2014/05/12/instant-search-with-twitter-bootstrap-jekyll-json-and-jquery.html>
  - <https://truongtx.me/2012/12/28/jekyll-create-simple-search-box/>
- ✓ elisp shortcut to put highlight: [My Elisp Tweak]({% post_url 2015-07-21-my-elisp-tweak %})
- how to get sass work `_sass/_syntax-highlighting.scss`
- move between `http://localhost:4000/2015/07/21/to-do/` and `_posts/2015-07-21-to-do.md`
  - ✓ emacs to browser
  - browser to emacs

**how to get syntax highlight work in jekyll**

- see <https://truongtx.me/2012/12/28/jekyll-bootstrap-syntax-highlighting/>
- put syntax.css file (like [this](https://raw.githubusercontent.com/mojombo/tpw/master/css/syntax.css))
  in `<jekyll root>/css/syntax.css`
- put this code in `<jekyll root>/_includes/themes/bootstrap-3/default.html`:

	{% highlight html %}
		<link rel="stylesheet" href="/css/syntax.css">
	{% endhighlight %}

- markdown: redcarpet

**Short language names for highlight tag**

- <http://haisum.github.io/2014/11/07/jekyll-pygments-supported-highlighters/>
