---
layout: post
title: "Jekyll Setup"
description: ""
category: 
tags: [jekyll, ruby]
---

### What I Did

- Install [Jekyll Bootstrap](http://jekyllbootstrap.com/).
- Remove `comment:` in _config.yml since I didn't like comment/ad area
- Change index page to the archive page as a sym link
- Create syncing function: see [this post]({% post_url 2015-07-24-jekyll-sync-with-emacs %})
- elisp shortcut to put highlight: [My Elisp Tweak]({% post_url 2015-07-21-my-elisp-tweak %})
- move between `http://localhost:4000/2015/07/21/to-do/` and `_posts/2015-07-21-to-do.md`
  - see this post: [Applescript with Javascript]({% post_url 2015-07-22-applescript %})

### What I Will Do

- Make appropriate index page and about.html
- Add search function via right top box
  - <http://thornelabs.net/2014/05/12/instant-search-with-twitter-bootstrap-jekyll-json-and-jquery.html>
  - <https://truongtx.me/2012/12/28/jekyll-create-simple-search-box/>
- Table of contents auto-generation
  - <https://github.com/dafi/jekyll-toc-generator>
  - <https://github.com/dafi/tocmd-generator>
- Consider a good practice to take a note about tips instead of 'mydoc/tips.org'
  - ex. overwriting css style: give a link to source code of phonecat sample.
- How to manage To-do in this blog
- Not only jump to header, but also anything
- _**Style change**_
  - make the width of all pages smaller
  - change header style, bolder or color change
- why rake restart[jekyll] is cut off when running 'stop' part
  - <http://askubuntu.com/questions/184071/what-is-the-purpose-of-the-9-option-in-the-kill-command>
  - <https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=rake%20kill%20process>
- employ same code highlighter as used in github
- create an on-going mark for easily find what is current task

### References

- Original: <http://jekyllrb.com/docs/home/>
- Jekyll Bootstrap: <http://jekyllbootstrap.com/usage/jekyll-quick-start.html>

### Markdown-mode in Emacs

- C-c C-n: go to next visible header
- C-c C-p: go to previous visible header
- see [this post]({% post_url 2015-07-21-my-elisp-tweak %})


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
