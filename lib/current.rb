class Current
  KEYS = [:shard, :project, :environment, :account, :user].freeze

  KEYS.each do |key|
		define_singleton_method :"#{key}" do
			RequestStore.store[key]
		end

		define_singleton_method :"#{key}=" do |value|
			RequestStore.store[key] = value
		end
	end
end
