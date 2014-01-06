class AdminPostsAndPagesHandler < AbstractHandler
  helpers AdminHelper

  # Create identical handlers for Posts and Pages
  [Post, Page].each do |klass|
    thing = klass.name.downcase
    var = "@#{thing}"

    # List objects
    get "/admin/#{thing}s/?" do
      instance_variable_set("@#{thing}s", klass.ordered)
      admin_erb :"#{thing}s/index"
    end

    # Form to create a new object
    get "/admin/#{thing}s/new/?" do
      instance_variable_set(var, klass.new)
      admin_erb :"#{thing}s/new"
    end

    # Creates a new object
    post "/admin/#{thing}s/?" do
      obj = instance_variable_set(var, klass.new(params[thing.to_sym]))
      if obj.save
        redirect "/admin/#{thing}s"
      else
        admin_erb :"#{thing}s/new"
      end
    end

    # Form to edit an object
    get "/admin/#{thing}s/:id/?" do |id|
      instance_variable_set(var, klass.get(id.to_i))
      admin_erb :"#{thing}s/edit"
    end

    # Updates an object
    put "/admin/#{thing}s/:id/?" do |id|
      obj = instance_variable_set(var, klass.get(id.to_i))
      obj.updated_at = Time.now # XXX workaround for https://github.com/datamapper/dm-tags/issues/4
      obj.attributes = params[thing.to_sym]
      if obj.save
        redirect "/admin/#{thing}s"
      else
        admin_erb :"#{thing}s/edit"
      end
    end

    # Deletes an object
    delete "/admin/#{thing}s/:id/?" do |id|
      obj = instance_variable_set(var, klass.get(id.to_i))
      obj.destroy
      redirect "/admin/#{thing}s"
    end
  end
end
