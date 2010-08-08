class Vocabulary
  include MongoMapper::Document

  key :code, String, :required => true
  key :name, String, :required => true
  key :is_freetagging_allowed, Boolean, :required => true, :default => false
  key :may_select_multiple, Boolean, :required => true, :default => true
  key :node_types_required, Array, :required => true
  key :node_types_optional, Array, :required => true

  many :terms
end
