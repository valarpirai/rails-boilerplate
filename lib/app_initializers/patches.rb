# frozen_string_literal: true

ActiveModel::Errors.class_eval do
  def app_json(_options = nil)
    a = []
    to_hash.map do |key, values|
      values.each do |val|
        a << [key.to_s, val]
      end
    end
    a.to_json
  end
end
