---
layout: post
title: "Node.js Tutorial"
description: ""
category: 
tags: [node.js, javascript]
---

I followed some node.js tutorials out there.
Finally, I reached making
[my first npm package](https://www.npmjs.com/package/node_test_emacs_jump),
which is for [this]({% post_url 2015-07-21-jekyll-setup %}).
But, basically this is just for my study and experiments of nodejs,
so the npm package has a lot of things which don't make sense itself.

### What I Learned and References

- General overview and installation of node.js: <https://www.airpair.com/javascript/node-js-tutorial>
- Node.js programming
  - create a server listening localhost port and handling POST request
	- <http://stackoverflow.com/questions/5710358/how-to-get-post-a-query-in-express-js-node-js>
	- allow cross domain: <http://stackoverflow.com/questions/18310394/no-access-control-allow-origin-node-apache-port-issue>
  - call a shell command
	- <https://nodejs.org/api/child_process.html#child_process_child_process_exec_command_options_callback>
	- <http://stackoverflow.com/questions/12941083/get-the-output-of-a-shell-command-in-node-js>
  - get a command line arguments in nodejs executable file: <https://nodejs.org/docs/latest/api/process.html#process_process_argv>
  - read a json file: <http://stackoverflow.com/questions/10011011/using-node-js-how-do-i-read-a-json-object-into-server-memory>
- Make and publish an npm package
  - very nice guide: <http://nickdesaulniers.github.io/blog/2013/08/28/making-great-node-dot-js-modules-with-coffeescript/>
  - parameters in package.json: <https://docs.npmjs.com/files/package.json>
  - pre-setting: <https://gist.github.com/coolaj86/1318304>
  - put dependencies in package.json
	- you can check by `npm list` whether the dependencies written in `package.json` is
	  consistent with local `node_modules` directory.
- Grunt
  - compile coffescript: <https://github.com/gruntjs/grunt-contrib-coffee>
- How to make a module
  - tutorial: <https://nodesource.com/blog/your-first-nodejs-package>
  - example: <http://www.sitepoint.com/understanding-module-exports-exports-node-js/>
  - export a class written by coffeescript: <http://stackoverflow.com/questions/12310070/node-js-module-exports-in-coffeescript>
- Misc
  - `class` notation in coffeescript: <http://coffeescript.org/#classes>
  - with emacs
	- nodejs-repl
	- coffee-repl ?
  - browse npm packages online: <https://www.npmjs.com/>

### How My Package Works

#### **Installation:**

{% highlight bash %}
$ npm install node_test_emacs_jump
{% endhighlight %}

#### **Usage:**

As an executable,
{% highlight bash %}
$ node_modules/.bin/node_test_emacs_jump_app <port-number> # stand up the server for something ridiculous
{% endhighlight %}

As a module,
{% highlight coffeescript %}
myModule = require 'node_test'
p0 = new myModule.Person 'John', 'Doe'
p0.fullname()                          # returns 'John Doe'
{% endhighlight %}

### Future Study

- Learn basic test framework in nodejs project as in
  <http://nickdesaulniers.github.io/blog/2013/08/28/making-great-node-dot-js-modules-with-coffeescript/>
- Deeper node.js tutorial running a server: <http://cwbuecheler.com/web/tutorials/2013/node-express-mongo/>
