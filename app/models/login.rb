class Login
  include DataMapper::Resource

  property :id, Serial
  property :username, String, :required => true
  property :hashword, String, :required => true, :accessor => :private
  property :salt, String, :required => true, :accessor => :private

  belongs_to :user

  def login
  end
end
