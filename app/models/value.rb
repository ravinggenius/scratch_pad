class Value
  include MongoMapper::Document

  key :value, String, :required => true
  key :type, String, :required => true

  timestamps!
  userstamps!
end
