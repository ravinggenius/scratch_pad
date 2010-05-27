class Vocabulary
  include MongoMapper::Document

  key :code, String, :required => true
  key :name, String, :required => true
  # ...

  many :terms
end
