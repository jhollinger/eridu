class AdminCommentsHandler < AbstractHandler
  helpers do
    include AdminHelper
  end

  # Lists all comments
  get "/admin/comments/?" do
    @comments = Comment.ordered
    admin_erb :"comments/index"
  end

  # Edit a comment
  get "/admin/comments/:id/?" do |id|
    @comment = Comment.get(id)
    admin_erb :"comments/edit"
  end

  # Update a comment
  put "/admin/comments/:id/?" do |id|
    @comment = Comment.get(id)
    if @comment.update(params[:comment])
      redirect '/admin/comments'
    else
      admin_erb :"comments/edit"
    end
  end

  # Delete a comment
  delete "/admin/comments/:id/?" do |id|
    @comment = Comment.get(id)
    @comment.destroy
    redirect '/admin/comments'
  end
end
