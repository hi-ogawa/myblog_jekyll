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
