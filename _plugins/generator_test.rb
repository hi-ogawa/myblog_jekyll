module Reading
  class Generator < Jekyll::Generator
    def generate(site)

      return true unless site.show_drafts

      require 'json'
      require 'pathname'

      local_root = Pathname.new(site.config['local_root'])

      site.posts.each do |p|

        # deal with yaml front matter
        original_file_content = File.read(p.path, encoding: 'UTF-8')
        first_line = p.content.split(/\n/)[0]
        lineno = original_file_content.split(/\n/).index(first_line) + 1

        edited_content = ""   # header tagged content
        # h = {}                # header line number hash
        h = []

        f = File.open(local_root.join('sync', p.name + '.json'), 'w')

        p.content.each_line.map(&:chomp).each do |l|
          if l =~ /^#/
            puts "#{lineno.to_s} \t #{l}"
            edited_content += l + "\n" + jump_tag(lineno, local_root.join(p.path).to_s) + "\n"
            id   = l.gsub(/[^\w]+/,'-').gsub(/(\_)|(^\-*)|(\-*$)/, '').downcase
            h.push [id, lineno]
          else 
            edited_content += l + "\n"
          end
          lineno += 1
        end

        f.write JSON.pretty_generate({url: p.url, jump: h}) # write json
        f.close
        p.content = edited_content      # update post content
      end

    end

    def jump_tag(lineno, path)
      "<span lineno='#{lineno}' path='#{path}'></span>"
    end

  end
end
