module ApplicationConfig
  def self.prepare(params)
    if params.is_a?(Hash)
      params.symbolize_keys!
      params.each { |k, v| params[k] = prepare(v) }
    end
    params
  end

  def self.default_domain
    "localhost.#{BASE_DOMAIN[Rails.env.to_sym]}"
  end
end

YAML.load_file(File.join(Rails.root, 'config', 'config.yml')).each do |k, v|
  ApplicationConfig.const_set(k.upcase, ApplicationConfig::prepare(v))
end
