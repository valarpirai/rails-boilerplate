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
      is_numeric?(shard_key) ? find_by(account_id: shard_key) : fetch_by_domain(shard_key)
    end

    def fetch_by_domain(domain)
      domain = ApplicationConfig.default_domain if Rails.env.eql?('development') && domain.eql?('localhost')
      find_by(account_id: DomainMapping.find_by(domain: domain)&.account_id)
    end

    private
    def is_numeric?(str)
      true if Float(str) rescue false
    end

    def account_uuid?(str)
      !(str =~ /^[a-zA-Z0-9]{10}$/).nil?
    end
  end
end
