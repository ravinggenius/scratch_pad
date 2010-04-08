class TextBlock
  include DataMapper::Resource
  include NodeExtension

  property :id, Serial
  property :data, Text, :required => true, :lazy => false

  after :save, :set_id
end
