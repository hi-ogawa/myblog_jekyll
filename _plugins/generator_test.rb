module Reading
  class Generator < Jekyll::Generator
    def generate(site)
      # ongoing, done = Book.all.partition(&:ongoing?)

      # reading = site.pages.detect {|page| page.name == 'reading.html'}
      # reading.data['ongoing'] = ongoing
      # reading.data['done'] = done

      # site.pages.each do |page|
      #   puts page.path
      # end

      p = site.posts[0]
      puts p.path
      puts p.name
      puts p.content[0..400]

      p.content = "### Overwritten from costom generator"
    end
  end
end
