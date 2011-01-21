class FilterGroup
  include MongoMapper::Document 

  key :name, String, :required => true, :unique => true
  key :filters, FilterArray, :required => true

  many :nodes
end
