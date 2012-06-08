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
    end
  end
end
