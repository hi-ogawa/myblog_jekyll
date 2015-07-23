---
layout: post
title: "Javascript Basics: Core Part"
description: ""
category: 
tags: [javascript]
---
{% include JB/setup %}

I've been using Javascript for a few months, but actually I haven't learn this language
systematically, which means I just put my codes all by intutition and learned what works by
try and error.
What's worse it seems I mixes jQuery and Javascript primitive.
That is not a productive work at all.
 
Recently, I started to learn some front-end javascript frameworks but those things seems
nothing but magic to me. Basically, I don't want to use too much magic feature,
so I feel I should start to look at source code but that's totally far from my knowledge
of javascript.

From these experiences, I decided to look over [this tutorial](http://www.w3schools.com/js/default.asp) by w3cscool.

For the record, I've not write raw javascrict code since I like the syntax of coffeescript,
but I know I have to learn some wierd behaviour comes from javascript basic.

Here, I write some basics I didn't know or what's different from my guess about javascript.




---

**Undefined value**
{% highlight javascript %}
var x;   // the value of x is `undefined`
{% endhighlight %}

**Left associative operator and Overloading**
{% highlight javascript %}
var x = 16 + 4 + 'hoge'    //  ==>  x is "20hoge"
var y = 'hoge' + 16 + 4    //  ==>  y is "hoge164"
{% endhighlight %}

**Two ways of function definition**
{% highlight javascript %}
var f = function(arg){ return arg + 2; };
function g(arg){ return arg + 2; }            // semicolon is unnecessary?
{% endhighlight %}

**Accessing object properties**
{% highlight javascript %}
var x = {prop0: 'hoge', prop1: 12};
// x.prop0     => 'hoge'
// x['prop1']  =>  12
{% endhighlight %}

**Object Literals**

These two seem to work same.
{% highlight javascript %}
var x = { foo:  1,  bar:  2};
var y = {'foo': 1, 'bar': 2}; 
{% endhighlight %}

**Scope**

> In JavaScript, scope is the set of variables, objects, and functions you can access to.

(from <http://www.w3schools.com/js/js_scope.asp>)

- **Automatically global if variable is used without declaration**

{% highlight javascript %}
function f() { x = 'hoge'; }
alert(x)                      //  <= not error
{% endhighlight %}

**Global variables is just a property of `window` object**

{% highlight javascript %}
function f() { x = 'hoge'; }
alert(window.x)               //  <= not error
{% endhighlight %}

**HTML events**

- <http://www.w3schools.com/jsref/dom_obj_event.asp>

{% highlight html %}
<button onclick='getElementById("demo").innerHTML=Date()'>The time is?</button>
{% endhighlight %}

{% highlight html %}
<button onclick="this.innerHTML=Date()">The time is?</button>
{% endhighlight %}

- <a name='q1'></a> _Question:_
	- Where the hell does `getElementByID` method come from?
	  What I found out so far is `getElementById` is not a method from `window` object.
	  - _Answer_ is `document.getElementById`.
	- Who is `this`?
	- How different are `document` and `window` each other?

**String**

- **Quotes**

	Those below are all legit string.
{% highlight javascript %}
var answer = "It's alright";
var answer = "He is called 'Johnny'";
var answer = 'He is called "Johnny"';
{% endhighlight %}

- **Break**

	You can also break a long string literal by putting a backslash.
{% highlight javascript %}
var x = "hoge fo\
o bar"
{% endhighlight %}

- **Methods**

	Basically, it's impossible for primitive values to have properies or methods.
	But, Javascript specially treats a primitive value so that it's okay to call
	properties or methods like being a object.

{% highlight javascript %}
"John Doe".length   // 8
{% endhighlight %}

	Here is a list of String methods: <http://www.w3schools.com/jsref/jsref_obj_string.asp>

**Comparison of object**

- **comparing values of two strings**

	One is a primitive value another is a String object.
{% highlight javascript %}
"john" == new String ('john')               =>  true
{% endhighlight %}

- **comparing values and types of two things**
{% highlight javascript %}
"john" === new String ('john')              =>  false
{% endhighlight %}

- **impossible to compare two objects**
{% highlight javascript %}
new String("john") == new String ('john')   =>  false
{% endhighlight %}



**Number**

Javascript has only one type for numbers,
which are always represented as 64-bit floating point:
- sign: 1bit
- fraction: 11bit
- exponent: 52bit

- **Putting number in a different base representation**

{% highlight javascript %}
128.toString(16);	   // returns 80
128.toString(8);	   // returns 200
128.toString(2);	   // returns 10000000	
{% endhighlight %}

- **Infinity, NaN**
- **number object wrapper: Number**

All methods related number objects or primitives are here: <http://www.w3schools.com/jsref/jsref_obj_number.asp>

**Special objects**

- **Math object**: <http://www.w3schools.com/jsref/jsref_obj_math.asp>
- **Date object**: <http://www.w3schools.com/jsref/jsref_obj_date.asp>

{% highlight javascript %}
typeof (Date())         // "string"  (Date() can be window.Date())
typeof (new Date())     // "object"
{% endhighlight %}

{% highlight javascript %}
Number(Date())         // NaN
Number(new Date())     // Millisec of the current time
{% endhighlight %}


- **Array object**: <http://www.w3schools.com/js/js_array_methods.asp>
  - should `new Array()` be avoided? (I might have seen some codes which use this.) 
  
  - <a name='q2'></a> recognizing array:
  they say this function returns true if the object prototype
  of `myArray` is `"[object array]"`. What the hell is 'object prototype'?
  what is the `.contructor` ?
  

{% highlight javascript %}
function isArray(myArray) {
    return myArray.constructor.toString().indexOf("Array") > -1;
}
{% endhighlight %}

**What value is treated as `false`**

{% highlight javascript %}
_.some([0, -0, "", undefined, null, false, NaN])  //  false
{% endhighlight %}

**Switch case statement**

It seems kinda wierd. `case` is just testing from top.
{% highlight javascript %}
switch (new Date().getDay()) {
    case 1:
    case 2:
    case 3:
    default: 
        text = "Looking forward to the Weekend";
        break; 
    case 4:
    case 5:
       text = "Soon it is Weekend";
        break; 
    case 0:
    case 6:
       text = "It is Weekend";
}
{% endhighlight %}

**Javascript Data Types**

The thing in Javascript can be divided as below:

	.
	|-- data types (can contain values)
	|	    |-- string
	|		|-- number
	|		|-- boolean
	|		|-- function
	|		|-- object
	|              |-- Object
	|              |-- Date
	|              |-- Array
    |
	|-- other things (cannot contain values)
             |-- `null`
          	 |-- `undefined`

The operator `typeof` returns the above 5 data types.

Value conversion rules are here: <http://www.w3schools.com/jsref/jsref_type_conversion.asp>

**Regular expression**

<http://www.w3schools.com/jsref/jsref_obj_regexp.asp>

**Error handling**

I don't know if it's common to use this error handling. I think I've never seen the code
which uses this mechanism.

{% highlight javascript %}
try {
	throw "error happenning";
} catch (err) {
	console.log("error '" + err + "' is catched.");
} finally {
	console.log("this code is always executed.")
}
{% endhighlight %}

**Debugging**

I didn't know this reserved word. It will be a very good friend of mine.
{% highlight javascript %}
var x = 15 * 5;
debugger;
console.log(x);
{% endhighlight %}

**Strict mode**

This `"use strict"` is just what i saw on the tutorial of angular.js.
There are a lot of code pattarn not allowed to write in this mode, which is obviously
what I've never written.

- <http://www.w3schools.com/js/js_strict.asp>

Then, here is about Coffeescript and `"use strict"`.

- <https://github.com/jashkenas/coffeescript/issues/1547>
- <http://stackoverflow.com/questions/17176637/how-can-i-ensure-that-code-works-the-same-way-in-strict-mode-and-lax-mode>
- <http://www.coffeescriptlove.com/2012/04/coffeescript-gets-strict-mode.html>

I don't go over everything here, but it looks like I don't have to care this mode as long as
being with Coffeescript.

**Coding convension**

Actually these three parts are telling me I should write javascript with Coffeescript.
That's it.

- <http://www.w3schools.com/js/js_conventions.asp>
- <http://www.w3schools.com/js/js_best_practices.asp>
- <http://www.w3schools.com/js/js_mistakes.asp>

Some points I should put in my mind could be the below:

- Javascript automatically close a statement at the end of line (if the line works as it is).

{% highlight javascript %}
function myFunction(a) {
    var            // this line cannot be a statement itself.
    power = 10;
    return         // this line can be a statement itself. that's why it returns `undefined`.
    a * power;
}
{% endhighlight %}

- `undefined` is not `null`.

	`null` is an object and is not an `undefined` thing at least.
	You should check "undefinedness" first to see the existence of the variable,
	which is done in Coffeescript:
{% highlight javascript %}
typeof x !== "undefined" && x !== null;      //    <-   `x?` in coffeescript
{% endhighlight %}



**Reserved words**

<http://www.w3schools.com/js/js_reserved.asp>


**JSON (JavaScript Object Notation)**

JSON data can be easilly converted to native Javascript object.
{% highlight javascript %}
var text = '{ "employees" : [' +
'{ "firstName":"John" , "lastName":"Doe" },' +
'{ "firstName":"Anna" , "lastName":"Smith" },' +
'{ "firstName":"Peter" , "lastName":"Jones" } ]}';
var obj = JSON.parse(text);
{% endhighlight %}


**HTML form validation API**

- <http://www.w3schools.com/js/js_validation_api.asp>: 
  I'm suspicious this is a good practice to validate the input of forms.
  I suppose there's another way to handle this with js frameworks or libraries.


**Javascript object**

- _`this`_:

	> In JavaScript, the thing called this, is the object that "owns" the JavaScript code.
	>
	> - The value of this, when used in a function, is the object that "owns" the function.
	> - The value of this, when used in an object, is the object itself.
	> - The this keyword in an object constructor does not have a value. It is only a substitute for the new object.
	> - The value of this will become the new object when the constructor is used to create an object.

- _objects are mutable_:

{% highlight javascript %}
var x = {hoge: 1, foo: 2};
var y = x;
y.hoge = 10                  // then, x.hoge is also 10.
{% endhighlight %}

- <a name='q3'></a> _prototype_ is a special object from which
  javascript objects inherit their properties and methods.

{% highlight javascript %}
Array.prototype                          // returns `[]`
function person(first, last, age) {      // defines an object constructor.
    this.firstName = first;
    this.lastName = last;
    this.age = age;
}
var p = new person('hi', 'ogawa', 100);
person.prototype;                        // returns `person()`
{% endhighlight %}

- changing prototype properties and methods

{% highlight javascript %}
function person(first, last) {
    this.firstName = first;
    this.lastName = last;
}
var p = new person('hi', 'ogawa');
person.prototype.name = function() {
    return this.firstName + " " + this.lastName;
};
p.name();                                          // this returns "hi ogawa"
{% endhighlight %}


**Functions**

- _as objects_: a function itself has properties and methods.

{% highlight javascript %}
function f(a, b) {
    return [arguments.length, arguments[0]];
}
f('a')                          // returns [1, 'a'] 
f('c', 'b', 'a')				// returns [3, 'c']
f.toString();
{% endhighlight %}

- _arguments_: These are rules.

	> - JavaScript function definitions do not specify data types for parameters.
	> - JavaScript functions do not perform type checking on the passed arguments.
	> - JavaScript functions do not check the number of arguments received.

When a function is called with "missing arguments", the variable in a function body are
set to `undefined`.
{% highlight javascript %}
function f(a, b){
	return b;
}
f(1)                           // returns `undefined`
{% endhighlight %}

- _call-by-value, call-with-reference_:

{% highlight javascript %}
function f(o){
	o.name = 'hoge';
}
var o = {name: 'foo'}
o.name                        // returns 'foo'
f(o)
o.name						  // returns 'hoge'
{% endhighlight %}


- _the behaviour of `this`_: depends on contenxts. (`this` becomes an owner object.)

{% highlight javascript %}
// a function in a global scope (window object)

function f(){ return this; }
f()                               // returns the `window` object when you're in a browser
{% endhighlight %}

{% highlight javascript %}
// a function in an object literal.

var p = {
    firstName:"John",
    lastName: "Doe",
    fullName: function () {
        return this.firstName + " " + this.lastName;
    }
}
p.fullName();         // Will return "John Doe"
{% endhighlight %}

{% highlight javascript %}
// a function as a constructor of an object

function person(first, last, age) {
    this.firstName = first;
    this.lastName = last;
    this.age = age;
}
var p = new person('hi', 'ogawa', 100);
p.firstName;
{% endhighlight %}

{% highlight javascript %}
// specifing owner by `call` or `apply` from "function" object methods.
// the only difference between `call` and `apply` is the way you give parameters.

function f(a, b) {
	return this[a] + this[b];
}
var o = {hoge: 1, foo: 2};
f.call(o, 'hoge', 'foo');             // returns 3 

function f(a, b) {
	return this[a] + this[b];
}
var o = {hoge: 1, foo: 2};
f.apply(o, ['hoge', 'foo']);          // returns 3
{% endhighlight %}


**Questions references**

- [Q1](#q1)
- [Q2](#q2)
- [Q3](#q3) Is it possible to create prototype/constructor in coffeescript
  since function definition in coffeescript always returns something and I feel
  that makes a different behaviour.
