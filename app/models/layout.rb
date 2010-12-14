class Layout
  include MongoMapper::Document

  key :scope, String, :required => true
  key :name, String, :required => true

  many :layout_regions
end
