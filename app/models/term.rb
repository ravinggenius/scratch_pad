class Term
  include MongoMapper::Document
  extend Relationship

  key :name, String, :required => true

  belongs_to :vocabulary
  habtm :terms, :nodes, :tagging

  after_save :save_taggings
end
