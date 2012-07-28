class AdminMediaHandler < AbstractHandler
  helpers do
    include AdminHelper

    # Returns a unique filepath
    def safe_filepath(filepath)
      dir = File.dirname(filepath)
      filename = File.basename(filepath)
      name = filename.split('.')
      ext = name.pop
      name = name.join('.')

      num = 1
      while File.exists? File.join(dir, filename)
        num += 1
        filename = "#{name} #{num}.#{ext}"
      end
      File.join(dir, filename)
    end
  end

  get '/admin/media/?' do
    @files = Dir.glob(ROOT['public', 'media', '**', '*']).map { |f| f.gsub(ROOT['public'], '') }
    admin_erb :"media"
  end

  post '/admin/media/?' do
    filepath = safe_filepath(ROOT['public', 'media', params[:filename]])
    File.open(filepath, 'w') do |f|
      f.puts Base64.decode64(params[:data])
    end
    # Show the file url
    filepath.gsub(ROOT['public'], '')
  end

  delete '/admin/media/:filename' do |filename|
    filepath = File.join(ROOT['public', 'media', filename])
    File.unlink(filepath) if File.exists? filepath
    redirect '/admin/media'
  end
end
