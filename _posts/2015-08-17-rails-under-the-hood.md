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
  - TODO
  - ex.
    - WEBrick(included in ruby's standard library): <http://ruby-doc.org/stdlib-2.0.0/libdoc/webrick/rdoc/WEBrick.html>
    - Unicorn: <https://github.com/blog/517-unicorn>
    - Passenger (kinda different? like tweak Nginx directory?): <https://github.com/phusion/passenger>

- two ways of invokation: (track WEBrick and WEBrick handler: TODO)
  - via a ruby program:
    - TODO
    
  - via the cli `rackup` with a DSL-like config file `config.ru`:
    - TODO

# Initialization of Rails Application

As I read the source code, I picked up the path of initializing chain (in my local PC).
For simplicity, I omitted a lot of parts of each file (I don't even write three dots "...") and
sometimes added the meaning of methods as omments without showing the code of methods.

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
	require APP_PATH              # <= require "(rails root)/config/application"
	Dir.chdir(Rails.application.root) # <= TODO: when `Rails.application` is set?
	server.start                  # <= Rails::Server.start

{% endhighlight %}


## "Rails::Server" ->> "Rack::Server" ->> "WEBrick::HTTPServer"?

{% highlight ruby %}

 # .../railties/rails/commands/server.rb
require 'action_dispatch'
require 'rails'
module Rails
  class Server < ::Rack::Server
    def initialize(*)
      super                   # <= Rack::Server.initialize
      set_environment         # <= set `ENV["RAILS_ENV"]`

    def start
      print_boot_information  # what you see after `$ rails s`
      trap(:INT) { exit }
      create_tmp_directories  # `mkdir tmp/{cache, pids, sessions, sockets}`
      log_to_stdout if options[:log_stdout]
      super                     # <= Rack::Server.start

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
      @app = options[:app] if options && options[:app] # TODO: is this not relavant now?

    def start &blk
      server.run wrapped_app, options, &blk
       # <= (5) wrapped_app
       # <= (6) Rack::Handler::WEBrick.run

    def server
      @_server ||=  ... || Rack::Handler.default(options)
       # <= set as Rack::Handler::WEBrick (could be any web server)

    def wrapped_app
      @wrapped_app ||= build_app app

    def app
      @app ||= ... ? ... : build_app_and_options_from_config

    def build_app(app) # <= TODO: what middleware is?
      middleware[options[:environment]].reverse_each do |middleware|  # <= (4) 
        middleware = middleware.call(self) if middleware.respond_to?(:call)
        next unless middleware
        klass, *args = middleware
        app = klass.new(app, *args)
      end
      app

    def build_app_and_options_from_config
      app, options = Rack::Builder.parse_file(self.options[:config], opt_parser)
      app

    def options
      ... default_options ...

    def default_options
      ... { :Port => 9292, :config => "config.ru" ... } ...


 # .../rack/builder.rb
module Rack
  class Builder
    def self.parse_file(config, opts = Server::Options.new)
      ... cfgfile = ::File.read(config) ...  # <= read `(rails root)/config.ru`
      app = new_from_string cfgfile, config

    def self.new_from_string(builder_script, file="(rackup)")
      eval "Rack::Builder.new {\n" + builder_script + "\n}.to_app",
        TOPLEVEL_BINDING, file, 0
    
    def initialize(default_app = nil,&block)
      @use, @map, @run = [], nil, default_app
      instance_eval(&block) if block_given?
        # <= run the code in `config.ru` as in `Rack::Builder`

    def to_app
      app = @map ? generate_map(@run, @map) : @run
      fail "missing run or map statement" unless app
      app = @use.reverse.inject(app) { |a,e| e[a] }
      @warmup.call(app) if @warmup
      app
    end

    def run(app)
      @run = app

 # (rails root)/config.ru
require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application  # <= `Rack::Builder#run`

 # (rails root)/config/environment.rb
require File.expand_path('../application', __FILE__)
Rails.application.initialize!                                  # (2)

 # (rails root)/config/application.rb                          # (1)
require 'rails/all'   # <= require active_record, action_controller, etc...
Bundler.require(*Rails.groups) # <= TODO: when did you create `Rails.groups`
module MyApp
  class Application < Rails::Application

 # .../railties/rails/application.rb # <= I'm not sure this is really executed (Rails::Application.new should be called somewhere).
module Rails
  class Application < Engine
    def initialize(initial_variable_values = {}, &block)
      Rails.application ||= self

 # .../railties/rails.rb
module Rails
  class << self
    attr_accessor :application, :cache, :logger            # <= there exists `Rails.application` here.
    delegate :initialize!, :initialized?, to: :application # <= `Rails.initialize!` calls `Rails.application.initialize!` ??

 # .../railties/rails/application.rb # (2)
module Rails
  class Application < Engine
    def initialize!(group=:default) #:nodoc:
      run_initializers(group, self)

 # .../railties/rails/initializable.rb
module Rails
  module Initializable
    def run_initializers(group=:default, *args)
      return if instance_variable_defined?(:@ran)
      initializers.tsort_each do |initializer|
        initializer.run(*args) if initializer.belongs_to?(group)
      end
      @ran = true
    end

    def initializers
      @initializers ||= self.class.initializers_for(self)
    end

    class Initializer
      def run(*args)
        @context.instance_exec(*args, &block)
      end

 # <= corresponds to (4)
module Rack
  class Server
    def middleware
      middlewares = []
      middlewares << [Rails::Rack::Debugger] if options[:debugger]
      middlewares << [::Rack::ContentLength]

module Rack
  class Server
    def self.middleware
      @middleware ||= begin
        m = Hash.new {|h,k| h[k] = []}
        m["deployment"].concat [
          [Rack::ContentLength],
          [Rack::Chunked],
          logging_middleware
        ]
        m["development"].concat m["deployment"] + [[Rack::ShowExceptions], [Rack::Lint]]
        m
      end
    end

    def middleware
      self.class.middleware
    end

 # .../rack/handler/webrick.rb  <= corresponds to (5)
module Rack
  module Handler
    class WEBrick < ::WEBrick::HTTPServlet::AbstractServlet
      def self.run(app, options={})
        options[:BindAddress] = options.delete(:Host) if options[:Host]
        options[:Port] ||= 8080
        @server = ::WEBrick::HTTPServer.new(options)
        @server.mount "/", Rack::Handler::WEBrick, app
        yield @server  if block_given?
        @server.start
      end

{% endhighlight %}

- TODO:
  - where exactly is the instance of `Rails::Application` is created?
  - `Rails::Initializable#initialize`: how does `Rails::Application#initialize!` leads to this method?
  - `Rack::Server#initialize`: how does the middleware work?
- `::Rack::Server` means `Rack::Server` (defined in `rack/server.rb`) not 
  `Rails::Rack::Server` (see the below "Basic Facts in Ruby").


# Routing

- [RailsCast 231](http://railscasts.com/episodes/231-routing-walkthrough)

# Request to Response

- [Part 1](http://andrewberls.com/blog/post/rails-from-request-to-response-part-1--introduction),
  [Part 2](http://andrewberls.com/blog/post/rails-from-request-to-response-part-2--routing)


# Active Support

- [`#delegate`](http://apidock.com/rails/Module/delegate)

# Bundler

- for what bundler is: <http://bundler.io/rationale.html>
- [`bundle install`](http://bundler.io/bundle_install.html),
  [`bundler/setup`](http://bundler.io/bundler_setup.html)

# Basic Facts in Ruby

## Ruby primitives (or in standard lib)

- [`Signal#trap`](http://ruby-doc.org/core-2.2.0/Signal.html#method-c-trap),
  [`Object#send`](http://ruby-doc.org/core-2.2.2/Object.html#method-i-send),
  [`Object#tap`](http://ruby-doc.org/core-2.2.2/Object.html#method-i-tap),
  [`Object#instance_eval`](http://ruby-doc.org/core-2.2.0/BasicObject.html#method-i-instance_eval),
  [`Object#inspect`](http://ruby-doc.org/core-2.2.2/Object.html#method-i-inspect),
  [`Object#freeze`](http://ruby-doc.org/core-2.2.3/Object.html#method-i-freeze),
  [`Module#const_get`](http://ruby-doc.org/core-2.1.0/Module.html#method-i-const_get),
  [`File.expand_path`](http://ruby-doc.org/core-2.1.5/File.html#method-c-expand_path)

## Any features I didn't know

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

# References

- RailsGuides:
  - [The Rails Initialization Process](http://guides.rubyonrails.org/initialization.html)
  - [Rails on Rack](http://guides.rubyonrails.org/rails_on_rack.html)
- RailsCast:
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
