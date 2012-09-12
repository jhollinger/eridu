# Eridu config singleton class
module Conf
  @@config = nil

  # Access the config hash
  def self.[](*path)
    path.inject(@@config) do |config, item|
      break nil unless config.is_a? Hash
      config[item]
    end
  end

  # Loads all config files as a Hash
  def self.load!
    @@config = Dir.glob(ROOT['config', '*.yml']).inject({}) do |root_config, file_path|
      yaml = Psych.load_file(file_path)
      name = File.basename(file_path).gsub(/\.yml$/, '').to_sym
      config = name == :eridu ? root_config : root_config[name] = {}
      config.merge!(yaml[APP_ENV] || yaml)
      root_config
    end
    @@config[:domain] = URI.parse(@@config[:url]).host
  end
end
