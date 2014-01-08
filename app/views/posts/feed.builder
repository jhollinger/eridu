xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'
xml.feed :"xml:lang" => 'en-US', :xmlns => 'http://www.w3.org/2005/Atom' do
  xml.id "tag:#{E[:domain]},2008:/posts"

  xml.link :rel => 'self', :type => 'application/atom+xml', :href => "#{E[:url]}#{@tag}.atom"
  xml.link :rel => 'alternate', :type => 'text/html', :href => "#{E[:url]}"

  xml.title E[:title]
  xml.subtitle E[:tagline]
  xml.updated @posts.first.published_at unless @posts.empty?

  xml.author do
    xml.name E[:author][:name]
    xml.email E[:author][:email]
  end

  for post in @posts
    xml.entry do
      xml.id "tag:#{E[:domain]},2008:#{post.class.name}/#{post.id}"
      xml.link :rel => 'alternate', :type => 'text/html', :href => post.permalink(E[:url])
      xml.published post.published_at
      xml.updated post.edited_at
      xml.title post.title
      xml.content post.body_html, :type => 'html'

      for tag in post.tag_list
        xml.category :term => tag
      end

      xml.author do
        xml.name E[:author][:name]
      end
    end
  end
end
