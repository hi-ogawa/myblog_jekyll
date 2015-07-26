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

      filename = h["url"].match(/\/([^\/]*)$/)[1]

      if context.registers[:site].show_drafts
        return "[[[github snippet doesn't works on --drafts mode <a href='#{h["url"]}'>view</a> ]]]"
      end

      open(h["url"].sub("/blob/","/raw/")) do |f|
        source = f.read
        use_lines = source.split("\n")[(h["start"] - 1)..(h["end"] - 1)]
        code = use_lines.inject {|ls, l| ls + "\n" + l}
        
        require 'cgi'
        code_escaped = CGI.escapeHTML code

        output = <<-CODE

<div    style='background: #e8e8e8; width: 100%;'> &nbsp;
  <span class='toggle-snippet' style='cursor: pointer;'>  &#43; </span>
  <span style='position: absolute; left:  40px;' >                  #{filename}       </span>
  <span style='position: absolute; right: 30px;' > <a href='#{h["url"]}'>  view </a>  </span>
</div>

<pre class='prettyprint lang-#{ h["lang"] }'>
#{ code_escaped }
</pre>

<script src="https://cdn.rawgit.com/google/code-prettify/master/loader/run_prettify.js"></script>
<script src="/assets/code-prettify/src/lang-#{ h["lang"] }.js"></script>

CODE
        # puts output
        output
      end
    end
  end
end

Liquid::Template.register_tag('github', Jekyll::MyGithubSnippetTag)
