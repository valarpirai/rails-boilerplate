return unless Account.current
DomainMapping.create(
  account_id: Account.current.id, 
  domain: "localhost.#{AppConfig[:base_domain][Rails.env]}")