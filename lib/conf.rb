# Eridu config singleton class
module Conf
  @@config = nil

  # Access the config hash
  def self.[](*path)
    load_config! if @@config.nil?
    path.inject(@@config) do |config, item|
      break nil unless config.is_a? Hash
      config[item]
    end
  end

  private

  # Loads all config files as a Hash
  def self.load_config!
    root_config = {}
    # Load all config
    Dir.glob(ROOT['config', '*.yml']).each do |file_path|
      name = File.basename(file_path).gsub(/\.yml$/, '').to_sym
      config = name == :eridu ? root_config : root_config[name] = {}
      config.merge!(Psych.load_file(file_path))
    end

    # A little cleanup
    root_config[:database] = root_config[:database][APP_ENV]
    root_config[:url] = "http://#{root_config[:domain]}"

    @@config = root_config
  end
end
