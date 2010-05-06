class User
  include MongoMapper::Document

  key :name, String
  key :email, String
  key :username, String
  key :hashword, String
  key :salt, String

  many :groups
  many :logins
  many :nodes

  validates_presence_of :name, :email, :username, :hashword, :salt

  def login
  end

  private :hashword, :hashword=, :salt, :salt=
end
