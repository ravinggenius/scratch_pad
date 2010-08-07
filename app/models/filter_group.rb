class FilterGroup
  include MongoMapper::Document 

  key :name, String, :required => true
  key :filters, FilterArray, :required => true

  many :nodes
end
