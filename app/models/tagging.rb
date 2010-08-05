class Tagging
  include MongoMapper::Document
  include Relationship

  habtm_glue :node, :term
end
