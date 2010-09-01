class Term
  include MongoMapper::Document
  include Relationship

  key :vocabulary_id, BSON::ObjectID, :required => true
  key :name, String, :required => true

  belongs_to :vocabulary
  habtm :terms, :nodes, :glue_model => :tagging
end
