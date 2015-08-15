---
layout: post
title: "Backbone.js Tutorial"
description: ""
category: 
tags: [backbone.js, javascript]
---

# References

- <http://pragmatic-backbone.com/>
- <http://backbonejs.org/>
- <https://dzone.com/articles/backbone-tutorial-part-5>
- <https://backbonetutorials.com/>
- <http://thomasdavis.github.io/2011/02/07/making-a-restful-ajax-app.html>
- <http://ajaxload.info/>
- <http://adrianmejia.com/blog/2012/09/11/backbone-dot-js-for-absolute-beginners-getting-started/>
- <http://arturadib.com/hello-backbonejs/docs/1.html>

- Annotated source of todo application: <http://backbonejs.org/docs/todos.html>
- todo by typescript with backbone.js: <https://github.com/tastejs/todomvc/tree/gh-pages/examples/typescript-backbone>

- template by underscore: <http://underscorejs.org/#template>
  - `<%= ... %>`: normal
  - `<%- ... %>`: HTML-escape
  - `<%  ... %>`: execute arbitrary JavaScript code

- with Haml:
  - <http://stackoverflow.com/questions/16596659/unescaping-haml-in-an-attribute-hash>
  - <http://stackoverflow.com/questions/11218025/how-could-i-escape-a-in-haml-so-that-it-compiles-to-instead-of-amp-haml>

To get this `%input.edit{value: "<%- title %>"}` properly compiled, you need to set
the option `--no-escape-attrs` like this:

{% highlight ruby %}
rule '.html' => '.haml' do |t|
  sh "haml --no-escape-attrs #{t.source} #{t.name}"
end
{% endhighlight %}

For the record, I cannot use `html_safe` like this
`%input.edit{value: "<%- title %>".html_safe}` since I'm not in Rails.

- `this.input = this.$("#new-todo")` is so wired? what is happening

- Catalog of Events: <http://backbonejs.org/#Events-catalog>

- event context for `on` method:
  - <http://backbonejs.org/#Events-on>
  - [this](http://stackoverflow.com/questions/5490448/how-do-i-pass-the-this-context-into-an-event-handler)
	helps me to understand the notion of context.

- you need to consider what methods triggers what events, see <http://backbonejs.org/#Collection>.
  I felt this thinking about this chain is nightmare, but I think I was wrong and
  I should have written a nice program that works without thinking about these things.
  - `collection.create` triggers `collection.add`
  - `collection.add` triggers `model.add` and `model.update` (which means `change` too)

- the meaning of `this.$input = this.$(".edit")`
  - advantage:
	- overhead from searching a dom happens only one time
  - disadvantage:
	- you have to track when the associated dom (often comes from template) is refreshed.
	  (but I think we should consider this kind of tracking, generally.)
	- somehow it looks redundant.

- the type of collection-like things
  - when can I use `_.each col` or `col.each`?
  - is `col.filter F` no longer collection?
  - when can i use `_.chain(col)`?

- meaning of `type: text/template`
  - <http://stackoverflow.com/questions/4912586/explanation-of-script-type-text-template-script>

- events what is clicked:
  - <http://stackoverflow.com/questions/5680807/backbone-js-events-knowing-what-was-clicked>
  - <http://www.quirksmode.org/js/events_order.html>

- events trigger from input text field

- events triggered in collection/model
  - very confusing
  - `sync`, `reset`: <http://backbonejs.org/#Events-catalog>
  - `Backbone.sync`: <http://backbonejs.org/#Sync>
  - `collection.fetch`: <http://backbonejs.org/#Collection-fetch>
  - <http://stackoverflow.com/questions/15959306/backbone-js-fetch-method-does-not-fire-reset-event>

This is from [Backbone.js 1.2.1 annotated source](http://backbonejs.org/docs/backbone.html):
{% highlight javascript %}
fetch: function(options) {
  options = _.extend({parse: true}, options);
  var success = options.success;
  var collection = this;
  options.success = function(resp) {
	var method = options.reset ? 'reset' : 'set';
	collection[method](resp, options);
	if (success) success.call(options.context, collection, resp, options);
	collection.trigger('sync', collection, resp, options);
  };
  wrapError(this, options);
  return this.sync('read', this, options);
},
{% endhighlight %}

It looks like we don't have to give `{reset: true}` to `collection.fetch`.

- backbone.localstorage for a single model: <https://github.com/jeromegn/Backbone.localStorage/issues/56>
  - you must specify ID for consistency
  
{% highlight coffeescript %}
app.LocalData = Backbone.Model.extend
  localStorage: new Backbone.LocalStorage "ext-local-data"
  defaults: {id: 0}
app.localData = new app.LocalData()
{% endhighlight %}

- what the hell is `emulateHTTP`?
  - <http://backbonejs.org/#Sync-emulateJSON>
  - while testing a http request (to create model) with sinatra,
	it seemed I had to put this true like: `Backbone.emulateJSON = true`.
	I was freaked out while this caused me a trouble.
  - adopt to the request type `application/json`
	- <http://stackoverflow.com/questions/13675549/how-to-capture-params-hash-from-posted-json-in-sinatra-app>

  - media type: <https://en.wikipedia.org/wiki/Internet_media_type>
  - JSON data via HTTP: <http://stackoverflow.com/questions/477816/what-is-the-correct-json-content-type>
  - <http://stackoverflow.com/questions/20620300/http-content-type-header-and-json>

- parse only on model not on collection
  - <http://stackoverflow.com/questions/18652437/backbone-not-parse-each-model-in-collection-after-fetch>

- template with handlebars:
  - <http://stackoverflow.com/questions/9072324/using-handlebars-with-backbone>
  - <https://gist.github.com/kyleondata/3440492>
  - <http://www.remwebdevelopment.com/blog/javascript/using-handlebars-with-backbone-and-requirejs-and-precompiling-templates-182.html>
  
