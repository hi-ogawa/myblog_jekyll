---
layout: post
title: "TypeScript Tutorial"
description: ""
category: 
tags: []
---

# Flow

See [this official tutorial](http://www.typescriptlang.org/Tutorial)

- Installation: `npm install -g typescript`

# Misc

- module import/export: <http://www.typescriptlang.org/Handbook#modules-splitting-across-files>
- [definitelytyped.org](http://definitelytyped.org/)
- [repo](https://github.com/borisyankov/DefinitelyTyped)

# class

- Those initilizing things below are called in the following order:
  - `constructor`
  - property assignment
  - `initialize`

A property assignment is done after `constructor` call, which means
the instantiation (via constructor (is there any other instanciation?))
doesn't reflect the value assigned by this.
So basically you shouldn't do:

{% highlight javascript %}
// views/appView.ts
export class AppView extends Backbone.View<Backbone.Model> {
	el = "#todoapp"; // uncool
	constructor() {
		super();
	}
}
{% endhighlight %}

Probably, the way you can assign class property properly is to assign a value in
a overridden constructor definition, like this;

{% highlight javascript %}
// views/appView.ts
export class AppView extends Backbone.View<Backbone.Model> {
	constructor() {
		this.el = "#todoapp" // cool
		super();
	}
}
{% endhighlight %}

As another way, sometimes this kind of property initialization can be given through
`constructor` arguments, like this:

{% highlight javascript %}
// views/appView.ts
export class AppView extends Backbone.View<Backbone.Model> {
	constructor() {
	    super({el: "#todoapp"});
	}
}
{% endhighlight %}

You can see the same pattern in all of the other class definition file extended
from the class `backbone.d.ts`.

- the model generated at compile time can be recognized as an instance,
  but the one which is generated through `collection.add` or some other method
  can not be an instance.
  - since d.ts file doesn't change the implementation of `collection` method. ?
	- you need to assign explicitly `model = Todo` not only giving the generic instance by
	  `class TodoList extends Backbone.Collection<Todo>`.

- Should I put a type annotation like this:
  `var val : string = this.$input.val().trim();`
  - I think it's not so good since the right side expression can be anything on runtime.
  - but, just checking the use of `val` after this line could be worth.

- the syntax for a method definition in a object literal:
{% highlight javascript %}
	events() {
	    return {
		"keypress #new-todo": "createTodoOnEnter",
		"click .set-sort"      (){ this.sort = !this.sort; },  // <- are these possible
		"click .sets"		   (){ this.render(); }			   // <- in plain javascript ?
	    };
	}
{% endhighlight %}
