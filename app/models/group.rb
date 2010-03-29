class Group
  include DataMapper::Resource

  property :id, Serial
  property :access_code, Integer, :required => true, :unique => true
  property :code, String, :required => true
  property :name, String, :required => true

  has n, :users, :through => Resource

  before :save do
    # validate access code
  end
end
