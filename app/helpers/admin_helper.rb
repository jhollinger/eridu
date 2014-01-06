module AdminHelper
  NAV = []
  NAV << ['Dashboard', '/admin', '/admin']
  NAV << ['Posts <a href="/admin/posts/new">(+)</a>', '/admin/posts', %r{/admin/posts}]
  NAV << ['Pages <a href="/admin/pages/new">(+)</a>', '/admin/pages', %r{/admin/pages}]
  NAV << ['Media', '/admin/media', '/admin/media']
  NAV << ['Trash', '/admin/trash', %r{/admin/trash}]

  # Returns a navigation array. If one matches the current page, the third element is "true"
  def nav
    NAV.map do |title, path, check|
      [title, path, check === request.path]
    end
  end

  # Admin path generators
  def admin_post_path(post); "/admin/posts/#{post.id}"; end
  def admin_page_path(page); "/admin/pages/#{page.id}"; end
  def admin_media_path(file); "/admin/media/#{file}"; end

  # Prepends admin/ to the template, sets the layout to admin/layout.
  def admin_erb(template, options={:layout => :"admin/layout"})
    erb :"admin/#{template}", options
  end

  # Returns true if the user is signed in, false if not
  def signed_in?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [Conf[:author][:username], Conf[:author][:password]]
  end

  def require_sign_in!
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end
end
