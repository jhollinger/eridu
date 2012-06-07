class AdminTrashHandler < AbstractHandler
  helpers do
    include AdminHelper
  end

  get '/admin/trash/?' do
    @posts = DB['select id, title, body from posts where deleted_at is not null order by published_at desc']
    @comments = DB['select c.id, c.author, c.body, p.title from comments c left outer join posts p on c.post_id=p.id where c.deleted_at is not null order by c.created_at desc']
    @pages = DB['select id, title, body from pages where deleted_at is not null order by title']
    title 'Trash'
    admin_erb :trash
  end

  # Create identical handlers for Posts, Comments and Pages
  [Post, Comment, Page].each do |klass|
    thing = klass.name.downcase

    # Some path helpers
    helpers do
      define_method("preview_#{thing}_path") { |obj| "/admin/trash/#{thing}s/#{obj.id}" }
      define_method("restore_#{thing}_path") { |obj| "/admin/trash/#{thing}s/#{obj.id}/restore" }
      define_method("purge_#{thing}_path") { |obj| "/admin/trash/#{thing}s/#{obj.id}/delete" }
    end

    # Ajax preview path
    get "/admin/trash/#{thing}s/:id/?" do |id|
      DB["select body_html from #{thing}s where id = ? and deleted_at is not null limit 1", id.to_i].first
    end

    # Restore an item
    put "/admin/trash/#{thing}s/:id/restore/?" do |id|
      DB["update #{thing}s set deleted_at = ? where id = ?", nil, id.to_i]
      redirect '/admin/trash'
    end

    # Permanently delete an item
    delete "/admin/trash/#{thing}s/:id/delete/?" do |id|
      DB["delete from #{thing}s where id = ?", id.to_i]
      redirect '/admin/trash'
    end
  end
end
