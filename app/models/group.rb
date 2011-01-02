class Group
  include MongoMapper::Document
  include Relationship

  key :access_code, Integer, :required => true, :unique => true
  key :code, String, :required => true
  key :name, String, :required => true, :unique => true

  habtm :groups, :users

  before_save :validate_access_code

  private

  def validate_access_code
    # TODO fill this in
    # access_code should double with each new group
  end

  def self.locked
    first :code => :locked
  end

  def self.root
    first :code => :root
  end
end
