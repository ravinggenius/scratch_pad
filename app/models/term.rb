class Term
  include MongoMapper::Document

  key :name, String

  belongs_to :vocabulary
  many :nodes

  validates_presence_of :name
end
