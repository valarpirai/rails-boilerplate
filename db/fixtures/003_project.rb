return unless Account.current
account = Account.current
Project.seed do |s|
  s.account_id = account.id
  s.name = "Test Project"
  s.description = "First project on the system"
end
