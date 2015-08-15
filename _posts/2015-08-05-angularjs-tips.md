---
layout: post
title: "angularjs tips"
description: ""
category: 
tags: []
---

# Angularjs generator by Yeoman

- Grunt automation
  - [jit-grunt](https://www.npmjs.com/package/jit-grunt)
	- `require('jit-grunt')` makes it unnecessarily to use `loadNpmTasks`
	  for each grunt dependencies.
  - [grunt-wiredep](https://github.com/stephenplusplus/grunt-wiredep)
	- when `bower.json` updates (which happens upon `bower install`), `wiredep` task runs
	  and inserts dependent js files written in `bower.json`
	  into the `app/index.html` file (see `bower:js` and `endbower`).
	- Q. Does this insert `app/scripts` js files too?
	  - A. No. But this is done by angularJS generator
		(see [readme](https://github.com/yeoman/generator-angular#add-to-index)).
  - [grunt-usemin](https://github.com/yeoman/grunt-usemin)
	- it minifies various resources.
	- see `build:js` (or `build:css`) and `endbuild` in `app/index.html`.
	- You should put your own scripts, like in `app/scripts`, into this region.
  - Watch and Compile HAML
    - <http://www.drurly.com/blog/2013/07/06/yeoman-and-haml>

# Work on Ruby on Rails

- cool: <http://blog.benmorgan.io/post/77446075979/setting-up-an-angularjs-app-with-a-rails-api>
  - with [Yeoman AngularJS generator](https://github.com/yeoman/generator-angular),
	putting the angular app into `/public` and rails api into `/app`.

- uncool: <https://thinkster.io/angular-rails/>
  - with `gem 'angular-rails-templates'`

{% highlight ruby %}
 # app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
...
  def angular
    render "layouts/application"
  end
end

 # config/routes.rb
root "application#angular"
{% endhighlight %}


# nested FormData

- <http://stackoverflow.com/questions/28774746/sending-nested-formdata-on-ajax>
- debug FormData: <http://stackoverflow.com/questions/7752188/formdata-appendkey-value-is-not-working>

# upload file (send data as a FormData object)

- <https://uncorkedstudios.com/blog/multipartformdata-file-upload-with-angularjs>
- <http://www.bennadel.com/blog/2615-posting-form-data-with-http-in-angularjs.htm>
- <http://stackoverflow.com/questions/11442632/how-can-i-post-data-as-form-data-instead-of-a-request-payload>

# custom directive (with `controller as`)

- <http://blog.thoughtram.io/angularjs/2015/01/02/exploring-angular-1.3-bindToController.html>

# get route parameter

- <https://docs.angularjs.org/api/ngRoute/service/$route>

# CRUD, state router

- <http://www.sitepoint.com/creating-crud-app-minutes-angulars-resource/>

# parse resource response

- custom service: <http://stackoverflow.com/questions/12719782/angularjs-customizing-resource>
- http interceptor: <http://stackoverflow.com/questions/21509829/angular-resource-make-date-objects>

- `transformResponse` or `intercepter`
  - `transformResponse` will do for each http (or resource) call
  - `intercepter` is kinda globally


# the trouble in PUT $resource (id parameter is not reflected in URL)

- <http://stackoverflow.com/questions/20205752/angularjs-resource-put-method-is-not-getting-the-id>

# event trigger

- `$broadcast`, `$emit`:
  - <http://stackoverflow.com/questions/14502006/working-with-scope-emit-and-on>
  - <http://stackoverflow.com/questions/26752030/rootscope-broadcast-vs-scope-emit>
- testing events:
  - <http://stackoverflow.com/questions/15272414/how-can-i-test-events-in-angular>

# difference betw. service/factory/provider

- <https://gist.github.com/Mithrandir0x/3639232>

# keep track a flush message

- <http://fdietz.github.io/recipes-with-angular-js/common-user-interface-patterns/displaying-a-flash-notice-failure-message.html>
- <http://sachinchoolur.github.io/angular-flash/>

# testing

- jasmine: <http://jasmine.github.io/1.3/introduction.html>
- karma: <https://www.airpair.com/angularjs/posts/testing-angular-with-karma>
- protractor:

- unit test: <https://docs.angularjs.org/guide/unit-testing>
- end to end test: <https://docs.angularjs.org/guide/e2e-testing>

- mock backend
  - <http://www.jeremyzerr.com/angularjs-backend-less-development-using-httpbackend-mock>
  - <https://docs.angularjs.org/api/ngMockE2E/service/$httpBackend>
  - <http://michalostruszka.pl/blog/2013/05/27/easy-stubbing-out-http-in-angularjs-for-backend-less-frontend-development/>

- testing promise
  - <http://entwicklertagebuch.com/blog/2013/10/how-to-handle-angularjs-promises-in-jasmine-unit-tests/>

- `spyOn` (Jasmine):
  - <http://angular-tips.com/blog/2014/03/introduction-to-unit-test-spies/>

- coffeescript notes on `$provide`:
  - <http://stackoverflow.com/questions/14238490/injecting-dependent-services-when-unit-testing-angularjs-services>

# form validation

- <https://scotch.io/tutorials/angularjs-form-validation>

# styleguide

- <https://github.com/johnpapa/angular-styleguide>
- coffeescript <https://github.com/Plateful/plateful-mobile/wiki/AngularJS-CoffeeScript-Style-Guide>
- make service component by coffeescript class <https://gist.github.com/xcarpentier/1e5683289cd24e626341>

# seeds

- <http://www.sitepoint.com/5-angular-js-seeds-bootstrap-apps-2/>

# user authentication (working with rails API)

- <https://medium.com/opinionated-angularjs/techniques-for-authentication-in-angularjs-applications-7bbf0346acec>
- <http://jasonwatmore.com/post/2015/03/10/AngularJS-User-Registration-and-Login-Example.aspx>
