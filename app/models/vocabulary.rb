class Vocabulary
  include MongoMapper::Document

  key :code, String
  key :name, String
  # ...

  many :terms
  many :nodes

  validates_presence_of :code, :name
end
