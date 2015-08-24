---
layout: post
title: "rails under the hood"
description: ""
category: 
tags: []
---

# Rack

- is a web server interface: <http://rack.github.io/>
- what Rack app (web framework) does is providing "app" like this:
  - `app` : (env. hash) ⟼ [ (http resp. code), (header hash), (resp. body)]
  - `app` responds to the method `#call` (it seems `app` should be a `Proc` object).
  - what composes the env. hash: <http://www.rubydoc.info/github/rack/rack/master/file/SPEC#The_Environment>
    - `REQUEST_METHOD`: represents HTTP request method.
    - `PATH_INFO`: represents request URL.
    - `QUERY_STRING`: represents request parameter following URL after `?`.
    - `rack.input`: represents POST data.
    - and more ...
  - ex. Rails, Sinatra, ...

- what Rack server does is preparing "handler" like this:
  - (Someday, I follow one of those libraries below and ruby web request primitive.)
  - ex.
    - WEBrick(included in ruby's standard library): <http://ruby-doc.org/stdlib-2.0.0/libdoc/webrick/rdoc/WEBrick.html>
    - Unicorn: <https://github.com/blog/517-unicorn>
    - Passenger (kinda different? like tweak Nginx directory?): <https://github.com/phusion/passenger>

- two ways of invokation:
{% highlight ruby %}
 # via a ruby program:
 # `web_app.rb`
require 'rack'
Rack::Handler::WEBrick.run lambda {|env| ['200', {'Content-Type' => 'text/html'}, ['here is rack app.']]}
{% endhighlight %}

{% highlight ruby %}
 # via the cli `rackup` with a DSL-like config file `config.ru`:
 # `config.ru` usage: $ rackup config.ru
run lambda {|env| ['200', {'Content-Type' => 'text/html'}, ['here is rack app.']]}
{% endhighlight %}

# Initialization of Rails Application

As I read the source code, I picked up the path of initializing chain (in my local PC).
For simplicity, I omitted a lot of parts of each file (I don't even write three dots "...") and
sometimes added the meaning of methods as omments without showing the code of methods.

These two helps me a lot to see the overall direction.

- [RailsCast #299](http://railscasts.com/episodes/299-rails-initialization-walkthrough)
- [RailsGuides](http://guides.rubyonrails.org/initialization.html)

## "$ rails s" ->> "Rails::Server"

{% highlight ruby %}
 # ~/.rbenv/versions/2.1.2/bin/rails
load Gem.bin_path('railties', 'rails', version)

 # ~/.rbenv/versions/2.1.2/lib/ruby/gems/2.1.0/gems/railties-4.1.4/bin/rails
require "rails/cli"

 # ~/.../railties-4.1.4/lib/rails/cli.rb
require 'rails/app_rails_loader'
Rails::AppRailsLoader.exec_app_rails

 # ~/.../railties-4.1.4/lib/rails/app_rails_loader.rb
exec RUBY, exe, *ARGV # <= exececute `bin/rails` in your local rails project

 # (rails root)/bin/rails
APP_PATH = File.expand_path('../../config/application',  __FILE__)
   # <= '(rails root)/config/application'
require_relative '../config/boot'
require 'rails/commands'

 # (rails root)/config/boot.rb
require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])
  # <= make gems listed in Gemfile ready to be required

 # ~/.../railties-4.1.4/lib/rails/commands.rb
require 'rails/commands/commands_tasks'
Rails::CommandsTasks.new(ARGV).run_command!(command)

 # ~/.../railties-4.1.4/lib/rails/commands/commands_tasks.rb
def run_command!(command)
  send(command)
def server
  set_application_directory!        # <= Dir.chdir("(rails root)")
  require_command!("server")        # <= require "rails/commands/server"
  Rails::Server.new.tap do |server|
    # `Rails::Server.new` doesn't do big things. ignore it, for now. 
    require APP_PATH   # (1)
    Dir.chdir(Rails.application.root)
    server.start       # (2)
{% endhighlight %}

## (1) "require APP_PATH" ->> defining "Rails.application"

{% highlight ruby %}

 # railties/rails.rb # first of all, `Rails` has an instance variable `application`
module Rails
  class << self
    attr_accessor :application, :cache, :logger

 # (rails root)/config/application.rb
require 'rails/all'   # <= require active_record, action_controller, etc...
Bundler.require(*Rails.groups)
module MyApp
  class Application < Rails::Application
   # <= this triggers `Rails::Application.inherited(MyApp::Application)`

 # railties/rails/application.rb
module Rails
  class Application < Engine
    class << self
      def inherited(base)
        # codes triggered when `module MyApp; class Application < Rails::Application`
        super
        base.instance     # <= this leads to `Rails::Realtie.instance`, see below.

    def initialize(initial_variable_values = {}, &block)
      Rails.application ||= self # `Rails.application` : `Rails::Application`

 # railties/rails/engine.rb
module Rails
  class Engine < Railtie

 # railties/rails/realtie.rb
module Rails
  class Realtie
    class << self
      def instance
        @instance ||= new   # <= Here it is!! this creates `MyApp::Application.new`.
{% endhighlight %}

## (2) "server.start" ->> "Rack::Server#start"

- (2.1) build "rack app"
  - (2.1.1) initialize
    - `Rack::Server#app`
    - `Rack::Builder#instance_eval`
    - evaluates `(rails root)/config.ru`
  - (2.1.2) adds middleware
    - `Rack::Server#build_app`
- (2.2) run "rack compatible web server"

{% highlight ruby %}

 # .../railties/rails/commands/server.rb
require 'action_dispatch'
require 'rails'
module Rails
  class Server < ::Rack::Server
    def initialize(*)
      super
      set_environment  # <= set `ENV["RAILS_ENV"]`

    def start
      print_boot_information  # what you see after `$ rails s`
      trap(:INT) { exit }
      create_tmp_directories  # `mkdir tmp/{cache, pids, sessions, sockets}`
      log_to_stdout if options[:log_stdout]
      super

    def default_options
      super.merge({
        Port:        3000, ...
        environment: (ENV['RAILS_ENV'] || ENV['RACK_ENV'] || "development").dup, ...
        config:      File.expand_path("config.ru")
    
 # .../rack/server.rb
module Rack
  class Server
    def initialize(options = nil)
      @options = options

    def start &blk
      server.run wrapped_app, options, &blk
      ### (2.1) wrapped_app: builds rack app
      ### (2.2) server.run: runs some rack compatible web server
      ###                   (e.g. Rack::Handler::WEBrick.run)

    def server
      @_server ||=  ... || Rack::Handler.default(options)
       # <= set as `Rack::Handler::WEBrick` by default

    def wrapped_app
      @wrapped_app ||= build_app app
      ### (2.1.1) initialize:     `Rack::Server#app`
      ### (2.1.2) add middleware: `Rack::Server#build_app`

    def app
      @app ||= ... ? ... : build_app_and_options_from_config

    def build_app_and_options_from_config
      app, options = Rack::Builder.parse_file(self.options[:config], opt_parser)
      app

    def options
      ... default_options ...

    def default_options
      ... { :Port => 9292, :config => "config.ru" ... } ...


{% endhighlight %}

## (2.1.1) Initialize rack app: `Rack::Server#app`

{% highlight ruby %}

 # .../rack/builder.rb
module Rack
  class Builder
    def self.parse_file(config, opts = Server::Options.new)
      ... cfgfile = ::File.read(config) ...  # <= reads `(rails root)/config.ru`
      app = new_from_string cfgfile, config

    def self.new_from_string(builder_script, file="(rackup)")
      eval "Rack::Builder.new {\n" + builder_script + "\n}.to_app" ...
    
    def initialize(default_app = nil,&block)
      ... instance_eval(&block) if block_given?
      # run the code in `config.ru` as in `Rack::Builder`, which returns "rack app"

    def run(app)
      @run = app

 # (rails root)/config.ru
require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application  # <= `Rack::Builder#run`

 # (rails root)/config/environment.rb
require File.expand_path('../application', __FILE__)
 # <= returns `false` (see `require APP_PATH` in `rails/commands/commands_tasks.rb`)
Rails.application.initialize!  # <= `Rails::Application#initialize!`


 # .../railties/rails/application.rb
module Rails
  class Application < Engine
    ... autoload :Bootstrap,  'rails/application/bootstrap' ...
    
    def initialize!(group=:default)
      run_initializers(group, self)
      # the parent class `Rails::Realtie` `include` a module `Rails::Initializable`

 ## classes which `include Initializable` ##
module Rails
  class Realtie
    include Initializable # this triggers `Rails::Initializable.included`
...
  class Application
    module Bootstrap
      include Initializable
...
    module Finisher
      include Initializable

 # .../railties/rails/initializable.rb
module Rails
  module Initializable
    def self.included(base)
      base.extend ClassMethods
      # methods in `ClassMethods` are available from `MyApp::Application`
      
    def run_initializers(group=:default, *args)
      initializers.tsort_each do |initializer|
        initializer.run(*args) if initializer.belongs_to?(group)
        # if you want to know what is "run" here, see the block given to
        # `initializer` in bootstrap.rb, finisher.rb

    def initializers
      @initializers ||= self.class.initializers_for(self)
      # here, `self` is `Rails.Application`

    class ClassMethods
      def initializers_for(binding)
        Collection.new(initializers_chain.map { |i| i.bind(binding) })
        # `Rails::Initializable::Initilizer#bind` keeps the `@context` for
        # `Rails::Initializable::Initilizer` to evaluate a "initializing" block
        # via `@context.instance_exec` in `Rails::Initializable::Initilizer#run`

      def initializers_chain
        initializers = Collection.new   # defined below
        ancestors.reverse_each do |klass|
          next unless klass.respond_to?(:initializers)
          # <= this loop runs through included modules and super classes of
          #   `MyApp::Application` (includs itself) having a method `initializers`.
          initializers = initializers + klass.initializers
          # the real data is kept under `@initializers`
        end
        initializers

      def initializer(name, opts = {}, &blk)
        initializers << Initializer.new(name, nil, opts, &blk)
        # put new initilizer into `Rails.application@initializers`
        
      def initializers
        @initializers ||= Collection.new
        # this is accesible from `Rails::Realtie` (`MyApp::Application` too),
        # `Rails::Aplication::Bootstrap`, `Rails::Aplication::Finisher`
        
    class Initializer
      def initialize(name, context, options, &block)
        options[:group] ||= :default
        @name, @context, @options, @block = name, context, options, block
        
      def run(*args)
        @context.instance_exec(*args, &block)

      def bind(context)
        return self if @context
        Initializer.new(@name, context, @options, &block)

    class Collection < Array # just an `Array` with some `tsort` oprations.

 # realties/rails/application/bootstrap.rb
module Rails
  class Application
    module Bootstrap
      include Initializable

      #  those `initializer` functions are executed just before calling
      # `Rails::Application::Bootstrap.initializers` in `initializers_chain`
      #  because of `autoload :Bootstrap` in `Rails::Application`.

      initializer :initialize_logger, group: :all do ... end
      #  this puts `Rails::Initializable::Initializer` instance into
      # `Rails.application@initializers`


{% endhighlight %}

## (2.1.2) Add middleware: `Rack::Server#build_app`

{% highlight ruby %}

 # rack/server.rb
module Rack
  class Server
    def wrapped_app
      @wrapped_app ||= build_app app

    def build_app(app)
      middleware[options[:environment]].reverse_each do |middleware|
        # (TODO-0): I suppose `middleware` is just a single element array
        # like `[Rails::Rack::Debugger]`, but that doesn't make any sence
        # (even `Rails::Rack::Debugger` doesn't `respond_to` `call`)
        # Forget it, somehow it is working. 
        middleware = middleware.call(self) if middleware.respond_to?(:call)
        next unless middleware
        klass, *args = middleware
      #`klass` is a class stands for "rack middleware"(e.g.`Rails::Rack::Debugger`).
        app = klass.new(app, *args) # (TODO-1)
      end
      app

    def middleware # this is overwridden by `Rails::Server#middleware`

 # realties/rails/commands/server.rb
module Rails
  class Server < ::Rack::Server
    def middleware
      middlewares = []
      ... middlewares << [Rails::Rack::Debugger] ...
      Hash.new(middlewares)  # this hash returns a value `middlewares` for any key.

 # realties/rails/rack/debugger.rb (as an example of rack middleware)
module Rails
  module Rack
    class Debugger
      def initialize(app)
        @app = app ...
        
      def call(env)
        @app.call(env)

{% endhighlight %}

## (2.2) running rack web server: `Rack::Handler::WEBrick.run`

(TODO-3): following what is happening in
[WEBrick](http://ruby-doc.org/stdlib-2.0.0/libdoc/webrick/rdoc/WEBrick.html).
  
{% highlight ruby %}

 # .../rack/handler/webrick.rb
module Rack
  module Handler
    class WEBrick < ::WEBrick::HTTPServlet::AbstractServlet
      def self.run(app, options={})
        ... @server = ::WEBrick::HTTPServer.new(options) ...
        ... @server.start

 # ...stdlib.../webrick.rb  ## to be continued ... ?
{% endhighlight %}

### What I skipped

- TODO-0: why `middleware.call(self)` in `Rack::Server#build_app` is working .
- TODO-1: how stacking "rack middleware" works through the loop of
  `app = klass.new(app)` in `Rack::Server#build_app`.
- TODO-2: how `Module#ancestors` works internally
- TODO-3: what "rack web server" is responsible to do.
- TODO-4: how to debug rails framework itself

# Configuring

- [RailsGuides](http://guides.rubyonrails.org/configuring.html)

Here are the examples of initialization code and common three placements
in your Rails application.

{% highlight ruby %}
 ## (A) `config/application.rb`
module Myapp
  class Application < Rails::Application
    config.time_zone = 'Central Time (US & Canada)' # <= `Rails::Application#config`

 # (B) `config/environments/development.rb`
Rails.application.configure do
  # <= `Rails::Railtie#configure` evaluates a block with `instance_eval`
  config.cache_classes = false

 # (C) `config/initializers/filter_parameter_logging.rb`
Rails.application.config.filter_parameters += [:password]
{% endhighlight %}

Rails source corresponds to the above could be those below.

{% highlight ruby %}
 # the family of `Rails::Application`
module Rails
  class Application < Engine
    autoload :Configuration, 'rails/application/configuration'
    def config
      @config ||= Application::Configuration.new ...
...
  class Engine < Railtie
    autoload :Configuration, "rails/engine/configuration"
    def config  # overridden by `Rails::Application#config`
...
  class Railtie
    autoload :Configuration, "rails/railtie/configuration"
    def configure(&block)
      instance_eval(&block)

 # the family of `Rails::Application::Configuration`
module Rails
  class Application
    class Configuration < ::Rails::Engine::Configuration
      attr_accessor ..., :cache_classes, :filter_parameters, :time_zone, ...
      def initialize(*)
        super
        @filter_parameters = []
        @time_zone         = "UTC"
...
  class Engine
    class Configuration < ::Rails::Railtie::Configuration
      ... attr_writer :middleware, ...
      def initialize(root=nil)
        super() ...
        @root = root
...
  class Railtie
    class Configuration
      def initialize
        @@options ||= {}

{% endhighlight %}

The comments in the automatically generated file `config/application.rb` says:

> Settings in config/environments/* take precedence over those specified here.
> Application configuration should go into files in config/initializers
> -- all .rb files in that directory are automatically loaded.

Here, "take orecedence over" means just "overwrite"
because of the execution order of relevant files.

(TODO) (A) -> (B) -> (C) or (A) -> (C) -> (B)

Let's get into how these initialization order is realized
through the whole rails application initialization process.

- (A): `require APP_PATH` (see <a href="#tocAnchor-1-2-2">here</a>)
- (B), (C): `initializers_chain` in `Rails.application.initialize!` (see <a href="">here</a>)

{% highlight ruby %}
 # (B) `config/environments/*.rb`, (C) `config/initializers/*.rb`
module Rails
  class Engine
    # corresponds to `Rails::Initializable::ClassMethods#initializer`
    initializer :load_environment_config, ... do
      paths["config/environments"].existent.each do |environment|
        require environment

    initializer :load_config_initializers do
      config.paths["config/initializers"].existent.sort.each do |initializer|
        load_config_initializer(initializer)
...
    class Configuration < ::Rails::Railtie::Configuration
      def paths
        @paths ||= begin
          paths = Rails::Paths::Root.new(@root)
          paths.add "config/environments", glob: "#{Rails.env}.rb"
          paths.add "config/initializers", glob: "**/*.rb"
...
  module Paths
    class Root
      def add(path, options = {})
        ... @root[path] = Path.new(self, path, with, options)
    class Path
      def existent  # expands glob and returns files which exist
        expanded.select { |f| File.exist?(f) } 

{% endhighlight %}

Those blocks given to `Rails::Initializable::ClassMethods#initializer` are executed
in the context of `Rails.application` since `Initializer#bind` sets
`@context = Rails.application` and `Initializer#run` the blocks via `@context.instance_exec`
(see the walkthrough <a href="#tocAnchor-1-2-4">above</a>).

- TODO:
  - `Rails.application.paths`
  - `Rails.application.config.paths`
  - `Rails.application.load_config_initializer`
  - hash arguments (like `Initializer.new`).


# Routing

- [RailsCast 231](http://railscasts.com/episodes/231-routing-walkthrough)

# Request to Response

- [Part 1](http://andrewberls.com/blog/post/rails-from-request-to-response-part-1--introduction),
  [Part 2](http://andrewberls.com/blog/post/rails-from-request-to-response-part-2--routing)


# Active Support

- [`#delegate`](http://apidock.com/rails/Module/delegate),

# Bundler

- for what bundler is: <http://bundler.io/rationale.html>
- [`bundle install`](http://bundler.io/bundle_install.html),
  [`bundler/setup`](http://bundler.io/bundler_setup.html)

# Basic Facts in Ruby

## Ruby primitives (or in standard lib) with link to rdoc

- [`Class`](http://ruby-doc.org/core-2.0.0/Class.html),
  [`Module`](http://ruby-doc.org/core-2.0.0/Module.html),
  [`Signal#trap`](http://ruby-doc.org/core-2.2.0/Signal.html#method-c-trap),
  [`Object#send`](http://ruby-doc.org/core-2.2.2/Object.html#method-i-send),
  [`Object#tap`](http://ruby-doc.org/core-2.2.2/Object.html#method-i-tap),
  [`Object#instance_eval`](http://ruby-doc.org/core-2.2.0/BasicObject.html#method-i-instance_eval),
  [`Object#inspect`](http://ruby-doc.org/core-2.2.2/Object.html#method-i-inspect),
  [`Object#freeze`](http://ruby-doc.org/core-2.2.3/Object.html#method-i-freeze),
  [`Module#const_get`](http://ruby-doc.org/core-2.1.0/Module.html#method-i-const_get),
  [`File.expand_path`](http://ruby-doc.org/core-2.1.5/File.html#method-c-expand_path),
  [`Class#inherited`](http://ruby-doc.org/core-2.0.0/Class.html#method-i-inherited),
  [`Module#included`](http://ruby-doc.org/core-2.2.0/Module.html#method-i-included),
  [`Module#ancestors`](http://ruby-doc.org/core-2.1.0/Module.html#method-i-ancestors),
  [`Module#include`](http://ruby-doc.org/core-2.0.0/Module.html#method-i-include),
  [`Module#append_features`](http://ruby-doc.org/core-2.0.0/Module.html#method-i-append_features),
  [`Object#respond_to?`](http://ruby-doc.org/core-2.2.3/Object.html#method-i-respond_to-3F),
  [`Module#autoload`](http://ruby-doc.org/core-2.0.0/Module.html#method-i-autoload),
  [`Hash.new`](http://ruby-doc.org/core-2.2.0/Hash.html#method-c-new)

## Any features I didn't know

- `Module`, `Class`, `Module#include`, `class <` (inheritance) and `Module#ancestors`
  - (TODO-2)
  - good picture explaining the relation between "objects" in ruby:
    [stackoverflow](http://stackoverflow.com/questions/19045195/understanding-ruby-class-and-ancestors-methods#answer-19045339)
    <img src="http://i.stack.imgur.com/tBVGQ.png">
  - why does rdoc explains `Module#ancestors` by

    > Returns a list of modules included in mod (including mod itself).
    
  - I mean, why don't they write like the answer of the above stackoverflow question?

    > Module#ancestors will include list of modules included in mod (including mod itself) and the superclass of your class Order.

  - Are they hinting that `Module#include` and `class SubC < SuperC`
    have something in common internally?
    
  - by the way, `Module#include` seems just calling `Module#append_features`.

  - My guess is `Module#include` change some data represented by `RCLASS_SUPER(p)`
    (I gave up following everything).

  - some notes for understanding `typedef` `struct` in c language:
    [stackoverflow](http://stackoverflow.com/questions/252780/why-should-we-typedef-a-struct-so-often-in-c),
    [stackoverflow](http://stackoverflow.com/questions/1675351/typedef-struct-vs-struct-definitions),
    [tutorialspoint](http://www.tutorialspoint.com/cprogramming/c_structures.htm)
    
Here is some c code internally called from ruby.
{% highlight c %}
VALUE rb_mod_ancestors(VALUE mod){
    VALUE p, ary = rb_ary_new();
    for (p = mod; p; p = RCLASS_SUPER(p)) { ... rb_ary_push(ary, p); ... }
    return ary;
}
{% endhighlight %}

{% highlight c %}
// function call chain from `Module#include`
static VALUE rb_mod_include(int argc, VALUE *argv, VALUE module){
    ... CONST_ID(id_append_features, "append_features"); ...
    ... rb_funcall(argv[argc], id_append_features, 1, module); ...
}

static VALUE rb_mod_append_features(VALUE module, VALUE include){
   ... rb_include_module(include, module); ...
}

void rb_include_module(VALUE klass, VALUE module){
    ... include_modules_at(klass, RCLASS_ORIGIN(klass), module); ...
}

// it's so complicated for me to follow through everything. I've given up...
static int include_modules_at(const VALUE klass, VALUE c, VALUE module){ ... }
{% endhighlight %}


{% highlight c %}
// macro definitions leading to `Class#superclass`
 rb_class_superclass(VALUE klass){
     VALUE super = RCLASS_SUPER(klass); ...
     return super;
 }

 #define RCLASS_SUPER(c) (RCLASS_EXT(c)->super)

 #define RCLASS_EXT(c) ((rb_deprecated_classext_t *)RCLASS(c)->ptr)

 typedef struct rb_deprecated_classext_struct {
     VALUE super;
 } rb_deprecated_classext_t;

 struct RClass { ... rb_classext_t *ptr; ... };

 typedef struct rb_classext_struct rb_classext_t;
 
 struct rb_classext_struct { ... VALUE super; ... };
{% endhighlight %}


- `Bundler.require(*Rails.groups)`:
  - `f(*[arg0, arg1, arg2])` is same as `f(arg0, arg1, arg2)`
    [stackoverflow](http://stackoverflow.com/questions/918449/what-does-the-unary-operator-do-in-this-ruby-code)

- `module Rails; class Server < ::Rack::Server` in `railties/rails/commands/server.rb`
  - Difference between `::Module0` and `Module0`:
  [stackoverflow](http://stackoverflow.com/questions/5032844/ruby-what-does-prefix-do)

- `default_options` in `Rails::Server` and `Rack::Server`
  - override method via inheritance:
{% highlight ruby %}
class C
  def m_override; "call m_override defined in C"; end
  def m_inherit;  m_override; end
end

class C1 < C
  def m_override; "call m_override defined in C1"; end
end

puts C1.new.m_inherit # "call m_override defined in C1"
{% endhighlight %}


- nested class:
  [stackoverflow](http://stackoverflow.com/questions/6195661/when-to-use-nested-classes-and-classes-nested-in-modules),
  [stackoverflow](http://stackoverflow.com/questions/14739640/ruby-classes-within-classes-or-modules-within-modules)

{% highlight ruby %}
class A
  class B
  end
end
{% endhighlight %}

- `module Rails; class << self` in `railties/rails.rb`
  - singleton method, singleton class:
    [stackoverflow](http://stackoverflow.com/questions/212407/what-exactly-is-the-singleton-class-in-ruby)
  - module self class:
    [stackoverflow](http://stackoverflow.com/questions/2505067/class-self-idiom-in-ruby),
    [stackoverflow](http://stackoverflow.com/questions/10037031/using-class-self-when-to-use-classes-or-modules)

{% highlight ruby %}
anything = ...
class << anything  # open up a singleton class for `anything`
  def method_for_singleton_class
    ...
  end
end
 # is same as
def anything.method_for_singleton_class
 ...
end
{% endhighlight %}

- `module Rails; module Initializable; def self.included(base); base.extend ClassMethods`
  - `Module#included`, `ClassMethods`, `active_support/concern`
    - [rails api](http://api.rubyonrails.org/classes/ActiveSupport/Concern.html)
    - <http://yehudakatz.com/2009/11/12/better-ruby-idioms/>
    - [stackoverflow](http://stackoverflow.com/questions/7463440/why-do-we-need-classmethods-and-instancemethods)

# References

- RailsGuides:
  - [The Rails Initialization Process](http://guides.rubyonrails.org/initialization.html)
  - [Rails on Rack](http://guides.rubyonrails.org/rails_on_rack.html)
  - [Configuring Rails Application](http://guides.rubyonrails.org/configuring.html)
- RailsCast:
  - [#299 Rails Initialization Walkthrough](http://railscasts.com/episodes/299-rails-initialization-walkthrough)
  - [#150 Rails Metal](http://railscasts.com/episodes/150-rails-metal)
  - [#151 Rack Middleware](http://railscasts.com/episodes/151-rack-middleware)
  - [#231 Routing WalkThrough](http://railscasts.com/episodes/231-routing-walkthrough)
- Rails from Request to Response
  - [Part 1](http://andrewberls.com/blog/post/rails-from-request-to-response-part-1--introduction)
  - [Part 2](http://andrewberls.com/blog/post/rails-from-request-to-response-part-2--routing)
- `find` in Active Record: <http://www.rubyinside.com/under-the-hood-of-rails-find-method-317.html>
- [Quora](http://www.quora.com/How-do-I-start-learning-Rails-under-the-hood):
  Recommended books
  - [Crafting Rails 4 Applications](https://pragprog.com/book/jvrails2/crafting-rails-4-applicationsbook)
  - [Ruby for Rails](http://www.manning.com/black/)
