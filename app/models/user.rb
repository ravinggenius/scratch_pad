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

  validates_confirmation_of :password
  validates_presence_of :name, :email, :username, :hashword, :salt

  def verify_password(password)
    encrypt_password(password) == hashword
  end

  before_save :set_hashword

  private

  def set_hashword
    if hashword.nil? || hashword.empty?
      self.salt = '' # TODO make new secure salt
      self.hashword = encrypt_password(password)
    end
  end

  def encrypt_password(password, salt = self.salt)
    # TODO encrypt password
  end

  private :hashword, :hashword=, :salt, :salt=
end
