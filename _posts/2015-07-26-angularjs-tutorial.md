---
layout: post
title: "Angular.js Tutorial"
description: ""
category: 
tags: [angular.js, javascript]
---

I followed [the phone catalog tutorial](https://docs.angularjs.org/tutorial)
by official angular.js (but, I skipped test parts of it.)
It's just overwriting the tutorial with coffeescript and haml.
Here is my clone of the original one
<https://github.com/hi-ogawa/angularjs_test/tree/by_coffeescript_haml>.


# Side notes

- css style overwrite rule: <http://stackoverflow.com/questions/18321785/how-do-i-overwrite-certain-conditions-when-you-have-two-css-files>

{% github { "url":     "https://github.com/hi-ogawa/angularjs_test/blob/215d83f2c71a992d5a11f2133eef25277161d4d3/app/css/animations.sass", "start": 5  , "end": 27    , "lang": "sass" }%}

- pushing shallow clone to new repository: <http://stackoverflow.com/questions/28983842/remote-rejected-shallow-update-not-allowed-after-changing-git-remote-url>

{% highlight bash %}
$ git push origin master            # error
... ! [remote rejected] master -> master (shallow update not allowed) ...
$ git remote add old git@github.com:angular/angular-phonecat.git
$ git fetch --unshallow old
$ git push origin master            # worked
{% endhighlight %}


# Future Study

- follow the test part.
- understand npm packages this app depends on
  - `http-server`
  - `"scripts"` in `package.json`
