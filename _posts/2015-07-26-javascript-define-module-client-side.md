---
layout: post
title: "Javascript Module Export/Import (Client Side by Require.js)"
description: ""
category: 
tags: [javascript]
---

# Require.js tutorial

I followed the basic usage of require.js written [here](http://requirejs.org/docs/api.html).
What I did is just wirte what is described in the usage page into
coffee script and haml.
Here is a repositiory for that <https://github.com/hi-ogawa/requirejs_test>.
I don't understand the mechanism of how the require.js library works,
but I got the first step of how to use it and what the library wants to do.

## dependency of my tutorial:

        jQuery  mylib1
       / |     /  /
      /  |    /  /
     |   |   /  /
     | mylib0  /
     |   |    /
      \  |   /
       \ |  /
        main 

## directory structure :

     .
     |-- index.html
     `-- scripts
         |-- lib
         |   |-- mylib0.js
         |   `-- mylib1.js
         |-- main.js
         |-- require.js
         `-- vendor
             `-- jquery.js

(by the way, I didn't know there is a command `tree`, which generate the above nicely.)

## Notes

- `baseUrl`: require.js loads codes based on relative paths from `baseUrl`.
  (by default, it's set to same as the directory of a file specified `data-main` attribute.)
- `data-main` attribute: specifies a special file which require.js check first.

- ex. `define`
{% github { "url":     "https://github.com/hi-ogawa/requirejs_test/blob/7f999b3c3588255e0f04dc018d362f6a7736f48c/scripts/lib/mylib0.coffee", "start": 1  , "end": 10    , "lang": "" }%}

- ex. `requirejs`
{% github { "url":     "https://github.com/hi-ogawa/requirejs_test/blob/7f999b3c3588255e0f04dc018d362f6a7736f48c/scripts/main.coffee", "start": 1  , "end": 15    , "lang": "coffeescript" }%}

- Especially, when you want to use a classic library like jQuery, it seems you have to
  take care some kind of module ID restriction, see [this](http://requirejs.org/docs/jquery.html#modulename).

- In an array given as a first argument of `define` or `requirejs`,
  each module ID must corresponds to only single file.

# References

- `define` in Javascript: <http://stackoverflow.com/questions/8350699/explanation-of-define-of-the-requirejs-library>
- AMD (Asynchronous Module Definition) specification: <https://github.com/amdjs/amdjs-api/blob/master/AMD.md>
- `require.js` doc
  - usage: <http://requirejs.org/docs/api.html#define>
  - web modules in general: <http://requirejs.org/docs/why.html>
  - Javascript modules: <http://requirejs.org/docs/whyamd.html>
- samples: <http://www.sitepoint.com/building-library-with-requirejs/>
- real example:
  - underscore.js: <http://underscorejs.org/docs/underscore.html>
  - backbone.js: <http://backbonejs.org/docs/backbone.html>

# Related Topics

- CommonJS
  - relation between CommonJS, AMD and RequireJS: <http://stackoverflow.com/questions/16521471/relation-between-commonjs-amd-and-requirejs>
  - CommonJS explained by RequireJS: <http://requirejs.org/docs/commonjs.html>
- Module patterns by using Javascript functions: <http://www.adequatelygood.com/JavaScript-Module-Pattern-In-Depth.html>
