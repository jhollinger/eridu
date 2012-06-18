xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'
xml.feed :"xml:lang" => 'en-US', :xmlns => 'http://www.w3.org/2005/Atom' do
  xml.id "tag:#{Conf[:domain]},2008:/posts"

  xml.link :rel => 'self', :type => 'application/atom+xml', :href => "#{Conf[:url]}/#{@tag}.atom"
  xml.link :rel => 'alternate', :type => 'text/html', :href => "#{Conf[:url]}"

  xml.title Conf[:title]
  xml.subtitle Conf[:tagline]
  xml.updated @posts.first.published_at unless @posts.empty?
  xml.generator 'Eridu', :uri => 'http://jordanhollinger.com'

  xml.author do
    xml.name Conf[:author, :name]
    xml.email Conf[:author, :email]
  end

  for post in @posts
    xml.entry do
      xml.id "tag:#{Conf[:domain]},2008:#{post.class.name}/#{post.id}"
      xml.link :rel => 'alternate', :type => 'text/html', :href => "#{Conf[:url]}#{permalink_path(post)}"
      xml.published post.published_at
      xml.updated post.edited_at
      xml.title post.title
      xml.content post.body_html, :type => 'html'

      for tag in post.tag_list
        xml.category :term => tag
      end

      xml.author do
        xml.name Conf[:author, :name]
      end
    end
  end
end
