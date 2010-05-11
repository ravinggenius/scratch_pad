class Group
  include MongoMapper::Document

  key :access_code, Integer
  key :code, String
  key :name, String

  many :users

  validates_presence_of :access_code, :code, :name
  validates_uniqueness_of :access_code

  before_save :validate_access_code

  private

  def validate_access_code
  end
end
