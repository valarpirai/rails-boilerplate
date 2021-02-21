module FlagManager
    require 'concurrent-ruby'
    class Store
        attr_reader :store
        
        def initialize
            @store = Concurrent::Map.new
        end

        def get(key)
            store[key]
        end

        def set(key, value)
            store.compute(key) do |old_value|
                FeatureFlag.new(key, value)
            end
        end

        def del(key)
            store.delete key
        end
    end

    class FeatureFlag
        attr_reader :name, :value

        def initialize(args)
            @name = args[:name]
            @value = args[:value]
        end
    end
end
