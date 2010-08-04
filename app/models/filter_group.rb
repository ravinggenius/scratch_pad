class FilterGroup
  include MongoMapper::Document 

  key :name, String, :required => true
  key :filters, Array, :required => true, :typcast => 'String' # 'Filter' # http://gist.github.com/507531

  many :nodes
end
