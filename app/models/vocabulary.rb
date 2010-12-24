class Vocabulary
  include MongoMapper::Document

  key :name, String, :required => true
  key :is_freetaggable, Boolean, :required => true, :default => false
  key :is_hierarchical, Boolean, :required => true, :default => false
  key :is_multiselectable, Boolean, :required => true, :default => true
  key :node_types_optional, AddonArray, :required => true
  key :node_types_required, AddonArray, :required => true

  many :terms
end
