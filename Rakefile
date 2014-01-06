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
end

namespace :export do
  desc "Export your posts and pages to Jekyll/Octopress"
  task :jekyll, :dir do |task, args|
    dir = File.expand_path(args[:dir])
    Post.all.each do |post|
      filepath = File.join(dir, '_posts', "#{post.published_at.strftime('%Y-%m-%d')}-#{post.slug}.textile")
      content = %Q|---\nlayout: post\ntitle: #{post.title}\ndate: #{post.published_at.strftime('%Y-%m-%d %H:%M')}\ncategories: [#{post.tag_list.join(', ')}]\ncomments: true\n---\n#{post.body}|
      if File.exists? filepath
        puts "Skippinng #{filepath}"
      else
        puts "Writing #{filepath}"
        File.open(filepath, 'w') { |f| f.write content }
      end
    end
    Page.all.each do |page|
      page_dir = File.join(dir, page.slug)
      filepath = File.join(page_dir, 'index.textile')
      content = %Q|---\nlayout: page\ntitle: #{page.title}\ndate: #{page.updated_at.strftime('%Y-%m-%d %H:%M')}\ncomments: false\nsharing: false\nfooter: false\n---\n#{page.body}|
      Dir.mkdir(page_dir) unless Dir.exists? page_dir
      if File.exists? filepath
        puts "Skippinng #{filepath}"
      else
        puts "Writing #{filepath}"
        File.open(filepath, 'w') { |f| f.write content }
      end
    end
  end
end
