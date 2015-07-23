---
layout: post
title: "Jekyll Setup"
description: ""
category: 
tags: [jekyll, ruby]
---

### blog setup with jekyll bootstrap

- References
  - <http://jekyllrb.com/docs/home/>
  - <http://jekyllbootstrap.com/usage/jekyll-quick-start.html>
- ✓ remove ad or some other bullshits
  - just commend out `comment:` in _config.yml
- ✓ configuration `index.html`, `about.html`
- ✓ elisp shortcut to put highlight: [My Elisp Tweak]({% post_url 2015-07-21-my-elisp-tweak %})
- ✓ move between `http://localhost:4000/2015/07/21/to-do/` and `_posts/2015-07-21-to-do.md`
  - see this post: [Applescript with Javascript]({% post_url 2015-07-22-applescript %})
- search function throughout my posts
  - <http://thornelabs.net/2014/05/12/instant-search-with-twitter-bootstrap-jekyll-json-and-jquery.html>
  - <https://truongtx.me/2012/12/28/jekyll-create-simple-search-box/>
- table of contents auto-generation 
- consider a good practice to take a note about tips instead of 'mydoc/tips.org'
  - ex. overwriting css style: give a link to source code of phonecat sample.
- how to manage To-do in this blog
- make the width of all pages smaller

### Markdown-mode in Emacs

- C-c C-n: go to next visible header
- C-c C-p: go to previous visible header
- see [this post]({% post_url 2015-07-21-my-elisp-tweak %})

- make todo work cycler

### Move from Emacs to Chrome

Not just run a command `open <file.html>`

Ideas:

### Move from Chrome to Emacs

Ideas:

- Jekyll automatically puts an id attribute to each header.
- via BTB, make shortcut working with click plus some special key,
- which invokes an applescript.
- In that applescript, you

or

- Open server process locally, which monitors a request, like localhost:4010.
- When click happens on a header in a jekyll post, that triggers a javascript function,
  which send a request to localhost:4010 with data consisting of
  the id attribute of the header
- Then, after the server calculates the location of a header in the original markdown file,
  it runs a command `emacsclient` with a line number.
- To realize this, I have to find a way to put Javascript code in jekyll posts.
  - put `<script src="/assets/my_ext/browser_to_emacs.js"></script>` around the bottom of
	`_includes/themes/bootstrap-3/default.html` after including jQuery.
  - put the below code in `assets/my_ext/browser_to_emacs.js`
	(this is an original coffeescript):

{% highlight coffeescript %}

{% endhighlight %}

- What server to use? I want to try node.js.

### how to get syntax highlight work in jekyll

- Basically, Jekyll Bootstrap has a scss file `_sass/_syntax-highlighting.scss` for highlighing code snippet.
- The scss file are included in `css/main.css`, like this:
{% highlight css %}
@import
        "base",
        "layout",
        "syntax-highlighting"
;
{% endhighlight %}
- And Jekyll always compiles `css/main.css` into `_site/css/main.css`.
- But, by default Jekyll Bootstrap employs a customized styles file like this:
{% highlight html %}
// in _includes/themes/bootstrap-3/default.html
<!-- Custom styles -->
<link href="{{ ASSET_PATH }}/css/style.css?body=1" rel="stylesheet" type="text/css" media="all">
{% endhighlight %}
- So, all you have to do is just comment out that style link and put this code:
{% highlight html %}
<link href="/css/main.css" rel="stylesheet">
{% endhighlight %}

### Taking `tag_box` style from jekyll-bootstrap

{% highlight sass %}
/* copied from `assets/themes/bootstrap-3/css/style.css` to `_sass/_tag-box.sass`
.tag_box
  list-style: none
  margin: 0
  overflow: hidden

  li
    line-height: 28px
    float: left

    i
      opacity: 0.9

  a
    padding: 3px 6px
    margin: 2px
    background: #eee
    color: #555
    border-radius: 3px
    text-decoration: none
    border: 1px dashed #cccccc

    span
      vertical-align: super
      font-size: 0.8em

    &:hover
      background-color: #e5e5e5

    &.active
      background: #57A957
      border: 1px solid #4c964d
      color: #FFF
{% endhighlight %}

### Short language names for highlight tag

<http://haisum.github.io/2014/11/07/jekyll-pygments-supported-highlighters/>


### Write My Own Jekyll Tag

By following [this page](http://jekyllrb.com/docs/plugins/#tags), I made
one basic tag plugin which generates anchor link.

{% highlight ruby %}
# _plugins/test.rb
module Jekyll
  class MyAnchorTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      "#{@text.strip}<a name=\"#{@text.strip}\"></a>"
    end
  end
end

Liquid::Template.register_tag('anchor', Jekyll::MyAnchorTag)
{% endhighlight %}
