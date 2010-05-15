class Cache
  include MongoMapper::Document

  key :key, String, :required => true
  key :value, String, :required => true

  timestamps!
end
