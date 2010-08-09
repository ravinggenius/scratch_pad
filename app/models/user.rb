# http://github.com/codahale/bcrypt-ruby
# http://api.rubyonrails.org/classes/ActionController/HttpAuthentication/Basic.html
# http://charlesmaxwood.com/rails-metal-example-1-authentication/

class User
  include MongoMapper::Document
  include BCrypt
  include Relationship

  attr_writer :password_confirmation
  cattr_accessor :anonymous, :current

  key :email, String, :required => true
  key :username, String, :required => true
  key :hashword, String

  habtm :users, :groups

  validates_confirmation_of :password
  validates_uniqueness_of :username

  after_validation :ensure_hashword_is_set

  def password
    @password ||= Password.new(hashword) rescue nil
  end

  def password=(new_password)
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

  private

  def ensure_hashword_is_set
    errors.add(:password, 'can\'t be empty') if hashword.blank?
  end

  private :hashword, :hashword=
end
