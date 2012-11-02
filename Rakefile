require './eridu'

namespace :db do
  namespace :schema do
    desc "Create a fresh database"
    task :load do
      DataMapper.auto_migrate!
    end
  end

  desc "Update the database schema"
  task :migrate do
    DataMapper.auto_upgrade!
  end

  namespace :migrate do
    desc "Convert from Enki's schema to Eridu's"
    task :enki do
      class Tagging
        property :taggable_type, Class, :required => true, :default => 'Post'
        property :tag_context, String, :required => true, :default => 'tags'
      end

      # Convert schema
      puts 'Beginning conversion from Enki...'
      DataMapper.auto_upgrade!

      # Convert existing tagging data
      Tagging.update!(:taggable_type => 'Post', :tag_context => 'tags')

      # Set comment count
      Post.all.each(&:set_comments_count!)

      # Fix date format for sqlite
      if DataMapper.repository(:default).adapter.class.name =~ /sqlite/i
        fields = [:published_at, :edited_at, :created_at, :updated_at]
        [Post, Page, Comment].each do |klass|
          klass.all.each do |obj|
            fields.each do |field|
              obj.send(:"#{field}=", obj.send(field).to_s) if obj.respond_to?(field) and !obj.send(field).blank?
            end
            obj.save!
          end
        end
      end
      puts "Finished conversion from Enki!"
      puts ''
      puts "IMPORTANT NOTE: Enki created comments.author_email and comments.author_url as non-null."
      puts "However, Eridu allows them to be null. BEFORE COMMENTS WILL WORK, you must manually "
      puts "alter the comments table in your database to allow author_email and author_url to be null."
    end
  end
end

namespace :export do
  desc "Export your posts and pages to Jekyll/Octopress"
  task :jekyll, :dir do |task, args|
    dir = File.expand_path(args[:dir])
    Post.all.each do |post|
      filepath = File.join(dir, '_posts', "#{post.published_at.strftime('%Y-%m-%d')}-#{post.slug}.textile")
      content = %Q|---\nlayout: post\ntitle: #{post.title}\ndate: #{post.published_at.strftime('%Y-%m-%d %H:%M')}\ncategories: [#{post.tag_list.join(', ')}]\ncomments: true\n---\n#{post.body}|
      File.write(filepath, content)
    end
    Page.all.each do |page|
      page_dir = File.join(dir, page.slug)
      filepath = File.join(page_dir, 'index.textile')
      content = %Q|---\nlayout: page\ntitle: #{page.title}\ndate: #{page.updated_at.strftime('%Y-%m-%d %H:%M')}\ncomments: false\nsharing: false\nfooter: false\n---\n#{page.body}|
      Dir.mkdir(page_dir) unless Dir.exists? page_dir
      File.write(filepath, content)
    end
  end

  desc "Export your Eridu comments to Disqus"
  task :disqus do
    xml = Builder::XmlMarkup.new(:encoding => 'utf-8')
    xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'
    xml.rss :version => '2.0', :"xmlns:content" => 'http://purl.org/rss/1.0/modules/content/', :"xmlns:dsq" => 'http://www.disqus.com/', :"xmlns:dc" => 'http://purl.org/dc/elements/1.1/', :"xmlns:wp" => 'http://wordpress.org/export/1.0/' do
      xml.channel do
        for post in Post.all
          xml.item do
            xml.title post.title
            xml.link post.permalink(Conf[:url])
            xml.content(:encoded) { xml.cdata! 'Body not needed' }
            xml.dsq :thread_identifier, post.id
            xml.wp :post_date_gmt, post.published_at.new_offset(0).strftime('%Y-%m-%d %H:%M:%S')
            xml.wp :comment_status, 'open'
            for comment in post.comments
              xml.wp :comment do
                xml.wp :comment_id, comment.id
                xml.wp :comment_author, comment.author
                xml.wp :comment_author_email, comment.author_email
                xml.wp :comment_author_url, comment.author_url
                xml.wp :comment_author_IP
                xml.wp :comment_date_gmt, comment.created_at.new_offset(0).strftime('%Y-%m-%d %H:%M:%S')
                xml.wp(:comment_content) { xml.cdata! comment.body_html }
                xml.wp :comment_approved, 1
                xml.wp :comment_partent, 0
              end
            end
          end
        end
      end
    end
    puts xml.target!
  end
end
