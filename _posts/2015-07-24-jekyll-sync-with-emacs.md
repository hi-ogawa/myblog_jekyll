---
layout: post
title: "? Jekyll Plugin for Syncing Between Emacs and Chrome"
description: ""
category: 
tags: [jekyll, ruby, elisp, applescript, node.js, javascript]
---

# New Files and Setting

Here are some files and configurations you need to set:

- Jekyll plugin: `_plugins/generator_test.rb`
- Elisp: `~/.emacs.d/init.el`
{% github {"url": "https://github.com/hi-ogawa/emacs-customization/blob/2e23b7cb033da922bdd56f41a75ae561699b657c/init.el", "start": 320, "end": 355, "lang": "lisp"} %}

- Applescript: `smart_jump_to_chrome.scpt`
- Node package: `node_test_emacs_jump`
- JavaScript assets: `assets/my_ext/browser_to_emacs.js`
- Put `exclude: [ ..., "_sync", "node_module"]` in `_config.yml`



I will explain how they are working together.

## Emacs to Chrome:

- Jekyll plugin: `_plugins/generator_test.rb`
  - creates a sync file at `_sync/post.md.json`, which includes a post url and
	json object associatesa line number for each header.
- Elisp: `~/.emacs.d/init.el`
  - in post.md, the shortcut `C-c C-l` invokes the following steps:
	- looks up `_sync/postname.md.json` and finds the nearst anchor name
	- call the next applescript with arguments which specifing a url and an anchor.
- Applescript: `smart_jump_to_chrome.scpt`
  - invokes by the previous elisp shortcut.

## Chrome to Emacs:

- Jekyll plugin: `_plugins/generator_test.rb`
  - converts markdown header notation (like `### something`) in post.md files
	into an oridinary header tag with additional attributes, which is checked
	by the next `browser_to_emacs.js`.
- Node package: `node_test_emacs_jump`
  - install the package by `npm install node_test_emacs_jump`
  - `node_modules/.bin/node_test_emacs_jump_app 4010` monitors a POST request at localhost:4010.
  - upon a request, run `emacsclient` command with appropriate options given from POST data.
- JavaScript assets: `assets/my_ext/browser_to_emacs.js`
  - Click on headers invokes a POST request to localhost:4010 with data consisting of
	the line number in original md file.

# References to implement those programs

- Node.js: see [this post]({% post_url 2015-07-23-node-js-tutorial %}) for the detail.
- Elisp
  - get current line number: <https://www.gnu.org/software/emacs/manual/html_node/eintr/what_002dline.html>
  - number string conversion: <http://www.gnu.org/software/emacs/manual/html_node/elisp/String-Conversion.html>
  - read file
	- <http://ergoemacs.org/emacs/elisp_read_file_content.html>
	- <https://lists.gnu.org/archive/html/help-gnu-emacs/2004-09/msg00292.html>
  - parse json: <http://edward.oconnor.cx/2006/03/json.el>
  - association list: <http://www.gnu.org/software/emacs/manual/html_node/elisp/Association-Lists.html#Association-Lists>
  - utility for sequence
	- map: <http://www.gnu.org/software/emacs/manual/html_node/elisp/Mapping-Functions.html>
	- nth, elt: <http://www.gnu.org/software/emacs/manual/html_node/elisp/List-Elements.html>
  - common lisp extension (cl-lib): <http://www.gnu.org/software/emacs/manual/html_mono/cl.html>
	- filter: <http://ergoemacs.org/emacs/elisp_filter_list.html>
	- sort: <http://www.gnu.org/software/emacs/manual/html_mono/cl.html#Sorting-Sequences>
  - check type: <http://www.gnu.org/software/emacs/manual/html_node/elisp/Type-Predicates.html>
- Applescript
- Jekyll
  - generator plugin sample: <http://jekyllrb.com/docs/plugins/#generators>
  - post yaml front matter: `site.posts[0].data`
  - site configuration in _config.yml: `site.config`
  - check if draft mode (jekyll build/serve --drafts): `site.show_drafts`
  - get anchor id by kramdown library: <https://github.com/gettalong/kramdown>
- Ruby
  - avoid `invalid byte sequence in US-ASCII`
	- <http://stackoverflow.com/questions/5163339/write-and-read-a-file-with-utf-8-encoding>
	- <http://stackoverflow.com/questions/11664403/does-ruby-provide-a-way-to-do-file-read-with-specified-encoding>
  - get an index of a member in array: <http://stackoverflow.com/questions/6242311/quickly-get-index-of-array-element-in-ruby>
  - map(&:), each_line, chomp <http://stackoverflow.com/questions/601888/how-do-you-loop-through-a-multiline-string-in-ruby>
  - select (filter function) <http://progzoo.net/wiki/Ruby:Filtering_an_Array>
  - giving arguments (block) for a higher order function
	- not `p = site.posts.select({|p| p.title == 'Jekyll Setup'}).first`
	- but `p = site.posts.select{|p| p.title == 'Jekyll Setup'}.first`
  - write to file: <http://stackoverflow.com/questions/2777802/how-to-write-to-file-in-ruby>
  - write json in a file: <http://stackoverflow.com/questions/5507512/write-to-json-file-in-correct-format-ruby>
  - regular expression <http://www.tutorialspoint.com/ruby/ruby_regular_expressions.htm>


# Future Work

- don't add attributes when it's in syntax highlight mode
- support a jump from archive page
- when clicking the title, it invokes a jump to emacs: (done) <https://github.com/hi-ogawa/hi-ogawa.github.io/commit/e4d4054b29ecd2adf8033dcdbf350cdf9df89ae9>
