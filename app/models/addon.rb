class Addon
  include MongoMapper::Document

  key :scope, String, :required => true
end
