---
layout: post
title: "rails under the hood"
description: ""
category: 
tags: []
---

# Request to Response

- Unicorn: <https://github.com/blog/517-unicorn>
{% highlight ruby %}
 # unicorn/lib/unicorn/http_server.rb
def process_client(client)
  status, headers, body = @app.call(env = @request.read(client))
  ...
  http_response_write(client, status, headers, body, @request.response_start_sent)
{% endhighlight %}

- Rack: <http://rack.github.io/>
  - `app` : (env. hash) ⟼ [ (http resp. code), (header hash), (resp. body)]
  - `app` responds to the method `#call` (it seems `app` should be a `Proc` object).
  - what composes the env. hash: <http://www.rubydoc.info/github/rack/rack/master/file/SPEC#The_Environment>
    - `REQUEST_METHOD`: represents HTTP request method.
    - `PATH_INFO`: represents request URL.
    - `QUERY_STRING`: represents request parameter following URL after `?`.
    - `rack.input`: represents POST data.
    - etc...

- `@app` : `MyApp::Application` < `Rails::Application`
{% highlight ruby %}
 # config/application.rb
module MyApp
  class Application < Rails::Application
{% endhighlight %}

- ``

## Invokation of Rails Commands to Initialization of Rails Application

- Starting chain (in my local PC):
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
require_relative '../config/boot'
require 'rails/commands'

 # (rails root)/config/boot.rb
require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE']) # <= make gems listed in Gemfile (including 'rack') ready to be required

 # ~/.../railties-4.1.4/lib/rails/commands.rb
require 'rails/commands/commands_tasks'
Rails::CommandsTasks.new(ARGV).run_command!(command)

 # ~/.../railties-4.1.4/lib/rails/commands/commands_tasks.rb
def run_command!(command)
  send(command)

def server
  set_application_directory!
  require_command!("server")          # <= require "rails/commands/server"

  Rails::Server.new.tap do |server|
	require APP_PATH              # <= require "(rails root)/config/application"
	Dir.chdir(Rails.application.root)
	server.start

 # ~/.../railties-4.1.4/lib/rails/commands/server.rb
require 'action_dispatch'
require 'rails'
module Rails
  class Server < ::Rack::Server
    def initialize(*)
      super                     # <= Rack::Server.initialize
      set_environment
    end

    def start
      print_boot_information
      trap(:INT) { exit }
      create_tmp_directories
      log_to_stdout if options[:log_stdout]
      super                     # <= Rack::Server.start

 # ~/.../rack-1.5.5/lib/rack/sever.rb
module Rack
  class Server
    def initialize(options = nil)
      @options = options
      @app = options[:app] if options && options[:app]
    end

    def start &blk
      ...
      server.run wrapped_app, options, &blk  # <= (5)
    end

    def server
      @_server ||= Rack::Handler.get(options[:server]) || Rack::Handler.default(options)
    end

    def wrapped_app
	  @wrapped_app ||= build_app app
	end

    def app
      @app ||= options[:builder] ? build_app_from_string : build_app_and_options_from_config
    end

    def build_app_and_options_from_config
      app, options = Rack::Builder.parse_file(self.options[:config], opt_parser)
      app
    end

    def build_app(app)
	  middleware[options[:environment]].reverse_each do |middleware|  # <= (4) 
		middleware = middleware.call(self) if middleware.respond_to?(:call)
		next unless middleware
		klass, *args = middleware
		app = klass.new(app, *args)
	  end
	  app
	end


 # .../rack/builder.rb
module Rack
  class Builder
    def self.parse_file(config, opts = Server::Options.new)
      app = new_from_string cfgfile, config
    end

    def self.new_from_string(builder_script, file="(rackup)")
      eval "Rack::Builder.new {\n" + builder_script + "\n}.to_app",
        TOPLEVEL_BINDING, file, 0
    end
    
    def initialize(default_app = nil,&block)
      @use, @map, @run = [], nil, default_app
      instance_eval(&block) if block_given?
    end

 ### the code from here in this file is executed in the context of `Rack::Builder.new` by `instance_eval`

 # (rails root)/config.ru
require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application                                           # (3)

 # (rails root)/config/environment.rb
require File.expand_path('../application', __FILE__)
Rails.application.initialize!                                  # (2)

 # (rails root)/config/application.rb                          # (1)
require 'rails/all'
Bundler.require(*Rails.groups)
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

 # .../rack/builder.rb <= corresponds to (3)
module Rails
  class Server < ::Rack::Server
    def middleware
      middlewares = []
      middlewares << [Rails::Rack::Debugger] if options[:debugger]
      middlewares << [::Rack::ContentLength]

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

- Questions:
  - where exactly is the instance of `Rails::Application` is created?
  - `Rails::Initializable#initialize`: how does `Rails::Application#initialize!` leads to this method?
  - `Rack::Server#initialize`: how does the middleware work?
- `Object#send`: <http://ruby-doc.org/core-2.2.2/Object.html#method-i-send>
- `Object#tap`: <http://ruby-doc.org/core-2.2.2/Object.html#method-i-tap>
- `Object#instance_eval`: <http://ruby-doc.org/core-2.2.0/BasicObject.html#method-i-instance_eval>
- `::Rack::Server` means `Rack::Server` defined in `gems/rack-1.5.5/lib/rack/server.rb`
  - <http://stackoverflow.com/questions/5032844/ruby-what-does-prefix-do>
- Bundler
  - for what bundler is: <http://bundler.io/rationale.html>
  - `bundle install`: <http://bundler.io/bundle_install.html>
  - `bundler/setup`:  <http://bundler.io/bundler_setup.html>

- nested class
  - <http://stackoverflow.com/questions/6195661/when-to-use-nested-classes-and-classes-nested-in-modules>
  - <http://stackoverflow.com/questions/14739640/ruby-classes-within-classes-or-modules-within-modules>
{% highlight ruby %}
class A
  class B
  end
end
{% endhighlight %}

- module self class
  - <http://stackoverflow.com/questions/2505067/class-self-idiom-in-ruby>
  - <http://stackoverflow.com/questions/10037031/using-class-self-when-to-use-classes-or-modules>
  - `Object#inspect`: <http://ruby-doc.org/core-2.2.2/Object.html#method-i-inspect>
{% highlight ruby %}
module A
  class << self
  end
end
{% endhighlight %}

- `#delegate`: <http://apidock.com/rails/Module/delegate>

# References

- Rails on Rack: <http://guides.rubyonrails.org/rails_on_rack.html>
  - <http://railscasts.com/episodes/151-rack-middleware>
- The Rails Initialization Process: <http://guides.rubyonrails.org/initialization.html>
- Rails from Request to Response
  - Part 1: <http://andrewberls.com/blog/post/rails-from-request-to-response-part-1--introduction>
  - Part 2: <http://andrewberls.com/blog/post/rails-from-request-to-response-part-2--routing>
- Active Record `find`: <http://www.rubyinside.com/under-the-hood-of-rails-find-method-317.html>
- Quora: <http://www.quora.com/How-do-I-start-learning-Rails-under-the-hood>
  - Books:
	- [Crafting Rails 4 Applications](https://pragprog.com/book/jvrails2/crafting-rails-4-applicationsbook)
	- [Ruby for Rails](http://www.manning.com/black/)

