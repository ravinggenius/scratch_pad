class Vocabulary
  include DataMapper::Resource

  property :id, Serial
  property :code, String, :required => true
  property :name, String, :required => true
  # ...

  has n, :terms
  has n, :nodes, :through => Resource
end
