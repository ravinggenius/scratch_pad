class Value
  include MongoMapper::Document

  key :value, String, :required => true

  timestamps!
  userstamps!

  belongs_to :setting
end
