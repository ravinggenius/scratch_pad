# http://github.com/codahale/bcrypt-ruby
# http://api.rubyonrails.org/classes/ActionController/HttpAuthentication/Basic.html
# http://charlesmaxwood.com/rails-metal-example-1-authentication/

class User
  include MongoMapper::Document
  include BCrypt
  include Relationship

  attr_writer :password_confirmation

  key :email, String, :required => true
  key :name, String, :required => true
  key :username, String, :required => true
  key :hashword, String

  habtm :users, :groups

  validates_uniqueness_of :username
  validate :ensure_hashword_is_set

  def password
    @password ||= Password.new(hashword) rescue nil
  end

  def password=(new_password)
    #User.validates_confirmation_of :password # TODO find a home for this

    temp = []

    if new_password.blank?
      temp << 'can\'t be empty'
    else
      # TODO add other requirements here
      temp << 'is too short' unless new_password.length > 6
    end

    if temp.empty?
      @password = Password.create(new_password)
      self.hashword = @password
    else
      temp.each { |message| errors.add(:password, message) }
    end
  end

  def self.current
    @current || anonymous
  end

  def self.current=(user)
    @current = user
  end

  def self.anonymous
    @anon ||= first :username => 'anon'
  end

  def self.root
    @root ||= first :username => 'root'
  end

  private

  def ensure_hashword_is_set
    errors.add(:password, 'can\'t be empty') if hashword.blank?
  end

  private :hashword, :hashword=
end
