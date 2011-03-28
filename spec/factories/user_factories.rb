Factory.define(:user) do |u|
  u.email 'test@example.com'
  u.name 'Test Account'
  u.password 'password'
  u.password_confirmation 'password'
end
