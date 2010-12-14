class LayoutRegion
  include MongoMapper::EmbeddedDocument

  key :name, String, :required => true
  key :widgets, AddonArray
end
