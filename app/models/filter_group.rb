class FilterGroup
  include MongoMapper::Document 

  key :name, String, :required => true
  key :filters, Array, :required => true, :typecast => 'Filter'

  many :nodes
end
