class ShardMapping < ApplicationRecord
  not_sharded

  def ok?
    status == 200
  end

  def latest_shard
    AppConfig['latest_shard']
  end

  class << self
    def lookup(shard_key)
      is_numeric?(shard_key) ? find_by(account_id: shard_key) : find_by(domain: shard_key)
    end

    private
    def is_numeric?(str)
      true if Float(str) rescue false
    end
  end
end
