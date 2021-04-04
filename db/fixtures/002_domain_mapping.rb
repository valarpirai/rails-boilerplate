return unless Account.current
DomainMapping.seed do |s|
    s.account_id = Account.current.id
    s.domain = "localhost.#{AppConfig[:base_domain][Rails.env]}"
end

ShardMapping.seed do |s| 
    s.account_id = Account.current.id
    s.shard_name = AppConfig[:latest_shard]
end
