---
layout: post
title: "Applescript with Javascript"
description: ""
category: 
tags: [javascript, applescript, btt]
---
{% include JB/setup %}

### How to open a dictionary for certain application.

<img src='/assets/images/applescript0.gif' width='600' height='auto'>

---

### Example: Running Javascript on Safari/GoogleChrome
<img src='/assets/images/applescript1.png' width='800' height='auto'>

{% highlight javascript %}
// google chrome
var chrome = Application('Google Chrome');
var tab    =  chrome.windows[0].activeTab;
var jscode = 'alert("from applescript")';
chrome.execute(tab, {javascript: jscode});
{% endhighlight %}

{% highlight javascript %}
// safari
var safari = Application('Safari')
safari.doJavaScript('alert("Hello!")', { in: safari.windows[0].currentTab })
{% endhighlight %}

---

### Jumping shortcut from chrome to Emacs

Consulting with these two example of applescript,

- [Getting the Application Instance](https://github.com/dtinth/JXA-Cookbook/wiki/Getting-the-Application-Instance)
- [Running Shell Scripts](https://github.com/dtinth/JXA-Cookbook/wiki/Shell-and-CLI-Interactions)

I finally made a shortcut for jumping from chrome to emacs when editting articles
made by Jekyll.

After writing this applescript as below:
{% highlight javascript %}
// jump_to_emacs_jekyll.scpt
var chrome = Application('Google Chrome');

var app = Application.currentApplication()
app.includeStandardAdditions = true

var url = chrome.windows[0].activeTab.url();
var filename = url.match(/^http:\/\/[^\/]*\/(.*)\/$/)[1].replace(/\//g,'-');
var com = '/usr/local/Cellar/emacs/24.3/bin/emacsclient --no-wait "/Users/hiogawa/repositories/github_public/myblog/_posts/' + filename + '.md"';

app.doShellScript(com);
{% endhighlight %}

I register a shortcut command (Com-J) via [BetterTouchTool](http://www.bettertouchtool.net/),
like this:

<img src='/assets/images/applescript2.png' width='600' height='auto'>


### Future work

- how could I find out `windows` is an available property which is not on scripting dictionaries?
  - I think I need to go through [this article](https://developer.apple.com/library/mac/releasenotes/InterapplicationCommunication/RN-JavaScriptForAutomation/) by apple.
- Create jump feature much more like TeX-PDF sync.
  - how to keep line number and position (it seems possible).


#### applescript/javascript references

- <https://developer.apple.com/library/mac/releasenotes/InterapplicationCommunication/RN-JavaScriptForAutomation/>
- <http://www.macstories.net/tutorials/getting-started-with-javascript-for-automation-on-yosemite/>
- <http://developer.telerik.com/featured/javascript-os-x-automation-example/>
- <https://github.com/dtinth/JXA-Cookbook/wiki>

