# Application initializers in the Given Order
module LoadAppInitializer
    def self.load_files(file_path, params)
      return if params.blank?
      params.each { |k, v| load_files("#{file_path}/#{k}", v) } && return if params.is_a?(Hash)
  
      # params is Array
      params.each do |file|
        if file.is_a?(String)
          require "#{file_path}/#{file}.rb"
        else # file is Hash
          file.each { |k, v| load_files("#{file_path}/#{k}", v) }
        end
      end
    end
  end
  
  puts 'Loading App Initializers...'
  LoadAppInitializer.load_files("#{Rails.root}/lib", YAML.load_file(File.join(Rails.root, 'config', 'app_initializers.yml')))
  