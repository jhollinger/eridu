# Eridu config singleton class
module Conf
  @@config = nil

  # Access the config hash
  def self.[](*path)
    @@config ||= get_config
    path.inject(@@config) do |config, item|
      break nil unless config.is_a? Hash
      config[item]
    end
  end

  private

  # Returns all config files as a Hash
  def self.get_config
    root_config = {}
    # Load all config
    Dir.glob(ROOT['config', '*.yml']).each do |file_path|
      name = File.basename(file_path).gsub(/\.yml$/, '')
      config = name == 'eridu' ? root_config : root_config[name] = {}
      config.merge!(YAML::load(IO.read(file_path)))
    end

    # A little cleanup
    root_config['database'] = root_config['database'][APP_ENV.to_s]
    root_config['domain'] = root_config['url'].gsub(/^https?:\/\//, '')

    symbolize_keys(root_config)
  end

  private

  # Recursively symbolize all keys in a Hash
  def self.symbolize_keys(hash)
    hash.inject({}) do |options, (key, value)|
      options[(key.to_sym rescue key)] = value.is_a?(Hash) ? symbolize_keys(value) : value
      options
    end
  end
end
