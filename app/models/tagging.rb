class Tagging
  include MongoMapper::Document
  extend Relationship

  key :node_id, String, :required => true
  key :term_id, String, :required => true

  habtm_glue :node, :term
end
