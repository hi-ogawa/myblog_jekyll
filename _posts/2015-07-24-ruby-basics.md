---
layout: post
title: "Ruby Tips"
description: ""
category: [tips]
tags: []
---

# rails: the choice of database

- [SQLite vs MySQL vs PostgreSQL (Degital Ocean)](https://www.digitalocean.com/community/tutorials/sqlite-vs-mysql-vs-postgresql-a-comparison-of-relational-database-management-systems)
- [stackoverflow](http://stackoverflow.com/questions/11622070/which-database-is-recommended-to-use-with-ruby-on-rails-considering-hosting-of)
- <http://tenmiles.com/blog/2010/08/rails-database-default-alternatives/>
- <https://www.ruby-forum.com/topic/127682>

- MySQL setup
  - <https://gorails.com/setup/osx/10.10-yosemite>
  - <https://www.digitalocean.com/community/tutorials/how-to-use-mysql-with-your-ruby-on-rails-application-on-ubuntu-14-04>
  - <https://www.digitalocean.com/community/tutorials/scaling-ruby-on-rails-setting-up-a-dedicated-mysql-server-part-2>
  - <http://www.tutorialspoint.com/ruby-on-rails/rails-database-setup.htm>
  - cannot set default value to `text` type
    - but, that can be done via active record callback: <http://stackoverflow.com/questions/1550688/how-do-i-create-a-default-value-for-attributes-in-rails-activerecords-model/4576026#4576026>


# Overall reference

- [WikiBooks](https://en.wikibooks.org/wiki/Ruby_Programming)
  - [variables and constants](https://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Variables_and_Constants)
    - [pre-defined variables](https://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Variables_and_Constants#Pre-defined_Variables)
  - [classes](https://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Classes)

- [The Ruby Cross Reference](http://rxr.whitequark.org/mri/ident?i=rb_include_module)

# rbenv plugins

- sudo: <https://github.com/dcarley/rbenv-sudo>
  - use case: deploy rails on VPS which requires root permission for binding port 80
    - `rbenv sudo rails s -p 80`
  
# Server and Client seperation

- 3 options: <http://stackoverflow.com/questions/10941249/separate-rest-json-api-server-and-client?rq=1>
- use of sub domain: <http://stackoverflow.com/questions/25031188/securing-my-backbone-js-client-to-a-node-js-based-api-that-is-public>



# How to write down JSON API spec

- <http://jsonapi.org/>
- <https://news.ycombinator.com/item?id=8912897>
- <http://stackoverflow.com/questions/1968033/recommendation-for-documenting-json-api>
- <http://stackoverflow.com/questions/3213398/how-to-describe-json-data-in-a-spec>
- rspec matchers for json: <https://github.com/collectiveidea/json_spec>
  - it seems symbolized json cannot be used within this library. not really.
- <http://json-schema.org/>
- <https://robots.thoughtbot.com/validating-json-schemas-with-an-rspec-matcher>
- <https://github.com/ruby-json-schema/json-schema>
- cson <https://github.com/bevry/cson>
- <http://spacetelescope.github.io/understanding-json-schema/>

# Rspec

- matcher list <https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers>
- sample of model rspec <https://gist.github.com/kyletcarlson/6234923>

# Database

- arguments for `column`: <http://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/TableDefinition.html#method-i-column-label-Examples>
- what is `add_index` and how (or where, who) `unique` column works

# Rails

- change email to username in devise
  - <https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address>
  - <http://stackoverflow.com/questions/10866667/devise-authenticating-with-username-instead-of-email>
  - <http://alexvpopov.github.io/blog/2013/10/31/allow-users-to-authenticate-with-username-only-using-devise-activeadmin-rails-4-and-ruby-2/>

- filtering models
  - native: 7.6 of <http://apionrails.icalialabs.com/book/chapter_seven>
  - gem: <https://github.com/activerecord-hackery/ransack>
  - <http://guides.rubyonrails.org/active_record_querying.html#passing-in-arguments>

- model
  - not allow `nil` but `""`: <http://stackoverflow.com/questions/12395743/rails-3-how-do-i-validate-to-allow-blanks-but-not-nil-null-in-database>
  - factory girl: <https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md>
  - ffaker cheatsheets:
	- <https://github.com/ffaker/ffaker/blob/master/REFERENCE.md>
	- <http://ricostacruz.com/cheatsheets/ffaker.html>

- rspec guildlines: <http://betterspecs.org/>

- rspec controllers: <http://codecrate.com/2014/11/rspec-controllers-best-practices.html>

- `belongs_to` or `has_one` 
  - <http://guides.rubyonrails.org/association_basics.html#choosing-between-belongs-to-and-has-one>
  - <http://requiremind.com/differences-between-has-one-and-belongs-to-in-ruby-on-rails/>

- paperclip factory with FactoryGirl:
  - <http://stackoverflow.com/questions/3294824/how-do-i-use-factory-girl-to-generate-a-paperclip-attachment>
  - <http://apidock.com/rails/ActionDispatch/TestProcess/fixture_file_upload#1234-To-use-with-factory-girl-and-prevent-leaking-file-handles>

- strong parameters, mass assignment, parameter sanitization:
  - <https://github.com/rails/strong_parameters#nested-parameters>
  - <http://code.tutsplus.com/tutorials/mass-assignment-rails-and-you--net-31695>

# Use Rails only as an API
	
- official: <http://edgeguides.rubyonrails.org/api_app.html>
- original gem: <https://github.com/rails-api/rails-api>
  - rails cast: <http://railscasts.com/episodes/348-the-rails-api-gem>
- objection?: <http://bradgessler.com/articles/do-not-just-use-rails-as-an-api/>
- manage session (user authentication)
  - <http://stackoverflow.com/questions/15342710/adding-cookie-session-store-back-to-rails-api-app>
- books:
  - <http://apionrails.icalialabs.com/book/chapter_one>

- http status code symbols: <http://billpatrianakos.me/blog/2013/10/13/list-of-rails-status-code-symbols/>

- why use `||=` (or equals): <http://www.rubyinside.com/what-rubys-double-pipe-or-equals-really-does-5488.html>
- monadic patterns: <http://dave.fayr.am/posts/2011-10-4-rubyists-already-use-monadic-patterns.html>

- active model serializers: <https://github.com/rails-api/active_model_serializers#rspec>
- keep collection of models as a list: <https://github.com/swanandp/acts_as_list>
  - <http://rhnh.net/2010/06/30/acts-as-list-will-break-in-production>

- testing in rails api
  - <http://matthewlehner.net/rails-api-testing-guidelines/>
  - <http://www.mikeball.us/blog/rails-api-integration-tests/>
  - <https://github.com/bblimke/webmock>

- integration test in rspec: <https://robots.thoughtbot.com/rspec-integration-tests-with-capybara>

- feature/request in rspec: <http://stackoverflow.com/questions/15173946/rspec-what-is-the-difference-between-a-feature-and-a-request-spec>

- how to write custom matchers
  - <https://github.com/dchelimsky/rspec/wiki/Custom-Matchers>
  - <https://www.relishapp.com/rspec/rspec-expectations/v/2-99/docs/custom-matchers/define-matcher>

# References

- [Programming Ruby](http://ruby-doc.com/docs/ProgrammingRuby/html/index.html)

# Misc

- switch statement
  - <http://ruby-doc.com/docs/ProgrammingRuby/html/tut_expressions.html#S5>
  - <http://stackoverflow.com/questions/948135/how-can-i-write-a-switch-statement-in-ruby>
- Rakefile
  - call other rake tasks: 
  - give arguments:


{% github { "url":     "https://github.com/hi-ogawa/myblog_jekyll/blob/2ad2e549de19c2cbd4e39cee6e9bd644ccce3485/_plugins/generator_test.rb", "start": 14  , "end": 15    , "lang": "ruby" }%}

- create a directory (do nothing if it already exists) <http://stackoverflow.com/questions/12617152/how-do-i-create-directory-if-none-exists-using-file-class-in-ruby#answer-23648661>


{% github { "url":     "https://github.com/hi-ogawa/myblog_jekyll/blob/8ad2edc3e78bd971b99634effcf5cc2486709b81/Rakefile", "start": 4  , "end":  8   , "lang": "ruby" }%}

- change directory in rake tasks <http://stackoverflow.com/questions/16533571/temporarily-change-current-directory-in-rake>

{% github { "url":     "https://github.com/hi-ogawa/myblog_jekyll/blob/3a600e3f79b446cff90128694354a7d55ae5d612/_plugins/tag_test.rb", "start": 22  , "end": 68 , "lang": "ruby" }%}

- parse json: <http://ruby-doc.org/stdlib-2.0.0/libdoc/json/rdoc/JSON.html>
- open uri: <http://ruby-doc.org/stdlib-2.1.2/libdoc/open-uri/rdoc/OpenURI.html>
- foldl, inject: <http://apidock.com/ruby/Enumerable/inject>
  - `[a0, a1, a2].inject(b) f  =>  (f (f (f b a0) a1) a2)`
- replace a word in string: <http://stackoverflow.com/questions/8381499/replace-words-in-string-ruby>
- escape html string <http://stackoverflow.com/questions/1600526/how-do-i-encode-decode-html-entities-in-ruby>
- multiline string literal <http://stackoverflow.com/questions/15838974/is-there-an-easy-way-to-do-multiline-indented-strings-in-ruby>


- skip/break each loop
  - next: <http://stackoverflow.com/questions/4230322/in-ruby-how-do-i-skip-a-loop-in-a-each-loop-similar-to-continue>
  - break: <http://stackoverflow.com/questions/8502397/ruby-syntax-break-out-from-each-do-block>

- filelist exclude
  - <http://apidock.com/ruby/v1_9_3_392/Rake/FileList/exclude>

- with AngularJS
  - <http://blog.honeybadger.io/beginners-guide-to-angular-js-rails/>
  - <http://angular-rails.com/>
  - <https://github.com/hiravgandhi/angularjs-rails>

- Pow
  - <http://pow.cx/>

- file upload in sinatra
  - <http://www.wooptoot.com/file-upload-with-sinatra>
