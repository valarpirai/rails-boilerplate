class Sharding
  class << self
    def select_shard_of(shard_key, &block)
      shard = ShardMapping.lookup(shard_key)
      check_shard_status(shard)
      shard_name = shard.shard_name 
      ActiveRecord::Base.on_shard(shard_name.to_sym,&block)
    end

    def run_on_master(&block)
      ActiveRecord::Base.on_master(&block)
    end

    def run_on_slave(&block)
      ActiveRecord::Base.on_slave(&block)
    end

    def select_latest_shard(&block)
      ActiveRecord::Base.on_shard(ShardMapping.latest_shard,&block)
    end

    def run_on_shard(shard_name,&block)
      ActiveRecord::Base.on_shard(shard_name.to_sym,&block)
    end

    def all_shards
      ActiveRecord::Base.shard_names
    end

    def run_on_all_shards(&block)
      results = ActiveRecord::Base.on_all_shards(&block)
      results.flatten
    end

    def run_on_all_slaves(&block)
      results = run_on_all_shards { run_on_slave(&block)}
    end

    def execute_on_all_shards(&block)
      ActiveRecord::Base.on_all_shards(&block)
    end

    private

    def check_shard_status(shard)
      raise ActiveRecord::RecordNotFound  if shard.nil?
      raise DomainNotReady unless shard.ok?
    end
  end
end

class DomainNotReady < StandardError; end
class ShardNotFound < StandardError; end
