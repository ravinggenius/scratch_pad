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
  validate :ensure_password_is_secure

  def is_locked?
    groups.include? Group.locked
  end

  def password
    @hash ||= Password.new(hashword) rescue nil
  end

  def password=(new_password)
    @new_password = new_password
    self.hashword = @hash = Password.create(new_password)
  end

  def self.current
    @current || anonymous
  end

  def self.current=(user)
    @current = user
  end

  def self.anonymous
    @anon ||= first :username => :anon
  end

  def self.root
    @root ||= first :username => :root
  end

  private

  def ensure_hashword_is_set
    errors[:password] << 'can\'t be empty' if hashword.blank?
  end

  def ensure_password_is_secure
    #self.class.validates_confirmation_of :password # TODO find a home for this

    if @new_password.blank?
      errors[:password] << 'can\'t be empty'
    else
      min_length = Setting[:sp, :user, :password, :min_length] || 8
      requirements = {}
      requirements[:length]     = /(?=.{#{min_length},})/
      requirements[:upper_case] = /(?=.*[A-Z])/
      requirements[:lower_case] = /(?=.*[a-z])/
      requirements[:digits]     = /(?=.*[\d])/
      requirements[:special]    = /(?=.*[\W])/
      regex = /^.*#{requirements.values.join}.*$/
      unless @new_password =~ regex
        errors[:password] << 'is not complex enough'
        errors[:password] << "must be at least #{min_length} characters long and contain at least one of each of the following: lower-case letter, upper-case letter, digit and symbol"
      end
    end
  end

  private :hashword, :hashword=
end
