class Object
  require 'securerandom'
  def random_uuid
    SecureRandom.alphanumeric(10)
  end
end
