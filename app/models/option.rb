class Option
  include MongoMapper::Document

  key :code, String, :required => true
  key :name, String, :required => true

  belongs_to :setting
end
