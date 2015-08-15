---
layout: post
title: "ChromeExtension Tips"
description: ""
category: [tips]
tags: []
---

# where to save authentiction token on the client side

- <http://security.stackexchange.com/questions/80727/best-place-to-store-authentication-tokens-client-side>
- <https://auth0.com/blog/2014/01/27/ten-things-you-should-know-about-tokens-and-cookies/>
- <http://security.stackexchange.com/questions/33727/drawbacks-of-storing-an-authentication-token-on-the-client-side>
- JWT <https://stormpath.com/blog/token-auth-spa/>


# the arguments for sendMessage

- obviously `FormData` object cannot be given.
  - in content script	
	`Object {url: "http://localhost:4567/upload", type: "POST", data: FormData, processData: false, contentType: false}`
  - in background
	`Object {url: "http://localhost:4567/upload", type: "POST", data: Object, processData: false, contentType: false}`


# check request is working (easily)

- sinatra <http://www.sinatrarb.com/intro.html>
- mock server <http://www.mock-server.com/mock_server/getting_started.html>

# callback from onMessage

- <https://developer.chrome.com/extensions/runtime#event-onMessage>
- <https://developer.mozilla.org/en-US/docs/Web/Guide/Parsing_and_serializing_XML>

> - _the argument should be JSON-ifiable object._
> - _This function becomes invalid when the event listener returns, unless you return true._

So, I couldn't pass an xml document object to a callback,
which is why I bothered to get through like this:

{% highlight javascript %}
chrome.runtime.onMessage.addListener (request, sender, callback) ->

  switch request.type
    when "ajax"
      Promise.resolve($.ajax(request.settings))
        .then((data) ->
          if request.settings.dataType is "xml"
            callback {status: "success", data: (new XMLSerializer()).serializeToString(data)}
          callback {status: "success", data: data})
        .catch((err) ->
          callback {status: "error",   data: err})
      true  # this got the programs work, what a mystery

{% endhighlight %}

# inject HTML content in the body (from content script)

- with jQuery
  - <http://stackoverflow.com/questions/5125254/jquery-replace-div-contents-with-html-from-an-external-file-full-example>
  - <http://stackoverflow.com/questions/3432553/how-to-load-replace-an-entire-div-from-an-external-html-file>

- load file from its own extension package directory
  - refferring to extension files: <https://developer.chrome.com/extensions/content_scripts#extension-files>

- manifest setting
  - web_accessible_resources: <http://stackoverflow.com/questions/13696906/resources-must-be-listed-in-the-web-accessible-resources-manifest-key-in-order-t>

# listen the change of localstorage

- <https://developer.chrome.com/extensions/storage>
  - <https://developer.chrome.com/extensions/storage#event-onChanged>

- is it possible to put this in backbone? (in what sense?)

# Keep user session

- <http://stackoverflow.com/questions/6991226/chrome-extension-web-app-session-control>
- <http://stackoverflow.com/questions/7287061/log-in-to-my-web-from-a-chrome-extension/10493861#10493861>
- <http://stackoverflow.com/questions/5354029/login-to-website-with-chrome-extension-and-get-data-from-it/5354526#5354526>

Reading all these, the point is Google Chrome keeps a cookie for each domain
to which you've done accessed.
So, basically, you don't have to manage user sessions within a chrome extension
independently from its relavant web service.

Actually, I'm using a silly strategy about user authentication in [my chrome extension](),
which includes some redundant steps.
So, I finally can make it simple.

- before: [some codes and images]()
- after: [some codes and images]()
