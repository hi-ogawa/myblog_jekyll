# make an anchor by {% anchor test%}
# then, you can jump to there by click on [label](test)
module Jekyll
  class MyAnchorTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      "#{@text.strip}<a name=\"#{@text.strip}\"></a>"
    end
  end
end

Liquid::Template.register_tag('anchor', Jekyll::MyAnchorTag)


# this work with google code prettify
# ex. {% github {"url": "https://github.com/hi-ogawa/emacs-customization/blob/master/init.el", "start": 320, "end": 355, "lang": "lisp"} %}
require 'json'
require 'open-uri'
module Jekyll
  class MyGithubSnippetTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      h = JSON.parse @text
      open(h["url"].sub("/blob/","/raw/")) do |f|
        source = f.read
        use_lines = source.split("\n")[(h["start"] - 1)..(h["end"] - 1)]
        code = use_lines.inject {|ls, l| ls + "\n" + l}

        output = <<-CODE
<?prettify lang=#{ h["lang"] }?>
<pre>
#{ code }
</pre>
<script src="https://cdn.rawgit.com/google/code-prettify/master/loader/run_prettify.js"></script>
<script src="/assets/code-prettify/src/lang-#{ h["lang"] }.js"></script>
CODE
        output
      end
    end
  end
end

Liquid::Template.register_tag('github', Jekyll::MyGithubSnippetTag)
