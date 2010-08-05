class Group
  include MongoMapper::Document
  include Relationship

  key :access_code, Integer, :required => true
  key :code, String, :required => true
  key :name, String, :required => true

  habtm :groups, :users, :grouping

  validates_uniqueness_of :access_code

  before_save :validate_access_code

  private

  def validate_access_code
    # TODO fill this in
  end
end
