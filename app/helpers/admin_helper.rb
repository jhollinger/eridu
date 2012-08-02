module AdminHelper
  NAV = [['Dashboard', '/admin', '/admin'],
         ['Posts <a href="/admin/posts/new">(+)</a>', '/admin/posts', %r{/admin/posts}],
         ['Pages <a href="/admin/pages/new">(+)</a>', '/admin/pages', %r{/admin/pages}],
         ['Comments', '/admin/comments', %r{/admin/comments}],
         ['Media', '/admin/media', '/admin/media'],
         ['Trash', '/admin/trash', %r{/admin/trash}]]

  # Returns a navigation array. If one matches the current page, the third element is "true"
  def nav
    NAV.map do |title, path, check|
      [title, path, check === request.path]
    end
  end

  # Admin path generators
  def admin_post_path(post); "/admin/posts/#{post.id}"; end
  def admin_comment_path(comment); "/admin/comments/#{comment.id}"; end
  def admin_page_path(page); "/admin/pages/#{page.id}"; end
  def admin_media_path(file); "/admin/media/#{file}"; end

  # Prepends admin/ to the template, sets the layout to admin/layout.
  def admin_erb(template, options={:layout => :"admin/layout"})
    erb :"admin/#{template}", options
  end

  # Returns true if the user is signed in, false if not
  def signed_in?
    session[:token] and session[:salt] and MortalToken.new(session[:salt]) === session[:token]
  end
end
