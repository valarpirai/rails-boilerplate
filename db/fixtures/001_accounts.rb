unless Account.current
  if Account.count == 0
    signup = Signup.new(
      account: { name: 'Test Account', domain: 'localhost' },
      user: {
        first_name: 'Admin',
        last_name: 'User',
        password: 'test1234',
        password_confirmation: 'test1234',
        email: AppConfig['EMAILS']['admin_email']
      }
    )
    signup.save
    signup.account.make_current
  else
    Account.first.make_current
  end
end
