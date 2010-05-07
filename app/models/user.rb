require 'bcrypt'

# http://api.rubyonrails.org/classes/ActionController/HttpAuthentication/Basic.html
# http://charlesmaxwood.com/rails-metal-example-1-authentication/

class User
  include MongoMapper::Document

  attr_accessor :password, :password_confirmation
  cattr_accessor :anonymous, :current

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
    # TODO ...
  end

  before_save :set_hashword

  private

  def set_hashword
    if hashword.nil? || hashword.empty?
      # TODO ...
    end
  end

  def encrypt_password
    # TODO ...
  end

  private :hashword, :hashword=, :salt, :salt=
end
