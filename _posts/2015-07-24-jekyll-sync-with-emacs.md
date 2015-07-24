---
layout: post
title: "Jekyll Plugin for Syncing Between Emacs and Chrome"
description: ""
category: 
tags: [jekyll, ruby, elisp, applescript, node.js, javascript]
---

Here are some files and configurations you need to set:

- Jekyll plugin: `_plugins/generator_test.rb`
- Elisp: `~/.emacs.d/init.el`
- Applescript: `smart_jump_to_chrome.scpt`
- Node package: `node_test_emacs_jump`
- JavaScript assets: `assets/my_ext/browser_to_emacs.js`
- Put `exclude: [ ..., "_sync", "node_module"]` in `_config.yml`

I will explain how they are working together.

#### 1. _Emacs to Chrome_:

- Jekyll plugin: `_plugins/generator_test.rb`
  - creates a sync file at `_sync/postname.md.json`, which is looked up
	by the next elisp function.
- Elisp: `~/.emacs.d/init.el`
  - in post.md, the shortcut `C-c C-l` invokes a function, which does:
	- bla, bla, ...
- Applescript: `smart_jump_to_chrome.scpt`
  - This is invokes by the previous elisp shortcut.

#### 2. _Chrome to Emacs_:

- Jekyll plugin: `_plugins/generator_test.rb`
  - converts markdown header notation (like `### something`) in post.md files
	into an oridinary header tag with additional attributes, which is checked
	by the next `browser_to_emacs.js`.
- Node package: `node_test_emacs_jump`
  - `./bin/executable.js 4010` monitors a POST request at localhost:4010.
  - upon a request, run `emacsclient` command with appropriate options given from POST data.
- JavaScript assets: `assets/my_ext/browser_to_emacs.js`
  - Click on headers invokes a POST request to localhost:4010.

### References to implement those programs

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

### Move from Chrome to Emacs

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

### Future Work

- don't add attributes when it's in syntax highlight mode
