# http://github.com/codahale/bcrypt-ruby
# http://api.rubyonrails.org/classes/ActionController/HttpAuthentication/Basic.html
# http://charlesmaxwood.com/rails-metal-example-1-authentication/

class User
  include MongoMapper::Document
  include BCrypt
  include Relationship

  # TODO add devise to project
  #devise :database_authenticatable, :recoverable, :rememberable, :validatable, :registerable

  attr_writer :password_confirmation

  key :email, String, :required => true, :unique => true
  key :name, String, :required => true
  key :username, String, :required => true, :unique => true
  key :hashword, String

  habtm :users, :groups

  validates_confirmation_of :password
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

  def to_param
    username
  end

  def self.from_param(username)
    first :username => username
  end

  def self.new_password(length = 12)
    pool = []

    pool << '` ~ ! @ # $ % ^ & * ( ) - _ + = ? / \ | { } < > , .'.split
    pool << ('0'..'9').to_a
    pool << ('A'..'Z').to_a
    pool << ('a'..'z').to_a

    pool.flatten!
    size = pool.size

    (0...length).map { pool[Kernel.rand(size)] }.join
  end

  def self.anonymous
    first :username => :anon
  end

  def self.root
    first :username => :root
  end

  private

  def ensure_hashword_is_set
    errors[:password] << 'can\'t be empty' if hashword.blank?
  end

  def ensure_password_is_secure
    if @new_password.blank?
      errors.add :password, 'can\'t be empty'
    else
      min_length = Setting[:user, :password, :min_length] || 8
      requirements = {}
      requirements[:length]     = /(?=.{#{min_length},})/
      requirements[:upper_case] = /(?=.*[A-Z])/
      requirements[:lower_case] = /(?=.*[a-z])/
      requirements[:digits]     = /(?=.*[\d])/
      requirements[:special]    = /(?=.*[\W])/
      regex = /^.*#{requirements.values.join}.*$/
      unless @new_password =~ regex
        errors.add :password, 'is not complex enough'
        errors.add :password, "must be at least #{min_length} characters long and contain at least one of each of the following: lower-case letter, upper-case letter, digit and symbol"
      end
    end
  end

  private :hashword, :hashword=
end
