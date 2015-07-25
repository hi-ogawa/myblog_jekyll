module Reading
  class Generator < Jekyll::Generator
    def generate(site)

      return unless site.show_drafts


      require 'json'
      require 'pathname'

      local_root = Pathname.new(site.config['local_root'])
      
      # make sure the directory for sync files exists
      require 'fileutils'
      FileUtils.mkdir_p local_root.join('_sync')

      site.posts.each do |p|

        # deal with yaml front matter
        original_file_content = File.read(p.path, encoding: 'UTF-8')
        first_line = p.content.split(/\n/)[0]
        lineno = original_file_content.split(/\n/).index(first_line) + 1

        edited_content = ""   # header tagged content
        h = []                # header line number hash

        
        f = File.open(local_root.join('_sync', p.name + '.json'), 'w')

        p.content.each_line.map(&:chomp).each do |l|
          if l =~ /^#/
            edited_content += l + "\n" + jump_tag(lineno, local_root.join(p.path).to_s) + "\n"
            anchor = make_anchor l
            h.push({id: anchor, lineno: lineno})
          else 
            edited_content += l + "\n"
          end
          lineno += 1
        end

        f.write JSON.pretty_generate({url: p.url, jump: h}) # write json
        p.content = edited_content      # update post content
      end

    end

    def make_anchor(line)
      require 'kramdown'  # site.config['markdown'] == 'kramdown' by default
      require 'nokogiri'

      Nokogiri::HTML(Kramdown::Document.new(line).to_html)
        .css('h1, h2, h3, h4, h5, h6').first.attr('id')
    end

    def jump_tag(lineno, path)
      "<span lineno='#{lineno}' path='#{path}'></span>"
    end

  end
end
