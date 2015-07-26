---
layout: post
title: "? Ruby Basics"
description: ""
category: 
tags: []
---
{% include JB/setup %}


# References

- [Programming Ruby](http://ruby-doc.com/docs/ProgrammingRuby/html/index.html)

# Misc

- switch statement
  - <http://ruby-doc.com/docs/ProgrammingRuby/html/tut_expressions.html#S5>
  - <http://stackoverflow.com/questions/948135/how-can-i-write-a-switch-statement-in-ruby>
- Rakefile
  - call other rake tasks: 
  - give arguments:


{% github { "url":     "https://github.com/hi-ogawa/myblog_jekyll/blob/2ad2e549de19c2cbd4e39cee6e9bd644ccce3485/_plugins/generator_test.rb", "start": 14  , "end": 15    , "lang": "ruby" }%}
- create a directory (do nothing if it already exists) <http://stackoverflow.com/questions/12617152/how-do-i-create-directory-if-none-exists-using-file-class-in-ruby#answer-23648661>


{% github { "url":     "https://github.com/hi-ogawa/myblog_jekyll/blob/8ad2edc3e78bd971b99634effcf5cc2486709b81/Rakefile", "start": 4  , "end":  8   , "lang": "ruby" }%}
- change directory in rake tasks <http://stackoverflow.com/questions/16533571/temporarily-change-current-directory-in-rake>

{% github { "url":     "https://github.com/hi-ogawa/myblog_jekyll/blob/3a600e3f79b446cff90128694354a7d55ae5d612/_plugins/tag_test.rb", "start": 22  , "end": 68 , "lang": "ruby" }%}
- parse json: <http://ruby-doc.org/stdlib-2.0.0/libdoc/json/rdoc/JSON.html>
- open uri: <http://ruby-doc.org/stdlib-2.1.2/libdoc/open-uri/rdoc/OpenURI.html>
- foldl, inject: <http://apidock.com/ruby/Enumerable/inject>
  - `[a0, a1, a2].inject(b) f  =>  (f (f (f b a0) a1) a2)`
- replace a word in string: <http://stackoverflow.com/questions/8381499/replace-words-in-string-ruby>
- escape html string <http://stackoverflow.com/questions/1600526/how-do-i-encode-decode-html-entities-in-ruby>
- multiline string literal <http://stackoverflow.com/questions/15838974/is-there-an-easy-way-to-do-multiline-indented-strings-in-ruby>
