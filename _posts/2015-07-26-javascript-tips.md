---
layout: post
title: "Javascript Tips"
description: ""
category: [tips]
tags: []
---

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
