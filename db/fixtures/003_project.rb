return unless Account.current
account = Account.current
Project.seed do |s|
  s.account_id = account.id
  s.name = "Test Project"
  s.description = "First project on the system"
end

Environment.seed do |e|
  e.account_id = account.id
  e.project_id = account.projects.first.id
  e.name = 'Production'
  e.description = '(Default environment)'
end
