---
layout: post
title: "CSS/SASS Tips"
description: ""
category: [tips]
tags: []
---

# reset all attributes

- `!important`: <http://www.w3.org/TR/CSS21/cascade.html#important-rules>
- raw css: <http://stackoverflow.com/questions/15901030/reset-remove-css-styles-for-element-only>

# icon without bootstrap

- font awesome <http://fortawesome.github.io/Font-Awesome/get-started/>

# Overwrite style rule
See the side notes on [this]({% post_url 2015-07-26-angularjs-tutorial %}).

# @media rule

- @media rule <http://www.w3schools.com/cssref/css3_pr_mediaquery.asp>
- media type <http://www.w3schools.com/css/css_mediatypes.asp>
- example in Jekyll Bootstrap:

{% github { "url":     "https://github.com/hi-ogawa/myblog_jekyll/blob/2ad2e549de19c2cbd4e39cee6e9bd644ccce3485/css/main.scss", "start": 36  , "end": 40    , "lang": "scss" }%}

{% github { "url":     "https://github.com/hi-ogawa/myblog_jekyll/blob/2ad2e549de19c2cbd4e39cee6e9bd644ccce3485/_sass/_my-style.sass", "start": 27  , "end": 32    , "lang": "sass" }%}

# font-family

- <http://www.w3schools.com/cssref/css_websafe_fonts.asp>
- <http://www.cssfontstack.com/>

# Aligning span within div

- <http://www.w3schools.com/css/css_align.asp>

{% github { "url":     "https://github.com/hi-ogawa/myblog_jekyll/blob/2ad2e549de19c2cbd4e39cee6e9bd644ccce3485/_plugins/tag_test.rb", "start": 44  , "end": 48    , "lang": "html" }%}

# Structuring CSS/SASS files

- <http://thesassway.com/beginner/how-to-structure-a-sass-project>
- <http://stackoverflow.com/questions/29883636/grunt-contrib-sass-compile-multiple-files-in-different-modules-best-practice>
- <http://stackoverflow.com/questions/22850751/best-practices-organizing-css-files-within-a-large-backbone-js-app-and-account>

- watch dependencies by import <http://stackoverflow.com/questions/5571477/use-multiple-sass-files>

{% highlight bash %}
sass --watch --sourcemap=none -r compass `compass imports` css/main.sass:css/main.css
{% endhighlight %}

# bootstrap blank glyphicon

- <http://stackoverflow.com/questions/19598336/blank-placeholder-for-bootstrap-glyphicon>
