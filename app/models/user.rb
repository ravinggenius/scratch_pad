class User
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true
  property :email, String, :required => true

  has n, :groups, :through => Resource
  has n, :logins
  has n, :nodes
end
