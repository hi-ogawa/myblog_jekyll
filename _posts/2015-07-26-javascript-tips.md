---
layout: post
title: "Javascript Tips"
description: ""
category: [tips]
tags: []
---

# fluent interface in javascript

- <https://en.wikipedia.org/wiki/Fluent_interface>
- <http://nikas.praninskas.com/javascript/2015/04/26/fluent-javascript/>

# style guides

- Airbnb (including ES6) <https://github.com/airbnb/javascript#ecmascript-6-styles>

# ECMAScript 5.1

- annotated source? <http://es5.github.io/>
- official <http://ecma-international.org/ecma-262/5.1/>

# utility libraries

- [underscore](https://github.com/jashkenas/underscore),
  [DefinitelyTyped](https://github.com/borisyankov/DefinitelyTyped/blob/master/underscore/underscore.d.ts)
- [lodash](https://github.com/lodash/lodash)
- [boiler](https://github.com/Xaxis/boiler)
- [lazy.js](https://github.com/dtao/lazy.js),
  [DefinitelyTyped](https://github.com/borisyankov/DefinitelyTyped/blob/master/lazy.js/lazy.js.d.ts)
- [javascript-algorithms](https://github.com/mgechev/javascript-algorithms)


# Under the hood (interaction with the native browser)

- must watch videos <https://github.com/bolshchikov/js-must-watch>

<iframe width="260" height="155" src="https://www.youtube.com/embed/dibzLw4wPms" frameborder="0" allowfullscreen></iframe>
<iframe width="260" height="155" src="https://www.youtube.com/embed/Bv_5Zv5c-Ts" frameborder="0" allowfullscreen></iframe>
<iframe width="260" height="155" src="https://www.youtube.com/embed/UzyoT4DziQ4" frameborder="0" allowfullscreen></iframe>

- [Understanding JavaScript Function Invocation and "this"](http://yehudakatz.com/2011/08/11/understanding-javascript-function-invocation-and-this/)
  - Invoking a function call could be considered as just a suger of the "primitive" method
    `<function>.call(<object>, <arg0>, <arg1>, ...)`.
  - see [this](http://hi-ogawa.github.io/2015/07/21/javascript-basics/#tocAnchor-1-25).
  - `bind`: (`f`: function, `o`: object) ->> (function f whose `this` is fixed as a given `o`)
- [Understanding "Prototypes" in JavaScript](http://yehudakatz.com/2011/08/12/understanding-prototypes-in-javascript/)
  - `Object.create(null)`: returns an empty object
  - the types of a property which appear on the argument of `Object.defineProperty()`:
    - "enumerable": make it show up on `for(prop in obj)` loop.
    - "configurable": make it able to be deleted or be changed its other attributes
      (what's this "attributes" supposed to mean? those 3 types?).
    - "writable": make it able to be overwritten anytime.?
  - `Object.create()` works like inheritance of objects because of this fact:

> In fact, JavaScript objects also have one additional attribute: a pointer to another object. We call this pointer the object's prototype. If you try to look up a key on an object and it is not found, JavaScript will look for it in the prototype. It will follow the "prototype chain" until it sees a null value. In that case, it returns undefined.

  - method/property assignments for objects are just a sugar of `Object.defineProperty()`.
  - object literal is a sugar of `Object.create(Object.prototype)`
  
{% highlight javascript %}
var e0 = Object.create(null);
Object.getPrototypeOf(e0)     // returns `null`
var e1 = {};
Object.getPrototypeOf(e1)     // returns `Object.prototype`
{% endhighlight %}

  - `Object.prototype` has a reasonable methods we expect for objects, which can be overridden.
    - ex. `.toString()` ...
  - what `new <f: function>(<arg0>, <arg1>, ...)` does:
{% highlight javascript %}
var o = Object.create(f.prototype);

{% endhighlight %}
  
- prototype chain
  - <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Inheritance_and_the_prototype_chain>
  - <http://wildlyinaccurate.com/understanding-javascript-inheritance-and-the-prototype-chain/>

- <https://www.youtube.com/watch?v=Bv_5Zv5c-Ts>
  - the real mechanism of hoisting and execution context:
    <https://youtu.be/Bv_5Zv5c-Ts?t=41m43s>
    - `Uncaught: ReferenceError` vs. `undefined`
  - scope chain (lexical outer environment): <https://youtu.be/Bv_5Zv5c-Ts?t=1h16m7s>
  - asynchronicity of various engines composing a browser:
    <https://youtu.be/Bv_5Zv5c-Ts?t=1h39m10s>
    - only after any global code is executed, events queue is watched.
  - Framework Aside: <https://youtu.be/Bv_5Zv5c-Ts?t=2h58m13s>
    - loading js scripts from html
  - Objects and functions <https://youtu.be/Bv_5Zv5c-Ts?t=3h5m20s>

# coffeescript

- fat arrow
  - <http://webapplog.com/understanding-fat-arrows-in-coffeescript/>
  - `this` = `@`
- multiline string: <http://coffeescript.org/#strings>


# define global variables in coffeescript

- <http://stackoverflow.com/questions/4214731/coffeescript-global-variables>

# underscore

- chaining: <http://underscorejs.org/#chaining>

# Language

- TypeScript, CoffeeScript, ES6: <http://www.slideshare.net/NeilGreen1/type-script-vs-coffeescript-vs-es6>
- adding typescript to coffeescript: <http://stackoverflow.com/questions/12874942/adding-typescript-to-coffeescript>

# Frameworks

- TodoMVC <http://todomvc.com/>
- Knockout <http://knockoutjs.com/>
- React <http://facebook.github.io/react/>
- React vs Angular
  - <https://www.airpair.com/angularjs/posts/angular-vs-react-the-tie-breaker>
  - <https://www.codementor.io/reactjs/tutorial/react-vs-angularjs#/>
- What is MVVM framework? <http://addyosmani.com/blog/understanding-mvvm-a-guide-for-javascript-developers/>

# JSONP, CORS

- JSONP (JSON with Padding)<http://stackoverflow.com/questions/2067472/what-is-jsonp-all-about>
- CORS (Cross Origin Resource Sharing) <https://en.wikipedia.org/wiki/Cross-origin_resource_sharing>
- Ajax (asynchronous JavaScript and XML) <https://en.wikipedia.org/wiki/XMLHttpRequest>
- HMLHttpRequest <https://en.wikipedia.org/wiki/XMLHttpRequest>
- YQL <https://developer.yahoo.com/yql/>
- Jquery with YQL <http://james.padolsey.com/javascript/cross-domain-requests-with-jquery/>
- Cross origin Ajax <http://www.ajax-cross-origin.com/how.html>

# Misc

- node.js http-server: <http://chrisbitting.com/2014/06/16/local-web-server-for-testing-development-using-node-js-and-http-server/>
- how to prepare fake response for test:
  - <https://docs.angularjs.org/api/ngMock/service/$httpBackend>
- browser caching
  - json file is not updated
- include 3rd-parth javascript library in angular.js
  - <http://stackoverflow.com/questions/21559123/include-3rd-party-javascript-libraries-into-an-angularjs-app>
- coffeescript global object
  - <http://stackoverflow.com/questions/4214731/coffeescript-global-variables>
  - <http://jarrettmeyer.com/blog/2013/02/07/getting-to-global-variables-in-coffeescript>

- console object, callback and illegal invocation?
  - <http://stackoverflow.com/questions/8904782/uncaught-typeerror-illegal-invocation-in-javascript>

- how to show ajax loading gif image?
  - <http://stackoverflow.com/questions/4684722/show-loading-image-while-ajax-is-performed>
  - <http://www.w3schools.com/jquery/ajax_ajaxcomplete.asp>
- by yql, how to get only html data without associated assets?
- what is a gap between the time callback works and ng-model updates?
  - <http://jimhoskins.com/2012/12/17/angularjs-and-apply.html>
  - <http://stackoverflow.com/questions/11873627/angularjs-ng-model-binding-not-updating-with-dynamic-values>
  - <http://stackoverflow.com/questions/9682092/databinding-in-angularjs>

- inline select box: <http://stackoverflow.com/questions/19905166/bootstrap-3-select-input-form-inline>

- inject external video in ifram: <http://stackoverflow.com/questions/21292114/external-resource-not-being-loaded-by-angularjs>

- amber vs angular: <http://eviltrout.com/2013/06/15/ember-vs-angular.html>

- promise thing
  - <http://stackoverflow.com/questions/17646034/what-is-the-best-practice-for-making-an-ajax-call-in-angular-js>
  - in AngularJS: <https://docs.angularjs.org/api/ng/service/$q>
  - MDN: <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise>
	- throw error: <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/resolve#Resolving_thenables_and_throwing_Errors>
  - in JQuery: <http://api.jquery.com/jquery.ajax/>
  - patterns: <https://www.promisejs.org/patterns/>

- service
  - <https://docs.angularjs.org/guide/services>

- angularjs with requirejs
  - <http://stackoverflow.com/questions/12529083/does-it-make-sense-to-use-require-js-with-angular-js>
  - <https://github.com/tnajdek/angular-requirejs-seed>

- run function by hitting enter
  - <https://docs.angularjs.org/api/ng/directive/ngSubmit>
  - <http://stackoverflow.com/questions/15417125/submit-form-on-pressing-enter-with-angularjs>

- insert html
  - <http://stackoverflow.com/questions/9381926/insert-html-into-view-using-angularjs>

- ng-click in ng-repeat
  - <http://stackoverflow.com/questions/16736804/ng-click-doesnt-work-inside-ng-repeat>
  - to access models in `$scope` from in 'ng-repeat' children,
	you need to write like this: `$parent.<model name>`.

- save object within session
  - `$cookies.put`, `$cookies.get`:
  - `$cookies.putObject`, `$cookies.putObject`: serialize, deserialize
  - <https://blog.nraboy.com/2014/12/use-ngstorage-angularjs-local-storage-needs/>
  - the type of storage
	- cookie, sessionstorage, localstorage

- FormData object
  - <https://developer.mozilla.org/en-US/docs/Web/API/FormData/Using_FormData_Objects>
  - with jQuery
	- <http://stackoverflow.com/questions/6974684/how-to-send-formdata-objects-with-ajax-requests-in-jquery>
	- <http://www.mattlunn.me.uk/blog/2012/05/sending-formdata-with-jquery-ajax/>
	- <http://www.sitepoint.com/easier-ajax-html5-formdata-interface/>

- dataURL to file object
  - <http://stackoverflow.com/questions/6850276/how-to-convert-dataurl-to-file-object-in-javascript>
  - and the opposite way (to debug (or just confirm) the above way is working)
	- <http://stackoverflow.com/questions/4478863/show-image-from-blob-in-javascript>
	- <http://www.w3.org/TR/FileAPI/#url>

{% highlight coffeescript %}
chrome.tabs.captureVisibleTab (dataurl) ->
  picBlob = dataURLtoBlob dataurl	
  picUrl = URL.createObjectURL(picBlob)
  $('body').append $("<img>").attr("src", picUrl)
{% endhighlight %}

- check the detail of a web request with google developer tool
  - Developer Tools -> Network (see the bottom half pane)
