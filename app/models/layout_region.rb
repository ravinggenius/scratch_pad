class LayoutRegion
  include MongoMapper::EmbeddedDocument

  key :name, String, :required => true
  key :wrapper, String
  key :widgets, AddonArray
end
